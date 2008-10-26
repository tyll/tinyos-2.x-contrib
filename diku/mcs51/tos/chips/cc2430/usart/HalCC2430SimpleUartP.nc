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

module HalCC2430SimpleUartP {
  provides {
    interface Init;
    interface SerialByteComm as uart0;
  }
  /*  uses {
    interface HalMcs51Led as Led1;
    interface HalMcs51Led as Led3;
    }*/
}
implementation {
  command error_t Init.init() {

    /* Borrowed from ChipCon */
#define BAUD_E(baud, clkDivPow) (     \
    (baud==2400)   ?  6  +clkDivPow : \
    (baud==4800)   ?  7  +clkDivPow : \
    (baud==9600)   ?  8  +clkDivPow : \
    (baud==14400)  ?  8  +clkDivPow : \
    (baud==19200)  ?  9  +clkDivPow : \
    (baud==28800)  ?  9  +clkDivPow : \
    (baud==38400)  ?  10 +clkDivPow : \
    (baud==57600)  ?  10 +clkDivPow : \
    (baud==76800)  ?  11 +clkDivPow : \
    (baud==115200) ?  11 +clkDivPow : \
    (baud==153600) ?  12 +clkDivPow : \
    (baud==230400) ?  12 +clkDivPow : \
    (baud==307200) ?  13 +clkDivPow : \
    0  )

#define BAUD_M(baud) (      \
    (baud==2400)   ?  59  : \
    (baud==4800)   ?  59  : \
    (baud==9600)   ?  59  : \
    (baud==14400)  ?  216 : \
    (baud==19200)  ?  59  : \
    (baud==28800)  ?  216 : \
    (baud==38400)  ?  59  : \
    (baud==57600)  ?  216 : \
    (baud==76800)  ?  59  : \
    (baud==115200) ?  216 : \
    (baud==153600) ?  59  : \
    (baud==230400) ?  216 : \
    (baud==307200) ?  59  : \
  0)


    //    call Led1.on();

    // PERCFG selects beween alternative pin mappings for the
    // peripherals PERCFG.U0CFG == PERCFG.U0CFG select Uart0 as part
    // of port0 (U0CFG=0) or port1 (U0CFG=1)
    // P0.2 = rx P0.3 = tx
    PERCFG &= ~0x1u;

    /* HUH!?
    CLKCON |= 0x40;
    // XOSC stable status
    while(! (SLEEP & 0x20)); //HIGH_FREQUENCY_RC_OSC_STABLE
    if( ((CLKCON & 0x38) >> 3) == 0){ // TICKSPD == 0

      }
    */
    //CLKCON=0;
    
    // UART_SETUP(0, 57600, HIGH_STOP);
    P0_ALT |= 0x0Cu; // Aka P0SEL

    //////U0GCR = 10 + (CLKCON & 0x07); //BAUD_E((57600),CLKSPD);
    //U0GCR = 10; //BAUD_E((57600),CLKSPD);
    //U0GCR = BAUD_E((230400),(CLKCON & _BV(CC2430_CLKCON_CLKSPD)));
    U0GCR = BAUD_E((230400), ((CLKCON & _BV(CC2430_CLKCON_OSC)) >> CC2430_CLKCON_OSC) );

    //U0BAUD = 216; //BAUD_M(57600)
    U0BAUD = BAUD_M(230400);

    U0CSR |=  0x80u | 0x40u; // U0CSR.Mode=1 | U0CSR.ReceiveEnable=1
    U0UCR |= (0x2u  | 0x80u); //((HIGH_STOP) | FLUSH) 

    // Clear any pending flags
    UTX0IF = 0;
    URX0IF = 0;

    URX0IE = 1; // Enable Receive  interrupt interrupt

    // Enable Transmit interrupt interrupt
    IEN2 |= 1<<2; // UTX0IE = 1

    return SUCCESS;
  }
  
  async command error_t uart0.put(uint8_t data){
    U0BUF = data;
    return SUCCESS;
  }

  MCS51_INTERRUPT(SIG_URX0) { //URX0 complete interrupt
    URX0IF = 0;
    signal uart0.get(U0BUF);
  }

  /* 
   * This interrupt should be generated when the doublebuffered U0BUF
   * register is ready the recieve new data. This unfortunately does
   * not seem to be the case:
   * 
   * The interrupt is generated after the first char has been
   * accepted, but never again. This leaves us with few options on how
   * to generate the putDone event at a time when the UART is ready to
   * receive a new char. The options include spin lock - or this
   * interrupt spin loop. This way each char generates a few hundred
   * interrupts.
   *
   */

  MCS51_INTERRUPT(SIG_UTX0) { //TRX0 complete interrupt
    int done = 0;

    atomic {
      // Check if the transmission is done before clearing the flag.. Which means
      // a sort of interrupt spin lock
      // WHY!?
      if (! (U0CSR & 0x1)) {
    //  call Led1.toggle();
    UTX0IF = 0;
    done = 1;
      }
    }
    if (done) {
      signal uart0.putDone();
    }
  }

  //  async event void SerialByteComm.get(uint8_t data) {
  //  }
  default async event void uart0.get(uint8_t data) { return; }

  //  async event void SerialByteComm.putDone(){
  //  }
  default async event void uart0.putDone() { return; }
}
