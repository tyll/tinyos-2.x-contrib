/* Copyright (c) 2007, Tor Petterson <motor@diku.dk>
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
  @author Tor Petterson <motor@diku.dk>
*/

module HplHcs08SpiP {
  provides interface HplHcs08Spi as Spi;
  provides interface StdControl;
  uses interface McuPowerState;
}
implementation {

  command error_t StdControl.start()
  {
  	call Spi.enable();
  	call McuPowerState.update();
  	
  	return SUCCESS;
  }
  
  command error_t StdControl.stop()
  {
	call Spi.disableRecieveInterrupt();
	call Spi.disableTransmitInterrupt();
	call Spi.disable();
	call McuPowerState.update();
	
	return SUCCESS;
  }
  
  async command void Spi.enable()
  {
  	SPIC1_Bits.SPE = 1;
  }
  
  async command void Spi.disable()
  {
  	SPIC1_Bits.SPE = 0;
  }
  
  async command void Spi.enableRecieveInterrupt()
  {
  	SPIC1_Bits.SPIE = 1;
  }
  
  async command void Spi.disableRecieveInterrupt()
  {
  	SPIC1_Bits.SPIE = 0;
  }
  
  async command void Spi.enableTransmitInterrupt()
  {
  	SPIC1_Bits.SPTIE = 1;
  }
  
  async command void Spi.disableTransmitInterrupt()
  {
  	SPIC1_Bits.SPTIE = 0;
  }
  
  async command void Spi.msbFirst()
  {
  	SPIC1_Bits.LSBFE = 0;
  }
  
  async command void Spi.lsbFirst()
  {
  	SPIC1_Bits.LSBFE = 1;
  }
  
  async command bool Spi.isLsbFirst()
  {
  	return SPIC1_Bits.LSBFE;
  }
  
  async command void Spi.masterMode()
  {
  	SPIC1_Bits.MSTR = 1;
  }
  
  async command void Spi.slaveMode()
  {
  	SPIC1_Bits.MSTR = 0;
  }
  
  async command bool Spi.isMasterMode()
  {
  	return SPIC1_Bits.MSTR;
  }
  
  async command void Spi.clockPolarityHigh()
  {
  	SPIC1_Bits.CPOL = 0;
  }
  
  async command void Spi.clockPolarityLow()
  {
  	SPIC1_Bits.CPOL = 1;
  }
  
  async command bool Spi.isClockPolarityLow()
  {
  	return SPIC1_Bits.CPOL;
  }
  
  async command void Spi.phaseEdge()
  {
  	SPIC1_Bits.CPHA = 1;
  }
  
  async command void Spi.phaseMiddle()
  {
  	SPIC1_Bits.CPHA = 0;
  }
  
  async command bool Spi.isPhaseEdge()
  {
  	return SPIC1_Bits.CPHA;
  }
  
  async command void Spi.setSpeed(uint8_t ratePrescaleDiv, uint8_t rateDiv)
  {
  	uint8_t pre, rate;
  	
  	pre = ratePrescaleDiv -1;
  	pre &= 0x07;
  	pre = pre << 4;
  	
  	while (rateDiv) {
	  rateDiv = rateDiv>>1;
	  rate++;
	}
	rate-=2;
	rate &= 0x07;
	
	rate |= pre;
	
  	SPIBR = rate;
  }
  
  async command uint8_t Spi.getRatePrescaleDiv()
  {
  	uint8_t div;
  	
  	div = SPIBR >> 4;
  	div &= 0x07;
  	div--;
  	return div;
  }
  
  async command uint8_t Spi.getRateDiv()
  {
  	uint8_t reg, div = 2;
  	reg = SPIBR & 0x07;
  	while(reg)
  	{
  	  reg--;
  	  div = div << 1;
  	}
  	return div;
  }
  	
  async command uint8_t Spi.get()
  {
  	return SPID;
  }
  
  async command error_t Spi.send(uint8_t byte)
  {
  	SPID = byte;
  }
  
  async command bool Spi.isEmpty()
  {
  	return SPIS_Bits.SPTEF;
  }
  
  async command bool Spi.isReady()
  {
  	return SPIS_Bits.SPRF;
  }
  
  TOSH_SIGNAL(SPI)
  {
  	if(SPIS_Bits.SPRF)
  	  signal Spi.RecievedByte(SPID);
  	
  	if(SPIS_Bits.SPTEF)
  	  signal Spi.TransmitBufferEmpty();
  	
  	//MODF not handled
  }
  
}