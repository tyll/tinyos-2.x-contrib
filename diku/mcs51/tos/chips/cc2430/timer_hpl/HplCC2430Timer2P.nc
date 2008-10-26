
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

#include <ioCC2430.h>

#warning "This code is untested"

module HplCC2430Timer2P {
  provides interface HplCC2430TimerMAC as Timer2;
  provides interface Init;

} implementation {
  command error_t Init.init() {

    T2CNF &= ~(CC2430_T2CNF_CMPIF | CC2430_T2CNF_PERIF | CC2430_T2CNF_OFCMPIF); // Clear all if

    return SUCCESS;
  }

  async command void Timer2.setMode( enum cc2430_timerMAC_mode_t mode ){
    T2CNF = (T2CNF & ~_BV(CC2430_T2CNF_RUN)) | mode;
  };

  async command enum  Timer2.getMode(){
    return ((enum cc2430_timerMAC_mode_t) (T2CNF & CC2430_T2CNF_RUN));
  };

  async command uint16_t Timer2.getAdjust() {
  }

  async command void Timer2.setAdjust( uint16_t d ) {
  }

  async command void Timer2.enableOvfCmpEvent(){  T2PEROF2 |=  _BV(CC2430_T2PEROF2_OFCMPIM); }
  async command void Timer2.disableOvfCmpEvent(){ T2PEROF2 &= ~_BV(CC2430_T2PEROF2_OFCMPIM); }

  async command void Timer2.enableOverflowEvent(){  T2PEROF2 |=  _BV(CC2430_T2PEROF2_CMPIM); }
  async command void Timer2.disableOverflowEvent(){ T2PEROF2 &= ~_BV(CC2430_T2PEROF2_CMPIM); }

  async command void Timer2.enableCmpEvent(){  T2PEROF2 |=  _BV(CC2430_T2PEROF2_OFCMPIM); }
  async command void Timer2.disableCmpEvent(){ T2PEROF2 &= ~_BV(CC2430_T2PEROF2_OFCMPIM); }

  async command bool Timer2.isIfPending(enum cc2430_timerMAC_if_t if_mask_t){
    return (T2CNF & if_mask);
  };
  async command void Timer2.clearIf(enum cc2430_timerMAC_if if_mask_t){
    T2CNF &= ~if_mask;
  };

  MCS51_INTERRUPT(SIG_T2) {
    signal Timer2.fired();
  }
}
