/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
 
#include "uartprintf.h"

/** 
 * @author David Moss
 * @author Kevin Klues
 */
module UartPrintfP {
  uses {
    interface Boot;
    interface StdControl;
    interface UartByte;
    interface UartStream;
  }
}

implementation {

  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    call StdControl.start();
    
    /*
    printf("Last reset was a ");
    if(IFG1 & WDTIFG) {
      printf("watchdog timer.\n\r");
    } else if(IFG1 & OFIFG) {
      printf("oscillator fault.\n\r");
    } else if(IFG1 & NMIIFG) {
      printf("NMI.\n\r");
    } else if(IFG1 & 0x4) {
      printf("reset line.\n\r");
    } else if(IFG1 & 0x8) {
      printf("POR.\n\r");
    } else {
      printf("mystery.\n\r");
    }
    
    IFG1 = 0x0;
    */
    
    printf("\n\rBooted.\n\r\n\r");
  }
  
  /***************** UartStream Events ****************/
  /**
   * These events are included to make PlatformSerial happy when nothing else
   * is using UartStream events.
   */
  async event void UartStream.sendDone( uint8_t* buf, uint16_t len, error_t error ) {
  }

  async event void UartStream.receivedByte( uint8_t byte ) {
  }

  async event void UartStream.receiveDone( uint8_t* buf, uint16_t len, error_t error ) {
  }
  
  
  /***************** Printf Implementation ****************/
#ifdef _H_msp430hardware_h
  int putchar(int c) __attribute__((noinline)) @C() @spontaneous() {
#endif
#ifdef _H_atmega128hardware_H
  int uart_putchar(char c, FILE *stream) __attribute__((noinline)) @C() @spontaneous() {
#endif
    
    WDTCTL = WDTPW | ((WDTCTL & 0xFF) | WDTCNTCL);
    call UartByte.send(c);
    return 0;
  }
}


