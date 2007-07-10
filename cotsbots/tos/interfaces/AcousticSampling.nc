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
 * Date last modified:  10/21/03
 *
 *
 */

interface AcousticSampling {

  /**
   * calibrate
   * @param num: The number of ADC values to get for calibration.
   *  @return Always returns SUCCESS.
   */
  command result_t calibrate(uint16_t num);

  /**
   * startSampling
   * @param num: The number of ADC values to get for sampling.
   *  @return Always returns SUCCESS.
   */
  command result_t startSampling(uint16_t num);

  /**
   * setThreshold
   * @param threshold: new +/- to use for determining beep
   *  @return Always returns SUCCESS.
   */
  command result_t setThreshold(uint8_t threshold);

  /**
   * doneCalibrating
   * @param value: new calibrated steady-state value for mic
   *  @return Always returns SUCCESS.
   */
  event result_t doneCalibrating(uint16_t value);

  /**
   * doneSampling
   * @param heardBeep: true/false if heard beep
   *  @return Always returns SUCCESS.
   */
  event result_t doneSampling(bool heardBeep);
}
