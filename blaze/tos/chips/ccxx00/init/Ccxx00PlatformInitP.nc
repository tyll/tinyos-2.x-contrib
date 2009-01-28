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
    interface Resource;
    interface BlazeStrobe as SIDLE;
    interface BlazeStrobe as SPWD;
    interface BlazeStrobe as SRES;
    
    interface GeneralIO as Csn[radio_id_t radioId];
    interface GeneralIO as ChipRdy[radio_id_t radioId];
    interface GeneralIO as Gdo0[radio_id_t radioId];
    
    interface Leds;
    interface Init as LedsInit;
  }
}

implementation {

  /***************** PlatformInit Commands ****************/
  command error_t PlatformInit.init() {
    error_t error;
    int i;
    uint32_t timeout;
    
    call LedsInit.init();
    
    if((error = call Resource.immediateRequest()) != SUCCESS) {
      return error;
    }
    
    for(i = 0; i < uniqueCount(UQ_BLAZE_RADIO); i++) {
      call ChipRdy.makeInput[i]();
      call Gdo0.makeInput[i]();
      call Csn.set[i]();
      call Csn.makeOutput[i]();
    }
    
    for(i = 0; i < uniqueCount(UQ_BLAZE_RADIO); i++) {
      timeout = 0;
      call Csn.clr[i]();
      
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(9);
#endif

      // First, wait for the chip to be ready to use.
      while(call ChipRdy.get[i]()) {
        timeout++;
        if(timeout > 10000) {
          // Many times the ChipRdy line never drops low, causing our platform
          // init to lock up completely. As usual, reset and pray.
          call Csn.set[i]();
          call Csn.clr[i]();
          call SRES.strobe();
          call Csn.set[i]();
          i--;
          continue;
        }
      }
      
      // Second, do another reset. Yes, this is mandatory.
      call Csn.set[i]();
      call Csn.clr[i]();
      call SRES.strobe();
      call Csn.set[i]();
      call Csn.clr[i]();
      while(call ChipRdy.get[i]());
      
#if BLAZE_ENABLE_WHILE_LOOP_LEDS
      call Leds.set(0);
#endif
      
      // Finally, put the radio to sleep.
      call Csn.clr[i]();
      call SIDLE.strobe();
      call SPWD.strobe();
      call Csn.set[i]();
    }
    
    call Resource.release();
    return SUCCESS;
  }
  
  /***************** Resource Events ****************/
  event void Resource.granted() {
  }
  
  /***************** Defaults ****************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
  default async command void ChipRdy.set[ radio_id_t id ](){}
  default async command void ChipRdy.clr[ radio_id_t id ](){}
  default async command void ChipRdy.toggle[ radio_id_t id ](){}
  default async command bool ChipRdy.get[ radio_id_t id ](){return FALSE;}
  default async command void ChipRdy.makeInput[ radio_id_t id ](){}
  default async command bool ChipRdy.isInput[ radio_id_t id ](){return FALSE;}
  default async command void ChipRdy.makeOutput[ radio_id_t id ](){}
  default async command bool ChipRdy.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command void Gdo0.set[ radio_id_t id ](){}
  default async command void Gdo0.clr[ radio_id_t id ](){}
  default async command void Gdo0.toggle[ radio_id_t id ](){}
  default async command bool Gdo0.get[ radio_id_t id ](){return FALSE;}
  default async command void Gdo0.makeInput[ radio_id_t id ](){}
  default async command bool Gdo0.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Gdo0.makeOutput[ radio_id_t id ](){}
  default async command bool Gdo0.isOutput[ radio_id_t id ](){return FALSE;}
  
}

