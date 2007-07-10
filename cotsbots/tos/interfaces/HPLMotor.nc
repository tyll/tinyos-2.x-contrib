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
 * Date last modified:  7/9/02
 *
 *
 */

// The hardware motor interface.  Currently speed is an 8-bit number from
// 0-255 (nonlinear).  Direction: forward = 1, reverse = 0.

interface HPLMotor {

  /**
   * Init. 
   *  @return Always returns SUCCESS.
   */
  command result_t init();

  /**
   * setSpeed. 
   * @param speed: The acceptable range is from 0-255.  However, a high
   *   speed with fresh batteries is somewhere around 70 or 80 on the Mini-Z.
   *  @return Always returns SUCCESS.
   */
  command result_t setSpeed(uint8_t speed);

  /**
   * setDir. 
   * @param direction: set robot direction to forward or reverse
   *    forward = 1
   *    reverse = 0
   *  @return Always returns SUCCESS.
   */
  command result_t setDir(uint8_t direction);

  /**
   * getSpeed. 
   *  @return Returns the current speed setting for the motor.
   */
  command uint8_t getSpeed();

  /**
   * Init. 
   *  @return Returns the current direction of the motor.
   */
  command uint8_t getDir();
}
