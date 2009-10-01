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

#include "AM.h"
#include "TrafficControl.h"
#include "message.h"
#include "RadioStackPacket.h"

/**
 * @author David Moss
 */
 
module TrafficControlP {
  provides {
    interface Send;
    interface TrafficControl;
    interface TrafficPriority[am_id_t amId];
  }
  
  uses {
    interface Send as SubSend;
    interface Timer<TMilli>;
    interface AMPacket;
    interface AckDetails;
    interface PacketAcknowledgements;
    interface Leds;
  }
}

implementation {
  
  bool useHighPriority;
  
  uint8_t state;
  
  uint16_t timeBetweenTransmissions = DEFAULT_TRAFFIC_CONTROL_DELAY;
  
  bool isActive = FALSE;
  
  enum {
    S_IDLE,
    S_QUEUED,
    S_SENDING,
  };
  
  enum {
    LONGER_DELAY = 102U,  // = 80% of the shorter delay
    SHORTER_DELAY = 128U,
  };
  
  
  /***************** TrafficPriority Commands ****************/
  /**
   * This command allows an individual packet to be sent with a high priority
   *
   * @param priority The priority of the packet. 0 = default (low); greater
   *     than 0 is highest priority.
   */
  command void TrafficPriority.setPriority[am_id_t amId](uint8_t priority) {
    useHighPriority = priority;
  }
  
  
  /***************** TrafficControl Commands ****************/
  command void TrafficControl.enable(bool active) {
    isActive = active;
  }
  
  command void TrafficControl.setDelay(uint16_t delay) {
    timeBetweenTransmissions = delay;
  }
  
  command uint16_t TrafficControl.getDelay() {
    return timeBetweenTransmissions;
  }
  
  
  /***************** Send Commands ****************/
  command error_t Send.send(message_t* msg, uint8_t len) {
    if(state != S_IDLE) {
      return EBUSY;
    }
    
    state = S_QUEUED;
    
    if(isActive) {
      useHighPriority = FALSE;
      signal TrafficPriority.requestPriority[call AMPacket.type(msg)](call AMPacket.destination(msg), msg);
    }
    
    if(!isActive || useHighPriority || !(call Timer.isRunning())) {
      // Send the packet now
      state = S_SENDING;
      call Timer.stop();
      if((call SubSend.send(RADIO_STACK_PACKET, 0)) != SUCCESS) {
        state = S_IDLE;
        return FAIL;
      }
    }
    
    // Wait for the timer to fire before sending the message
    return SUCCESS;
  }
  
  command error_t Send.cancel(message_t* msg) {
    state = S_IDLE;
    return call SubSend.cancel(msg);
  }
  
  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }
  
  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }
  
  /***************** SubSend Events ****************/
  event void SubSend.sendDone(message_t *msg, error_t error) {
    state = S_IDLE;
    signal Send.sendDone(msg, error);
    
    // Dynamic throttle adjustment
    // Trying to balance capabilities with memory footprint
    // Another possibility is to see how much traffic is on the channel
    // per second and adjust using those metrics.  See TCP traffic control.
    if(call AckDetails.shouldAck(msg)) {
      if(call PacketAcknowledgements.wasAcked(msg)) {
        timeBetweenTransmissions -= SHORTER_DELAY;

      } else {
        timeBetweenTransmissions += LONGER_DELAY;
      }
      
      if(timeBetweenTransmissions < SHORTEST_TRAFFIC_DELAY
          || timeBetweenTransmissions > LONGEST_TRAFFIC_DELAY) {
          
        // Reset to even out the network
        timeBetweenTransmissions = DEFAULT_TRAFFIC_CONTROL_DELAY;
      }
    }
    
    call Timer.startOneShot(timeBetweenTransmissions);
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    if(state == S_QUEUED) {
      state = S_SENDING;
      if((call SubSend.send(RADIO_STACK_PACKET, 0)) != SUCCESS) {
        state = S_IDLE;
        signal Send.sendDone(RADIO_STACK_PACKET, FAIL);
      }
    }
  }
  
  /***************** Defaults ****************/
  default event void TrafficPriority.requestPriority[am_id_t amId](am_addr_t addr, message_t *msg) { }
}
