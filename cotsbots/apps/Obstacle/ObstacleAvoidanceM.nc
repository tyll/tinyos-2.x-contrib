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
 *
 * This is an obstacle-avoidance component that utilizes the accelerometer on
 * the mica sensorboard to determine the presence of an obstacle.  When
 * an obstacle is detected, the robot will back up, turn, and go in a
 * new direction.
 *
 */

module ObstacleAvoidanceM
{
  provides interface StdControl;
  uses {
    interface Leds;
    interface StdControl as ObstacleControl;
    interface Obstacle;
    interface Robot;

    interface Timer as ReverseTimer;
    interface StdControl as TimerControl;
  }
}
implementation
{
  enum {
    SPEED_FORWARD = 60,
    SPEED_REV = 70,
    OFF = 0,
    FORWARD = 1,
    REVERSE = 0,
    RIGHT = 45,
    STRAIGHT = 30,
    TURN_TIME = 1000
  };

  /**
   * Used to initialize this component.
   */
  command result_t StdControl.init() {
    call Leds.init();
    call Leds.greenOn();

    //turn on the sensors so that they can be read.
    call ObstacleControl.init();
    call TimerControl.init();
    call Robot.init();

    dbg(DBG_BOOT, "OBSTACLE initialized\n");
    return SUCCESS;
  }

  /**
   * Starts the SensorControl and CommControl components.
   * @return Always returns SUCCESS.
   */
  command result_t StdControl.start() {
    call Obstacle.setThreshold(4,2);
    call Obstacle.calibrate();

    return SUCCESS;
  }

  /**
   * Stops the SensorControl and CommControl componets.
   * @return Always returns SUCCESS.
   */
  command result_t StdControl.stop() {
    call ObstacleControl.stop();
    call Robot.setSpeed(OFF);
    call TimerControl.stop();
    return SUCCESS;
  }

  /**
   * Signalled when obstacle calibration is finished.
   * @return Always returns SUCCESS.
   */
  event result_t Obstacle.calibrateDone(uint16_t dataX, uint16_t dataY) {
    call Leds.greenOff();
    call ObstacleControl.start();
    call Robot.setSpeedTurnDirection(SPEED_FORWARD,STRAIGHT,FORWARD);
    return SUCCESS;
  }

  /**
   * Signalled when obstacle is detected.
   * @return Always returns SUCCESS.
   */
  event result_t Obstacle.obstacleDetected(uint16_t data, uint8_t direction) {
    call Robot.setSpeedTurnDirection(SPEED_REV,RIGHT,REVERSE);
    call Leds.redOn();
    call ReverseTimer.start(TIMER_ONE_SHOT, TURN_TIME);
    return SUCCESS;
  }


  /**
   * Signalled when the clock ticks.
   * @return The result of calling ADC.getData().
   */
  event result_t ReverseTimer.fired() {
    call Leds.redOff();
    call Robot.setSpeedTurnDirection(SPEED_FORWARD,STRAIGHT,FORWARD);
    return SUCCESS;
  }

}
