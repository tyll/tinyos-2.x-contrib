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
 * This implements the 2 standard external interrupts of the
 * 8051. Additional variants like the Maxim DS80C320 define additional
 * while others define completely different interrupt setup (like the
 * Chip Con CC2430). However some stick to the original (like the
 * Nordic nRF24E1).
 *
 * I'm sure this could be implement with generic components, but I
 * couldn't find a clever way to pass the register/interrupt
 * definitions thorough the interface
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

module HplMcs51InterruptP {
  provides interface HplMcs51Interrupt as ext_int_0;
  provides interface HplMcs51Interrupt as ext_int_1;
}
implementation {
  // EX0 ~ IE.0   Sets the interrupt mask
  // PX0 ~ IP.0   Selects 1/0 priority level
  // IT0 ~ TCON.0 Sets edge/level trigered
  // IE0 ~ TCON.1 Interupt detected flag
  // IE1 ~ TCON.3 Interupt detected flag
  inline async command void ext_int_0.enable()  { EX0 = 1; }
  inline async command void ext_int_0.disable() { EX0 = 0; }
  inline async command void ext_int_0.clear()   { IE0 = 0; }
  inline async command void ext_int_0.priority(bool pri) { PX0 = pri ? 1 : 0;}
  inline async command void ext_int_0.edge_trig(bool edge) { IT0 = edge ? 1 : 0; }

  default async event void ext_int_0.fired() { }
  MCS51_INTERRUPT(SIG_INTERRUPT0) {
    signal ext_int_0.fired();
  }


  inline async command void ext_int_1.enable()  { EX0 = 1; }
  inline async command void ext_int_1.disable() { EX0 = 0; }
  inline async command void ext_int_1.clear()   { IE0 = 0; }
  inline async command void ext_int_1.priority(bool pri) { PX0 = pri ? 1 : 0;}
  inline async command void ext_int_1.edge_trig(bool edge) { IT0 = edge ? 1 : 0; }

  default async event void ext_int_1.fired() { }
  MCS51_INTERRUPT(SIG_INTERRUPT1) {
    signal ext_int_1.fired();
  }
}
