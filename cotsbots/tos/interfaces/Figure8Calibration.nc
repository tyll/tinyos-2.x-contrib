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
 * Date last modified:  8/13/02
 *
 *
 */

interface Figure8Calibration {

  /**
   * setRightTurn. 
   * @param time: The time at which to make the right turn in the figure8.
   *  @return Always returns SUCCESS.
   */
  command result_t setRightTurn(uint8_t time);

  /**
   * setStraight1Turn. 
   * @param time: The time at which to make the first straight turn in 
   *  the figure8.
   *  @return Always returns SUCCESS.
   */
  command result_t setStraight1Turn(uint8_t time);

  /**
   * setLeftTurn. 
   * @param time: The time at which to make the left turn in the figure8.
   *  @return Always returns SUCCESS.
   */
  command result_t setLeftTurn(uint8_t time);

  /**
   * setStraight2Turn. 
   * @param time: The time at which to make the second straight turn in 
   *  the figure8.
   *  @return Always returns SUCCESS.
   */
  command result_t setStraight2Turn(uint8_t time);

  /**
   * setSpeed.
   * @param speed: The acceptable range is from 0-255.  However, a high
   *   speed with fresh batteries is somewhere around 70 or 80.  This is
   *   obviously a very critical parameter for an open-loop, timed figure8.
   */
  command result_t setSpeed(uint8_t speed);
}
