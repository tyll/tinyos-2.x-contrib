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
 * Responsible for putting all radios into power down mode during PlatformInit.
 * Simply reference this component from the ActiveMessageC configuration,
 * and it will do its job.
 * @author David Moss
 */
 
configuration Ccxx00PlatformInitC {
  uses {
    interface Init as RadioPlatformInit;
  }
}

implementation {
  components RealMainP,
      Ccxx00PlatformInitP,
      BlazeSpiC,
      HplRadioSpiC,
      BlazeCentralWiringC;
      
  RadioPlatformInit = Ccxx00PlatformInitP.RadioPlatformInit;
  
  RealMainP.PlatformInit -> Ccxx00PlatformInitP.PlatformInit;
    
  Ccxx00PlatformInitP.Resource -> HplRadioSpiC;
  Ccxx00PlatformInitP.SIDLE -> BlazeSpiC.SIDLE;
  Ccxx00PlatformInitP.SPWD -> BlazeSpiC.SPWD;
  Ccxx00PlatformInitP.SRES -> BlazeSpiC.SRES;
  
  Ccxx00PlatformInitP.Csn -> BlazeCentralWiringC.Csn;
  Ccxx00PlatformInitP.ChipRdy -> BlazeCentralWiringC.Gdo2_io;
  Ccxx00PlatformInitP.Gdo0 -> BlazeCentralWiringC.Gdo0_io;
  
}

