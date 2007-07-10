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
 */

interface EEPROM {

  /**
   * Init. 
   *  @return Always returns SUCCESS.
   */
  async command result_t init();

  /**
   * read.  Read from the EEPROM.
   * @param address: address I would like to read.  On the ATmega8L for
   *   example, there are 512 bytes of EEPROM.
   *  @return Always returns SUCCESS.
   */
  async command uint8_t read(uint8_t address);

  /**
   * write.  Write to the EEPROM.
   * @param address: address I would like to write.  On the ATmega8L for
   *   example, there are 512 bytes of EEPROM.
   *  @return Always returns SUCCESS.
   */
  async command result_t write(uint8_t address, uint8_t data);

  /**
   * writeDone event.
   *  @return Always returns SUCCESS.
   */
  async event result_t writeDone();
}
