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
 * This interface exposes the highly peculiar interrupt interface of
 * the CC2430. Since all 3 ports are different we don't create a
 * general definition for all ports, but expose methods that correspond
 * almost one to one to the registers of the chip.
 * 
 * This is rather different than the standard 8051 interface.
 * 
 */

/**
 * @author Martin Leopold <leopold@diku.dk>
 */

/** INCOMPLETE, mising:
 * enable
 * clear (clear int. flag)
 */

interface HplCC2430Interrupt
{

  async command void P0_edge(bool low_to_high);
  // PICTL.P0ICON
  async command void P1_edge(bool low_to_high);
  // PICTL.P1ICON
  async command void P2_edge(bool low_to_high);
  // PICTL.P2ICON

  command void disable_P0(); // Disable interrupts from entire P0
  // IEN1.P0IE 

  command void disable_P0_0_3(); // Disable interrupts from pin 0-3 of P0
  // PICTL.POIENH

  command void disable_P0_3_7(); // Disable interrupts from pin 3-7 of P0
  // PICTL.POIENL

  command void disable_P1(); // Disable interrupts from entire P1
  // IEN2.P1IE 

  // Bellow P1IEN.0-7
  command void disable_P1_0(); // Disable interrupts from pin 0 of P1
  command void disable_P1_1(); // Disable interrupts from pin 1 of P1
  command void disable_P1_2(); // Disable interrupts from pin 2 of P1
  command void disable_P1_3(); // Disable interrupts from pin 3 of P1
  command void disable_P1_4(); // Disable interrupts from pin 4 of P1
  command void disable_P1_5(); // Disable interrupts from pin 5 of P1
  command void disable_P1_6(); // Disable interrupts from pin 6 of P1
  command void disable_P1_7(); // Disable interrupts from pin 7 of P1

  command void disable_P2(); // Disable interrupts from entire P2
  // IEN2.P2IE
  command void disable_P2_0_3(); // Disable interrupts from pin 0-4 of P2
  // PICT.P2IEN

  /**
   * Signalled when any of the pins of P0 triggers an interrupt
   */
  async event void P0_fired();
  // Signal: IRCON2.P0IF

  /**
   * Signalled when any of the pins of P0 triggers an interrupt
   */
  async event void P1_fired();
  // Signal: IRCON2.P1IF

  /**
   * Signalled when any of the pins of P0 triggers an interrupt
   */
  async event void P2_fired();
  // Signal: IRCON2.P2IF
}
