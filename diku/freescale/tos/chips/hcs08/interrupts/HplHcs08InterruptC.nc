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
 * implementation of the IRQ pin on the Hcs08
 * @author Tor Petterson <motor@diku.dk>
 */

module HplHcs08InterruptC
{
  provides interface HplHcs08Interrupt;
}
implementation
{

  async command void HplHcs08Interrupt.enable()
  {
  	//Enable IRQ pin
  	IRQSC_IRQPE = 1;
  	//Acknowledge any pending interrupts
  	IRQSC_IRQACK = 1;
  }
  
  async command void HplHcs08Interrupt.disable()
  {
  	IRQSC_IRQPE = 0;
  	IRQSC_IRQIE = 0;
  }
  
  async command void HplHcs08Interrupt.enableInterrupt()
  {
  	IRQSC_IRQIE = 1;
  }
  
  async command void HplHcs08Interrupt.disableInterrupt()
  {
  	IRQSC_IRQIE = 0;
  }
  
  async command bool HplHcs08Interrupt.get()
  {
    return IRQSC_IRQF;
  }
  
  async command void HplHcs08Interrupt.ack()
  {
    IRQSC_IRQACK = 1;
  }
  
  async command void HplHcs08Interrupt.interruptOnRising()
  {
  	IRQSC_IRQEDG = 1;
  }
  
  async command void HplHcs08Interrupt.interruptOnFalling()
  {
  	IRQSC_IRQEDG = 0;
  }
  
  async command void HplHcs08Interrupt.interruptOnEdge()
  {
  	IRQSC_IRQMOD = 0;
  }
  
  async command void HplHcs08Interrupt.interruptOnEdgeLevel()
  {
  	IRQSC_IRQMOD = 1;
  }
  
  TOSH_SIGNAL(IRQ)
  {
  	IRQSC_IRQACK = 1;
  	signal HplHcs08Interrupt.fired();
  }
}
  
  