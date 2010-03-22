/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/** 
 * This is sort of the hardware implementation layer of Wake-on-Radio
 * @author David Moss
 */

#include "Blaze.h"
#include "Wor.h"

configuration WorC {
  provides {
    interface Wor[radio_id_t radioId];
  }
}

implementation {
  components MainC,
    WorP,
    new BlazeSpiResourceC(),
    BlazeSpiC, 
    BlazeCentralWiringC;
  
  MainC.SoftwareInit -> WorP;
  
  Wor = WorP;
  
  WorP.Resource -> BlazeSpiResourceC;
  WorP.MCSM2 -> BlazeSpiC.MCSM2;
  WorP.WOREVT1 -> BlazeSpiC.WOREVT1;
  WorP.WOREVT0 -> BlazeSpiC.WOREVT0;
  WorP.WORCTRL -> BlazeSpiC.WORCTRL;
  WorP.SWOR -> BlazeSpiC.SWOR;
  WorP.SIDLE -> BlazeSpiC.SIDLE;
  WorP.SRX -> BlazeSpiC.SRX;
  WorP.SFRX -> BlazeSpiC.SFRX;
  WorP.SFTX -> BlazeSpiC.SFTX;
  WorP.RadioStatus -> BlazeSpiC;
  WorP.ChipRdy -> BlazeCentralWiringC.Gdo2_io;
  WorP.Csn -> BlazeCentralWiringC.Csn;
  WorP.RxInterrupt -> BlazeCentralWiringC.Gdo0_int;
  
  components LedsC;
  WorP.Leds -> LedsC;
  
  components new TimerMilliC() as KickTimerC;
  WorP.KickTimer -> KickTimerC;

	//added by Gang
	WorP.PKTSTATUS -> BlazeSpiC.PKTSTATUS;
  
}

