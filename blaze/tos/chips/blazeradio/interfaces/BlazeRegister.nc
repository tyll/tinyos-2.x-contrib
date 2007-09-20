/*									tab:4
 * "Copyright (c) 2005 Stanford University. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and
 * its documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 * 
 * IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 * 
 * STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
 * HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/**
 * @author Philip Levis
 * @author Jared Hill
 * @author David Moss
 */

#include "Blaze.h"

interface BlazeRegister {

  /**
   * Read a 8-bit data word from the register.
   *
   * @param data pointer to place the register value.
   * @return status byte from the read.
   */
  async command blaze_status_t read(uint8_t* data);

  /**
   * Write a 8-bit data word to the register.
   * 
   * @param data value to write to register.
   * @return status byte from the write.
   */
  async command blaze_status_t write(uint8_t data);
  

}
