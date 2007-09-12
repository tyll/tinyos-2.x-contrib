/*
 * Copyright (c) 2005 Arched Rock Corporation 
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of the Arched Rock Corporation nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE ARCHED
 * ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
/**
 * Implements the TOS 2.0 SpiByte and SpiPacket interfaces for the PXA27x.
 * Provides master mode communication for a variety of frame formats, speeds
 * and data sizes.
 * 
 * @param valFRF The frame format to use. 
 * 
 * @param valSCR The value for the SSP clock rate.
 *
 * @param valDSS The value for the DSS field in the SSCR0 register of the
 * associated SSP peripheral.
 * 
 * @param enableRWOT Enables Receive without transmit mode. Used only for 
 * the SpiPacket interface. If the txBuf parameter of SpiPacket.send is null
 * the implementation will continuously clock in data without regard to the 
 * contents of the TX FIFO.  This is different from the spec for the interface
 * which requires that the transmitter send zeros (0) for this case.
 * 
 * @author Phil Buonadonna
 */
/**
 * Adapted for nxtmote.
 * @author Rasmus Ulslev Pedersen
 */
module HalAT91SpiPioM 
{
  provides {
    interface Init;
    interface SpiByte;
    interface SpiPacket;
  }
  uses {
    interface HplAT91SPI as SPI;
  }
}

implementation
{

  task void SpiPacketDone() {
    
    return;
  }

  command error_t Init.init() {

    return SUCCESS;
  }

  async command uint8_t SpiByte.write(uint8_t tx) {
    volatile uint8_t val = 0;
   
    return val;
  }

  async command error_t SpiPacket.send(uint8_t* txBuf, uint8_t* rxBuf, uint16_t len) {
    
    error_t error = SUCCESS;
    
    *AT91C_SPI_TPR = (unsigned int)txBuf;
	  *AT91C_SPI_TCR = (unsigned int)len;
	  *AT91C_SPI_PTCR = AT91C_PDC_TXTEN;

    return error;
  }
  
  async event void SPI.interruptSPI() {
    return;
  }

  default async event void SpiPacket.sendDone(uint8_t* txBuf, uint8_t* rxBuf, 
					      uint16_t len, error_t error) {
    return;
  }
  
}
