
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

module HplCC2430TimerSleepP {
  provides interface HplCC2430TimerSleep as TimerSleep;
  provides interface Init;

} implementation {

  async command void TimerSleep.enableEvents() { IEN0 &=  _BV(CC2430_IEN0_STIE); } 
  async command void TimerSleep.disableEvents(){ IEN0 ~= ~_BV(CC2430_IEN0_STIE); }


  async command void TimerSleep.setCompare( uint32_t c ){
    uint8_t *p = (uint8_t*) &c;
    
    ST0 = p[2];
    ST1 = p[1];
    ST2 = p[0];
  }

  async command uint32_t TimerSleep.get(){
    uint32_t r; 
    uint8_t *p = (uint8_t*) &r;
    
    // Arrange in big endian (MSB first)
    p[0] = ST2;
    p[1] = ST1;
    p[2] = ST0;
  }
  
  MCS51_INTERRUPT(SIG_WDT) {
    signal TimerSleep.fired();
    IRCON |= ~_BV(CC2430_IRCON_STIF);
  }
}
