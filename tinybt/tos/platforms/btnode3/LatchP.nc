/* $Id$ */
/*
 * Copyright (c) 2006 NUS
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
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Module implementation of Latch
 *
 *  @author Lee Seng Jea
 */
#include "Latch.h"
module LatchP {
  provides interface Leds;
  provides interface GeneralIO as CCPower;
  provides interface GeneralIO as IOPower;
  provides interface GeneralIO as BTPower;
  provides interface GeneralIO as BTReset;
  uses interface GeneralIO as LatchPin;
}
implementation {
  uint8_t latch_value = 0;
  void set_latch(uint8_t _latch_value) {
    volatile uint8_t* pointer;
atomic {
    pointer = (uint8_t *) ((uint16_t) _latch_value << 8);
    *pointer++;
    *pointer--;
    //TODO: Magic Numbers!
    DDRB |= 1 << 5;  
    PORTB |= 1 << 5;
    asm volatile ("nop"::);
    PORTB &= ~(1 << 5);
    latch_value = _latch_value;
    }
  }
   async command void Leds.led0On() {
    dbg("LedsC", "LEDS: Led 1 on.\n"); 
    atomic set_latch(latch_value | (1 << LATCH_PIN_LED0));
  }

  async command void Leds.led0Off() {
    dbg("LedsC", "LEDS: Led 1 off.\n");
    atomic set_latch(latch_value & ~(1 << LATCH_PIN_LED0));
  }

  async command void Leds.led0Toggle() {
    atomic set_latch(latch_value ^ (1 << LATCH_PIN_LED0));
  }

   async command void Leds.led1On() {
    dbg("LedsC", "LEDS: Led 2 on.\n"); 
    atomic set_latch(latch_value | (1 << LATCH_PIN_LED1));
  }

  async command void Leds.led1Off() {
    dbg("LedsC", "LEDS: Led 2 off.\n");
    atomic set_latch(latch_value & ~(1 << LATCH_PIN_LED1));
  }

  async command void Leds.led1Toggle() {
    atomic set_latch(latch_value ^ (1 << LATCH_PIN_LED1));
  }

   async command void Leds.led2On() {
    dbg("LedsC", "LEDS: Led 3 on.\n"); 
    atomic set_latch(latch_value | (1 << LATCH_PIN_LED2));
  }

  async command void Leds.led2Off() {
    dbg("LedsC", "LEDS: Led 3 off.\n");
    atomic set_latch(latch_value & ~(1 << LATCH_PIN_LED2));
  }

  async command void Leds.led2Toggle() {
    atomic set_latch(latch_value ^ (1 << LATCH_PIN_LED2));
  }

   async command void Leds.led3On() {
    dbg("LedsC", "LEDS: Led 4 on.\n"); 
    atomic set_latch(latch_value | (1 << LATCH_PIN_LED3));
  }

  async command void Leds.led3Off() {
    dbg("LedsC", "LEDS: Led 4 off.\n");
    atomic set_latch(latch_value & ~(1 << LATCH_PIN_LED3));
  }

  async command void Leds.led3Toggle() {
    atomic set_latch(latch_value ^ (1 << LATCH_PIN_LED3));
  }

  async command uint8_t Leds.get() {
    uint8_t rval;
    atomic return latch_value & 0x0F;
  }

  async command void Leds.set(uint8_t val) {
   atomic set_latch((val & 0x0F) | latch_value);
  }
  async command void CCPower.set(){ atomic set_latch(latch_value | (1 << LATCH_PIN_CCPOWER)); }
  async command void CCPower.clr() { atomic set_latch(latch_value & ~(1 << LATCH_PIN_CCPOWER)); }
  async command void CCPower.toggle() { atomic set_latch(latch_value ^ (1 << LATCH_PIN_CCPOWER)); }
  async command bool CCPower.get() { atomic return latch_value & (1 << LATCH_PIN_CCPOWER); }
  async command void CCPower.makeInput() {}
  async command bool CCPower.isInput() { return FALSE; }
  async command void CCPower.makeOutput() {}
  async command bool CCPower.isOutput() { return TRUE; }
  async command void IOPower.set(){ atomic set_latch(latch_value | (1 << LATCH_PIN_IOPOWER)); }
  async command void IOPower.clr() { atomic set_latch(latch_value & ~(1 << LATCH_PIN_IOPOWER)); }
  async command void IOPower.toggle() { atomic set_latch(latch_value ^ (1 << LATCH_PIN_IOPOWER)); }
  async command bool IOPower.get() { atomic return latch_value & (1 << LATCH_PIN_IOPOWER); }
  async command void IOPower.makeInput() {}
  async command bool IOPower.isInput() { return FALSE; }
  async command void IOPower.makeOutput() {}
  async command bool IOPower.isOutput() { return TRUE; }
  async command void BTPower.set(){ atomic set_latch(latch_value | (1 << LATCH_PIN_BTPOWER)); }
  async command void BTPower.clr() { atomic set_latch(latch_value & ~(1 << LATCH_PIN_BTPOWER)); }
  async command void BTPower.toggle() { atomic set_latch(latch_value ^ (1 << LATCH_PIN_BTPOWER)); }
  async command bool BTPower.get() { atomic return latch_value & (1 << LATCH_PIN_BTPOWER); }
  async command void BTPower.makeInput() {}
  async command bool BTPower.isInput() { return FALSE; }
  async command void BTPower.makeOutput() {}
  async command bool BTPower.isOutput() { return TRUE; }
  async command void BTReset.set(){ atomic set_latch(latch_value | (1 << LATCH_PIN_BTRESET)); }
  async command void BTReset.clr() { atomic set_latch(latch_value & ~(1 << LATCH_PIN_BTRESET)); }
  async command void BTReset.toggle() { atomic set_latch(latch_value ^ (1 << LATCH_PIN_BTRESET)); }
  async command bool BTReset.get() { atomic return latch_value & (1 << LATCH_PIN_BTRESET); }
  async command void BTReset.makeInput() {}
  async command bool BTReset.isInput() { return FALSE; }
  async command void BTReset.makeOutput() {}
  async command bool BTReset.isOutput() { return TRUE; }
}
