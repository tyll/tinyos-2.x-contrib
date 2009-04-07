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
 * Exposes just the interrupt vector routine for 
 * easy linking to generic components.
 *
 * @author Henrik Makitaavola
 */
module HplM16c62pInterruptSigP @safe()
{
  provides interface HplM16c62pInterruptSig as IntSig0;
  provides interface HplM16c62pInterruptSig as IntSig1;
  provides interface HplM16c62pInterruptSig as IntSig2;
  provides interface HplM16c62pInterruptSig as IntSig3;
  provides interface HplM16c62pInterruptSig as IntSig4;
  provides interface HplM16c62pInterruptSig as IntSig5;
}
implementation
{
  default async event void IntSig0.fired() { }
  M16C_INTERRUPT_HANDLER(M16C_INT0)
  {
    signal IntSig0.fired();
  }

  default async event void IntSig1.fired() { }
  M16C_INTERRUPT_HANDLER(M16C_INT1)
  {
    signal IntSig1.fired();
  }

  default async event void IntSig2.fired() { }
  M16C_INTERRUPT_HANDLER(M16C_INT2)
  {
    signal IntSig2.fired();
  }

  default async event void IntSig3.fired() { }
  M16C_INTERRUPT_HANDLER(M16C_INT3)
  {
    signal IntSig3.fired();
  }

  default async event void IntSig4.fired() { }
  M16C_INTERRUPT_HANDLER(M16C_INT4)
  {
    signal IntSig4.fired();
  }

  default async event void IntSig5.fired() { }
  M16C_INTERRUPT_HANDLER(M16C_INT5)
  {
    signal IntSig5.fired();
  }

}
