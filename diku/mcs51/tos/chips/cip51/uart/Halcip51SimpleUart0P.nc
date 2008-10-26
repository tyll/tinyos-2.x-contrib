
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
 *
 * @author Martin Leopold <leopold@polaric.dk>
 */

#include "serial.h"
#include "mcs51-timer.h"

#define SYSCLK       48000000ul          // SYSCLK frequency in Hz

module Halcip51SimpleUart0P {
  provides interface SerialControl;
  provides interface SerialByteComm;
  provides interface StdControl;
  provides interface Init;

  uses interface HplMcs51Counter as RateCounter;
} implementation {


  /**
   * The start/stop commands should also handle any dependencies to
   * low power modes
   */
   command error_t StdControl.start() { 
     call RateCounter.setMode(MCS51_TIMER_MODE_8BIT_RELOAD);
     call RateCounter.start();
     call RateCounter.setInterruptEnable(FALSE);

     ES0 = 1;                            // Enable UART0 interrupt

     return SUCCESS;
   } 

  command error_t StdControl.stop() {
    ES0 = 0; // Disable UART0 interrupt
    call RateCounter.stop();
    return SUCCESS;
  }

  async command error_t SerialControl.setFlow(bool f){ return (f==FALSE ? SUCCESS : FAIL); }
  async command bool SerialControl.getFlow(){ return FALSE; }

  async command error_t SerialControl.setParity(ser_parity_t p){ return (p==par_none? SUCCESS : FAIL); }
  async command ser_parity_t SerialControl.getParity(){ return (par_none);}

  async command error_t SerialControl.setDataBits(ser_data_bits_t d){ return (d==CS8? SUCCESS : FAIL); }
  async command ser_data_bits_t SerialControl.getDataBits(){  return CS8;  }

  async command error_t SerialControl.setStopBits(ser_stop_bits_t s){ return (s==stop_bit_1 ? SUCCESS : FAIL); }
  async command ser_stop_bits_t SerialControl.getStopBits(){}

  async command error_t SerialControl.setRate(ser_rate_t b){
    uint32_t baud = b*75ul;
    uint8_t count;
    
    /**
     * Calculate timer ticks for 8-bit timer overflow in terms of the
     * devided system clock
     */

    if (SYSCLK/baud/2/256 < 1) {
      count = -(SYSCLK/baud/2);
      CKCON &= ~0x0B;                  // T1M = 0; SCA1:0 = xx
      CKCON |=  0x08;                  // T1M = 1;
    } else if (SYSCLK/baud/2/256 < 4) {
      count = -(SYSCLK/baud/2/4);
      CKCON &= ~0x0B;                  // T1M = 0; SCA1:0 = 01                 
      CKCON |=  0x09;
    } else if (SYSCLK/baud/2/256 < 12) {
      count = -(SYSCLK/baud/2/12);
      CKCON &= ~0x0B;                  // T1M = 0; SCA1:0 = 00
    } else {
      count = -(SYSCLK/baud/2/48);
      CKCON &= ~0x0B;                  // T1M = 0; SCA1:0 = 10
      CKCON |=  0x02;
    }
    call RateCounter.set(count, count);
    return SUCCESS;
  }

  async command ser_rate_t SerialControl.getRate(){
    return (ser_rate_t) 0;
  }

  
  command error_t Init.init() {
    error_t r;

   XBR0 |= 0x01;                        // route UART 0 to crossbar
   XBR2 |= 0x01;                        // route UART 1 to crossbar
   XBR1 |= 0x40;                        // enable crossbar

/*    P0MDOUT |= 0x11;                    // set P0.4 to push-pull output */

   r = call SerialControl.setRate(B230400);
   
   SCON0 = 0x10;                       // SCON0: 8-bit variable bit rate
                                       //        level of STOP bit is ignored
                                       //        RX enabled
                                       //        ninth bits are zeros
                                       //        clear RI0 and TI0 bits


   IP |= 0x10;                         // Make UART high priority

   r |= call StdControl.start();

   return r;
  }

  async command error_t SerialByteComm.put(uint8_t data){
    SBUF0 = data;
    return SUCCESS;
  }

  /**
   * Combined RX/TX interrupt
   */

  MCS51_INTERRUPT(SIG_UART0) {
    uint8_t rx = 0, tx = 0;
    atomic{
      if (SCON & _BV(cip51_SCON_TI0)) {
        SCON &= ~_BV(cip51_SCON_TI0);
        tx = 1;
      }
      if (SCON & _BV(cip51_SCON_RI0)) {
        SCON &= ~_BV(cip51_SCON_RI0);
        rx = 1;
      }
    }
    if (tx == 1) {signal SerialByteComm.putDone();  }
    if (rx == 1) {signal SerialByteComm.get(SBUF0); }
  }

 async event void RateCounter.overflow() { }

 default async event void SerialByteComm.get(uint8_t data) { return; }

 default async event void SerialByteComm.putDone() { return; }
}
