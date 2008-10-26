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
 * This component provides access to the two traditional 8051 timers
 * with relatively limited functionality.
 *
 * The classic 8051 had a fixed clock divider of 12, while most chips
 * today provide a (vendor specific) programmable divider, and must be
 * configured elsewhere.
 *
 * Timer1/Counter1 is traditionally used for UART baud rate
 * generation.
 */

/**
 * @author Martin Leopold <leopold@polaric.dk>
 */

#include <byteorder.h>
#include "mcs51-timer.h"


module HplMcs51TimerP {
  provides interface HplMcs51Counter as Counter0;
  provides interface HplMcs51Counter as Counter1;
} implementation {

  /**
   * Counter 0
   */

  async command void Counter0.setInterruptEnable(bool i) {ET0=i;};
  async command void Counter0.start() {TR0=1;};
  async command void Counter0.stop()  {TR0=0;};
  async command void Counter0.set(uint8_t hi, uint8_t lo) { TL0 = lo; TH0 = hi;};
  async command bool Counter0.setRate(uint16_t r) {return TRUE;};
  async command void Counter0.setMode(mcs51_timer_mode_t mode) {
    TMOD = (TMOD & ~MCS51_TMOD_T0MODE_MASK) | mode;
  };
  async command void Counter0.setClkSrc(mcs51_timer_src_t src) {
    TMOD = (TMOD & ~_BV(MCS51_TMOD_CT0)) | src<<MCS51_TMOD_CT0;
  };

  async command uint16_t Counter0.get() {
    uint16_t r=0;
    r += TL0;
    r += 256*(uint16_t)TH0;
    return r;
  }
  async command bool Counter0.isOverflowPending() { return( TF0 ); }
  async command void Counter0.clearOverflow()     { TF0=0;  }
  default async event void Counter0.overflow() { }

  /**
   * Counter 1
   */

  async command void Counter1.setInterruptEnable(bool i) {ET1=i;};
  async command void Counter1.start() {TR1=1;};
  async command void Counter1.stop()  {TR1=0;};
  async command void Counter1.set(uint8_t hi, uint8_t lo) { TL1 = lo; TH1 = hi;};
  async command bool Counter1.setRate(uint16_t r) {return TRUE;};
  async command void Counter1.setMode(mcs51_timer_mode_t mode) {
    TMOD = (TMOD & ~MCS51_TMOD_T0MODE_MASK) | (mode<<MCS51_TMOD_T1M0);
  };
  async command void Counter1.setClkSrc(mcs51_timer_src_t src) {
    TMOD = (TMOD & ~_BV(MCS51_TMOD_CT1)) | src<<MCS51_TMOD_CT1;
  };

  async command uint16_t Counter1.get() {
    uint16_t r=0;
    r += TL1;
    r += 256*(uint16_t)TL1;
    return r;
  }
  async command bool Counter1.isOverflowPending() { return( TF1 ); }
  async command void Counter1.clearOverflow()     { TF1=0;  }

 default async event void Counter1.overflow() { }

  MCS51_INTERRUPT(SIG_TIMER0){
    signal Counter0.overflow();
    TF0=0;
  }

  MCS51_INTERRUPT(SIG_TIMER1){
    signal Counter1.overflow();
    TF1=0;
  }
}
