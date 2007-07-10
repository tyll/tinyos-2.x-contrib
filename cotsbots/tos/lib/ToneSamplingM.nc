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

module ToneSamplingM {
  provides interface StdControl;
  provides interface AcousticSampling;
  uses {
    interface StdControl as MicControl;
    interface Mic;
    interface StdControl as TimerControl;
    interface Timer as SampleTimer;
    interface Timer as ClockTimer;
    interface Leds;
  }
}
implementation {

  enum {
    MIC_WARMUP_TIME = 500,
    TONE_CAPTURE_TIME = 5,

    BEEP_THRESHOLD = 10,
    MIC_GAIN = 128,

    WARMUP = 1,
    SAMPLING = 2,
    IDLE = 3,
  };

  // Sampling
  uint8_t state;
  uint8_t beepCount;
  uint16_t sampleTime;

  command result_t StdControl.init() {
    atomic {
      state = IDLE;
      beepCount = 0;
      sampleTime = 0;
    }
    return rcombine(call MicControl.init(), call TimerControl.init());
  }

  command result_t StdControl.start() {
    return SUCCESS;
  }

  command result_t StdControl.stop() {
    call MicControl.stop();
    call SampleTimer.stop();
    call ClockTimer.stop();
    return SUCCESS;
  }

  command result_t AcousticSampling.calibrate(uint16_t num) {
    signal AcousticSampling.doneCalibrating(0);
    return SUCCESS;
  }

  command result_t AcousticSampling.startSampling(uint16_t time) {
    call MicControl.start();
    call Mic.muxSel(1);
    call Mic.gainAdjust(32);
    call SampleTimer.start(TIMER_ONE_SHOT, MIC_WARMUP_TIME);
    atomic {
      state = WARMUP;
      beepCount = 0;
      sampleTime = time;
    }
    return SUCCESS;
  }

  command result_t AcousticSampling.setThreshold(uint8_t t) {
    return SUCCESS;
  }

  event result_t SampleTimer.fired() {
    if (state == IDLE) return FAIL;
    if (state == WARMUP) {
      atomic {
	state = SAMPLING;
      }
      call SampleTimer.start(TIMER_ONE_SHOT, sampleTime);
      call ClockTimer.start(TIMER_REPEAT, TONE_CAPTURE_TIME);
    } else if (state == SAMPLING) {
      atomic {
	state = IDLE;
      }
      call MicControl.stop();
      call ClockTimer.stop();
      signal AcousticSampling.doneSampling(beepCount > BEEP_THRESHOLD);
    }
    return SUCCESS;
  }

  event result_t ClockTimer.fired() {
    // readToneDetector returns a 0 if a tone is detected
    if (state == SAMPLING) {
      uint8_t tone = call Mic.readToneDetector();
      if (!tone)
	beepCount++;
    }
    return SUCCESS;
  }

  default event result_t AcousticSampling.doneSampling(bool beeped) { return SUCCESS; }

  default event result_t AcousticSampling.doneCalibrating(uint16_t micValue) { return SUCCESS; }


}
