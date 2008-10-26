
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
 * This implemenatation is incomplete, use
 * HplCC2430Timer1AlarmCounterP for now
 * 
 * @author Martin Leopold <leopold@diku.dk>
 */


#include <ioCC2430.h>
#include <CC2430Timer.h>

module HplCC2430Timer1P {
  provides interface HplCC2430Timer16 as Timer1;
  provides interface Init;

} implementation {
  command error_t Init.init() {

    /* TIMER1_INIT: */
    T1CTL  = 0x00;    
    T1CCTL0 = 0x00;   
    T1CCTL1 = 0x00;   
    T1CCTL2 = 0x00;   
    TIMIF &= ~_BV(CC2430_TIMIF_OVFIM);   //Clear TIMIF.OVFIM

    T1CCTL0 |= _BV(CC2430_T1CCTLx_MODE); //Set mode to compare (capture not implemented)

    T1CTL = 0x01;

    return SUCCESS;
  }

  async command uint16_t Timer1.get() {

    uint16_t r;
    ((uint8_t*)&r)[0] = T1CNTH;
    ((uint8_t*)&r)[1] = T1CNTL;
    return r;

    //return ( SFR16_TO_UINT16( T1CNT ) );
    // Is this getting the endianes right?
    //return ( ((uint16_t) T1CNTL)<<8 | (uint16_t) T1CNTH );
  };
  async command void  Timer1.set( uint16_t t ){
    //T1CNT = UINT16_TO_SFR16( t );
    
    T1CNTH = ((uint8_t*)&t)[0]; //(uint8_t) t;
    T1CNTL = ((uint8_t*)&t)[1]; //(uint8_t) (t>>8);
  };

  async command void Timer1.enableCompare0() {
    T1CCTL0 |= _BV(CC2430_T1CCTLx_IM) | _BV(CC2430_T1CCTLx_MODE);
  }
  async command void Timer1.enableCompare1() {
    T1CCTL1 |= _BV(CC2430_T1CCTLx_IM) |  _BV(CC2430_T1CCTLx_MODE);
  }
  async command void Timer1.enableCompare2() {
    T1CCTL2 |= _BV(CC2430_T1CCTLx_IM) | _BV(CC2430_T1CCTLx_MODE);
  }

  /*
   * It seems that the interrupt mask is useless.. So to actullay kill these interrupts
   * we set it to capture mode
   */

  async command void Timer1.disableCompare0() {
    T1CCTL0 &= ~_BV(CC2430_T1CCTLx_IM) & ~_BV(CC2430_T1CCTLx_MODE);
  }
  async command void Timer1.disableCompare1() {
    T1CCTL1 &= ~_BV(CC2430_T1CCTLx_IM) & ~_BV(CC2430_T1CCTLx_MODE);
  }
  async command void Timer1.disableCompare2() {
    T1CCTL2 &= ~_BV(CC2430_T1CCTLx_IM) & ~_BV(CC2430_T1CCTLx_MODE);
  }

  async command void Timer1.setCompare0(uint16_t c) {
    T1CC0H = ((uint8_t*)&c)[0];
    T1CC0L = ((uint8_t*)&c)[1];
    //T1CC0 = UINT16_TO_SFR16(c);
  }
  async command uint16_t Timer1.getCompare0() {
    return ( SFR16_TO_UINT16( T1CC0 ) );
  }

  async command void Timer1.setCompare1(uint16_t c) {
    T1CC1 = UINT16_TO_SFR16(c);
  }
  async command uint16_t Timer1.getCompare1() {
    return ( SFR16_TO_UINT16( T1CC1 ) );
  }

  async command void Timer1.setCompare2(uint16_t c) {
    T1CC2 = UINT16_TO_SFR16(c);
  }
  async command uint16_t Timer1.getCompare2() {
    return ( SFR16_TO_UINT16( T1CC2 ) );
  }

  async command void Timer1.setMode( enum cc2430_timer1_mode_t mode ){
    T1CTL = (T1CTL & ~CC2430_T1CTL_MODE_MASK) | mode;
  };
  async command enum cc2430_timer1_mode_t Timer1.getMode(){
    return ((enum cc2430_timer1_mode_t) (T1CTL & CC2430_T1CTL_MODE_MASK));
  };

  // Sets the interrupt mask
  async command void Timer1.enableEvents(){
    T1IE    = 1;  
  };
  async command void Timer1.disableEvents(){
    T1IE    = 0;  
  };

  async command void Timer1.enableOverflow(){
    TIMIF |=  _BV(CC2430_TIMIF_OVFIM);
  };
  async command void Timer1.disableOverflow() {
    TIMIF &=  ~CC2430_TIMIF_OVFIM;
  };

  async command bool Timer1.isIfPending(enum cc2430_timer1_if_t if_mask){
    return ( T1CTL & if_mask);
  };
  async command void Timer1.clearIf(enum cc2430_timer1_if_t if_mask){
    T1CTL &= ~if_mask;
  };

  async command void Timer1.setScale( enum cc2430_timer1_prescaler_t p){
    T1CTL = ((T1CTL & ~CC2430_T1CTL_DIV_MASK) | p);
  };

  async command enum cc2430_timer1_prescaler_t Timer1.getScale(){
    return ( (enum cc2430_timer1_prescaler_t) T1CTL & CC2430_T1CTL_DIV_MASK);
  };

  MCS51_INTERRUPT(SIG_T1) {
    signal Timer1.fired();
  }
}
