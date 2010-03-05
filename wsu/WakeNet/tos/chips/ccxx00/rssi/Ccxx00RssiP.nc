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
 
module Ccxx00RssiP {
  provides {
    interface Read<int8_t>[radio_id_t radioId];
  }
  
  uses {
    interface BlazeRegister as RSSI;
    interface BlazeRegister as PKTSTATUS;
    interface GeneralIO as Csn[radio_id_t radioId];
    interface Resource;
    interface SplitControlManager[radio_id_t radioId];
  }
}

implementation {

  uint8_t currentClient;
  
  /***************** Prototypes ****************/
  void readRssi();
  
  /***************** Read Commands ****************/
  command error_t Read.read[radio_id_t radioId]() {
    if(!call SplitControlManager.isOn[radioId]()) {
      return EOFF;
    }
    
    currentClient = radioId;
    
    if(call Resource.immediateRequest() == SUCCESS) {
      readRssi();
      return SUCCESS;
    }
  
    return call Resource.request();
  }
  
  /****************** Resource events ****************/
  event void Resource.granted() {
    readRssi();
  }

  /****************** SplitControlManager Events ****************/
  event void SplitControlManager.stateChange[radio_id_t radioId]() {
  }
  
  /****************** Functions ****************/
  void readRssi() {
    int8_t rssi;
    uint8_t pktstatus;
    uint16_t timeout = 0;
    
    call Csn.clr[currentClient]();
    
    // Verify RSSI is valid:
    do {
      call PKTSTATUS.read(&pktstatus);
      timeout++;
    } while(!(pktstatus & 0x50) && (timeout < 0xFFF));
    
    call RSSI.read(&rssi);
    call Csn.set[currentClient]();
    call Resource.release();
    
    signal Read.readDone[currentClient](SUCCESS, rssi);
  }
  
  
  /****************** Defaults ****************/
  default event void Read.readDone[radio_id_t radioId]( error_t result, int8_t val ) {}
  
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  
}
