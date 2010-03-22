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
 * When sending a packet destined for a duty cycling receiver, this module 
 * will send it repetitively for a given amount of time, or until the 
 * receiver acknowledges reception of the packet.  
 * 
 * @author David Moss
 */
 
#include "Lpl.h"
#include "AM.h"
#include "Blaze.h"

module LplP {
  provides {
    interface Send[radio_id_t radioId];
    interface LowPowerListening[radio_id_t radioId];
  }
  
  uses {
    interface Send as SubSend[radio_id_t radioId];
    interface Timer<TMilli> as SendDoneTimer;
    interface PowerCycle[radio_id_t radioId];
    interface BlazePacketBody;
    interface PacketAcknowledgements;
    interface AMPacket;
    interface State as SendState;
    interface Leds;
  }
}

implementation {
  
  /** The current message we're sending */
  message_t *currentMsg;
  
  /** The length of the current message we're sending */
  uint8_t currentLen;
  
  /** The current sleep interval for our timer, to put back in place on sendDone */
  uint16_t currentSleepInterval;
  
  /** The current radio we're sending through */
  radio_id_t currentRadio;
    
  /***************** Prototypes ***************/
  task void send();
  
  uint16_t getActualDutyCycle(uint16_t dutyCycle);
  void sendDone(error_t error);
  
  /***************** LowPowerListening Commands ***************/
  /**
   * Set this this node's radio sleep interval, in milliseconds.
   * Once every interval, the node will sleep and perform an Rx check 
   * on the radio.  Setting the sleep interval to 0 will keep the radio
   * always on.
   *
   * This is the equivalent of setting the local duty cycle rate.
   *
   * @param sleepIntervalMs the length of this node's Rx check interval, in [ms]
   */
  command void LowPowerListening.setLocalSleepInterval[radio_id_t radioId](
      uint16_t sleepIntervalMs) {
    call PowerCycle.setSleepInterval[radioId](sleepIntervalMs);
  }
  
  /**
   * @return the local node's sleep interval, in [ms]
   */
  command uint16_t LowPowerListening.getLocalSleepInterval[radio_id_t radioId]() {
    return call PowerCycle.getSleepInterval[radioId]();
  }
  
  /**
   * Set this node's radio duty cycle rate, in units of [percentage*100].
   * For example, to get a 0.05% duty cycle,
   * <code>
   *   call LowPowerListening.setDutyCycle(5);
   * </code>
   *
   * For a 100% duty cycle (always on),
   * <code>
   *   call LowPowerListening.setDutyCycle(10000);
   * </code>
   *
   * This is the equivalent of setting the local sleep interval explicitly.
   * 
   * @param dutyCycle The duty cycle percentage, in units of [percentage*100]
   */
  command void LowPowerListening.setLocalDutyCycle[radio_id_t radioId](uint16_t dutyCycle) {
    call PowerCycle.setSleepInterval[radioId](
        call LowPowerListening.dutyCycleToSleepInterval[radioId](dutyCycle));
  }
  
  /**
   * @return this node's radio duty cycle rate, in units of [percentage*100]
   */
  command uint16_t LowPowerListening.getLocalDutyCycle[radio_id_t radioId]() {
    return call LowPowerListening.sleepIntervalToDutyCycle[radioId](
        call PowerCycle.getSleepInterval[radioId]());
  }
  
  
  /**
   * Configure this outgoing message so it can be transmitted to a neighbor mote
   * with the specified Rx sleep interval.
   * @param msg Pointer to the message that will be sent
   * @param sleepInterval The receiving node's sleep interval, in [ms]
   */
  command void LowPowerListening.setRxSleepInterval[radio_id_t radioId](message_t *msg, 
      uint16_t sleepIntervalMs) {
    (call BlazePacketBody.getMetadata(msg))->rxInterval = sleepIntervalMs;
  }
  
  /**
   * @return the destination node's sleep interval configured in this message
   */
  command uint16_t LowPowerListening.getRxSleepInterval[radio_id_t radioId](message_t *msg) {
    return (call BlazePacketBody.getMetadata(msg))->rxInterval;
  }
  
  /**
   * Configure this outgoing message so it can be transmitted to a neighbor mote
   * with the specified Rx duty cycle rate.
   * Duty cycle is in units of [percentage*100], i.e. 0.25% duty cycle = 25.
   * 
   * @param msg Pointer to the message that will be sent
   * @param dutyCycle The duty cycle of the receiving mote, in units of 
   *     [percentage*100]
   */
  command void LowPowerListening.setRxDutyCycle[radio_id_t radioId](message_t *msg, 
      uint16_t dutyCycle) {
    (call BlazePacketBody.getMetadata(msg))->rxInterval =
        call LowPowerListening.dutyCycleToSleepInterval[radioId](dutyCycle);
  }
  
    
  /**
   * @return the destination node's duty cycle configured in this message
   *     in units of [percentage*100]
   */
  command uint16_t LowPowerListening.getRxDutyCycle[radio_id_t radioId](message_t *msg) {
    return call LowPowerListening.sleepIntervalToDutyCycle[radioId](
        (call BlazePacketBody.getMetadata(msg))->rxInterval);
  }
  
  /**
   * Convert a duty cycle, in units of [percentage*100], to
   * the sleep interval of the mote in milliseconds
   * @param dutyCycle The duty cycle in units of [percentage*100]
   * @return The equivalent sleep interval, in units of [ms]
   */
  command uint16_t LowPowerListening.dutyCycleToSleepInterval[radio_id_t radioId](
      uint16_t dutyCycle) {
    dutyCycle = getActualDutyCycle(dutyCycle);
    
    if(dutyCycle == 10000) {
      return 0;
    }
    
    return (DUTY_ON_TIME * (10000 - dutyCycle)) / dutyCycle;
  }
  
  /**
   * Convert a sleep interval, in units of [ms], to a duty cycle
   * in units of [percentage*100]
   * @param sleepInterval The sleep interval in units of [ms]
   * @return The duty cycle in units of [percentage*100]
   */
  command uint16_t LowPowerListening.sleepIntervalToDutyCycle[radio_id_t radioId](
      uint16_t sleepInterval) {
    if(sleepInterval == 0) {
      return 10000;
    }
    
    return getActualDutyCycle((DUTY_ON_TIME * 10000) 
        / (sleepInterval + DUTY_ON_TIME));
  }
  
  
  /***************** Send Commands ****************/
  /**
   * Each call to this send command gives the message a single
   * DSN that does not change for every copy of the message
   * sent out.  For messages that are not acknowledged, such as
   * a broadcast address message, the receiving end does not
   * signal receive() more than once for that message.
   */
  command error_t Send.send[radio_id_t radioId](message_t *msg, uint8_t len) {
    if(call SendState.requestState(S_LPL_FIRST_SEND) != SUCCESS) {
      return FAIL;
    }
    
    currentMsg = msg;
    currentLen = len;
    currentRadio = radioId;
    
    // We don't want a long preamble. Get rid of the sleep interval here,
    // and put it back on sendDone().
    if(call LowPowerListening.getRxSleepInterval[radioId](msg) > 0) {
      call PacketAcknowledgements.requestAck(msg);
      
    } else {
      currentSleepInterval = 0;
    }
    
    currentSleepInterval = call LowPowerListening.getRxSleepInterval[radioId](msg);
    call LowPowerListening.setRxSleepInterval[radioId](msg, 0);
    
    post send();
    return SUCCESS;
  }

  command error_t Send.cancel[radio_id_t radioId](message_t *msg) {
    return call SubSend.cancel[radioId](msg);
  }
  
  command uint8_t Send.maxPayloadLength[radio_id_t radioId]() {
    return call SubSend.maxPayloadLength[radioId]();
  }

  command void *Send.getPayload[radio_id_t radioId](message_t* msg, uint8_t len) {
    return call SubSend.getPayload[radioId](msg, len);
  }
  
  /***************** SendDoneTimer ****************/
  event void SendDoneTimer.fired() {
    // Other areas of the system monitor this with isRunning()
  }
  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
    sendDone(error);
  }
  
  /***************** Tasks ******************/
  task void send() {
    error_t error;
    
    if((error = call SubSend.send[currentRadio](currentMsg, currentLen)) != SUCCESS) {
      sendDone(error);
    }
  }
  
  /***************** Functions ***************/  
  /**
   * Check the bounds on a given duty cycle
   * We're never over 100%, and we're never at 0%
   */
  uint16_t getActualDutyCycle(uint16_t dutyCycle) {
    if(dutyCycle > 10000) {
      return 10000;
      
    } else if(dutyCycle == 0) {
      return 1;
    }
    
    return dutyCycle;
  }
  
  /**
   * Send is complete, clean up or keep sending
   */
  void sendDone(error_t error) {
    if(call SendState.isState(S_LPL_FIRST_SEND)) {
      if(currentSleepInterval > 0) {
        call SendState.forceState(S_LPL_SENDING);
        call SendDoneTimer.startOneShot(currentSleepInterval + EXTRA_TRANSMIT_TIME);
      }
    }    
  
    if(error != SUCCESS) {
      call SendDoneTimer.stop();
    }
    
    if(call AMPacket.destination(currentMsg) != AM_BROADCAST_ADDR) {
      if(call PacketAcknowledgements.wasAcked(currentMsg)) {
        call SendDoneTimer.stop();
      }
    }
    
    if(call SendDoneTimer.isRunning()) {
      post send();
      
    } else {
      call LowPowerListening.setRxSleepInterval[currentRadio](currentMsg, currentSleepInterval);
      call SendState.toIdle();
      signal Send.sendDone[currentRadio](currentMsg, error);
    }
  }
}

