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
 * Date last modified:  8/12/02
 *
 *
 */

interface Robot {

  /**
   * Init. 
   *  @return Always returns SUCCESS.
   */
  command error_t init();

  /**
   * setSpeed. 
   * @param speed: The acceptable range is from 0-255.  However, a high
   *   speed with fresh batteries is somewhere around 70 or 80.
   *  @return Always returns SUCCESS.
   */
  command error_t setSpeed(uint8_t speed);

  /**
   * setDir. 
   * @param direction: set robot direction to forward or reverse
   *    forward = 1
   *    reverse = 0
   *  @return Always returns SUCCESS.
   */
  command error_t setDir(uint8_t direction);

  /**
   * setTurn. 
   * @param turn: The acceptable range is from 0-60 with
   *    straight = 30
   *    full left = 0
   *    full right = 60
   *  @return Always returns SUCCESS.
   */
  command error_t setTurn(uint8_t turn);

  /**
   * setSpeedTurnDirection. 
   * @param speed: The acceptable range is from 0-255.  However, a high
   *   speed with fresh batteries is somewhere around 70 or 80.
   * @param turn: The acceptable range is from 0-60 with
   *    straight = 30
   *    full left = 0
   *    full right = 60
   * @param direction: set robot direction to forward or reverse
   *    forward = 1
   *    reverse = 0
   *  @return Always returns SUCCESS.
   */
  command error_t setSpeedTurnDirection(uint8_t speed, uint8_t turn, uint8_t dir);
}
