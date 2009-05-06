/*
* Copyright (c) 2006 Stanford University.
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
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 
/**
 * @brief Driver module for the OmniVision OV7649 Camera
 * @author
 *		Andrew Barton-Sweeney (abs@cs.yale.edu)
 *		Evan Park (evanpark@gmail.com)
 */
/**
 * @brief Ported to TOS2
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 
 /**
 * OV7649LogicP is the driver for the OV7649, the I2C variant
 * of the Taos OV7649 line. 
 *  It requires an I2C packet interface and provides the 
 * OV7649 HPL interface.
 */

#include "SCCB.h"

module HplSCCBM
{
  provides interface HplSCCB[uint8_t IdentAddr];

  uses interface GeneralIO as SIOD;
  uses interface GeneralIO as SIOC;

  uses interface Leds;
}

implementation {


//#define sdata_out()	{ call SIOD.makeOutput(); }
//#define sclock_out()	{ call SIOC.makeOutput(); }
//#define sdata_in()	{ call SIOD.makeInput(); }
//#define sdata_set() { call SIOD.set(); }
//#define sdata_clr() { call SIOD.clr(); }
//#define sdata_get() { call SIOD.get(); }
//#define sclock_set() { call SIOD.set(); }
//#define sclock_clr() { call SIOD.clr(); }
//#define sccb_delay() {   asm volatile  ("nop" ::); asm volatile  ("nop" ::); asm volatile  ("nop" ::); }

//------------------------------------------------------------------------------
// SCCB Peripheral Function Prototypes
//------------------------------------------------------------------------------
error_t Write(uint8_t data_out);				//  Writes data over the I2C bus
error_t Read(uint8_t *data_in);// Reads data from the I2C bus
void Ack();
void Start();								//  Sends I2C Start Trasfer
void Stop();								//  Sends I2C Stop Trasfer
void SetSCLK(bool state);						//  Set SCLK to <state>
void SetSDATA(bool state);						//  Set SDATA to <state>
bool GetSDATA();								//  Get SDATA state

//------------------------------------------------------------------------------
// Procedure:	init
// Inputs:		identaddr
// Outputs:		error_t
// Description:	Initialize I2C and setup Slave Ident Addr. then check the ident
//				for response and returns SUCCESS if ok.
//------------------------------------------------------------------------------

command error_t HplSCCB.init[uint8_t IdentAddr]() {
	Stop();
	//sclock_out();	// added by brano
	sdata_out();				// Set SDATA as output
	SetSDATA(1);
	SetSCLK(1);
	return SUCCESS;
}

//------------------------------------------------------------------------------
// Procedure:	sccb_3write
// Inputs:		data out, address
// Outputs:		error_t
// Description:	3-phase write. Writes a byte to the given address and return status.
//------------------------------------------------------------------------------
command error_t HplSCCB.three_write[uint8_t IdentAddr](uint8_t data_out, uint8_t address)
{
	atomic{
		Start();							// Send start signal
		//Write(IdentAddr);
		Write(0x42);
		Ack();
		Write(address);
		Ack();
		Write(data_out);
		Ack();
		Stop();
	}

	return SUCCESS;
}

//------------------------------------------------------------------------------
// Procedure:	sccb_2write
// Inputs:		address
// Outputs:		error_t
// Description:	2-phase write
//------------------------------------------------------------------------------
command error_t HplSCCB.two_write[uint8_t IdentAddr](uint8_t address)
{
	atomic{
		Start();							// Send start signal
		//Write(IdentAddr);
		Write(0x42);
		Ack();
		Write(address);
		Ack();
		Stop();
	}	
	return SUCCESS;
}

//------------------------------------------------------------------------------
// Procedure:	sccb_read
// Inputs:		*data_in, address
// Outputs:		error_t
// Description:	Reads a byte from the given address and return status.
//------------------------------------------------------------------------------
command error_t HplSCCB.read[uint8_t IdentAddr](uint8_t *data_in)
{
	atomic{
		Start();							// Send start signal
		//Write(IdentAddr+1);
		Write(0x43);
		Ack();
		Read(data_in);  // includes ack
		Stop();
	}
	return SUCCESS;
}

//------------------------------------------------------------------------------
// SCCB Functions - Master
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// 	Routine:	Write
//	Inputs:		data_out
//	Outputs:	error_t
//	Purpose:	Writes data over the SCCB bus and return status.
//------------------------------------------------------------------------------
error_t inline Write(unsigned char data_out)
{
	unsigned char idx;
	unsigned char mask = 0x80;

	sdata_out();
	// An SCCB output byte is bits 7-0 (MSB to LSB). Shift one bit at a time to
	// the SDATA output, and then clock the data to the SCCB Slave device.
	// Send 8 bits out the port
	for(idx = 0; idx < 8; idx++)
	{
		SetSDATA(((data_out & mask) ? 1 : 0)); // Output the data bit to the device
		SetSCLK(1);
		sccb_delay();
		SetSCLK(0);
		data_out <<= 1;  // Shift the byte by one bit
	}
	return SUCCESS;
}

//------------------------------------------------------------------------------
// 	Routine:	Read
//	Inputs:		*data_in
//	Outputs:	error_t
//	Purpose:	Reads data from the SCCB bus and return it in data_in.
//------------------------------------------------------------------------------
error_t inline Read(unsigned char *data_in)
{
	uint8_t idx;

	*data_in = 0x00;
	for(idx = 0; idx < 8; idx++)
	{
		*data_in <<= 1;						// Shift the data right 1 bit
		SetSCLK(1);
		sccb_delay();
		*data_in |= GetSDATA();				// Read the data bit
		SetSCLK(0);
	}
	return SUCCESS;
}

//------------------------------------------------------------------------------
// 	Routine:	ack
//	Inputs:		none
//	Outputs:	none
//	Purpose:	?
//------------------------------------------------------------------------------
void Ack()
{
	SetSDATA(0);  // write 0
	sdata_in();
	SetSCLK(1);
	sccb_delay();
	SetSCLK(0);
	sccb_delay();
}

//------------------------------------------------------------------------------
// 	Routine:	Start
//	Inputs:		none
//	Outputs:	none
//	Purpose:	Sends I2C Start Trasfer - "S"
//------------------------------------------------------------------------------
void Start()
{
	sdata_out();
	SetSDATA(0);
	SetSCLK(0);
}

//------------------------------------------------------------------------------
// 	Routine:	Stop
//	Inputs:		none
//	Outputs:	none
//	Purpose:	Sends I2C Stop Trasfer - "P"
//------------------------------------------------------------------------------
void Stop()
{
	sdata_out();
	SetSCLK(1);
	SetSDATA(1);
}

//------------------------------------------------------------------------------
// 	Routine:	SetSDATA
//	Inputs:		state
//	Outputs:	none
//	Purpose:	Set the I2C port SDATA pin to <state>.
//------------------------------------------------------------------------------
void inline SetSDATA(bool state)
{
	if (state) {		// Set SDATA as input/high.
		sdata_set();
	} else {			// Set SDATA low.
		sdata_clr(); //call SIOD.clr();
	}
	sccb_delay();
}

//------------------------------------------------------------------------------
// 	Routine:	SetSCLK
//	Inputs:		state
//	Outputs:	none
//	Purpose:	Set the I2C port SCLK pin to <state>.
//------------------------------------------------------------------------------
void inline SetSCLK(bool state)
{
	if (state) {		// Set SCLK as input/high.
		sclock_set();//call SIOC.set();
	} else {			// Set SCLK low.
		sclock_clr();//call SIOC.clr();
	}
	sccb_delay();
}

//------------------------------------------------------------------------------
// 	Routine:	GetSDATA
//	Inputs:		none
//	Outputs:	bool
//	Purpose:	Get the I2C port SDATA pin state.
//------------------------------------------------------------------------------
bool inline GetSDATA()	{ 
  return (sdata_get());//(call SIOD.get()); 
}

}
