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

module Hcs08UartInterruptsP
{
  provides interface Hcs08UartEvent as SCI1TX;
  provides interface Hcs08UartEvent as SCI1RX;
  provides interface Hcs08UartEvent as SCI1ERR;
  provides interface Hcs08UartEvent as SCI2TX;
  provides interface Hcs08UartEvent as SCI2RX;
  provides interface Hcs08UartEvent as SCI2ERR;
}
implementation
{
  TOSH_SIGNAL(SCI1TX) { signal SCI1TX.fired(); }
  TOSH_SIGNAL(SCI1RX) { signal SCI1RX.fired(); }
  TOSH_SIGNAL(SCI1ERR) { signal SCI1ERR.fired(); }
  TOSH_SIGNAL(SCI2TX) { signal SCI2TX.fired(); }
  TOSH_SIGNAL(SCI2RX) { signal SCI2RX.fired(); }
  TOSH_SIGNAL(SCI2ERR) { signal SCI2ERR.fired(); }
  
  default async event void SCI1TX.fired() {}
  default async event void SCI1RX.fired() {}
  default async event void SCI1ERR.fired() {}
  default async event void SCI2TX.fired() {}
  default async event void SCI2RX.fired() {}
  default async event void SCI2ERR.fired() {}
}