// $Id$
/*
 * Copyright (c) 2010, Shimmer Research, Ltd.
 * All rights reserved
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:

 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of Shimmer Research, Ltd. nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Steve Ayer
 * @date   April, 2010
 */

#include "msp430usart.h"
#include <UserButton.h>

module TestSerialTimeC {
  uses {
    interface Boot;
    interface Leds;
    interface Time;
    interface HostTime;
    interface Notify<button_state_t> as buttonNotify;
    interface HplMsp430Usart as UARTControl;
    interface HplMsp430UsartInterrupts as UARTData;
  }
}
implementation {

  struct tm g_tm;
  time_t time_now;
  char timestring[128];
  uint8_t charsSent, toSend;
  bool transmissionComplete;

  void initialize_8mhz_clock(){
    /* 
     * set up 8mhz clock to max out 
     * msp430 throughput 
     */
    register uint8_t i;

    atomic CLR_FLAG(BCSCTL1, XT2OFF);

    call Leds.led0On();
    do{
      CLR_FLAG(IFG1, OFIFG);
      for(i = 0; i < 0xff; i++);
    }
    while(READ_FLAG(IFG1, OFIFG));

    call Leds.led0Off();

    call Leds.led1On();
    TOSH_uwait(50000UL);

    atomic{
      BCSCTL2 = 0;
      SET_FLAG(BCSCTL2, SELM_2);
    }
    
    call Leds.led1Off();

    atomic{
      SET_FLAG(BCSCTL2, SELS);  // smclk from xt2
      SET_FLAG(BCSCTL2, DIVS_1);  // divide it by 2; smclk will run at 8 mhz / 2; spi bus will run at 4mhz / 2
    }
  }

  event void Boot.booted(){
    initialize_8mhz_clock();

    call buttonNotify.enable();
  }

  task void sendOneChar() {
    if(charsSent < toSend)
      call UARTControl.tx(timestring[charsSent++]);
    else{
      transmissionComplete = TRUE;
    }
  }

  task void return_timestring() {
    toSend = strlen(timestring);
    charsSent = 0;
    transmissionComplete = FALSE;
    post sendOneChar();
  }

  
  event void HostTime.timeAndZoneSet(char * g_timestring){
    call Time.time(&time_now);
    call Time.localtime(&time_now, &g_tm);
    call Time.asctime(&g_tm, timestring, 128);
  }

  async event void UARTData.rxDone(uint8_t data) { }

  async event void UARTData.txDone() {
    if(!transmissionComplete) {
      post sendOneChar();
    }
  }

  event void buttonNotify.notify( button_state_t val){
    call Leds.led2Toggle();
    post return_timestring();
  }

  event void Time.tick() { }
}
