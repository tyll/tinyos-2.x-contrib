/*
 * Copyright (c) 2007 University of Copenhagen
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * This interfaces resembles the atm128 HPL interrupt interface, but
 * is different in the following ways:
 *   - getVal is removed (use GIOP instead)
 *   - edge is removed (only high-to-low edge available
 *   - priority sets the interrupt 1/0 priority
 *   - edge_trig sets edge or level trig
 *
 * @author Martin Leopold <leopold@diku.dk>
 * 
 */

interface HplMcs51Interrupt
{

  /** 
   * Sets the priority register for this interrupt
   */
  async command void priority(bool pri);

  /** 
   * Enables this interrupt by setting the interrupt mask
   */
  async command void enable();

  /** 
   * Disables this interrupt by setting the interrupt mask
   */
  async command void disable();

  /** 
   * Clears register for that particular port. For standard 8051
   * interrupts: the register can be cleared in edge triggered mode
   * (but will also be cleared by the start of an interrupt service
   * routine, it cannot be cleared in level triggered mode
   */
  async command void clear();

  /** 
   * Sets whether the external pin is edge or level triggered. In edge
   * trig mode the 2 standard interrupts of the 8051 are trigged on
   * high-to-low edge.
   *
   * @param TRUE if the interrupt should be triggered on edge, false
   *        triggers on level
   *
   */
  async command void edge_trig(bool edge_triggered);

  /**
   * Signalled when an interrupt occurs on this pin
   */
  async event void fired();
}
