/*									tab:4
 *
 *
 * "Copyright (c) 2000-2002 The Regents of the University  of California.  
 * All rights reserved.
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
 *
 * Authors:		Sarah Bergbreiter
 * Date last modified:  2/25/03
 * 10/21/2003 -- Noticed that I wasn't incrementing AccelX/YNumber so I 
 * added this in.  This could significantly affect things of course.
 *
 * This is an obstacle-avoidance component that utilizes the accelerometer on
 * the mica sensorboard to determine the presence of an obstacle.  When
 * an obstacle is detected, the robot will back up, turn, and go in a
 * new direction.
 *
 */

module ObstacleM
{
  provides interface StdControl;
  provides interface Obstacle;
  uses {
    interface StdControl as SensorControl;
    interface ADC as AccelX;
    interface ADC as AccelY;
    interface Timer as SampleTimer;
    interface StdControl as TimerControl;
  }
}
implementation
{
  // For moving average
  uint16_t yData;
  uint16_t accelYReading[8];
  uint8_t accelYNumber;

  uint16_t xData;
  uint16_t accelXReading[8];
  uint8_t accelXNumber;

  // For calibration
  uint8_t state;
  uint16_t calibrateCount;
  uint8_t calibrateYValue;
  uint8_t calibrateXValue;

  // For threshold
  uint8_t thresholdX;
  uint8_t thresholdY;

  enum {
    THRESHOLDX_INIT = 4,
    THRESHOLDY_INIT = 2,
    CALIBRATE_SIZE = 400,
    SAMPLE_TIME = 10,
    CALIBRATING = 0,
    IDLE = 1,
    SAMPLING = 2,
  };

  /**
   * Used to initialize this component.
   */
  command result_t StdControl.init() {
    int i;

    atomic {
      accelYNumber = 0;
      accelXNumber = 0;
      for(i=0;i<8;i++) {
	accelYReading[i] = 0;
	accelXReading[i] = 0;
      }
      
      state = IDLE;
      calibrateCount = 0;
      calibrateYValue = 0;
      calibrateXValue = 0;
      thresholdX = THRESHOLDX_INIT;
      thresholdY = THRESHOLDY_INIT;
    }

    dbg(DBG_BOOT, "OBSTACLE initialized\n");
    call SensorControl.init();
    call TimerControl.init();
    call SensorControl.start();
    return SUCCESS;
    //return rcombine(call SensorControl.init(), call TimerControl.init());
  }

  /**
   * Starts the SensorControl and CommControl components.
   * @return Always returns SUCCESS.
   */
  command result_t StdControl.start() {
    atomic {
      state = SAMPLING;
    }
    //call SensorControl.start();
    call SampleTimer.start(TIMER_REPEAT,SAMPLE_TIME);
    return SUCCESS;
  }

  /**
   * Stops the SensorControl and CommControl componets.
   * @return Always returns SUCCESS.
   */
  command result_t StdControl.stop() {
    atomic {
      state = IDLE;
    }
    //call SensorControl.stop();
    call SampleTimer.stop();
    return SUCCESS;
  }

  /**
   * Starts the calibration procedure for ObstacleAvoidance.
   * @return Always returns SUCCESS.
   */
  command result_t Obstacle.calibrate() {
    atomic {
      state = CALIBRATING;
    }
    //call SensorControl.start();
    call SampleTimer.start(TIMER_REPEAT,SAMPLE_TIME);
    return SUCCESS;
  }    

  /**
   * Sets the threshold value to indicate when obstacle is detected.
   * @return Always returns SUCCESS.
   */
  command result_t Obstacle.setThreshold(uint8_t tX, uint8_t tY) {
    atomic {
      thresholdX = tX;
      thresholdY = tY;
    }
    return SUCCESS;
  }

  /**
   * Gets the threshold value to indicate when obstacle is detected.
   * @return Always returns SUCCESS.
   */
  command uint8_t Obstacle.getThresholdY() {
    return thresholdY;
  }

  /**
   * Gets the threshold value to indicate when obstacle is detected.
   * @return Always returns SUCCESS.
   */
  command uint8_t Obstacle.getThresholdX() {
    return thresholdX;
  }

  /**
   * CalibrationDone event signifies the end of the calibration routine.  The user
   * should call the StdControl.start() method after this to start detecting
   * obstacles.
   * @return Always returns SUCCESS.
   */
  default event result_t Obstacle.calibrateDone(uint16_t valueX, uint16_t valueY) { return SUCCESS; }

  /**
   * obstacleDetected event fires when an obstacle is detected based on the 
   * threshold value.
   * @return Always returns SUCCESS.
   */
  default event result_t Obstacle.obstacleDetected(uint16_t value, uint8_t port) { return SUCCESS; }


  /**
   * Task to handle y-data
   */
  task void handleYData() {
    uint8_t i;
    uint16_t accelSum = 0;
    uint16_t accelAverage;
    uint8_t s;
    uint8_t y;

    atomic {
      s = state;
      y = calibrateYValue - thresholdY;
      accelYReading[accelYNumber++] = yData;
      accelYNumber &= 0x07;
      for(i=0; i < 8; i++)
	accelSum += accelYReading[i];
    }
    accelAverage = accelSum >> 3;

    dbg(DBG_USR1, "data_event\n");

    if (s == CALIBRATING) {
      atomic {
	calibrateCount++;
	if (calibrateCount >= CALIBRATE_SIZE) {
	  calibrateYValue = accelAverage;
	}
      }
    } else if (accelAverage < y) {
      if (s == SAMPLING) {
	signal Obstacle.obstacleDetected(accelAverage,1);
      }
    }

    call AccelX.getData();

  }

  /**
   * Signalled when data is ready from the AccelY. Averages data and
   * signals ObstacleDetected signal when above threshold
   * @return Always returns SUCCESS.
   */
  async event result_t AccelY.dataReady(uint16_t data) {
    atomic {
      yData = data >> 1;
    }
    post handleYData();
    return SUCCESS;
  }

  /** 
   * Task to handle x-data
   */
  task void handleXData() {
    uint8_t i;
    uint16_t accelSum = 0;
    uint16_t accelAverage;
    uint8_t s, xMinus, xPlus;
    uint16_t cc;

    atomic {
      s = state;
      xMinus = calibrateXValue-thresholdX;
      xPlus = calibrateXValue+thresholdX;
      cc = calibrateCount;
      accelXReading[accelXNumber++] = xData;
      accelXNumber &= 0x07;
      for(i=0; i < 8; i++)
	accelSum += accelXReading[i];
      accelAverage = accelSum >> 3;
    }

    dbg(DBG_USR1, "data_event\n");

    if (s == CALIBRATING) {
      if (cc >= CALIBRATE_SIZE) {
	atomic {
	  calibrateXValue = accelAverage;
	  state = IDLE;
	}
	call SampleTimer.stop();
	signal Obstacle.calibrateDone(calibrateXValue, calibrateYValue);  
      }
    } else if ((accelAverage < xMinus) || (accelAverage > xPlus)) {
      if (s == SAMPLING) {
	signal Obstacle.obstacleDetected(accelAverage,0);
      }
    }

  }

  /**
   * Signalled when data is ready from the AccelX ADC. Stuffs the sensor
   * reading into the current packet, and sends off the packet when
   * BUFFER_SIZE readings have been taken.
   * @return Always returns SUCCESS.
   */
  async event result_t AccelX.dataReady(uint16_t data) {
    atomic {
      xData = data >> 1;
    }
    post handleXData();
    return SUCCESS;

  }

  /**
   * Signalled when the clock ticks.
   * @return The result of calling AccelY.getData().
   */
  event result_t SampleTimer.fired() {
    return call AccelY.getData();
  }

}
