/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
 
#include "Msp430Timer.h"

module TestP {
  uses {
    interface Boot;
    interface Msp430Pwm;
    interface HplMsp430GeneralIO;
    interface Leds;
  }
}

implementation {

  event void Boot.booted() {
    // Select one of the TA1 outputs and tell it to output its TimerA events.
    call HplMsp430GeneralIO.makeOutput();
    call HplMsp430GeneralIO.selectModuleFunc();
    
    // 1. Initialize the clock sources
    call Msp430Pwm.init(MSP430TIMER_SMCLK, MSP430TIMER_CLOCKDIV_1);
    
    // 2. Setup the pulse you want to create
    call Msp430Pwm.setTiming(4000, 40);
    
    // 3. Optionally activate software interrupts. If you don't, your
    // software will probably run faster.
    call Msp430Pwm.activateInterrupts(TRUE);
    
    // 4. Tell it to turn on TA1.
    call Msp430Pwm.runA1(TRUE);
  }
  
  /**
   * This gets called every timer fire if you enable software interrupts.
   * You can set it up so it only fires on the rising edge, falling edge,
   * or both inside the PWM code.
   */
  async event void Msp430Pwm.fired() {
    call Leds.led0Toggle();
  }
  
}
