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
 * @author David Moss
 */
 
module AvailableRadiosP {
  provides {
    interface AvailableRadios;
    interface Init as RadioPlatformInit;
  }
  
  uses {
    interface BlazeRegister as PARTNUM;
    interface BlazeRegister as VERSION;
  }
}

implementation {

  
  enum {
    CC1100_PARTNUM = 0x0,
    CC1100_VERSION = 0x3,
    
    CC1101_PARTNUM = 0x0,
    CC1101_VERSION = 0x4,
    
    CC2500_PARTNUM = 0x80,
    CC2500_VERSION = 0x3,
  };
  
  uint8_t radioPartnums[uniqueCount(UQ_BLAZE_RADIO)];
  
  uint8_t radioVersions[uniqueCount(UQ_BLAZE_RADIO)];
  
  /***************** RadioPlatformInit Commands ****************/
  command error_t RadioPlatformInit.init() {
    int id;
    for(id = 0; id < uniqueCount(UQ_BLAZE_RADIO); id++) {
      if(radioVersions[id] == 0) {
        break;
      }
    }
    
    // id contains the radio id that we are now filling in details for.
    call PARTNUM.read(&radioPartnums[id]);
    call VERSION.read(&radioVersions[id]);
    return SUCCESS;
  }
  
  /***************** AvailableRadios Commands ****************/
  command bool AvailableRadios.isCc1100(uint8_t radioId) {
    return (radioPartnums[radioId] == CC1100_PARTNUM 
        && radioVersions[radioId] == CC1100_VERSION); 
  }
  
  command bool AvailableRadios.isCc1101(uint8_t radioId) {
    return (radioPartnums[radioId] == CC1101_PARTNUM 
        && radioVersions[radioId] == CC1101_VERSION); 
  }
  
  command bool AvailableRadios.isCc2500(uint8_t radioId) {
    return (radioPartnums[radioId] == CC2500_PARTNUM 
        && radioVersions[radioId] == CC2500_VERSION); 
  }
  
  
}
