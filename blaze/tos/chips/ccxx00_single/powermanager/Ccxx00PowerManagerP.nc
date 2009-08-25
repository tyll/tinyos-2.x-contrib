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
    interface Init;
    interface SplitControl;
  }
  
  uses {
    interface SplitControl as CsmaSplitControl;
    interface SplitControl as ReceiveSplitControl;
    interface SplitControl as InitSplitControl;
    
    interface Leds;
  }
}

implementation {
  
  /** State of this component in powering the radios on or off */
  uint8_t myState;
  
  /**
   * Define the order in which components get turned on
   */
  enum {
    S_START_BEGIN,
    
    S_START_RECEIVE,
    S_START_INIT,
    
    S_START_END,
    
    
    /** Define the order in which components get turned off */
    S_STOP_BEGIN,
    
    S_STOP_CSMA,
    S_STOP_RECEIVE,
    S_STOP_INIT,
    
    S_STOP_END,
  };
  
  /***************** Prototypes ****************/
  void startRadios();
  void stopRadios();

  /***************** Init Commands ****************/
  command error_t Init.init() {
    myState = S_STOP_END;
    return SUCCESS;
  }
  
  /***************** SplitControl Commands ****************/  
  command error_t SplitControl.start() {
    // if myState == S_STOP_END continue on.
    if(myState < S_STOP_BEGIN) {
      return EALREADY;
      
    } else if(myState < S_STOP_END) {
      return EBUSY;
    }
    
    myState = S_START_BEGIN;
    startRadios();
    return SUCCESS;
  }
  
  command error_t SplitControl.stop() {
    // if myState == S_START_END continue on.
    if(myState < S_START_END) {
      return EBUSY;
      
    } else if(myState > S_START_END) {
      return EALREADY;
    }
    
    myState = S_STOP_BEGIN;
    stopRadios();
    return SUCCESS;
  }
  
  
  /***************** CsmaSplitControl Events ****************/
  event void CsmaSplitControl.startDone(error_t error) {
    startRadios();
  }
    
  event void CsmaSplitControl.stopDone(error_t error) {
    stopRadios();
  }
  
  /***************** ReceiveSplitControl Events ****************/
  event void ReceiveSplitControl.startDone(error_t error) {
    startRadios();
  }
    
  event void ReceiveSplitControl.stopDone(error_t error) {
    stopRadios();
  }
  
  /***************** InitSplitControl Events ****************/  
  event void InitSplitControl.startDone(error_t error) {
    startRadios();
  }
    
  event void InitSplitControl.stopDone(error_t error) {
    stopRadios();
  }

  /***************** Tasks ****************/  
  void startRadios() {
    myState++;
    switch(myState) {      
      case S_START_RECEIVE:
        call ReceiveSplitControl.start();
        break;
        
      case S_START_INIT:
        call InitSplitControl.start();
        break;
        
      case S_START_END:
        signal SplitControl.startDone(SUCCESS);
        break;
        
      default:
        break;
    }
  }
  
  void stopRadios() {
    myState++;
    switch(myState) {
      case S_STOP_CSMA:
        call CsmaSplitControl.stop();
        break;
        
      case S_STOP_RECEIVE:
        call ReceiveSplitControl.stop();
        break;
        
      case S_STOP_INIT:
        call InitSplitControl.stop();
        break;
        
      case S_STOP_END:
        signal SplitControl.stopDone(SUCCESS);
        break;
        
      default:
        break;
    }
  }

}
