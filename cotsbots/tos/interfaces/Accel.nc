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
 * Date last modified:  9/4/02
 *
 * Hardware Accelerometer interface for digital outputs.  
 *
 */

interface Accel {

  /**
   * Init. 
   *  @return Always returns SUCCESS.
   */
  command result_t init();

  /**
   * startSensing.  Start continuous sensing of the acceleration. 
   *  @return Always returns SUCCESS.
   */
  command result_t startSensing();

  /**
   * stopSensing.  Stop the continuous sensing of the acceleration.
   *  @return Always returns SUCCESS.
   */
  command result_t stopSensing();

  /**
   * fire event.  Can fire an event when both x and y accelerations have
   *  been captured.
   * @param x The current x acceleration (currently in ADC units).
   * @param y The current y acceleration (currently in ADC units).
   *  @return Always returns SUCCESS.
   */
  event result_t fire(int16_t x, int16_t y);

  /**
   * debug event.  Can fire a debug event to a higher-level component
   *  (for example if a radio message is desired).
   * @param x The current x acceleration (currently in ADC units).
   * @param y The current y acceleration (currently in ADC units).
   *  @return Always returns SUCCESS.
   */
  event result_t debug(uint16_t x, uint16_t y);
}
