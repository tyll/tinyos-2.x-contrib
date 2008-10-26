/*
 * Copyright (c) 2008 Polaric
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
 * - Neither the name of Polaric nor the names of its contributors may
 *   be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL POLARIC OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * ReverseGPIOP reverses the semantics of clr/set in GeneralIO
 *
 * Usefull when implementing Leds (LedsC assumes active low)
 *
 * @author Martin Leopold <ml@polaric.dk>
 */

generic module ReverseGPIOP() {

  provides interface GeneralIO as Out;
  uses interface GeneralIO as In;
}
implementation {

#define REVERSE_GPIO_PIN(in, out) \
  inline async command bool out.get()       { return (call in.get());    } \
  inline async command void out.set()       { call in.clr();             } \
  inline async command void out.clr()       { call in.set();             } \
  async command void        out.toggle()    { atomic { call in.toggle();}} \
  inline async command bool out.isInput()   { call in.isInput();         } \
  inline async command bool out.isOutput()  { call in.isInput();;        } \
  inline async command void out.makeInput() { call in.makeInput();       } \
  inline async command void out.makeOutput(){ call in.makeOutput();      }


  REVERSE_GPIO_PIN(In, Out);
}
