/*
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO 
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL 
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH 
 * DAMAGE. 
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY 
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS 
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY 
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR 
 * MODIFICATIONS.
 */
/**
 * @author Martin Turon <mturon@xbow.com>
 */
 
/**
 * Interrupt interface access for interrupt capable GPIO pins.
 *
 * @author Henrik Makitaavola
 */
generic module HplM16c62pInterruptPinP (uint16_t ctrl_addr, uint8_t edgebit) @safe()
{
  provides interface HplM16c62pInterrupt as Irq;
  uses interface HplM16c62pInterruptSig as IrqSignal;
}
implementation
{
#define ctrl  (*TCAST(volatile uint8_t * ONE, ctrl_addr))

  inline async command bool Irq.getValue() { return READ_BIT(ctrl, 3); }
  inline async command void Irq.clear()    { CLR_BIT(ctrl, 3); }
  inline async command void Irq.disable()  { CLR_BIT(ctrl, 0); }
  inline async command void Irq.enable()
  {
    if (edgebit > 3)
    {
      SET_BIT(IFSR.BYTE, (edgebit+2));
    }
    SET_BIT(ctrl, 0);

  }

  inline async command void Irq.edge(bool low_to_high) {
    CLR_BIT(IFSR.BYTE, edgebit); // use edge mode
    // and select rising vs falling
    if (low_to_high)
    {
      SET_BIT(ctrl, 4);
    }
    else
    {
      CLR_BIT(ctrl, 4);
    }
  }

  inline async command void Irq.bothEdges()
  {
    SET_BIT(IFSR.BYTE, edgebit);
    CLR_BIT(ctrl, 4);
  }

  /** 
   * Forward the external interrupt event.
   */
  async event void IrqSignal.fired() {
    call Irq.clear();
    signal Irq.fired();
  }

  default async event void Irq.fired() { }
}
