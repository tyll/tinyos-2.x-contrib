

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
 * @author Marcus Chang <marcus@diku.dk>
 * @author Klaus S. Madsen <klaussm@diku.dk>
 */


module HPLCC2420M {
	provides {
		interface HPLCC2420;
		interface HPLCC2420RAM;
		interface HPLCC2420FIFO;
		interface HPLCC2420Status;
		interface Init;
        interface StdControl as HPLCC2420Control;
	}
	uses {
		interface Spi;
	}
}

implementation {

MSP430REG_NORACE(P3OUT);

#include "hplcc2420.h"

#define CC2420_SELECT(x) P3OUT |= 0x01
#define CC2420_UNSELECT(x) P3OUT &= ~0x01


	/*********************************************************************
	 *
	 * HPLCC2420Control interface
	 *
	 ********************************************************************/
	command error_t Init.init() 
	{
		/* Taken from CC2420_INIT in NanoStack's rf.c */
		P5DIR &= ~0x70; 
		P1DIR &= ~0x80; 
		P5SEL &= ~0x70; 
		P1SEL &= ~0x80;

		return SUCCESS;
	}

	command error_t HPLCC2420Control.start()
	{
		return SUCCESS;
	}

	command error_t HPLCC2420Control.stop()
	{
		return SUCCESS;
	}


  /** 
   * Zero out the reserved bits since they can be either 0 or 1.
   * This allows the use of "if !cmd(x)" in the radio stack
   */
  uint8_t adjustStatusByte(uint8_t status) {
    return status & 0x7E;
  }

	async command uint8_t HPLCC2420.cmd(uint8_t addr)
	{
		uint8_t value;
		
		CC2420_SELECT();
		value = call Spi.write(addr);
		CC2420_UNSELECT();
		return value;
	}

	async command uint8_t HPLCC2420.write(uint8_t reg, uint16_t data)
	{
		uint8_t res;

		CC2420_SELECT();
		res = call Spi.write(reg & 0x3F);
		call Spi.write(data >> 8);
		call Spi.write(data);
		CC2420_UNSELECT();

		return adjustStatusByte(res);
	}

	async command uint16_t HPLCC2420.read(uint8_t reg)
	{
		uint16_t value;
		
		CC2420_SELECT();
		call Spi.write((uint8_t) reg | 0x40);
		value = call Spi.write(0);
		value <<= 8;
		value |= (uint16_t)call Spi.write(0);
		CC2420_UNSELECT();

		return value;
	}

	/*********************************************************************
	 *
	 * HPLCC2420RAM interface
	 *
	 ********************************************************************/

  norace uint8_t rxramlen;
  norace uint16_t rxramaddr;
  norace uint8_t* rxrambuf;

  task void signalRAMRd() {
    signal HPLCC2420RAM.readDone(rxramaddr, rxramlen, rxrambuf);
  }

  async command error_t HPLCC2420RAM.read(uint16_t addr, uint8_t _length, uint8_t* buffer) {
		uint8_t i = 0;

		atomic {
			rxramaddr = addr;
			rxramlen = _length;
			rxrambuf = buffer;
		}

		CC2420_SELECT();
 		call Spi.write((rxramaddr & 0x7F) | 0x80);
		call Spi.write(((rxramaddr >> 1) & 0xC0) | 0x20);

		for (i = 0 ; i < rxramlen; i++) {
			buffer[i] = call Spi.write(0);
		}

		CC2420_UNSELECT();

		return post signalRAMRd();
	}

  norace uint8_t* rambuf;
  norace uint8_t ramlen;
  norace uint16_t ramaddr;

  task void signalRAMWr() {
    signal HPLCC2420RAM.writeDone(ramaddr, ramlen, rambuf);
  }

  async command error_t HPLCC2420RAM.write(uint16_t addr, uint8_t _length, uint8_t* buffer) {
		uint8_t i;

		atomic {
			ramaddr = addr;
			ramlen = _length;
			rambuf = buffer;
		}

		CC2420_SELECT();

		call Spi.write((ramaddr & 0x7F) | 0x80);
		call Spi.write(((ramaddr >> 1) & 0xC0));

		for (i = 0; i < ramlen; i++) {
			call Spi.write(rambuf[i]);
		}

		CC2420_UNSELECT();

		return post signalRAMWr();
	}

  default async event error_t HPLCC2420RAM.readDone(uint16_t addr, 
																										 uint8_t _length, 
																										 uint8_t *data) 
	{ 
		return SUCCESS; 
	}

  default async event error_t HPLCC2420RAM.writeDone(uint16_t addr, 
																											uint8_t _length, 
																											uint8_t *data) 
	{ 
		return SUCCESS; 
	}


	/*********************************************************************
	 *
	 * HPLCC2420FIFO
	 *
	 ********************************************************************/
  norace uint8_t rxlen;
  norace uint8_t* rxbuf;

  task void signalRXFIFO() {
    uint8_t _rxlen;
    uint8_t* _rxbuf;
		
    atomic {
      _rxlen = rxlen;
      _rxbuf = rxbuf;
    }
		
    signal HPLCC2420FIFO.RXFIFODone(_rxlen, _rxbuf);
  }

  async command error_t HPLCC2420FIFO.readRXFIFO(uint8_t length, 
																									uint8_t *data) 
	{
    uint8_t i;

		CC2420_SELECT();

		rxbuf = data;
		call Spi.write(CC_REG_RXFIFO | 0x40);
		rxlen = call Spi.write(0) & 0x7F;

		if (rxlen > 0) {
			rxbuf[0] = rxlen;
			rxlen++;

			if (rxlen > length) rxlen = length;

			for (i = 1 ; i < rxlen; i++) {
				rxbuf[i] = call Spi.write(0);
			}
		}

		CC2420_UNSELECT();

    return post signalRXFIFO();
	}

  norace uint8_t txlen;
  norace uint8_t* txbuf;

  task void signalTXFIFO() {
    uint8_t _txlen;
    uint8_t* _txbuf;

    atomic {
      _txlen = txlen;
      _txbuf = txbuf;
    }

    signal HPLCC2420FIFO.TXFIFODone(_txlen, _txbuf);
  }

  async command error_t HPLCC2420FIFO.writeTXFIFO(uint8_t length, uint8_t *data) 
	{
		uint8_t i;
		
		atomic {
			txlen = length;
			txbuf = data;
		}
		
		CC2420_SELECT();
		call Spi.write(CC_REG_TXFIFO);
		call Spi.write(txlen);

		for (i = 1; i < txlen; i++) {
			call Spi.write(txbuf[i]);
		}
		
		/* Release the radio */
		CC2420_UNSELECT();

		return post signalTXFIFO();
	}

  default async event error_t HPLCC2420FIFO.RXFIFODone(uint8_t _length, 
																												uint8_t *data) 
	{ 
		return SUCCESS; 
	}

  default async event error_t HPLCC2420FIFO.TXFIFODone(uint8_t _length, 
																												uint8_t *data) { 
		return SUCCESS; 
	}

	/*********************************************************************
	 *
	 * HPLCC2420Status
	 *
	 ********************************************************************/
	async command bool HPLCC2420Status.FIFO()
	{
		return P5IN & (1 << 5);
	}

	async command bool HPLCC2420Status.FIFOP()
	{
		return P5IN & (1 << 6);
	}

	async command bool HPLCC2420Status.CCA()
	{
		return P5IN & (1 << 4);
	}

	async command bool HPLCC2420Status.SFD()
	{
		return P1IN & (1 << 7);
	}


}
