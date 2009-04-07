/* "Copyright (c) 2000-2005 The Regents of the University of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */
/**
 * @author Joe Polastre
 * @author Martin Turon
 */
 
/**
 * Creates a HIL interrupt component from a M16c/62p interrupt.
 *
 * @author Henrik Makitaavola
 */

generic module M16c62pInterruptC()
{
  provides interface GpioInterrupt;
  uses interface HplM16c62pInterrupt;
}
implementation {
  /**
   * enable an edge interrupt on the Interrupt pin
   */
  async command error_t GpioInterrupt.enableRisingEdge()
  {
    atomic
    {
      call HplM16c62pInterrupt.disable();
      call HplM16c62pInterrupt.edge(true);
      call HplM16c62pInterrupt.clear();
      call HplM16c62pInterrupt.enable();
    }
    return SUCCESS;
  }

  async command error_t GpioInterrupt.enableFallingEdge()
  {
    atomic
    {
      call HplM16c62pInterrupt.disable();
      call HplM16c62pInterrupt.edge(false);
      call HplM16c62pInterrupt.clear();
      call HplM16c62pInterrupt.enable();
    }
    return SUCCESS;
  }

  /**
   * disables interrupts.
   */
  async command error_t GpioInterrupt.disable()
  {
    atomic
    {
      call HplM16c62pInterrupt.disable();
      call HplM16c62pInterrupt.clear();
    }
    return SUCCESS;
  }

  /**
   * Event fired by lower level interrupt dispatch for Interrupt.
   */
  async event void HplM16c62pInterrupt.fired()
  {
    signal GpioInterrupt.fired();
  }

  default async event void GpioInterrupt.fired() { }
}
