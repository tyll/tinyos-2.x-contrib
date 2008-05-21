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

module Hcs08SpiP
{
  provides interface Hcs08Spi;
  provides interface SpiByte;
  provides interface StdControl;
  
  uses interface HplHcs08GeneralIO as SS;
  uses interface HplHcs08Spi as Spi;
  uses interface StdControl as SpiControl;
}
implementation
{

  command error_t StdControl.start()
  {
  	call SpiControl.start();
  	call Spi.masterMode();
  	call Spi.phaseMiddle();
  	call Spi.clockPolarityHigh();
  	call Spi.msbFirst();
  	call Spi.setSpeed(1, 2);
  	call SS.set();
  	call SS.makeOutput();
  	
  	return SUCCESS;
  }
  
  command error_t StdControl.stop()
  {
  	call SS.set();
  	call SpiControl.stop();
  	
  	return SUCCESS;
  }
  
  async command uint8_t Hcs08Spi.write(uint8_t byte)
  {
  	int tmp;
  	tmp = call Spi.get();
  	//wait for buffer to be empty
  	while(!call Spi.isEmpty()); 
  	call Spi.send(byte);
  	while(!call Spi.isReady()); 
  	return call Spi.get();
  }
  
  async command error_t Hcs08Spi.writeAsync(uint8_t byte)
  {
  	if(!call Spi.isEmpty())
  	  return EBUSY;
  	call Spi.send(byte);
  	return  SUCCESS;
  }
  
  async command void Hcs08Spi.setSS() { call SS.set(); }
  async command void Hcs08Spi.clrSS() { call SS.clr(); }
  
  async command void Hcs08Spi.enableRecieveInterrupt() 
  { 
    call Spi.enableRecieveInterrupt(); 
  }
  
  async command void Hcs08Spi.disableRecieveInterrupt() 
  { 
    call Spi.disableRecieveInterrupt(); 
  }
  
  async command void Hcs08Spi.enableTransmitInterrupt()
  {
  	call Spi.enableTransmitInterrupt();
  }
  
  async command void Hcs08Spi.disableTransmitInterrupt()
  {
  	call Spi.disableTransmitInterrupt();
  }
  
  async command void Hcs08Spi.setLsbFirst(bool b)
  {
  	if(b)
  	  call Spi.lsbFirst();
  	else
  	  call Spi.msbFirst();
  }
  
  async command bool Hcs08Spi.getLsbFirst()
  {
  	return call Spi.isLsbFirst();
  }
  
  async command void Hcs08Spi.setClockLow(bool b)
  {
  	if(b)
  	  call Spi.clockPolarityLow();
  	else
  	  call Spi.clockPolarityHigh();
  }
  
  async command bool Hcs08Spi.getClockLow()
  {
  	return call Spi.isClockPolarityLow();
  }
  
  async command void Hcs08Spi.setPhaseEdge(bool b)
  {
  	if(b)
  	  call Spi.phaseEdge();
  	else
  	  call Spi.phaseMiddle();
  }
  
  async command bool Hcs08Spi.getPhaseEdge()
  {
  	return call Spi.isPhaseEdge();
  }
  
  async command void Hcs08Spi.setSpeed(uint8_t ratePrescaleDiv, uint8_t rateDiv)
  {
  	call Spi.setSpeed(ratePrescaleDiv, rateDiv);
  }
  
  async command uint8_t SpiByte.write( uint8_t byte ) 
  {
  	uint8_t result;
  	
    call Hcs08Spi.clrSS();
    result = call Hcs08Spi.write(byte);
    call Hcs08Spi.setSS();
    return result;
  }
    
  async event void Spi.TransmitBufferEmpty()
  {
  	signal Hcs08Spi.TransmitBufferEmpty();
  }
  
  async event void Spi.RecievedByte(uint8_t byte)
  {
  	signal Hcs08Spi.RecievedByte(byte);
  }
  
  default async event void Hcs08Spi.RecievedByte(uint8_t byte)
  {
  }
  
  default async event void Hcs08Spi.TransmitBufferEmpty()
  {
  }
}