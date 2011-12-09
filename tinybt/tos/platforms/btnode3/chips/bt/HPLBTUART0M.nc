/*									tab:4
 *
 *
 * "Copyright (c) 2000-2002 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
/*									tab:4
 *  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 *  downloading, copying, installing or using the software you agree to
 *  this license.  If you do not agree to this license, do not download,
 *  install, copy or use the software.
 *
 *  Intel Open Source License 
 *
 *  Copyright (c) 2002 Intel Corporation 
 *  All rights reserved. 
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 * 
 *	Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *      Neither the name of the Intel Corporation nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *  
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE INTEL OR ITS
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * 
 */
/*
 *
 * Based on HPLBTUARTM.nc by:
 * Authors:		Jason Hill, David Gay, Philip Levis
 * Date last modified:  6/25/02


 * Changed by Mads Bondo Dydensborg, <madsdyd@diku.dk>
 * Lots of cleanup needed.

 * This file implements support for the UART0 connected to the Bluetooth module
 * running with 8N1. Settings are "7" == 57.6k when running at 7.3728 MHz.
 *
 *
 */

// The hardware presentation layer. See hpl.h for the C side.
// Note: there's a separate C side (hpl.h) to get access to the avr macros

// The model is that HPL is stateless. If the desired interface is as stateless
// it can be implemented here (Clock, FlashBitSPI). Otherwise you should
// create a separate component

/* Note: The btnode2_2 uses uart 0 to connect to the Bluetooth module, and
   uart 1 to connect externally. 
   uart 0 is mapped to PE0 = RXD0, PE1 = TXD0,
   uart 1 is mapped to PD2 = RXD1, PD3 = TXD1.
 
   The code below only maps uart 0, as this is the one we need for
   communication with the bluetooth hardware. */


module HPLBTUART0M {
  provides interface HPLBTUART as BTUART;
  uses interface Interrupt;
}
implementation
{
  bool ion;
  uint8_t *sendStart, *sendEnd;
  uint16_t sendNext, sendCount;
  
  task void signal_done_tsk();
  
  /** 
      Uart initialization routine.
  */
  async command result_t BTUART.init() {
    atomic {
      /* Lets go, hopefully the Bluetooth hardware will want to talkl to us... */
      call BTUART.setRate(3);
      
      // Set RX interrupt + enable interrupt generation on RX/TX
      outp(1<<RXCIE | 1<<RXEN | 1<<TXEN,UCSR0B);   
      
      // ??
      //sbi(UART0_RTS_PORT_DDR, UART0_RTS);
      //cbi(UART0_RTS_PORT, UART0_RTS);
      
      TOSH_SET_UART_RXD0_PIN();
      
      // Now, this is cheating - turn on bluetooth module
      // FIXME: This is done by HCIPacket
      sbi (PORTF, 0);
      sendStart = NULL;
    }
    return SUCCESS;
  }

  /* Set the rate */
  /* UART 0
     is connected to the bluetooth hardware.
     
     Setting the baud rate (bps, really).
     This is documented in the datasheet for the atmega128l on 
     page 172.
     
     The registers used are
     UBBR0L and UBBR0H.
     
     Table 83 on page 190 of the datasheet:
     
     (Note, currently our stk 500's run at 3.6864, but the 
     btnodes run at 7.3728!)
     
     bps      UBBRL (3.6864)   UBBRL (7.3728)   esr-notation
     9.6k      23               47
     19.2k      11               23
     28.8k       7               15
     38.4k       5               11
     57.6k       3                7                 3
     115.2k                        3                 2
     230                                             1
     460                                             0       
     
     The default value in SmartIts for UART0 is  7@7.3728 == 57.6k  
     (well, it is 12, but I think that is for a slightly higher clock, 
     4MHz == 19.2 (+0.2%).. hmmm).

     TODO: This really depends on the clockrate! Wont work on the
     stk platform currently...
  */
  async command result_t BTUART.setRate(int rate) {
    // Since putPacket now signals that the char in the buffer
    // has moved into the shift register it means that we have to wait
    // a while untill the final byte in the register has been sent..

    // Wait for the last char in the buffer to be sent
    while ( ! ( UCSR0A & (1<<UDRE)));

    switch (rate) {
    case 0: {
      outp(0, UBRR0L); // 460.8 on target platform
      outp(0, UBRR0H);
      break;
    }
    case 1: {
      outp(1, UBRR0L); // 230.4 on target platform
      outp(0, UBRR0H);
      break;
    }
    case 2: {
      outp(3, UBRR0L); // 115.2 on target platform
      outp(0, UBRR0H);
      break;
    }
    default: {
      outp(7, UBRR0L); // 56.7 on target platform
      outp(0, UBRR0H);
    }
    }
    return SUCCESS;
  }

  default async event result_t BTUART.get(uint8_t data) { return SUCCESS; }

  TOSH_SIGNAL(SIG_UART0_RECV) {
    signal BTUART.get(inp(UDR0));

    // From TinyOS
    // Hmm.. Why should we end in this handler if this flag hasn't triggered?
    //if (inp(UCSR0A) & (1<<RXCIE))
    //  signal BTUART.get(inp(UDR0));
  }

  default async event result_t BTUART.putDone() { return SUCCESS; }

  command async result_t BTUART.put(uint8_t * start, uint8_t * end) {
    bool sending;
    atomic { // Martin: Is this needed?
      if(sendStart == NULL) {
	sendStart = start;
	sendEnd = end;
	sending = FALSE;
      } else
	sending = TRUE;
    }
    if (sending) {
      // There's something in the send buffer
      // and we're not done sending what was in there..
      return FAIL;
    } else {
      // Enable data register empty interrupt
      // Once we get one we'll start sending
      sbi( UCSR0B, UDRIE );
      return SUCCESS;
    }
  }

  TOSH_SIGNAL(SIG_UART0_DATA) {
    if (sendStart && sendStart < sendEnd) {
      outp(*(sendStart), UDR0);
      sendStart++;
    } else {
      // disable "USART data register empty interrupt"
      cbi(UCSR0B, UDRIE);
      
      // Leave interrupt context
      post signal_done_tsk();
    }
  }

  task void signal_done_tsk() {
    signal BTUART.putDone();
    atomic {
      sendStart = NULL;
    }
  }
}
