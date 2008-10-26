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
 * Exports Timer2 as Alarm interfaces
 *  
 *   The frequency is just there for show - it doesnt really do anything
 *
 * @author Mikkel Jønsson <jonsson@diku.dk>
 */
 
#include <Timer.h>
#include <nRF24E1Timer.h>

generic module HplnRF24E1Timer2AlarmP( typedef frequency ) {
  provides interface Alarm<frequency, uint16_t> as Alarm;
  provides interface Init;
  uses interface Leds;

} implementation {
  command error_t Init.init() {
    //Set clk scale
    CKCON = ((CKCON & ~nRF24E1_T2M_CKCON_MASK) | nRF24E1_TIMER2_DIV_4);
    //Set Timer mode: Autoreload of timer values.
    T2CON = ((T2CON & ~nRF24E1_T2CON_MODE_MASK) | nRF24E1_TIMER2_MODE_ARELOAD);
    ET2  = 1;
    TR2 = 1;
    return SUCCESS;
  }
#define GET_NOW(p) p  = TL2;\
                   p |= ((uint16_t)TH2)<<8;
/*********************************************************************
 *                              Alarm                              *
 *********************************************************************/ 

  async command void Alarm.stop(){
    TR2 = 0;
  }
  async command bool Alarm.isRunning(){
    return TR2; 
  }

  async command uint16_t Alarm.getAlarm(){
    uint16_t r;
    r =  RCAP2L;
    r |= ((uint16_t)RCAP2H)<<8;
    r = (2^16)-r;
    return (r);
  }

  async command uint16_t Alarm.getNow(){
    uint16_t r;
    GET_NOW(r);
    return (r);
  }

  async command void Alarm.start(uint16_t dt){
    uint16_t now;
    GET_NOW(now);
    call Alarm.startAt( now, dt );
  }

  async command void Alarm.startAt(uint16_t t0, uint16_t dt){
    uint16_t set, now, elapsed;
    uint16_t remaining,i,j;
    atomic {
      set = (2^16) - 0x00ff; //debug
      RCAP2L = (uint8_t) set;
      RCAP2H = (uint8_t) (set>>8);
    }
  }
/*********************************************************************
 *                              Event stubs                          *
 *********************************************************************/  
  default async event void Alarm.fired() { }
/*********************************************************************
 *                              Interrupts                           *
 *********************************************************************/ 
  MCS51_INTERRUPT(SIG_TIMER2) {
    signal Alarm.fired();
    TF2 = 0;
  }
}
