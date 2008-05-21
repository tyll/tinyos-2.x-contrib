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

#include "Hcs08Rti.h"

module HplHcs08RtiC
{
  provides interface HplHcs08Rti;
}
implementation
{
  
  async command void HplHcs08Rti.enable()
  {
  	SRTISC_RTIACK = 1;
  	SRTISC_RTIE = 1;
  }
  
  async command void HplHcs08Rti.disable()
  {
  	SRTISC_RTIE = 0;
  }
  
  async command void HplHcs08Rti.setPeriod(uint8_t period)
  {
  	SRTISC_RTIS0 = period & 1;
    SRTISC_RTIS1 = (period & 2) >> 1;
    SRTISC_RTIS2 = (period & 4) >> 2;
  }
  
  async command uint8_t HplHcs08Rti.getPeriod()
  {
  	return SRTISC_RTIS0 | (SRTISC_RTIS1 << 1) | (SRTISC_RTIS2 << 2);
  }
  
  async command void HplHcs08Rti.setExternalClock()
  {
  	SRTISC_RTICLKS = 1;
  }
  
  async command void HplHcs08Rti.setInternalClock()
  {
  	SRTISC_RTICLKS = 0;
  }
  
  TOSH_SIGNAL(RTI)
  {
  	SRTISC_RTIACK = 1;
  	signal HplHcs08Rti.fired();
  }
}