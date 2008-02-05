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
 * This turns the radio stack on and off in the right order
 * @author David Moss
 */

#include "Blaze.h"

module Ccxx00PowerManagerP {
  provides {
    interface SplitControl[radio_id_t radioId];
  }
  
  uses {
    interface SplitControl as CsmaSplitControl[radio_id_t radioId];
    interface SplitControl as ReceiveSplitControl[radio_id_t radioId];
    interface SplitControl as InitSplitControl[radio_id_t radioId];
  }
}

implementation {

  /** Focused radio id to turn on or off */
  radio_id_t focusedRadio;
  
  /** State of this component in powering the radios on or off */
  uint8_t myState;
  
  /**
   * This enum defines the order in which components get turned on and off.
   */
  enum {
    S_BEGIN,
    
    S_CSMA,
    S_RECEIVE,
    S_INIT,
    
    S_END,
  };
  
  /***************** Prototypes ****************/
  task void startRadios();
  task void stopRadios();

  /***************** SplitControl Commands ****************/  
  command error_t SplitControl.start[radio_id_t radioId]() {
    focusedRadio = radioId;
    myState = S_BEGIN;
    post startRadios();
    return SUCCESS;
  }
  
  command error_t SplitControl.stop[radio_id_t radioId]() {
    focusedRadio = radioId;
    myState = S_BEGIN;
    post stopRadios();
    return SUCCESS;
  }
  
  
  /***************** CsmaSplitControl Events ****************/
  event void CsmaSplitControl.startDone[radio_id_t radioId](error_t error) {
    post startRadios();
  }
    
  event void CsmaSplitControl.stopDone[radio_id_t radioId](error_t error) {
    post stopRadios();
  }
  
  /***************** ReceiveSplitControl Events ****************/
  event void ReceiveSplitControl.startDone[radio_id_t radioId](error_t error) {
    post startRadios();
  }
    
  event void ReceiveSplitControl.stopDone[radio_id_t radioId](error_t error) {
    post stopRadios();
  }
  
  /***************** InitSplitControl Events ****************/  
  event void InitSplitControl.startDone[radio_id_t radioId](error_t error) {
    post startRadios();
  }
    
  event void InitSplitControl.stopDone[radio_id_t radioId](error_t error) {
    post stopRadios();
  }


  /***************** Tasks ****************/  
  task void startRadios() {
    myState++;
    switch(myState) {
      case S_CSMA:
        call CsmaSplitControl.start[focusedRadio]();
        break;
        
      case S_RECEIVE:
        call ReceiveSplitControl.start[focusedRadio]();
        break;
        
      case S_INIT:
        call InitSplitControl.start[focusedRadio]();
        break;
        
      case S_END:
        signal SplitControl.startDone[focusedRadio](SUCCESS);
        break;
        
      default:
        break;
    }
  }
  
  task void stopRadios() {
    myState++;
    switch(myState) {
      case S_CSMA:
        call CsmaSplitControl.stop[focusedRadio]();
        break;
        
      case S_RECEIVE:
        call ReceiveSplitControl.stop[focusedRadio]();
        break;
        
      case S_INIT:
        call InitSplitControl.stop[focusedRadio]();
        break;
        
      case S_END:
        signal SplitControl.stopDone[focusedRadio](SUCCESS);
        break;
        
      default:
        break;
    }
  }

}
