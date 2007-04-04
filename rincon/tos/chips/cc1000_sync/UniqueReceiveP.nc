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
 * This layer keeps a history of the past RECEIVE_HISTORY_SIZE received messages
 * If the source address and dsn number of a newly received message matches
 * our recent history, we drop the message because we've already seen it.
 * @author David Moss
 */
 
#include "CC1000Msg.h"
#include "UniqueReceive.h"

module UniqueReceiveP {
  provides {
    interface Receive;
    interface Init;
  }
  
  uses {
    interface Receive as SubReceive;
  }
}

implementation {
  
  struct {
    am_addr_t source;
    uint8_t dsn;
  } receivedMessages[RECEIVE_HISTORY_SIZE];
  
  uint8_t writeIndex = 0;
  
  /***************** Init Commands *****************/
  command error_t Init.init() {
    int i;
    for(i = 0; i < RECEIVE_HISTORY_SIZE; i++) {
      receivedMessages[i].source = (am_addr_t) 0xFFFF;
      receivedMessages[i].dsn = 0;
    }
    return SUCCESS;
  }
  
  /***************** Prototypes Commands ***************/
  cc1000_header_t *getHeader(message_t *msg);
  bool hasSeen(message_t *msg);
  void insert(message_t *msg);
  
  /***************** Receive Commands ***************/
  command void *Receive.getPayload(message_t* msg, uint8_t* len) {
    return call SubReceive.getPayload(msg, len);
  }

  command uint8_t Receive.payloadLength(message_t* msg) {
    return call SubReceive.payloadLength(msg);
  }
  
  /***************** SubReceive Events *****************/
  event message_t *SubReceive.receive(message_t* msg, void* payload, 
      uint8_t len) {

    if(hasSeen(msg)) {
      return msg;
      
    } else {
      insert(msg);
      return signal Receive.receive(msg, payload, len);
    }
  }
  
  /****************** Functions ****************/
  cc1000_header_t *getHeader(message_t *msg) {
    return (cc1000_header_t *)(msg->data - sizeof( cc1000_header_t ));
  }
  
  bool hasSeen(message_t *msg) {
    int i;
    for(i = 0; i < RECEIVE_HISTORY_SIZE; i++) {
      if(receivedMessages[i].source == getHeader(msg)->source
          && receivedMessages[i].dsn == getHeader(msg)->dsn) {
        return TRUE;
      }
    }
    return FALSE;
  }
  
  void insert(message_t *msg) {
    receivedMessages[writeIndex].source = getHeader(msg)->source;
    receivedMessages[writeIndex].dsn = getHeader(msg)->dsn;
    writeIndex++;
    writeIndex %= RECEIVE_HISTORY_SIZE;
  }
}

