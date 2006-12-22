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
 * Automatically generated header file for BDictionary
 */
 
#include "Link_BDictionary.h"

module Link_BDictionaryP {
  uses {
    interface BDictionary;
    
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
  void execute(BDictionaryMsg *inMsg, BDictionaryMsg *replyPayload);
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
  
  /***************** BDictionary Events ****************/
  event void BDictionary.opened(uint32_t totalSize, uint32_t remainingBytes, error_t error) {
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BDICTIONARY_EVENT_OPENED;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->long0 = totalSize;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->long1 = remainingBytes;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    post sendEventMsg();
  }  
  
  event void BDictionary.closed(error_t error) {
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BDICTIONARY_EVENT_CLOSED;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    post sendEventMsg();
  }  
  
  event void BDictionary.inserted(uint32_t key, void *value, uint16_t valueSize, error_t error) {
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BDICTIONARY_EVENT_INSERTED;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->long0 = key;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->int0 = valueSize;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    memset(((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->byteArray, 0, BDICTIONARY_BYTE_ARRAY_LENGTH);
    memcpy(((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->byteArray, value, valueSize);    
    post sendEventMsg();
  }  
  
  event void BDictionary.retrieved(uint32_t key, void *valueHolder, uint16_t valueSize, error_t error) {
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BDICTIONARY_EVENT_RETRIEVED;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->long0 = key;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->int0 = valueSize;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    // Retrieve value already set by the command
    post sendEventMsg();
  }  
  
  event void BDictionary.removed(uint32_t key, error_t error) {
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BDICTIONARY_EVENT_REMOVED;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->long0 = key;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    post sendEventMsg();
  }  
  
  event void BDictionary.nextKey(uint32_t nextKey, error_t error) {
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BDICTIONARY_EVENT_NEXTKEY;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->long0 = nextKey;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    post sendEventMsg();
  }  
  
  event void BDictionary.fileIsDictionary(bool isDictionary, error_t error) {
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BDICTIONARY_EVENT_FILEISDICTIONARY;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->bool0 = isDictionary;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    post sendEventMsg();
  }  
  
  event void BDictionary.totalKeys(uint16_t totalKeys) {
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = BDICTIONARY_EVENT_TOTALKEYS;
    ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->int0 = totalKeys;
    post sendEventMsg();
  }
  
  /***************** Tasks ****************/
  task void sendReplyMsg() {
    if(sendSerial) {
      
      if(call SerialReplySend.send(destination, &replyMsg, sizeof(BDictionaryMsg)) != SUCCESS) {
        post sendReplyMsg();
      }
      
      
    } else {
      /** No radio
      call MessageTransport.setRetries(&replyMsg, 10);
      call MessageTransport.setRetryDelay(&replyMsg, 0);
      if(call RadioReplySend.send(destination, &replyMsg, sizeof(BDictionaryMsg)) != SUCCESS) {
        post sendReplyMsg();
      }
      */
    }
  }
  
  task void sendEventMsg() {
    if(sendSerial) {
      
      if(call SerialEventSend.send(destination, &eventMsg, sizeof(BDictionaryMsg)) != SUCCESS) {
        post sendEventMsg();
      }
      
      
    } else {
      /** No radio
      call MessageTransport.setRetries(&eventMsg, 10);
      call MessageTransport.setRetryDelay(&eventMsg, 0);
      if(call RadioReplySend.send(destination, &eventMsg, sizeof(BDictionaryMsg)) != SUCCESS) {
        post sendEventMsg();
      }
      */
    }
  }
      
  /***************** Functions ****************/
  void execute(BDictionaryMsg *inMsg, BDictionaryMsg *replyPayload) {
    memset(replyPayload, 0, sizeof(BDictionaryMsg));
    switch(inMsg->short0) {
      case BDICTIONARY_CMD_OPEN:
        replyPayload->short0 = BDICTIONARY_REPLY_OPEN;
        replyPayload->short1 = call BDictionary.open((char *) inMsg->byteArray, inMsg->long0);
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_ISOPEN:
        replyPayload->short0 = BDICTIONARY_REPLY_ISOPEN;
        replyPayload->bool0 = call BDictionary.isOpen();
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_CLOSE:
        replyPayload->short0 = BDICTIONARY_REPLY_CLOSE;
        replyPayload->short1 = call BDictionary.close();
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_GETFILELENGTH:
        replyPayload->short0 = BDICTIONARY_REPLY_GETFILELENGTH;
        replyPayload->long0 = call BDictionary.getFileLength();
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_GETTOTALKEYS:
        replyPayload->short0 = BDICTIONARY_REPLY_GETTOTALKEYS;
        replyPayload->short1 = call BDictionary.getTotalKeys();
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_INSERT:
        replyPayload->short0 = BDICTIONARY_REPLY_INSERT;
        replyPayload->short1 = call BDictionary.insert(inMsg->long0, inMsg->byteArray, inMsg->int0);
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_RETRIEVE:
        replyPayload->short0 = BDICTIONARY_REPLY_RETRIEVE;
        memset(((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->byteArray, 0, BDICTIONARY_BYTE_ARRAY_LENGTH);
        replyPayload->short1 = call BDictionary.retrieve(inMsg->long0, ((BDictionaryMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->byteArray, BDICTIONARY_BYTE_ARRAY_LENGTH);
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_REMOVE:
        replyPayload->short0 = BDICTIONARY_REPLY_REMOVE;
        replyPayload->short1 = call BDictionary.remove(inMsg->long0);
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_GETFIRSTKEY:
        replyPayload->short0 = BDICTIONARY_REPLY_GETFIRSTKEY;
        replyPayload->short1 = call BDictionary.getFirstKey();
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_GETLASTKEY:
        replyPayload->short0 = BDICTIONARY_REPLY_GETLASTKEY;
        replyPayload->long0 = call BDictionary.getLastKey();
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_GETNEXTKEY:
        replyPayload->short0 = BDICTIONARY_REPLY_GETNEXTKEY;
        replyPayload->short1 = call BDictionary.getNextKey(inMsg->long0);
        post sendReplyMsg();
        break;

      case BDICTIONARY_CMD_ISFILEDICTIONARY:
        replyPayload->short0 = BDICTIONARY_REPLY_ISFILEDICTIONARY;
        replyPayload->short1 = call BDictionary.isFileDictionary((char *) inMsg->byteArray);
        post sendReplyMsg();
        break;

      default:
    }


  }
}
