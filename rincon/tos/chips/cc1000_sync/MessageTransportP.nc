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
 * Reliable Message Transport Functionality
 * @author David Moss
 * @author Jon Wyant
 */
 
#include "CC1000Msg.h"

module MessageTransportP {
  provides {
    interface Send;
    interface MessageTransport;
  }
  
  uses {
    interface Send as SubSend;
    interface State as SendState;
    interface PacketAcknowledgements;
    interface Timer<TMilli> as DelayTimer;
    interface AMPacket;
  }
}

implementation {
  
  /** The message currently being sent */
  message_t *currentSendMsg;
  
  /** Length of the current send message */
  uint8_t currentSendLen;
  
  /** The length of the current send message */
  uint16_t totalRetries;
  
  
  /**
   * Send States
   */
  enum {
    S_IDLE,
    S_SENDING,
  };
  
  
  /***************** Prototypes ***************/
  task void send();
  cc1000_metadata_t *getMetadata(message_t* msg);
  void signalDone(error_t error);
    
  /***************** MessageTransport Commands ***************/
  /**
   * Set the maximum number of times attempt message delivery
   * Default is 0
   * @param msg
   * @param maxRetries the maximum number of attempts to deliver
   *     the message
   */
  command void MessageTransport.setRetries(message_t *msg, uint16_t maxRetries) {
    getMetadata(msg)->maxRetries = maxRetries;
  }

  /**
   * Set a delay between each retry attempt
   * @param msg
   * @param retryDelay the delay betweeen retry attempts, in milliseconds
   */
  command void MessageTransport.setRetryDelay(message_t *msg, uint16_t retryDelay) {
    getMetadata(msg)->retryDelay = retryDelay;
  }

  /** 
   * @return the maximum number of retry attempts for this message
   */
  command uint16_t MessageTransport.getRetries(message_t *msg) {
    return getMetadata(msg)->maxRetries;
  }

  /**
   * @return the delay between retry attempts in ms for this message
   */
  command uint16_t MessageTransport.getRetryDelay(message_t *msg) {
    return getMetadata(msg)->retryDelay;
  }

  /**
   * @return TRUE if the message was delivered.
   *     This should always be TRUE if the message was sent to the
   *     AM_BROADCAST_ADDR
   */
  command bool MessageTransport.wasDelivered(message_t *msg) {
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
    if(call SendState.requestState(S_SENDING) == SUCCESS) {
      if(call AMPacket.destination(msg) != AM_BROADCAST_ADDR &&
          call MessageTransport.getRetries(msg) > 0) {
        call PacketAcknowledgements.requestAck(msg);
      }
      
      currentSendMsg = msg;
      currentSendLen = len;
      totalRetries = 0;
      
      if((error = call SubSend.send(msg, len)) != SUCCESS) {
        call SendState.toIdle();
      }
      
      return error;
    }
    
    return EBUSY;
  }

  command error_t Send.cancel(message_t *msg) {
    if(currentSendMsg == msg) {
      signalDone(SUCCESS);
      return SUCCESS;
    }
    
    return FAIL;
  }
  
  
  command uint8_t Send.maxPayloadLength() {
    return call SubSend.maxPayloadLength();
  }

  command void *Send.getPayload(message_t* msg) {
    return call SubSend.getPayload(msg);
  }
  
  
  /***************** SubSend Events ***************/
  event void SubSend.sendDone(message_t* msg, error_t error) {
    if(call SendState.getState() == S_SENDING) {
      totalRetries++;
      if(call PacketAcknowledgements.wasAcked(msg)) {
        signalDone(SUCCESS);
        
      } else if(call AMPacket.destination(currentSendMsg) != AM_BROADCAST_ADDR
          && totalRetries < call MessageTransport.getRetries(currentSendMsg)) {
        
        if(call MessageTransport.getRetryDelay(currentSendMsg) > 0) {
          // Resend after some delay
          call DelayTimer.startOneShot(call MessageTransport.getRetryDelay(currentSendMsg));
          return;
          
        } else {
          // Resend immediately
          post send();
          return;
        }
      }
    }
    
    signalDone(error);
  }
  
  
  /***************** Timer Events ****************/  
  /**
   * When this timer is running, that means we're sending repeating messages
   * to a node that is receive check duty cycling.
   */
  event void DelayTimer.fired() {
    if(call SendState.getState() == S_SENDING) {
      post send();
    }
  }
  
  /***************** Tasks ***************/
  task void send() {
    if(call AMPacket.destination(currentSendMsg) != AM_BROADCAST_ADDR &&
        call MessageTransport.getRetries(currentSendMsg) > 0) {
      call PacketAcknowledgements.requestAck(currentSendMsg);
    }
    
    if(call SubSend.send(currentSendMsg, currentSendLen) != SUCCESS) {
      post send();
    }
  }
  
  /***************** Functions ***************/  
  cc1000_metadata_t *getMetadata(message_t* msg) {
    return (cc1000_metadata_t*) msg->metadata;
  }
  
  void signalDone(error_t error) {
    call DelayTimer.stop();
    signal Send.sendDone(currentSendMsg, error);
    // Block calls until sendDone gets back:
    call SendState.toIdle();
  }
}

