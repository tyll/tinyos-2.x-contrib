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


/**
 * Mc13192 register access
 * @author Tor Petterson <motor@diku.dk>
 */
 
 module Mc13192RegsP
{
  uses interface Hcs08Spi as Spi;
  
  provides interface mc13192Regs as Regs;
}
implementation
{
  async command uint16_t Regs.read(uint8_t addr)
  {
  	uint16_t w=0;
  	
  	IRQSC_IRQIE = 0;
    call Spi.clrSS();
    call Spi.write((addr & 0x3f) | 0x80);
    ((uint8_t*)&w)[0] = call Spi.write(0); // MSB
    ((uint8_t*)&w)[1] = call Spi.write(0); // LSB
    call Spi.setSS();
    IRQSC_IRQIE = 1;
    
    return w;
  }
  
  async command void Regs.write(uint8_t addr, uint16_t val)
  {
  	
  	IRQSC_IRQIE = 0;
  	call Spi.clrSS();
    call Spi.write(addr & 0x3f);
    call Spi.write(((uint8_t*)&val)[0]);
    call Spi.write(((uint8_t*)&val)[1]);
    call Spi.setSS();
    IRQSC_IRQIE = 1;
  }
  
  async command error_t Regs.recursiveRead(uint8_t addr, uint16_t* buf, uint8_t len)
  {
  	int i;
  	
  	IRQSC_IRQIE = 0;
  	call Spi.clrSS();
    call Spi.write((addr & 0x3f) | 0x80);
    for(i = 0; i < len; i++)
    {
      ((uint8_t*)&buf[i])[0] = call Spi.write(0); // MSB
      ((uint8_t*)&buf[i])[1] = call Spi.write(0); // LSB
    }
    call Spi.setSS();
    IRQSC_IRQIE = 1;
    
    return SUCCESS;
  }
  
  async command error_t Regs.recursiveWrite(uint8_t addr, uint16_t* buf, uint8_t len)
  {
    int i;
    
    IRQSC_IRQIE = 0;
    call Spi.clrSS();
    call Spi.write(addr & 0x3f);
    for(i = 0; i < len; i++)
    {
      call Spi.write(((uint8_t*)&buf[i])[0]);
      call Spi.write(((uint8_t*)&buf[i])[1]);
    }
    call Spi.setSS();
    IRQSC_IRQIE = 1;
    
    return SUCCESS;
  }
  
  async command error_t Regs.seqWriteStart(uint8_t addr)
  {
    call Spi.clrSS();
    call Spi.write(addr & 0x3f);
    return SUCCESS;
  }
  
  async command error_t Regs.seqReadStart(uint8_t addr)
  {
    call Spi.clrSS();
    call Spi.write((addr & 0x3f) | 0x80);
  }
  
  async command error_t Regs.seqEnd()
  {
    call Spi.setSS();
    return SUCCESS;
  }
  
  async command error_t Regs.seqWriteWord(uint8_t *buffer)
  {
    call Spi.write(buffer[1]);
	call Spi.write(buffer[0]);
	return SUCCESS;
  }
  
  async command error_t Regs.seqReadWord(uint8_t *buffer)
  {
    buffer[1] = call Spi.write(0); 
    buffer[0] = call Spi.write(0); 
  }
  
  async event void Spi.TransmitBufferEmpty() {}
  async event void Spi.RecievedByte(uint8_t byte) {}
}
