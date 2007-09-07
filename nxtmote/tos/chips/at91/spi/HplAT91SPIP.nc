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
 *
 * @author Phil Buonadonna
 */

module HplAT91SSPP 
{
  provides {
    interface Init;
    interface HplAT91SPI;
  }
  uses {
    interface HplAT91Interrupt as SPIIrq;
  }
}

implementation 
{

  command error_t Init.init() {
    error_t error = SUCCESS;
    
    return error;
  }

  async command void setSPICR(uint32_t val) {
    AT91C_BASE_AIC->SPI_CR = val;
  }
  
  async command void setSPIMR(uint32_t val) {
    AT91C_BASE_AIC->SPI_MR = val;
  }
  async command uint32_t getSPIMR() {
    return AT91C_BASE_AIC->SPI_MR;
  }
  
  async command uint32_t getSPISR() {
    return AT91C_BASE_AIC->SPI_SR;  
  }
  
  async command uint32_t getSPIRDR() {
    return AT91C_BASE_AIC->SPI_RDR;
  }
    
  async command void setSPITDR(uint32_t val) {
    AT91C_BASE_AIC->SPI_TDR = val;
  }
  
  async command void setSPIIER(uint32_t val) {
    AT91C_BASE_AIC->SPI_IER = val;
  }
    
  async command void setSPIIDR(uint32_t val) {
    AT91C_BASE_AIC->SPI_IDR = val;
  }
    
  async command uint32_t getSPIIMR() {
    return AT91C_BASE_AIC->SPI_IMR;
  }
   
  async command uint32_t getSPICSR0() {
    return AT91C_BASE_AIC->SPI_CSR[0];
  }
  async command void setSPICSR0(uint32_t val) {
    AT91C_BASE_AIC->SPI_CSR[0] = val;
  }
      
  async command uint32_t getSPICSR1() {
    return AT91C_BASE_AIC->SPI_CSR[1];
  }
  async command void setSPICSR1(uint32_t val) {
    AT91C_BASE_AIC->SPI_CSR[1] = val;
  }
  
  async command uint32_t getSPICSR2() {
    return AT91C_BASE_AIC->SPI_CSR[2];
  }
  async command void setSPICSR2(uint32_t val) {
    AT91C_BASE_AIC->SPI_CSR[2] = val;
  }
  
  async command uint32_t getSPICSR3() {
    return AT91C_BASE_AIC->SPI_CSR[3];
  }
  async command void setSPICSR3(uint32_t val) {
    AT91C_BASE_AIC->SPI_CSR[3] = val;
  }

  default async event void HplAT91SPI.interruptSPI() {
    return;
  }

  async event void SPIIrq.fired() {
    signal HplAT91SPI.interruptSPI();
  }

  default async command void SPIIrq.enable() {return;}

}
