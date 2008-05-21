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

module Hcs08TimerCommonP
{
  provides interface Hcs08TimerEvent as TPM1Overflow;
  provides interface Hcs08TimerEvent as TPM1CH0;
  provides interface Hcs08TimerEvent as TPM1CH1;
  provides interface Hcs08TimerEvent as TPM1CH2;
  
  provides interface Hcs08TimerEvent as TPM2Overflow;
  provides interface Hcs08TimerEvent as TPM2CH0;
  provides interface Hcs08TimerEvent as TPM2CH1;
  provides interface Hcs08TimerEvent as TPM2CH2;
  provides interface Hcs08TimerEvent as TPM2CH3;
  provides interface Hcs08TimerEvent as TPM2CH4;
}
implementation
{
  TOSH_SIGNAL(TPM1OVF) { signal TPM1Overflow.fired(); }
  TOSH_SIGNAL(TPM1CH0) { signal TPM1CH0.fired(); }
  TOSH_SIGNAL(TPM1CH1) { signal TPM1CH1.fired(); }
  TOSH_SIGNAL(TPM1CH2) { signal TPM1CH2.fired(); }
  
  TOSH_SIGNAL(TPM2OVF) { signal TPM2Overflow.fired(); }
  TOSH_SIGNAL(TPM2CH0) { signal TPM2CH0.fired(); }
  TOSH_SIGNAL(TPM2CH1) { signal TPM2CH1.fired(); }
  TOSH_SIGNAL(TPM2CH2) { signal TPM2CH2.fired(); }
  TOSH_SIGNAL(TPM2CH3) { signal TPM2CH3.fired(); }
  TOSH_SIGNAL(TPM2CH4) { signal TPM2CH4.fired(); }
  
  default async event void TPM1Overflow.fired() {TPM1SC_TOF = 0;}
  default async event void TPM1CH0.fired() {}
  default async event void TPM1CH1.fired() {}
  default async event void TPM1CH2.fired() {}
  
  default async event void TPM2Overflow.fired() {TPM2SC_TOF = 0;}
  default async event void TPM2CH0.fired() {}
  default async event void TPM2CH1.fired() {}
  default async event void TPM2CH2.fired() {}
  default async event void TPM2CH3.fired() {}
  default async event void TPM2CH4.fired() {}
  
}

