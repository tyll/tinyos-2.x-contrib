/*
 * Copyright (c) 2007 Copenhagen Business School
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
 *   Neither the name of CBS nor the names of its
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
 * The Hpl Interface for the I2C component. 
 *
 * @author Rasmus Ulslev Pedersen
 */

module HplAT91I2CP
{
  provides interface Init;
  provides interface HplAT91I2C as I2C; 

  uses interface HplAT91Interrupt as I2CIrq;

}

implementation
{
  bool m_fInit = FALSE;

  command error_t Init.init() {
    bool isInited;

    atomic {
      isInited = m_fInit;
      m_fInit = TRUE;
    }

    if (!isInited) {
      // called in HalAT91I2CMasterP Init.inits
      //call I2C.setTWICWGR(0); //TODO: fix

      AT91C_BASE_PMC->PMC_PCER = (1<<AT91C_ID_TWI);
      call I2CIrq.allocate();
      call I2CIrq.enable();
    }

    return SUCCESS;
  }

  async command void I2C.setTWITHR(uint32_t val) {
    *AT91C_TWI_THR = val;
  }
  
  async command uint32_t I2C.getTWIRHR() {
    return *AT91C_TWI_RHR;
  }

  async command void I2C.setTWIMMR(uint32_t val) {
    *AT91C_TWI_MMR = val;
  }

  async command void I2C.setTWICR(uint32_t val) {
    *AT91C_TWI_CR = val;  
  }

  async command uint32_t I2C.getTWISR() {
    return *AT91C_TWI_SR ;
  }

  async command void I2C.setTWICWGR(uint32_t val) {
    *AT91C_TWI_CWGR = val;  
  }

  async command void I2C.setTWIIER(uint32_t val) {
    *AT91C_TWI_IER = val;
  }

  async command void I2C.setTWIIDR(uint32_t val) {
    *AT91C_TWI_IDR = val;
  }

  async event void I2CIrq.fired() {

    signal I2C.interruptI2C();
//problem

    return;
  }

  default async event void I2C.interruptI2C() { 
    return;
  }
}
