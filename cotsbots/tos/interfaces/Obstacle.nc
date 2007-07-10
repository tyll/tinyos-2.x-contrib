/*									tab:4
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
 * Authors:		Sarah Bergbreiter
 * Date last modified:  2/25/03
 *
 *
 */

interface Obstacle {

  /**
   * calibrate.
   *  @return Always returns SUCCESS.
   */
  command result_t calibrate();

  /**
   * calibrateDone. 
   * @param zeroX: zero-g calibration value from AccelX
   * @param zeroY: zero-g calibration value from AccelY
   *  @return Always returns SUCCESS.
   */
  event result_t calibrateDone(uint16_t zeroX, uint16_t zeroY);

  /**
   * obstacleDetected. 
   * @param value: current acceleration averaged value
   * @param direction: current direction acceleration came from
   *	0 = X
   *	1 = Y
   *  @return Always returns SUCCESS.
   */
  event result_t obstacleDetected(uint16_t value, uint8_t direction);

  /**
   * setThreshold.
   * @param thresholdX: Fire obstacleDetected if acceleration
   *	is above or below this threshold value in X direction
   * @param thresholdY: Fire obstacleDetected if acceleration
   *	is above or below this threshold value in Y direction
   *  @return Always returns SUCCESS.
   */
  command result_t setThreshold(uint8_t thresholdX, uint8_t thresholdY);


  /**
   * getThresholdX.
   *  @return returns thresholdX current value.
   */
  command uint8_t getThresholdX();

  /**
   * getThresholdY.
   *  @return returns thresholdY current value.
   */
  command uint8_t getThresholdY();

}
