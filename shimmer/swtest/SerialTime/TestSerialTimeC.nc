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

#include <UserButton.h>

module TestSerialTimeC {
  uses {
    interface Boot;
    interface Leds;
    interface HplMsp430Usart as UARTControl;
    interface HplMsp430UsartInterrupts as UARTData;
    interface Time;
    interface Notify<button_state_t> as buttonNotify;
  }
}
implementation {
  enum {
    NONE,
    BYTE_32,
    BYTE_24,
    BYTE_16,
    BYTE_8
  };
  struct tm g_tm;
  time_t g_host_time = 0;
  uint8_t sync_state, byte3, byte2, byte1, byte0, toSend, charsSent;
  char g_timestring[128];
  bool transmissionComplete;

  void setupUART() {
    /*
     * NOTE:  this sets the baudrate based upon a 4mhz SMCLK given by the 8mhz xt clock config
     * to run at the default msp430 clock settings, use _1MHZ_ for these two flags
     */
    msp430_uart_union_config_t RN_uart_config = { {ubr: UBR_4MHZ_115200, umctl: UMCTL_4MHZ_115200, 
						   ssel: 0x02, pena: 0, pev: 0, spb: 0, clen: 1,listen: 0, 
						   mm: 0, ckpl: 0, urxse: 0, urxeie: 0, 
						   urxwie: 0, utxe : 1, urxe :1} };

    call UARTControl.setModeUart(&RN_uart_config); // set to UART mode

    call UARTControl.enableTxIntr();
    call UARTControl.enableRxIntr();
  }

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
    TOSH_uwait(50000U);

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
    setupUART();
    
    sync_state = NONE;
    transmissionComplete = FALSE;

    call buttonNotify.enable();
  }

  task void sendOneChar() {
    if(charsSent < toSend)
      call UARTControl.tx(g_timestring[charsSent++]);
    else{
      transmissionComplete = TRUE;
    }
  }

  task void return_g_timestring() {
    toSend = strlen(g_timestring);
    charsSent = 0;
    transmissionComplete = FALSE;
    post sendOneChar();
  }

  task void assemble_g_timestring() {
    time_t time_now;

    g_host_time = byte3;
    g_host_time = g_host_time << 24;
    g_host_time = (g_host_time >> 16 | byte2) << 16;
    g_host_time = (g_host_time >> 8 | byte1) << 8;
    g_host_time = g_host_time | byte0;

    call Time.setCurrentTime(g_host_time);
    
    call Time.time(&time_now);
    call Time.localtime(&time_now, &g_tm);
    call Time.asctime(&g_tm, g_timestring, 128);
  }

  async event void UARTData.rxDone(uint8_t data) {        
    switch (sync_state) {
    case NONE:
      byte3 = data;
      sync_state = BYTE_32;
      break;
    case BYTE_32:
      byte2 = data;
      sync_state = BYTE_24;
      break;
    case BYTE_24:
      byte1 = data;
      sync_state = BYTE_16;
      break;
    case BYTE_16:
      byte0 = data;
      sync_state = NONE;
      post assemble_g_timestring();
      break;
    default:
      break;
    }
  }

  async event void UARTData.txDone() {
    if(!transmissionComplete) {
      post sendOneChar();
    }
  }

  event void buttonNotify.notify( button_state_t val){
    call Leds.led2Toggle();
    post return_g_timestring();
  }

  event void Time.tick() { }
}
