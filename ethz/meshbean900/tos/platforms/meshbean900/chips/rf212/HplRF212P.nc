/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Miklos Maroti
 */

#include <util/crc16.h>
#include "Atm128Spi.h"

module HplRF212P
{
	provides
	{
		interface GpioCapture as IRQ;
		interface Init as PlatformInit;
		interface HplRF212;
	}

	uses
	{
		interface HplAtm128Interrupt as Interrupt;
		interface GeneralIO as PortCLKM;
		interface GeneralIO as PortIRQ;
		interface HplAtm128Timer<uint16_t> as Timer;
	}
}

implementation
{
	command error_t PlatformInit.init()
	{
		call PortIRQ.makeInput();
		call PortIRQ.clr();
		return SUCCESS;
	}


	async event void Interrupt.fired() {
		uint16_t time = call Timer.get();
		signal IRQ.captured(time);
	}

	async command error_t IRQ.captureRisingEdge()
	{
		call Interrupt.edge(TRUE);
		call Interrupt.enable();
	
		return SUCCESS;
	}

	async command error_t IRQ.captureFallingEdge()
	{
		// falling edge comes when the IRQ_STATUS register of the RF230 is read
		return FAIL;	
	}

	async command void IRQ.disable()
	{
		call Interrupt.disable();
	}


    async event void Timer.overflow() {}

	// TODO: Check why the default crcByte implementation is in a different endianness
	inline async command uint16_t HplRF212.crcByte(uint16_t crc, uint8_t data)
	{
		return _crc_ccitt_update(crc, data);
	}

	inline async command void HplRF212.spiSplitWrite(uint8_t data)
	{
		// the SPI must have been started, so do not waste time here
		// SET_BIT(SPCR, SPE);

		SPDR = data;
	}

	inline async command uint8_t HplRF212.spiSplitRead()
	{
	    while( !( SPSR & 0x80 ) )
			;
		return SPDR;
	}

	inline async command uint8_t HplRF212.spiSplitReadWrite(uint8_t data)
	{
		uint8_t b;

	    while( !( SPSR & 0x80 ) )
			;
		b = SPDR;
		SPDR = data;

		return b;
	}

	inline async command uint8_t HplRF212.spiWrite(uint8_t data)
	{
		// the SPI must have been started, so do not waste time here
		// SET_BIT(SPCR, SPE);

		SPDR = data;
	    while( !( SPSR & 0x80 ) )
			;

		return SPDR;
	}
}
