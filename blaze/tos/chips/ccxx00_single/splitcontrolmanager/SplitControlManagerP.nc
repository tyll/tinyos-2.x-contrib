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
 * See the documentation in SplitControlManagerC.nc
 * @author David Moss
 */

#include "SplitControlManager.h"
#include "Blaze.h"
#include "RadioStackPacket.h"

module SplitControlManagerP {
  provides {
    interface SplitControl;
    interface Send;
    interface SplitControlManager;
  }
  
  uses {
    interface SplitControl as SubControl;
    interface Send as SubSend;
    interface Leds;
  }
}

implementation {

  /** State of all the radios compiled into our system */
  uint8_t radioState;
  
  /** TRUE if we're waiting for the radio to turn on before we send */
  bool delayedSend;
  
  /***************** SplitControl Commands ****************/
  /**
   * All radios must be off in order to start up one of the radios
   */
  command error_t SplitControl.start() {
    if(radioState != CCXX00_OFF) {
      return EALREADY;
    }
    
    radioState = CCXX00_TURNING_ON;
    
    signal SplitControlManager.stateChange();
    return call SubControl.start();
  }
  
  /**
   * The radio must be on in order to turn it off.
   */
  command error_t SplitControl.stop() {
    if(radioState != CCXX00_ON) {
      return EALREADY;
    }
    
    radioState = CCXX00_TURNING_OFF;
    
    signal SplitControlManager.stateChange();
    return call SubControl.stop();
  }
  

  /***************** Send Commands ****************/
  command error_t Send.send(message_t* msg, uint8_t len) {
    if(radioState != CCXX00_ON) {
      return call SplitControl.start();
      
    } else {
      return call SubSend.send(msg, len);
    }
  }

  command error_t Send.cancel(message_t* msg) {
    return FAIL;
  }
  
  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }

  command void* Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }
  
  /***************** SplitControlManager Commands ****************/
  /**
   * @return TRUE if the radio is currently enabled
   */
  command bool SplitControlManager.isOn() {
    return (radioState == CCXX00_ON);
  }
  
  /**
   * @return the state of the radio
   */
  command radio_state_t SplitControlManager.getState() {
    return radioState;
  }
  

  /***************** SubControl Events ****************/
  event void SubControl.startDone(error_t error) {
    radioState = CCXX00_ON;
    signal SplitControl.startDone(error);
    
    if(delayedSend) {
      delayedSend = FALSE;
      if(call SubSend.send(RADIO_STACK_PACKET, 0) != SUCCESS) {
        signal Send.sendDone(RADIO_STACK_PACKET, FAIL);
      }
    }
  }
  
  event void SubControl.stopDone(error_t error) {
    radioState = CCXX00_OFF;
    signal SplitControl.stopDone(error);
  }
  

  /***************** SubSend Events ****************/
  event void SubSend.sendDone(message_t *msg, error_t error) {
    delayedSend = FALSE;
    signal Send.sendDone(msg, error);
  }
  
  
  /***************** Defaults ****************/
  
}

