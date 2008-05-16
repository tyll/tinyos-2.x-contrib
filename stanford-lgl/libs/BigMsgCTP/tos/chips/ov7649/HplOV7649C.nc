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
 //#include "OV7649.h"
configuration HplOV7649C
{
  provides interface HplOV7649;
  provides interface HplOV7649Advanced;
}
implementation {
  components HplOV7649M, LedsC, HplSCCBC, GeneralIOC;

  // Interface wiring
  HplOV7649	= HplOV7649M; 
  HplOV7649Advanced	= HplOV7649M; 

  // Component wiring
  HplOV7649M.Leds -> LedsC.Leds;
  HplOV7649M.Sccb_OVWRITE -> HplSCCBC.HplSCCB[0x42];//OVWRITE

  HplOV7649M.RESET -> GeneralIOC.GeneralIO[83];	//A40-5 
  HplOV7649M.PWDN -> GeneralIOC.GeneralIO[82];	//A40-1 
  HplOV7649M.LED -> GeneralIOC.GeneralIO[106];	//A40-29 

  HplOV7649M.SIOD -> GeneralIOC.GeneralIO[56];	//A40-3 
  HplOV7649M.SIOC -> GeneralIOC.GeneralIO[57];	//A40-4 

}
