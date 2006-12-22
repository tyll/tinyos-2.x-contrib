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
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Automatically generated header file for BFileWrite
 */
 
#include "BFileWrite.h"

module Link_BFileWriteP {
  uses {
    interface BFileWrite;
    
    interface AMSend as SerialReplySend;
    interface AMSend as SerialEventSend;
    interface Receive as SerialReceive;
    interface Packet as SerialPacket;
    interface AMPacket as SerialAMPacket;
    
    /** No radio
    interface AMSend as RadioReplySend;
    interface AMSend as RadioEventSend;
    interface Receive as RadioReceive;
    interface Packet as RadioPacket;
    interface AMPacket as RadioAMPacket;
    interface MessageTransport;
    */
  }
}

implementation {

  /** Message to reply with return values */
  message_t replyMsg;
  
  /** Message to signal events */
  message_t eventMsg;
  
  /** TRUE if we are to reply to serial, FALSE to radio */
  bool sendSerial;
  
  /** Destination address to reply to */
  am_addr_t destination;
  
  
  /***************** Prototypes *****************/
  void execute(BFileWriteMsg *inMsg, BFileWriteMsg *replyPayload);
  task void sendEventMsg();
  task void sendReplyMsg();
  
  /***************** Receive Events ****************/
  
  event message_t *SerialReceive.receive(message_t *msg, void *payload, uint8_t len) {
    sendSerial = TRUE;
    destination = call SerialAMPacket.source(msg);
    execute(payload, call SerialPacket.getPayload(&replyMsg, NULL));
    return msg;
  }
  
  
  /** No radio
  event message_t *RadioReceive.receive(message_t *msg, void *payload, uint8_t len) {
    sendSerial = FALSE;
    destination = call RadioAMPacket.source(msg);
    execute(payload, call RadioPacket.getPayload(&replyMsg, NULL));
    return msg;
  }
  */
  
  /***************** Send Events ****************/
  
  event void SerialReplySend.sendDone(message_t *msg, error_t error) {
  }
  
  event void SerialEventSend.sendDone(message_t *msg, error_t error) {
  }
  
  
  /** No radio
  event void RadioReplySend.sendDone(message_t *msg, error_t error) {
  }
  
  event void RadioEventSend.sendDone(message_t *msg, error_t error) {
  }
  */
  
  /***************** BFileWrite Events ****************/
  event void BFileWrite.opened(uint32_t len, error_t error) {
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BFILEWRITE_EVENT_OPENED;
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->long0 = len;
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    post sendEventMsg();
  }

  event void BFileWrite.closed(error_t error) {
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BFILEWRITE_EVENT_CLOSED;
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    post sendEventMsg();
  }

  event void BFileWrite.saved(error_t error) {
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BFILEWRITE_EVENT_SAVED;
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    post sendEventMsg();
  }

  event void BFileWrite.appended(void *data, uint16_t amountWritten, error_t error) {
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BFILEWRITE_EVENT_APPENDED;
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->int0 = amountWritten;
    ((BFileWriteMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    post sendEventMsg();
  }


  
  /***************** Tasks ****************/
  task void sendReplyMsg() {
    if(sendSerial) {
      
      if(call SerialReplySend.send(destination, &replyMsg, sizeof(BFileWriteMsg)) != SUCCESS) {
        post sendReplyMsg();
      }
      
      
    } else {
      /** No radio
      call MessageTransport.setRetries(&replyMsg, 10);
      call MessageTransport.setRetryDelay(&replyMsg, 0);
      if(call RadioReplySend.send(destination, &replyMsg, sizeof(BFileWriteMsg)) != SUCCESS) {
        post sendReplyMsg();
      }
      */
    }
  }
  
  task void sendEventMsg() {
    if(sendSerial) {
      
      if(call SerialEventSend.send(destination, &eventMsg, sizeof(BFileWriteMsg)) != SUCCESS) {
        post sendEventMsg();
      }
      
      
    } else {
      /** No radio
      call MessageTransport.setRetries(&eventMsg, 10);
      call MessageTransport.setRetryDelay(&eventMsg, 0);
      if(call RadioReplySend.send(destination, &eventMsg, sizeof(BFileWriteMsg)) != SUCCESS) {
        post sendEventMsg();
      }
      */
    }
  }
      
  /***************** Functions ****************/
  void execute(BFileWriteMsg *inMsg, BFileWriteMsg *replyPayload) {
    memset(replyPayload, 0, sizeof(BFileWriteMsg));
    switch(inMsg->short0) {
      case BFILEWRITE_CMD_OPEN:
        replyPayload->short0 = BFILEWRITE_REPLY_OPEN;
        replyPayload->short1 = call BFileWrite.open((char *) inMsg->byteArray, inMsg->long0);
        post sendReplyMsg();
        break;

      case BFILEWRITE_CMD_ISOPEN:
        replyPayload->short0 = BFILEWRITE_REPLY_ISOPEN;
        replyPayload->bool0 = call BFileWrite.isOpen();
        post sendReplyMsg();
        break;

      case BFILEWRITE_CMD_CLOSE:
        replyPayload->short0 = BFILEWRITE_REPLY_CLOSE;
        replyPayload->short1 = call BFileWrite.close();
        post sendReplyMsg();
        break;

      case BFILEWRITE_CMD_SAVE:
        replyPayload->short0 = BFILEWRITE_REPLY_SAVE;
        replyPayload->short1 = call BFileWrite.save();
        post sendReplyMsg();
        break;

      case BFILEWRITE_CMD_APPEND:
        replyPayload->short0 = BFILEWRITE_REPLY_APPEND;
        replyPayload->short1 = call BFileWrite.append(inMsg->byteArray, inMsg->int0);
        post sendReplyMsg();
        break;

      case BFILEWRITE_CMD_GETREMAINING:
        replyPayload->short0 = BFILEWRITE_REPLY_GETREMAINING;
        replyPayload->long0 = call BFileWrite.getRemaining();
        post sendReplyMsg();
        break;

      default:
    }


  }
}
