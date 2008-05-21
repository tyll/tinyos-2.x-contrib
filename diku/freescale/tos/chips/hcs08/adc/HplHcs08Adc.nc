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

interface HplHcs08Adc
{
  async command void enableAdc();
  async command void disableAdc();
  async command void leftJustified();
  async command void rightJustfied();
  async command void resolution8Bit();
  async command void resolution10Bit(); 
  async command void resultSigned();
  async command void resultUnsigned();
  async command void enableInterrupt();
  async command void disableInterrupt(); 
  async command void setContinous(); 
  async command void setSingle();
  async command ATDC_t getATDC();
  async command ATDSC_t getATDSC();
  async command void setATDC(ATDC_t reg);
  async command void setATDSC(ATDSC_t reg);
  async command void setPrescaler(uint8_t factor); 
  async command bool isComplete();
  async command void selectChannel(uint8_t channel);
  async command uint16_t getValue();
  async command void pinEnable(uint8_t pin);
  async command void pinDisable(uint8_t pin);
  async command bool cancel();
  async event void dataReady(uint16_t data);
}