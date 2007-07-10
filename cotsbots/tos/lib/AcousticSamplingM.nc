/*                                                                      tab:4
 *
 *
 * "Copyright (c) 2002 and The Regents of the University
 * of California.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Authors:             Sarah Bergbreiter
 * Date last modified:  10/21/2003
 *
 * This component sends a series of beeps using the sounder and timing
 * information provided by the component calling AcousticSampling.
 *
 */

module AcousticSamplingM {
  provides interface StdControl;
  provides interface AcousticSampling;
  uses {
    interface StdControl as SensorControl;
    interface ADC;
    interface StdControl as TimerControl;
    interface Timer;
    interface StdControl as CommControl;
    interface SendMsg;
    interface Leds;
  }
}
implementation {

  enum {
    MIC_WARMUP_TIME = 1000,

    THRESHOLD_INIT = 3,
    BEEP_THRESHOLD = 100,
    CALIBRATE_SIZE = 400,

    CALIBRATING = 1,
    SAMPLING = 2,
    IDLE = 3,
  };

  // For calibration
  uint8_t state;
  uint16_t calibrateCount;
  uint16_t calibrateMicValue;

  // Sampling (low-pass filter -- average)
  uint16_t micArray[16];
  uint8_t micIndex;
  uint16_t sampleCount;
  uint8_t beepCount;
  uint16_t lastData;

  // Threshold
  uint8_t threshold;

  // For Debugging
  bool debug;
  TOS_Msg msg[2];
  uint8_t currentMsg;
  uint8_t packetReadingNumber;
  uint16_t readingNumber;

  command result_t StdControl.init() {
    atomic {
      state = IDLE;
      calibrateCount = 0;
      sampleCount = 0;
      beepCount = 0;
      calibrateMicValue = 0;
      micIndex = 0;
      threshold = THRESHOLD_INIT;
      debug = FALSE;
      packetReadingNumber = 0; readingNumber = 0; currentMsg = 0;
    }
    return rcombine3(call SensorControl.init(), call TimerControl.init(), call CommControl.init());
  }

  command result_t StdControl.start() {
    return call CommControl.start();
  }

  command result_t StdControl.stop() {
    call SensorControl.stop();
    call Timer.stop();
    call CommControl.stop();
    return SUCCESS;
  }

  command result_t AcousticSampling.calibrate(uint16_t num) {
    call SensorControl.start();
    call Timer.start(TIMER_ONE_SHOT, MIC_WARMUP_TIME);
    atomic {
      state = CALIBRATING;
      calibrateCount = num;
      micIndex = 0;
    }
    return SUCCESS;
  }

  command result_t AcousticSampling.startSampling(uint16_t num) {
    call SensorControl.start();
    call Timer.start(TIMER_ONE_SHOT, MIC_WARMUP_TIME);
    atomic {
      state = SAMPLING;
      sampleCount = num;
      beepCount = 0;
    }
    return SUCCESS;
  }

  command result_t AcousticSampling.setThreshold(uint8_t t) {
    atomic {
      threshold = t;
    }
    return SUCCESS;
  }

  default event result_t AcousticSampling.doneSampling(bool beeped) { return SUCCESS; }

  default event result_t AcousticSampling.doneCalibrating(uint16_t micValue) { return SUCCESS; }

  event result_t SendMsg.sendDone(TOS_MsgPtr m, bool success) {
    return SUCCESS;
  }

  task void dataTask() {
    struct OscopeMsg *pack;
    atomic {
      pack = (struct OscopeMsg *)msg[currentMsg].data;
      packetReadingNumber = 0;
      pack->lastSampleNumber = readingNumber;
    }

    pack->channel = 1;
    pack->sourceMoteID = TOS_LOCAL_ADDRESS;
    
    //Try to send the packet. Note that this will return
    //failure immediately if the packet could not be queued for
    //transmission.
    if (call SendMsg.send(TOS_UART_ADDR, sizeof(struct OscopeMsg),
			      &msg[currentMsg]))
      {
	atomic {
	  currentMsg ^= 0x1;
	}
	call Leds.yellowToggle();
      }
  }

  task void handleMicData() {
    uint8_t i;
    uint16_t average, sum = 0;

    if (debug) {
      bool done;
      struct OscopeMsg *pack;
      pack = (struct OscopeMsg *)msg[currentMsg].data;
      atomic {
	pack->data[packetReadingNumber++] = lastData;
	readingNumber++;
	done = packetReadingNumber == BUFFER_SIZE;
      }
      if (done) {
	post dataTask();
      }
    }

    if (state == CALIBRATING) {
      calibrateCount--;
      if (calibrateCount == 0) {
	atomic {
	  for( i = 0; i < 16; i++) {
	    sum += micArray[i];
	  }
	}
	average = sum >> 4;

	call SensorControl.stop();
	calibrateMicValue = average;
	signal AcousticSampling.doneCalibrating(calibrateMicValue);
	atomic {
	  state = IDLE;
	}
	return;
      }
    } else if (state == SAMPLING) {
      bool beeped;
      atomic {
	beeped = lastData > calibrateMicValue+threshold;
      }
      sampleCount--;
      if (beeped) {
	beepCount++;
      }
      if (sampleCount == 0) {
	call SensorControl.stop();
	signal AcousticSampling.doneSampling(beepCount > BEEP_THRESHOLD);
	atomic {
	  state = IDLE;
	}
	return;
      }
    }

    call ADC.getData();
  }

  async event result_t ADC.dataReady(uint16_t data) {
    if (state == IDLE) return FAIL;
    atomic {
      lastData = data;
      if (state == CALIBRATING) {
	micArray[micIndex++] = data;
	micIndex &= 0x0F;
      }
    }
    post handleMicData();

    return SUCCESS;
  }

  event result_t Timer.fired() {
    call ADC.getData();
    return SUCCESS;
  }

}
