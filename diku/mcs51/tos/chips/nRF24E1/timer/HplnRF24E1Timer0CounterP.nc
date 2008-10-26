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
 * Exports Timer0 as Counter interfaces
 *  
 *   The frequency is just there for show - it doesnt really do anything
 *
 * Note: The byte order of the registers i very important: the low
 * byte must always be read or written first!
 *
 * @author Mikkel Jønsson <jonsson@diku.dk>
 */
 
#include <Timer.h>
#include <nRF24E1Timer.h>

generic module HplnRF24E1Timer0CounterP( typedef frequency ) {
  provides interface Counter<frequency, uint16_t> as Counter;
  provides interface Init;

} implementation {
  bool counter_overflow;

  command error_t Init.init() {
    //Configure Counter (Timer0)
    CKCON = ((CKCON & ~nRF24E1_T0M_CKCON_MASK) | nRF24E1_TIMER0_DIV_4); //Set clk scale
    TMOD = (TMOD & ~nRF24E1_TMOD0_MODE_MASK) | nRF24E1_TIMER0_MODE_8B_ARELOAD;
    //Start Counter
    TR0 = 1;
    //Enable interrupts
    ET0 = 1;
    return SUCCESS;
  }
/*********************************************************************
 *                              Counter                              *
 *********************************************************************/ 

  async command uint16_t Counter.get() {
    uint16_t r;
    ((uint8_t*)&r)[1] = TL0;
    ((uint8_t*)&r)[0] = TH0;

    return r;
  }
  async command bool Counter.isOverflowPending() {
    return counter_overflow;
  }
  async command void Counter.clearOverflow()     {
    counter_overflow = FALSE;
  }

/*********************************************************************
 *                              Interrupts                           *
 *********************************************************************/ 

  MCS51_INTERRUPT(SIG_TIMER0) { 
    atomic{
      if(!counter_overflow){
        counter_overflow = TRUE;
        TF0 = 0;
        signal Counter.overflow();
      }
    }
  }
  default async event void Counter.overflow() { }
}
