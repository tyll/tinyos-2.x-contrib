/*
* Copyright (c) 2006 Stanford University.
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
* - Neither the name of the Stanford University nor the names of
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
 * @brief Driver module for the OmniVision OV7649 Camera
 * @author
 *		Andrew Barton-Sweeney (abs@cs.yale.edu)
 *		Evan Park (evanpark@gmail.com)
 */
/**
 * @brief Ported to TOS2
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 
 /** 
 * Implements a "reliable" sccb protocol.  Every sccb write is followed by a
 * read to ensure the value was actually written.  If not, the layer will
 * retry a specified number of times.
 */

configuration HplSCCBReliableC
{
  provides {
    interface HplSCCB[uint8_t id];
  }
}
implementation {
  components HplSCCBReliableM, HplSCCBC, NoLedsC as LedsC;

  // Interface wiring
  HplSCCB   = HplSCCBReliableM; 

  HplSCCBReliableM.Leds -> LedsC;
  // Component wiring
  HplSCCBReliableM.actualHplSCCB -> HplSCCBC.HplSCCB[0x42]; //OVWRITE
}
