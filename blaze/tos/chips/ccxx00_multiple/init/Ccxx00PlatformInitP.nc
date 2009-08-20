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

#include "Blaze.h"

/**
 * @author David Moss
 */
 
module Ccxx00PlatformInitP {
  provides {
    interface Init as PlatformInit;
  }
  
  uses {
    interface CentralWiring;
    
    interface Init as RadioPlatformInit;
    
    interface Resource;
    interface BlazeStrobe as SIDLE;
    interface BlazeStrobe as SPWD;
    interface BlazeStrobe as SRES;
    
    interface GeneralIO as Csn;
    interface GeneralIO as ChipRdy;
    interface GeneralIO as Gdo0;
  }
}

implementation {
  
  /**
   * Reset the radio
   */
  void reset() {
    call Csn.set();
    call Csn.clr();
    call SRES.strobe();
    call Csn.set();
  }
  
  /***************** PlatformInit Commands ****************/
  command error_t PlatformInit.init() {
    uint16_t timeout;
    int i;
    
    call Resource.immediateRequest();
    
    for(i = 0; i < uniqueCount(UQ_BLAZE_RADIO); i++) {
      call CentralWiring.switchTo(i);
      
      call ChipRdy.makeInput();
      call Gdo0.makeInput();
      call Csn.makeOutput();
      call Csn.clr();
      
      // First, wait for the chip to be ready to use.
      timeout = 0;
      while(call ChipRdy.get()) {
        timeout++;
        if(timeout > 10000) {
          // Many times the ChipRdy line never drops low, causing our platform
          // init to lock up completely. As usual, reset and pray.
          reset();
          continue;
        }
      }
      
      // Second, do another reset. Yes, this is mandatory.
      reset();
      call Csn.clr();
      while(call ChipRdy.get());
            
      // Finally, put the radio to sleep.
      call Csn.clr();
      
      // Bootstrap any other radio things while CSN is low.
      call RadioPlatformInit.init();
      
      call SIDLE.strobe();
      call SPWD.strobe();
      call Csn.set();
    }
    
    call Resource.release();
    return SUCCESS;
  }
  
  /***************** Resource Events ****************/
  event void Resource.granted() {
  }
  
  /***************** Defaults ****************/
  default command error_t RadioPlatformInit.init() {
    return SUCCESS;
  }
}

