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

#include "Lpl.h"
#include "Wor.h"

module LplP {
  provides {
    interface SplitControl[radio_id_t radioId];
    interface LowPowerListening[radio_id_t radioId];
    interface Send[radio_id_t radioId];
    
  }
  
  uses {
    interface Send as SubSend[radio_id_t radioId];
    interface Wor[radio_id_t radioId];
    interface State;
    interface SplitControlManager[radio_id_t radioId];
    interface BlazePacketBody;
    interface RxNotify[radio_id_t radioId];
    interface State as ReceiveState;
    interface Leds;
  }
}

implementation {
  
  /** TRUE if WoR is enabled on a system level, regardless of radio power */
  bool worSystemEnabled[uniqueCount(UQ_BLAZE_RADIO)];
  
  /** Current radio we're dealing with */
  radio_id_t focusedRadio;
  
  /** Message just sent */
  message_t *focusedMsg;
  
  /** Temporary variable used for length and error code on send and sendDone */
  uint8_t temp;
  
  /**
   * States
   */
  enum {
    S_IDLE,
    S_SPLITCONTROL_STOP,
    S_SPLITCONTROL_START,
    S_SENDING,
    S_SENDDONE,
    S_RXDONE,
    S_CONFIGURING,
  };
  
  enum {
    /** The amount of extra time to send a wake-up transmission, in bms */
    EXTRA_TRANSMIT_TIME = 3,
  };
  
    
  /***************** Prototypes ****************/
  uint16_t convertMsToBms(uint16_t ms);
  uint16_t convertBmsToMs(uint16_t bms);
  
  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start[radio_id_t radioId]() {
    call State.forceState(S_SPLITCONTROL_START);
    
    if(worSystemEnabled[radioId]) {
      call Wor.enableWor[radioId](TRUE);
      // continues at Wor.stateChanged()...
      
    } else {
      call State.toIdle();
      signal SplitControl.startDone[radioId](SUCCESS);
    }
    
    return SUCCESS;
  }
  
  command error_t SplitControl.stop[radio_id_t radioId]() {
    call State.forceState(S_SPLITCONTROL_STOP);
    
    if(worSystemEnabled[radioId]) {
      call Wor.enableWor[radioId](FALSE);
      return SUCCESS;
      // continues at Wor.stateChanged()...
      
    } else {
      call State.toIdle();
      signal SplitControl.stopDone[radioId](SUCCESS);
    }
    
    return SUCCESS;
  }
  
  
  /***************** Send Commands ****************/
  command error_t Send.send[radio_id_t radioId](message_t* msg, uint8_t len) {

    if(call State.requestState(S_SENDING) != SUCCESS) {
      return EBUSY;
    }
    
    if(worSystemEnabled[radioId] 
        && call Wor.isEnabled[radioId]()
          && call ReceiveState.isIdle()) {
      focusedMsg = msg;
      temp = len;
      call Wor.enableWor[radioId](FALSE);
      return SUCCESS;
      // continues at stateChange()...
      
    } else {
      return call SubSend.send[radioId](msg, len);
    }
  }

  command error_t Send.cancel[radio_id_t radioId](message_t* msg) {
    return call SubSend.cancel[radioId](msg);
  }

  command uint8_t Send.maxPayloadLength[radio_id_t radioId]() {
    return call SubSend.maxPayloadLength[radioId]();
  }

  command void* Send.getPayload[radio_id_t radioId](message_t* msg, uint8_t len) { 
    return call SubSend.getPayload[radioId](msg, len);
  }
  
  /***************** LowPowerListening Commands ****************/
  /** 
   * Use true milliseconds!
   */
  command void LowPowerListening.setLocalSleepInterval[radio_id_t radioId](uint16_t sleepIntervalMs) {  
    call Wor.calculateAndSetEvent0[radioId](sleepIntervalMs);
    if(sleepIntervalMs == 0) {
      // Disable WoR if it is currently active.
      worSystemEnabled[radioId] = FALSE;
      
      if(call Wor.isEnabled[radioId]()) {
        if(call State.requestState(S_CONFIGURING) != SUCCESS) {
          return;
        }
        
        call Wor.enableWor[radioId](FALSE);
      }
     
    } else {
      worSystemEnabled[radioId] = TRUE;
      if(call SplitControlManager.isOn[radioId]()) {
        if(call State.requestState(S_CONFIGURING) != SUCCESS) {
          return;
        }
        
        call Wor.synchronizeSettings[radioId]();
      }
    }
  }
  
  command uint16_t LowPowerListening.getLocalSleepInterval[radio_id_t radioId]() {
    return call Wor.getEvent0Ms[radioId]();
  }
  
  /**
   * Use true milliseconds!
   */
  command void LowPowerListening.setRxSleepInterval[radio_id_t radioId](message_t *msg, uint16_t sleepIntervalMs) {
    (call BlazePacketBody.getMetadata(msg))->rxInterval = 
        convertMsToBms(sleepIntervalMs) + EXTRA_TRANSMIT_TIME;
  }
  
  
  /**
   * @return true milliseconds
   */
  command uint16_t LowPowerListening.getRxSleepInterval[radio_id_t radioId](message_t *msg) {
    return convertMsToBms((call BlazePacketBody.getMetadata(msg))->rxInterval);
  }
  
  
  
  command void LowPowerListening.setLocalDutyCycle[radio_id_t radioId](uint16_t dutyCycle) {
    // Not supported!
  }
  
  command uint16_t LowPowerListening.getLocalDutyCycle[radio_id_t radioId]() {
    // Not supported!
    return 10000;
  }
  
  command void LowPowerListening.setRxDutyCycle[radio_id_t radioId](message_t *msg, uint16_t dutyCycle) {
    // Not supported!
  }
  
  command uint16_t LowPowerListening.getRxDutyCycle[radio_id_t radioId](message_t *msg) {
    // Not supported!
    return 10000;
  }
  
  command uint16_t LowPowerListening.dutyCycleToSleepInterval[radio_id_t radioId](uint16_t dutyCycle) {
    // Not supported!
    return 10000;
  }
  
  command uint16_t LowPowerListening.sleepIntervalToDutyCycle[radio_id_t radioId](uint16_t sleepInterval) {
    // Not supported!
    return 10000;
  }
  
  /***************** RxNotify Events ****************/
  event void RxNotify.doneReceiving[radio_id_t radioId]() {
    if(call SplitControlManager.isOn[radioId]() 
       && worSystemEnabled[radioId]
         && call State.isIdle()) {
      call State.forceState(S_RXDONE);
      call Wor.enableWor[radioId](TRUE);
      // Continues at stateChange()..
    }
  }

  /***************** SubSend Events ****************/
  event void SubSend.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
    if(call SplitControlManager.isOn[radioId]() 
        && worSystemEnabled[radioId]
            && call ReceiveState.isIdle()) {
            
      call State.forceState(S_SENDDONE);
      focusedMsg = msg;
      temp = error;
      
      call Wor.enableWor[radioId](TRUE);
      // Continues at stateChange()...
      
    } else {
      call State.toIdle();
      signal Send.sendDone[radioId](msg, error);
    }
  }
  
  
  /***************** Wor Events ****************/
  event void Wor.stateChange[radio_id_t radioId](bool enabled) {
    uint8_t lastState = call State.getState();
    call State.toIdle();
        
    switch(lastState) {
    case S_SPLITCONTROL_STOP:
      signal SplitControl.stopDone[radioId](SUCCESS);
      break;
    
    case S_SPLITCONTROL_START:
      signal SplitControl.startDone[radioId](SUCCESS);
      break;
    
    case S_SENDING:
      call SubSend.send[radioId](focusedMsg, temp);
      break;
      
    case S_SENDDONE:
      signal Send.sendDone[radioId](focusedMsg, temp);
      break;
      
    case S_RXDONE:
      // do nothing
      break;
      
    default:
      break;
    }
    
  }
  
  /***************** SplitControlManager Events ****************/
  event void SplitControlManager.stateChange[radio_id_t radioId]() {
  }
  
  /***************** Tasks and Functions ****************/
  uint16_t convertMsToBms(uint16_t ms) {
    return (((uint32_t) ms) * ((uint32_t) 1024)) / 1000;
  }
  
  uint16_t convertBmsToMs(uint16_t bms) {
    return (((uint32_t) bms) * ((uint32_t) 1000)) / 1024;
  }
  
  
  /***************** Defaults ****************/
  default event void SplitControl.startDone[radio_id_t radioId](error_t error) {
  }
  
  default event void SplitControl.stopDone[radio_id_t radioId](error_t error) {
  }
  
  default event void Send.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
  }

}

