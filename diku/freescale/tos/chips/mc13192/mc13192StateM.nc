/* Copyright (c) 2006, Jan Flora <janflora@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
  @author Jan Flora <janflora@diku.dk>
*/

module mc13192StateM {
	provides
	{
		interface mc13192State as State;
	}
	uses
	{
		interface mc13192Regs as Regs;
		interface mc13192EventTimer as EventTimer;
		interface mc13192Pins as Pins;
	}
}
implementation
{

	// Global transceiver mode mirror
	uint16_t rxtxMode;
	uint16_t irqMask = 0;
	
	// Forward declarations
	void setRXTXMode(uint16_t mode);
	void enableLowerIRQs();
	void disableLowerIRQs();

	async command uint16_t State.getRXTXStateMirror()
	{
		uint16_t mirror;
		atomic mirror = rxtxMode;
		return mirror;
	}
	
	async command uint16_t State.getRXTXState()
	{
		uint16_t reg;
		reg = call Regs.read(CONTROL_A);
		reg &= 0x1F33; // Mask out mode.
		return reg;
	}

	async command error_t State.setRXTXStateMirror(uint16_t reqMode)
	{
		// This is only used to set the state mirror back in
		// to idle mode, when the transceiver has automatically changed
		// state after fx. a successful rx/tx operation.
		call Pins.clrRXTXEN(); 
		atomic rxtxMode = reqMode;
		return SUCCESS;
	}
	
	async command error_t State.setIdleMode()
	{
		call Pins.clrRXTXEN(); 
		call Pins.setLNACtrl();
		setRXTXMode(IDLE_MODE);
		return SUCCESS;
	}
	
	async command error_t State.setCCAMode(uint8_t mode)
	{
		call Pins.clrRXTXEN(); 
		call Pins.setLNACtrl();
		call Pins.clrAntCtrl();
		setRXTXMode(CCA_MODE);
		call Pins.setRXTXEN();
		return SUCCESS;
	}
	
	async command error_t State.setEDMode(uint8_t mode)
	{
		call Pins.clrRXTXEN(); 
		call Pins.setLNACtrl();
		call Pins.clrAntCtrl(); 
		setRXTXMode(ED_MODE);
		call Pins.setRXTXEN(); 
		return SUCCESS;
	}
	
	async command error_t State.setRXMode()
	{
		call Pins.clrRXTXEN();
		call Pins.setLNACtrl();
		call Pins.clrAntCtrl(); 
		setRXTXMode(RX_MODE);
		call Pins.setRXTXEN(); 
		return SUCCESS;
	}
	
	async command error_t State.setTXMode()
	{
		call Pins.clrRXTXEN();
		call Pins.clrLNACtrl(); 
		call Pins.setAntCtrl(); 
		setRXTXMode(TX_MODE);
		call Pins.setRXTXEN();
		return SUCCESS;
	}
	
	inline async command error_t State.setRXStreamMode()
	{
		call Pins.clrRXTXEN();
		call Pins.setLNACtrl();
		
		call Pins.clrAntCtrl();
		setRXTXMode(RX_STRM_MODE);
		
		call Pins.setRXTXEN();
		return SUCCESS;
	}
	
	inline async command error_t State.setTXStreamMode()
	{
		call Pins.clrRXTXEN();
		call Pins.clrLNACtrl();
		call Pins.setAntCtrl(); 
		setRXTXMode(TX_STRM_MODE);
		call Pins.setRXTXEN(); 
		return SUCCESS;
	}
	
	// Helper functions	
	inline void setRXTXMode(uint16_t mode)
	{
		// This entire section is atomic, to ensure that state changes
		// are completed one at a time!
		atomic {
			rxtxMode = mode;
			if (call EventTimer.isSet()) mode |= 0x0080;
			call Regs.write(CONTROL_A, mode);
		}
	}
}
