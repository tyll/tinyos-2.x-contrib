
/*
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of Crossbow Technology nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <atm128hardware.h>

/**
 * Component providing access to all external interrupt pins on ATmega1284.
 * @author Martin Turon <mturon@xbow.com>
 * @author Martin Cerveny
 */

configuration HplAtm128InterruptC
{
  // provides all the ports as raw ports
  provides {
    interface HplAtm128Interrupt as Int0;
    interface HplAtm128Interrupt as Int1;
    interface HplAtm128Interrupt as Int2;
  }
}
implementation
{
#define IRQ_PORT_PIN(bit) (uint8_t)&EICRA, ISC##bit##0, ISC##bit##1, bit

  components 
    HplAtm128InterruptSigP as IrqVector,
    new HplAtm128InterruptPinP(IRQ_PORT_PIN(0)) as IntPin0,
    new HplAtm128InterruptPinP(IRQ_PORT_PIN(1)) as IntPin1,
    new HplAtm128InterruptPinP(IRQ_PORT_PIN(2)) as IntPin2;
  
  Int0 = IntPin0;
  Int1 = IntPin1;
  Int2 = IntPin2;

  IntPin0.IrqSignal -> IrqVector.IntSig0;
  IntPin1.IrqSignal -> IrqVector.IntSig1;
  IntPin2.IrqSignal -> IrqVector.IntSig2;
}

