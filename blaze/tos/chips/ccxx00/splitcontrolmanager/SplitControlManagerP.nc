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

module SplitControlManagerP {
  provides {
    interface SplitControl[radio_id_t radioId];
    interface Send[radio_id_t radioId];
    interface SplitControlManager[radio_id_t radioId];
  }
  
  uses {
    interface SplitControl as SubControl[radio_id_t radioId];
    interface Send as SubSend[radio_id_t radioId];
    interface Leds;
  }
}

implementation {

  /** State of all the radios compiled into our system */
  uint8_t radioState[uniqueCount(UQ_BLAZE_RADIO)];

  /** The radio we're currently servicing */
  uint8_t focusedRadio = 0xFF;
  
  enum {
    NO_FOCUSED_RADIO = 0xFF,
  };
  
  
  /***************** SplitControl Commands ****************/
  /**
   * All radios must be off in order to start up one of the radios
   */
  command error_t SplitControl.start[radio_id_t radioId]() {
    if(radioId > uniqueCount(UQ_BLAZE_RADIO)) {
      return EINVAL;
    }
    
    if(radioState[radioId] == CCXX00_ON) {
      return EALREADY;
    } else if(radioState[radioId] == CCXX00_TURNING_ON) {
      return SUCCESS;
    } else if(radioState[radioId] == CCXX00_TURNING_OFF) {
      return EBUSY;
    }
    
    if(focusedRadio != NO_FOCUSED_RADIO) {
      // Won't let you turn 2 radios on simultaneously
      return FAIL;
    }
    
    focusedRadio = radioId;
    radioState[focusedRadio] = CCXX00_TURNING_ON;
    
    signal SplitControlManager.stateChange[focusedRadio]();
    return call SubControl.start[radioId]();
  }
  
  /**
   * The radio must be on in order to turn it off.
   */
  command error_t SplitControl.stop[radio_id_t radioId]() {
    if(radioId > uniqueCount(UQ_BLAZE_RADIO)) {
      return EINVAL;
    }
    
    if(radioState[radioId] == CCXX00_OFF) {
      return EALREADY;
    } else if(radioState[radioId] == CCXX00_TURNING_ON) {
      return EBUSY;
    } else if(radioState[radioId] == CCXX00_TURNING_OFF) {
      return SUCCESS;
    }
    
    if(focusedRadio != radioId) {
      // You can only turn off the radio that is currently on
      // focusedRadio gets set back to NO_FOCUSED_RADIO on stopDone()
      return FAIL;
    }
   
    radioState[focusedRadio] = CCXX00_TURNING_OFF;
    
    signal SplitControlManager.stateChange[focusedRadio]();
    return call SubControl.stop[radioId]();
  }
  

  /***************** Send Commands ****************/
  command error_t Send.send[radio_id_t radioId](message_t* msg, uint8_t len) {
    if(radioState[radioId] != CCXX00_ON) {
      return EOFF;
    } else {
      return call SubSend.send[radioId](msg, len);
    }
  }

  command error_t Send.cancel[radio_id_t radioId](message_t* msg) {
    if(radioState[radioId] != CCXX00_ON) {
      return EOFF;
    } else {
      return call SubSend.cancel[radioId](msg);
    }
  }
  
  command uint8_t Send.maxPayloadLength[radio_id_t radioId]() {
    return call SubSend.maxPayloadLength[radioId]();
  }

  command void* Send.getPayload[radio_id_t radioId](message_t* msg, uint8_t len) {
    return call SubSend.getPayload[radioId](msg, len);
  }
  
  /***************** SplitControlManager Commands ****************/
  /**
   * @return TRUE if the radio is currently enabled
   */
  command bool SplitControlManager.isOn[radio_id_t radioId]() {
    return (radioState[radioId] == CCXX00_ON);
  }
  
  /**
   * @return the state of the radio
   */
  command radio_state_t SplitControlManager.getState[radio_id_t radioId]() {
    return radioState[radioId];
  }
  

  /***************** SubControl Events ****************/
  event void SubControl.startDone[radio_id_t radioId](error_t error) {
    radioState[radioId] = CCXX00_ON;
    signal SplitControl.startDone[radioId](error);
  }
  
  event void SubControl.stopDone[radio_id_t radioId](error_t error) {
    radioState[radioId] = CCXX00_OFF;
    focusedRadio = NO_FOCUSED_RADIO;
    signal SplitControl.stopDone[radioId](error);
  }
  

  /***************** SubSend Events ****************/
  event void SubSend.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
    signal Send.sendDone[radioId](msg, error);
  }
  
  
  /***************** Defaults ****************/
  
  default event void SplitControl.startDone[radio_id_t radioId](error_t error) {
  }
  
  default event void SplitControl.stopDone[radio_id_t radioId](error_t error) {
  }
  
  default event void SplitControlManager.stateChange[radio_id_t radioId]() {
  }

  default event void Send.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
  }
  
}

