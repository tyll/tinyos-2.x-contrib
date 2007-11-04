/*
* Copyright (c) 2007 University of Iowa 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of The University of Iowa  nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Timesync suite of interfaces, components, testing tools, and documents.
 * @author Ted Herman
 * Development supported in part by NSF award 0519907. 
 */
//--EOCpr712 (do not remove this line, which terminates copyright include)

configuration TnbrhoodC {
  provides interface Tnbrhood;
  provides interface Neighbor[uint8_t type];
  }
implementation {
  components NoLedsC, LedsC, OTimeC, WakkerC, PowConC;
  components TnbrhoodP, TsyncC;
  components new PowCommC(AM_NEIGHBOR) as Comm;
  components RandomLfsrC;  // for testing only
  Tnbrhood = TnbrhoodP;
  Neighbor = TnbrhoodP;
  #ifdef TRACK
  TnbrhoodP.AMSend -> Comm;
  TnbrhoodP.Receive -> Comm;
  TnbrhoodP.PowCon -> PowConC.PowCon[unique("PowCon")];
  #endif
  TnbrhoodP.OTime -> OTimeC;
  TnbrhoodP.Leds -> LedsC;
  TnbrhoodP.Wakker -> WakkerC.Wakker[unique("Wakker")];
  TnbrhoodP.Random -> RandomLfsrC;
  TnbrhoodP.Boot -> TsyncC.componentBoot;
  }
