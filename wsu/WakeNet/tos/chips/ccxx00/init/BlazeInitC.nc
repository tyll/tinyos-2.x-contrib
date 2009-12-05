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
 * Initialize a CC1100 or CC2500 radio
 * Note we combine both radios' I/O and interrupt lines here, providing
 * them for other modules to access freely.
 * 
 * @author David Moss
 */

configuration BlazeInitC {
  provides {
    interface SplitControl;
    interface BlazeCommit;
    interface PowerNotifier;
  }
  
  uses {
    interface StdControl as RadioBootstrapStdControl;
  }
}

implementation {

  components 
      BlazeInitP,
      BlazeSpiC,
      BlazeCentralWiringC,
      new BlazeSpiResourceC() as InitResourceC,
      new BlazeSpiResourceC() as DeepSleepResourceC;
      
  SplitControl = BlazeInitP;
  BlazeCommit = BlazeInitP;
  PowerNotifier = BlazeInitP;
  RadioBootstrapStdControl = BlazeInitP;

  BlazeInitP.Csn -> BlazeCentralWiringC.Csn;
  BlazeInitP.Gdo0_io -> BlazeCentralWiringC.Gdo0_io;
  BlazeInitP.Gdo2_io -> BlazeCentralWiringC.Gdo2_io;
  BlazeInitP.Gdo0_int -> BlazeCentralWiringC.Gdo0_int;
  BlazeInitP.Gdo2_int -> BlazeCentralWiringC.Gdo2_int;
  BlazeInitP.BlazeRegSettings -> BlazeCentralWiringC.BlazeRegSettings;
  
  BlazeInitP.InitResource -> InitResourceC;
  BlazeInitP.DeepSleepResource -> DeepSleepResourceC;
  
  BlazeInitP.SIDLE -> BlazeSpiC.SIDLE;
  BlazeInitP.SXOFF -> BlazeSpiC.SXOFF;
  BlazeInitP.SFRX -> BlazeSpiC.SFRX;
  BlazeInitP.SFTX -> BlazeSpiC.SFTX;
  BlazeInitP.SRX -> BlazeSpiC.SRX;
  BlazeInitP.SPWD -> BlazeSpiC.SPWD;
  BlazeInitP.RadioStatus -> BlazeSpiC.RadioStatus;
  BlazeInitP.SNOP -> BlazeSpiC.SNOP;
  BlazeInitP.SRES -> BlazeSpiC.SRES;
  
  BlazeInitP.RadioInit -> BlazeSpiC;
  
  BlazeInitP.PaReg -> BlazeSpiC.PA;
  
  components LedsC;
  BlazeInitP.Leds -> LedsC;
  
}

