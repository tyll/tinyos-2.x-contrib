// $Id$

/*
 * Copyright (c) 2009 NUS
 * Copyright (c) 2006 ETH Zurich.  
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

/**
 * The implementation of the standard 3 LED mote abstraction.
 *
 * @author Joe Polastre
 * @author Philip Levis
 * @author Jan Beutel
 *
 * @date   March 21, 2005
 */

module LedsP {
  provides {
    interface Init;
    interface Leds;
  }
  uses {
    interface Leds as Led0;
    interface SetNow<bool> as Led1;
    interface SetNow<bool> as Led2;
    interface SetNow<bool> as Led3;
  }
}
implementation {
  command error_t Init.init() {
    atomic {
      dbg("Init", "LEDS: initialized.\n");
//      call Led0.makeOutput();
//      call Led1.makeOutput();
//      call Led2.makeOutput();
//      call Led3.makeOutput();
    }
    return SUCCESS;
  }

  async command void Leds.led0On() {
    dbg("LedsC", "LEDS: Led 1 on.\n"); 
    call Led0.setNow(TRUE);
  }

  async command void Leds.led0Off() {
    dbg("LedsC", "LEDS: Led 1 off.\n");
    call Led0.setNow(FALSE);
  }

  async command void Leds.led0Toggle() {
    call LatchPin.set();
    call Led0.toggle();
    // this should be removed by dead code elimination when compiled for
    // the physical motes
    if (call Led0.get())
      dbg("LedsC", "LEDS: Led 1 off.\n");
    else
      dbg("LedsC", "LEDS: Led 1 on.\n");
  }

  async command void Leds.led1On() {
    dbg("LedsC", "LEDS: Led 2 on.\n");
    call LatchPin.set();
    call Led1.set();
  }

  async command void Leds.led1Off() {
    dbg("LedsC", "LEDS: Led 2 off.\n");
    call LatchPin.set();
    call Led1.clr();
  }

  async command void Leds.led1Toggle() {
    call LatchPin.set();
    call Led1.toggle();
    if (call Led1.get())
      dbg("LedsC", "LEDS: Led 2 off.\n");
    else
      dbg("LedsC", "LEDS: Led 2 on.\n");
  }

  async command void Leds.led2On() {
    dbg("LedsC", "LEDS: Led 3 on.\n");
    call LatchPin.set();
    call Led2.set();
  }

  async command void Leds.led2Off() {
    dbg("LedsC", "LEDS: Led 3 off.\n");
    call LatchPin.set();
    call Led2.clr();
  }

  async command void Leds.led2Toggle() {
    call LatchPin.set();
    call Led2.toggle();
    if (call Led2.get())
      dbg("LedsC", "LEDS: Led 3 off.\n");
    else
      dbg("LedsC", "LEDS: Led 3 on.\n");
  }

  async command void Leds.led3On() {
    dbg("LedsC", "LEDS: Led 4 on.\n");
    call LatchPin.set();
    call Led3.set();
  }

  async command void Leds.led3Off() {
    dbg("LedsC", "LEDS: Led 4 off.\n");
    call LatchPin.set();
    call Led3.clr();
  }

  async command void Leds.led3Toggle() {
    call LatchPin.set();
    call Led3.toggle();
    if (call Led3.get())
      dbg("LedsC", "LEDS: Led 4 off.\n");
    else
      dbg("LedsC", "LEDS: Led 4 on.\n");
  }

  async command uint8_t Leds.get() {
    uint8_t rval;
    atomic {
      rval = 0;
      if (call Led0.get()) {
	rval |= LEDS_LED0;
      }
      if (call Led1.get()) {
	rval |= LEDS_LED1;
      }
      if (call Led2.get()) {
	rval |= LEDS_LED2;
      }
      if (call Led3.get()) {
	rval |= LEDS_LED3;
      }
    }
    return rval;
  }

  async command void Leds.set(uint8_t val) {
    atomic {
    call LatchPin.set();
      if (val & LEDS_LED0) {
	call Leds.led0On();
      }
      else {
	call Leds.led0Off();
      }
      if (val & LEDS_LED1) {
	call Leds.led1On();
      }
      else {
	call Leds.led1Off();
      }
      if (val & LEDS_LED2) {
	call Leds.led2On();
      }
      else {
	call Leds.led3Off();
      }
      if (val & LEDS_LED3) {
	call Leds.led3On();
      }
      else {
	call Leds.led3Off();
      }
    }
  }
}
