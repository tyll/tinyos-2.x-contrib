
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
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

#include <ioCC2430.h

#warning "This code is untested"

module HplCC2430Timer4P {
  provides interface HplCC2430Timer8 as Timer4;
  provides interface Init;

} implementation {
  command error_t Init.init() {

    T4CTL  = 0x00;    // Stop the timer
    T4CCTL0 = 0x00;
    T4CCTL1 = 0x00;   
    T4IE    = 0;      // Disable events
    T4OVFIF = 0;      // Clear any leftover events
    T4CH0IF = 0;
    T4CH1IF = 0;

    return SUCCESS;
  }

  async command uint8_t Timer4.get() {   return ((uint8_t) T4CNT);  };
  async command void Timer4.set( uint8_t t ){    T4CNT = t;        };

  async command void Timer4.setMode( enum cc2430_timer_mode_t mode ){
    T4CTL = (T4CTL & ~CC2430_T34CTL_MODE_MASK) | mode;
  };
  async command enum cc2430_timer_mode_t Timer4.getMode(){
    return ((enum cc2430_timer_mode_t) (T4CTL & CC2430_T34CTL_MODE_MASK));
  };

  // Set/clear the interrupt mask
  async command bool Timer4.isIfPending(enum cc2430_timer34_if_t if_mask) {
    return (TIMIF | _BV(if_mask) );
  }
  async command void Timer4.clearIf(enum cc2430_timer34_if_t if_mask) {
    TIMIF &= ~_BV(if_mask);
  }

  async command void Timer4.enableEvents() {   T4IE    = 1;  };
  async command void Timer4.disableEvents(){   T4IE    = 0;  };

  async command void Timer4.enableOverflow() {  T4OVFIF = 1; }
  async command void Timer4.disableOverflow(){  T4OVFIF = 0; }

  async command bool Timer4.isOVFIFending() { return (bool) T4OVFIF; }
  async command void Timer4.clearOVFIF()    { T4OVFIF = 0;           }

  async command bool Timer4.isCH0IFPending(){ return (bool) T4CH0IF; }
  async command void Timer4.clearCH0IF()    { T4CH0IF = 0;           }

  async command bool Timer4.isCH1IFPending(){ return (bool) T4CH1IF; }
  async command void Timer4.clearCH1IF()    { T4CH1IF = 0;           }

  async command bool Timer4.enable(){
    T4CTL |= _BV(CC2430_T34CTL_START);
  };
  async command void Timer4.disable(){
    T4CTL &= ~_BV(CC2430_T34CTL_START);
  };

  async command void Timer4.setScale( enum cc2430_timer3_4_prescaler_t p){
    T4CTL = ((T4CTL & ~CC2430_T34CTL_DIV_MASK) | p);
  };
  async command enum cc2430_timer3_4_prescaler_t Timer4.getScale(){
    return ( (enum cc2430_timer3_4_prescaler_t ) T4CTL & CC2430_T34CTL_DIV_MASK);
  };

  MCS51_INTERRUPT(SIG_T4) {
    signal Timer4.fired();
  }
}
