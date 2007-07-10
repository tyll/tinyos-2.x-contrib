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

interface ServoCalibration {

  /**
   * setKp. 
   * @param Kp: The proportional term for the PI control loop to control
   *   the Mini-Z hardware servo.  Since each motor is different, this 
   *   parameter may be tuned for better performance.
   *  @return Always returns SUCCESS.
   */
  command result_t setKp(uint8_t Kp);

  /**
   * setKi.
   * @param Ki: The integral term for the PI control loop to control
   *   the Mini-Z hardware servo.  An integral term is necessary due to
   *   the motor inertia.  Since each motor is different, this parameter
   *   may be tuned for better performance.
   *  @return Always returns SUCCESS.
   */
  command result_t setKi(uint8_t Ki);

  /**
   * setStraight.
   * @param straight: Because the potentiometer on the motor shaft of each
   *   Mini-Z servo is different, it is necessary to calibrate for the
   *   "straight" value of each robot.  This is the 9-bit ADC reading found
   *   when the motor is going straight.
   *  @return Always returns SUCCESS.
   */
  command result_t setStraight(uint8_t straight);

  /**
   * getKp. 
   * @return Kp: The proportional term for the PI control loop to control
   *   the Mini-Z hardware servo.  Since each motor is different, this 
   *   parameter may be tuned for better performance.
   */
  command uint8_t getKp();

  /**
   * getKi.
   * @return Ki: The integral term for the PI control loop to control
   *   the Mini-Z hardware servo.  An integral term is necessary due to
   *   the motor inertia.  Since each motor is different, this parameter
   *   may be tuned for better performance.
   */
  command uint8_t getKi();

  /**
   * getStraight.
   * @return straight: Because the potentiometer on the motor shaft of each
   *   Mini-Z servo is different, it is necessary to calibrate for the
   *   "straight" value of each robot.  This is the 9-bit ADC reading found
   *   when the motor is going straight.
   */
  command uint8_t getStraight();

  /**
   * setDebug. 
   * @param debug: Set to 1 if would like servo debugging information.  This
   *    is useful while setting the Kp and Ki values (to see the actual
   *    positions my servo is being set to or the value of the motor
   *    control signal).
   *  @return Always returns SUCCESS.
   */
  command result_t setDebug(uint8_t state);
}
