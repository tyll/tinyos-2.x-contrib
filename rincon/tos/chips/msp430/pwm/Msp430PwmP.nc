
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
#include "Msp430Pwm.h"

 
module Msp430PwmP {
  provides {
    interface Msp430Pwm;
  }
  
  uses {
    interface Msp430Timer as TimerA;
    interface Msp430TimerControl as ControlA0;
    interface Msp430TimerControl as ControlA1;
    interface Msp430Compare as CompareA0;
    interface Msp430Compare as CompareA1;
  }
}

implementation {
  
  /** Interrupts are disabled by default */
  uint8_t interruptsEnabled = 0;
  
  /***************** Prototypes ****************/
  void reconfigure();
  
  /***************** Msp430Pwm Commands ****************/
  command void Msp430Pwm.init(uint16_t clockSource, uint16_t inputDivider) {
    call TimerA.setMode(MSP430TIMER_STOP_MODE);
    call TimerA.setClockSource(clockSource);
    call TimerA.setInputDivider(inputDivider);
  }
  
  command void Msp430Pwm.setTiming(uint16_t period, uint16_t on) {
    call CompareA0.setEvent(period - 1);
    call CompareA1.setEvent(on - 1);
  }
  
  command void Msp430Pwm.activateInterrupts(bool on) {
    if(interruptsEnabled != on) {
      interruptsEnabled = on;
      reconfigure();
    }
  }
  
  command void Msp430Pwm.runA1(bool on) {
    if(on) {
      reconfigure();
      call TimerA.setMode(MSP430TIMER_UP_MODE);
    
    } else {
      call TimerA.setMode(MSP430TIMER_STOP_MODE);
    }
  }
  
  /***************** Timer Events ****************/
  async event void TimerA.overflow() {
  }
  
  async event void CompareA0.fired() {
  }
  
  async event void CompareA1.fired() {
    signal Msp430Pwm.fired();
  }
  
  
  /***************** Functions ****************/
  void reconfigure() {
    msp430_compare_control_t resetSet = {
      ccifg : 0,   // capture/compare interrupt
      cov : 0,     // capture overflow flag
      out : 0,     // output value
      cci : 0,     // capture/compare interrupt value
      ccie : interruptsEnabled,  // capture/compare interrupt enable
      outmod : MSP430TIMER_OUTMODE_RESETSET, // Output mode
      cap : 0,     // 1 = capture mode, 0 = compare
      clld : 0,    // compare latch load
      scs : 0,     // synchronize capture source
      ccis : 0,    // capture/compare input select: 0=CCIxA, 1=CCIxB, 2=GND, 3=VCC
      cm : 0 };    // capture mode: 0=none, 1=rising, 2=falling, 3=both
      
    call ControlA1.setControl(resetSet);
  }
  
  
}
