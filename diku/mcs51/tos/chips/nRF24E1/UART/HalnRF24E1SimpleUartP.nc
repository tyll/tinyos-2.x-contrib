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
 * @author Mikkel Jønsson <jonsson@diku.dk>
 */

#include <ionRF24E1.h>

module HalnRF24E1SimpleUartP {
  provides {
    interface Init;
    interface SerialByteComm as uart;
    interface StdControl;
  }
}
implementation {

  command error_t Init.init(){
  	atomic{
  // Pins: P0_1 = RXD(in); P0_2 = TXD(out)
      P0_ALT |= 0x06;
      P0_DIR |= 0x02;
      P0_DIR &= 0xFB;
		}
  	return call StdControl.start();
  }
  
  command error_t StdControl.start() {
  	//DEBUG
    //P0_ALT &= 0xDF; //P06
    //P0_DIR &= 0xDF;
    //(P0_6==1) ? (P0_6=0) : (P0_6=1);
    atomic{
  // Timer1 options  19.2 Kb/s
      TMOD &= 0x0F;	// Reset T1 to zeros
      TMOD |= 0x20;  	// GATE=0; CT=0; M=2
      CKCON |= 0x10; 	// T1M=1 (/4 timer clock).
      TCON |= 0x80;	// Baud Rate = Timer1 overflow
      TH1 = 0xF3;	// Reload value. 0xF3 = 19.2Kb/s
      TR1 = 1;       	// Enable timer
  // Serial		// Mode 1: 8 bit; No Parity; 1 stop bit
      SCON = 0x52;	// Serial mode1, enable receiver
      PCON |= 0x80;  	// SMOD = 1
      ES = 1;		// Enable serial interrupt
    }
    return SUCCESS;
  }
  command error_t StdControl.stop(){
    ES = 0;
    TR1 = 0;
    return SUCCESS;
  }
  
  async command error_t uart.put(uint8_t data){
    SBUF = data;
    return SUCCESS;
  }

  MCS51_INTERRUPT(SIG_SERIAL) {
    uint8_t rx = 0, tx = 0;
    char buffer;
    atomic{
		  if(RI) {			// Receive
		    buffer = SBUF;
		    RI = 0;
		    rx = 1;
		  }
		}
		if(rx)
    	signal uart.get(buffer);
		atomic{
		  if(TI){		// Transmit done
		  	TI = 0;
		  	tx = 1;
		  }
		}
		if(tx)
	    signal uart.putDone();
  }
  default async event void uart.get(uint8_t data) { return; }
  default async event void uart.putDone() { return; }
}
