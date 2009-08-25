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
 
#include "Blaze.h"

module LplP {
  provides {
    interface LowPowerListening;
    interface SystemLowPowerListening;
    interface Send;
    interface Receive;
    interface SplitControl;
  }
  
  uses {
    interface AckReceive;
    interface Send as SubSend;
    interface Receive as SubReceive;
    interface SplitControl as SubControl;
    interface BlazePacket;
    interface BlazePacketBody;
    interface Timer<TMilli>;
    interface Leds;
  }
}

implementation {
  
  /*
   * This is for compatibility with other duty cycling receivers
   */
  enum {
    STATIC_WAKEUP_INCREASE = 5,
  };
  
  /** TRUE if this layer is sending a message */
  bool sending;
  
  /** TRUE if the radio is on */
  bool on;
  
  /** TRUE if SplitControl is on */
  bool splitControlOn;
  
  /** TRUE if the radio should turn off when it can by default */
  bool savePower;
  
  
  /***************** Send Commands ****************/
  command error_t Send.send(message_t *msg, uint8_t len) {
    sending = TRUE;

#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led2On();
#endif
    
    
    if(!on) {
      call SubControl.start();
      
    } else {
      call SubSend.send(RADIO_STACK_PACKET, 0);
    }
    
    return SUCCESS;
  }
  
  command error_t Send.cancel(message_t *msg) {
    return FAIL;
  }
  
  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }
  
  /***************** AckReceive Events ****************/
  async event void AckReceive.receive( blaze_ack_t *ackMsg ) {
    if(call BlazePacket.isPacketPending((message_t *) ackMsg)) {
    
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led1On();
#endif

      call Timer.startOneShot(5120);
    }
  }
  
  /***************** Send Events ****************/
  event void SubSend.sendDone(message_t *msg, error_t error) {

#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led2Off();
#endif
  
    signal Send.sendDone(msg, error);
    
    /*
     * The AckReceive event would have indicated if the packet pending bit
     * is set, and started the Timer before this sendDone event fires.
     */
    if(!call Timer.isRunning()) {
      call SubControl.stop();
    }
  }
  
  /***************** SubReceive Events ****************/
  event message_t *SubReceive.receive(message_t *msg, void *payload, uint8_t len) {
  
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led0Toggle();
#endif

    if(call BlazePacket.isPacketPending(msg)) {

#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led1On();
#endif

      call Timer.startOneShot(5120);
    }
    
    signal Receive.receive(msg, payload, len);
    return msg;
  }
  
  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start() {
    splitControlOn = TRUE;
    if(!savePower) {
      call SubControl.start();
    }
    
    signal SplitControl.startDone(SUCCESS);
    
    return SUCCESS;
  }
  
  command error_t SplitControl.stop() {
    splitControlOn = FALSE;
    signal SplitControl.stopDone(SUCCESS);
    return SUCCESS;
  }
  
  /***************** SubControl Events ****************/
  event void SubControl.startDone(error_t error) {
    on = TRUE;
    
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led3On();
#endif

    if(sending) {
      if(call SubSend.send(RADIO_STACK_PACKET, 0) != SUCCESS) {
        signal Send.sendDone(RADIO_STACK_PACKET, FAIL);
        call SubControl.stop();
      }
    }
  }
  
  event void SubControl.stopDone(error_t error) {
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led3Off();
#endif

    on = FALSE;
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
#if BLAZE_ENABLE_LPL_LEDS
    call Leds.led1Off();
#endif

    if(!sending) {
      call SubControl.stop();
    }
  }
  
  /***************** SystemLowPowerListening Commands ***************/
  command void SystemLowPowerListening.setDefaultRemoteWakeupInterval(uint16_t intervalMs) {
  }
  
  command void SystemLowPowerListening.setDelayAfterReceive(uint16_t intervalMs) {
  }

  command uint16_t SystemLowPowerListening.getDefaultRemoteWakeupInterval() {
    return 0;
  }
  
  command uint16_t SystemLowPowerListening.getDelayAfterReceive() {
    return 0;
  }
  
  /***************** LowPowerListening Commands ***************/
  command void LowPowerListening.setLocalWakeupInterval(
      uint16_t sleepIntervalMs) {
    
    savePower = (sleepIntervalMs > 0);
    
    if(savePower && !sending) {
      call SubControl.stop();
      
    } else if(!savePower && splitControlOn) {
      call Timer.stop();
      call SubControl.start();
    }
  }
  
  command uint16_t LowPowerListening.getLocalWakeupInterval() {
    return savePower;
  }
  
  command void LowPowerListening.setRemoteWakeupInterval(message_t *msg, 
      uint16_t sleepIntervalMs) {
    if(sleepIntervalMs > 0) {
      (call BlazePacketBody.getMetadata(msg))->rxInterval = sleepIntervalMs + STATIC_WAKEUP_INCREASE;
    }
  }
  
  command uint16_t LowPowerListening.getRemoteWakeupInterval(message_t *msg) {
    uint16_t currentRxInterval = (call BlazePacketBody.getMetadata(msg))->rxInterval;
    
    if(currentRxInterval > 0) {
      return currentRxInterval - STATIC_WAKEUP_INCREASE;
    }
    
    return 0;
  }
  
  
}
