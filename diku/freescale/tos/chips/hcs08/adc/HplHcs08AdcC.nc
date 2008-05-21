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

#include "hcs08regs.h"

module HplHcs08AdcC
{
	provides interface HplHcs08Adc;
}
implementation
{  
  async command void HplHcs08Adc.enableAdc() { ATDC_ATDPU = 1; }
  
  async command void HplHcs08Adc.disableAdc() {ATDC_ATDPU = 0; }
  
  async command void HplHcs08Adc.leftJustified() {ATDC_DJM = 0; }
  
  async command void HplHcs08Adc.rightJustfied() {ATDC_DJM = 1; }
  
  async command void HplHcs08Adc.resolution8Bit() {ATDC_RES8 = 1; }
  
  async command void HplHcs08Adc.resolution10Bit() {ATDC_RES8 = 0; }
  
  async command void HplHcs08Adc.resultSigned() { ATDC_SGN = 1; }
  
  async command void HplHcs08Adc.resultUnsigned() { ATDC_SGN = 0; }
  
  async command void HplHcs08Adc.enableInterrupt() { ATDSC_ATDIE = 1; }
  
  async command void HplHcs08Adc.disableInterrupt() { ATDSC_ATDIE = 0; }
  
  async command void HplHcs08Adc.setContinous() {ATDSC_ATDCO = 1; }
  
  async command void HplHcs08Adc.setSingle() {ATDSC_ATDCO = 0; }
  
//  DEFINE_UNION_CAST(ATDC2INT, ATDC_t, uint8_t);
//  DEFINE_UNION_CAST(ATDSC2INT, ATDSC_t, uint8_t);
  
  uint8_t ATDC2INT(ATDC_t x) {
    union atdc {
  	  ATDC_t f;
      uint8_t t;
      };
    union atdc c;
    c.f = x;
    return c.t;
  }
  
  uint8_t ATDSC2INT(ATDSC_t x) {
    union atdsc {
  	  ATDSC_t f;
      uint8_t t;
      };
    union atdsc c;
    c.f = x;
    return c.t;
  }
  
  async command ATDC_t HplHcs08Adc.getATDC()
  {
  	return *(ATDC_t*)&ATDC;
  }
  
  async command ATDSC_t HplHcs08Adc.getATDSC()
  {
  	return *(ATDSC_t*)&ATDSC;
  }
  
  async command void HplHcs08Adc.setATDC(ATDC_t reg)
  {
  	ATDC = ATDC2INT(reg);
  } 
  
  async command void HplHcs08Adc.setATDSC(ATDSC_t reg)
  {
  	ATDSC = ATDSC2INT(reg);
  } 
  
  async command void HplHcs08Adc.setPrescaler(uint8_t factor) 
  { 
    ATDC_PRS = (factor +1) *32; 
  }
  
  async command bool HplHcs08Adc.isComplete()
  {
  	return ATDSC_CCF;
  }
  
  async command void HplHcs08Adc.selectChannel(uint8_t channel)
  {
  	ATDSC_ATDCH = channel;
  }
  
  async command uint16_t HplHcs08Adc.getValue()
  {
  	return ATDR;
  }
  
  async command void HplHcs08Adc.pinEnable(uint8_t pin)
  {
  	ATDPE |= 1 << pin;
  }
  
  async command void HplHcs08Adc.pinDisable(uint8_t pin)
  {
  	ATDPE &= !(1 << pin);
  }
  
  async command bool HplHcs08Adc.cancel()
  {
  	bool ret;
  	atomic {
  	ret = ATDSC_ATDIE || ATDSC_CCF;
  	
  	call HplHcs08Adc.disableInterrupt();
  	
  	//This writes to ADTC which stops conversion
  	call HplHcs08Adc.enableAdc();
  	}
  	
  	return ret;
  }
  
  TOSH_SIGNAL(ATD)
  {
  	uint16_t data = call HplHcs08Adc.getValue();
  	
  	signal HplHcs08Adc.dataReady(data);
  }
}
