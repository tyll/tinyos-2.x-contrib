
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

module HplCC2430TimerWDTP {
  provides interface HplCC2430TimerWDT as TimerWDT;
  provides interface Init;

} implementation {
  command error_t Init.init() {
    IR2CON2 |= ~_BV(CC2430_IRCON2_WDTIF);
  }

  async command void TimerWDT.clear() {
    WDCTL = (WDCTL & 0x0F) | 0xA0;
    WDCTL = (WDCTL & 0x0F) | 0x50;
  }

  async command void TimerWDT.setMode( enum cc2430_timerWDT_mode_t mode ) {
    if (mode) {
      WDCTL &= _BV(CC2430_WDCTL_MODE); 
    } else {
      WDCTL |= ~_BV(CC2430_WDCTL_MODE);
    }
  }

  async command void TimerWDT.setInterval( enum cc2430_timerMAC_interval_t i ){
    WDCTL = (WDCTL & ~CC2430_WDCTL_INT_MASK) | i;
  }

  async command enum cc2430_timerMAC_interval_t getInterval(){
    return (enum cc2430_timerMAC_interval_t) (WDCTL & 3);
  }
  
  async command void TimerWDT.enable()  {    WDCTL |= CC2430_WDCTL_EN;   }
  async command void TimerWDT.disable() {    WDCTL &= ~0x08;  }

  async command void TimerWDT.enableEvents()  { IEN2 &=  _BV(CC2430_IEN2_WDTIE)  }
  async command void TimerWDT.disableEvents() { IEN2 |= ~_BV(CC2430_IEN2_WDTIE); }

  
  MCS51_INTERRUPT(SIG_WDT) {
    signal TimerWDT.fired();
    IR2CON2 |= ~_BV(CC2430_IRCON2_WDTIF);
  }
}
