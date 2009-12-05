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
 * Reliable Packet Link Functionality
 * @author David Moss
 * @author Jon Wyant
 */
 
#include "Blaze.h"
#include "RadioStackPacket.h"

module PacketLinkP {
  provides {
    interface Send;
    interface PacketLink;
  }
  
  uses {
    interface Send as SubSend;
    interface PacketAcknowledgements;
    interface Timer<TMilli> as DelayTimer;
    interface AMPacket;
    interface BlazePacketBody;
  }
}

implementation {
  
  /** The length of the current send message */
  uint16_t totalRetries;
  
  /** State of this component */
  uint8_t state;
  
  /**
   * Send States
   */
  enum {
    S_IDLE,
    S_SENDING,
  };
  
  
  /***************** Prototypes ***************/
  void signalDone(error_t error);
    
  /***************** PacketLink Commands ***************/
  /**
   * Set the maximum number of times attempt message delivery
   * Default is 0
   * @param msg
   * @param maxRetries the maximum number of attempts to deliver
   *     the message
   */
  command void PacketLink.setRetries(message_t *msg, uint8_t maxRetries) {
    (call BlazePacketBody.getMetadata(msg))->maxRetries = maxRetries;
  }

  /**
   * Set a delay between each retry attempt
   * @param msg
   * @param retryDelay the delay betweeen retry attempts, in bms
   */
  command void PacketLink.setRetryDelay(message_t *msg, uint16_t retryDelay) {
    (call BlazePacketBody.getMetadata(msg))->retryDelay = retryDelay;
  }

  /** 
   * @return the maximum number of retry attempts for this message
   */
  command uint8_t PacketLink.getRetries(message_t *msg) {
    return (call BlazePacketBody.getMetadata(msg))->maxRetries;
  }

  /**
   * @return the delay between retry attempts in sec for this message
   */
  command uint16_t PacketLink.getRetryDelay(message_t *msg) {
    return (call BlazePacketBody.getMetadata(msg))->retryDelay;
  }

  /**
   * @return TRUE if the message was delivered.
   */
  command bool PacketLink.wasDelivered(message_t *msg) {
    return call PacketAcknowledgements.wasAcked(msg);
  }
  
  /***************** Send Commands ***************/
  /**
   * Each call to this send command gives the message a single
   * DSN that does not change for every copy of the message
   * sent out.  For messages that are not acknowledged, such as
   * a broadcast address message, the receiving end does not
   * signal receive() more than once for that message.
   */
  command error_t Send.send(message_t *msg, uint8_t len) {
    error_t error;
    if(state != S_IDLE) {
      return FAIL;
    }
    
    state = S_SENDING;
    
    totalRetries = 0;

    if(call PacketLink.getRetries(msg) > 0) {
      call PacketAcknowledgements.requestAck(msg);
    }
     
    if((error = call SubSend.send(msg, len)) != SUCCESS) {
      state = S_IDLE;
    }
    
    return error;
  }

  command error_t Send.cancel(message_t *msg) {
    state = S_IDLE;
    return SUCCESS;
  }
  
  
  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }
  
  
  /***************** SubSend Events ***************/
  event void SubSend.sendDone(message_t* msg, error_t error) {
    if(state == S_SENDING) {
      totalRetries++;
      if(call PacketAcknowledgements.wasAcked(msg)) {
        signalDone(SUCCESS);
        return;
        
      } else if(totalRetries < call PacketLink.getRetries(RADIO_STACK_PACKET)) {
        call DelayTimer.startOneShot((call PacketLink.getRetryDelay(RADIO_STACK_PACKET)) + 1);
        return;
      }
      // else fall through.
      
    }
    
    signalDone(error);
  }
  
  
  /***************** Timer Events ****************/  
  /**
   * When this timer is running, that means we're sending repeating messages
   * to a node that is receive check duty cycling.
   */
  event void DelayTimer.fired() {
    call SubSend.send(RADIO_STACK_PACKET, 0);
  }
  
  
  /***************** Functions ***************/  
  void signalDone(error_t error) {
    call DelayTimer.stop();
    state = S_IDLE;
    signal Send.sendDone(RADIO_STACK_PACKET, error);
  }
}

