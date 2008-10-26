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
 *
 * @author Mikkel Jønsson <jonsson@diku.dk>
 */

module HPLUARTP {
  provides interface HPLUART as UART;
}

implementation {
  uint8_t *sendStart, *sendEnd;
  uint8_t mychar[2]; //For UART.put()
  uint8_t mylong[7]; //For UART.put_long()
  
// Uart initialization routine.
  async command bool UART.init() {
    atomic{
  // Pins
      P0_ALT |= 0x06;// P0_1 = RXD(in); P0_2 = TXD(out)
      P0_DIR |= 0x02;
      P0_DIR &= 0xFB;
  // Timer1 options  19.2 Kb/s
      TMOD &= 0x0F;	 // Reset T1 to zeros
      TMOD |= 0x20;  // GATE=0; CT=0; M=2
      CKCON |= 0x10; // T1M=1 (/4 timer clock).
      TCON |= 0x80;	 // Baud Rate = Timer1 overflow
      TH1 = 0xF3;	   // Reload value. 0xF3 = 19.2Kb/s
      TR1 = 1;       // Enable timer
  // Serial		// Mode 1: 8 bit; No Parity; 1 stop bit
      SCON = 0x52;	 // Serial mode1, enable receiver
      PCON |= 0x80;  // SMOD = 1
      ES = 1;		     // Enable serial interrupt
  // Initialize variables
      sendStart = NULL;
    }
    return SUCCESS;
  }

  async command bool UART.stop() {
    atomic ES = 0;
    return SUCCESS;
  }
  /* Event stub */
  default async event bool UART.get(uint8_t data) { 
    return SUCCESS; 
  }
//Sends a long in Hex format to UART
  async command bool UART.put_long(uint16_t no){
    uint16_t tmp,base;
    uint8_t i,j;
    i = 3;
    j = 2;
    base = no;
    mylong[0]=0x30; mylong[1]=0x78;//To make it look like hex: 0x
    while(i+1){
      i ? (tmp = (base  >> (i*4))) : (tmp = no % 0x10);
      base = base - (tmp << ((i)*4));
      tmp<0xA ? (mylong[j] = tmp+UART_OFFSET_NUM) : (mylong[j] = tmp+UART_OFFSET_CHR);
      i--; j++;
    }
    return call UART.put2(mylong);
  }

  async command bool UART.put2(uint8_t * start) {
    bool was_sending;
		while(sendStart){} //Wait for the uart to be ready
    atomic {
      if(sendStart == NULL) {
        sendStart = start;
        while(*start != 0){
          sendEnd = (start++);
        }
        sendEnd;
        was_sending = FALSE;
      } else
        was_sending = TRUE;
    }
    if (was_sending) {
			// There's something in the send buffer
			// and we're not done sending what was in there..
      return FAIL;
    } else {
		  // Enable data register empty interrupt
			// Once we get one we'll start sending
      atomic TI = 1;
      return SUCCESS;
    }
  }
  //Not used
  async command bool UART.put(uint8_t data) {
    atomic mychar[0] = data;
    return call UART.put2(mychar);
  }
  /* Event Stub */
  default async event bool UART.putDone(){};
  
  MCS51_INTERRUPT(SIG_SERIAL) {
    char buffer;
    if(RI) {			// Receive
      atomic buffer = SBUF;
      signal UART.get(buffer);
      atomic RI = 0;
    }
    else if(TI) {		// Transmit done
      atomic {
        if (sendStart && (sendStart <= sendEnd)) {
          SBUF = *(sendStart);	// Transmit the data
          sendStart++;
        } else {
          // Leave interrupt context
          sendStart = NULL;
          signal UART.putDone();
        }
        TI = 0;
      }
    }
  }
}
