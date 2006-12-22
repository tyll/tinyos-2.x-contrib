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
 * Automatically generated header file for BFileDir
 */
 
#include "BFileDir.h"
#include "BlackbookConst.h"

module Link_BFileDirP {
  uses {
    interface BFileDir;
    
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
  void execute(BFileDirMsg *inMsg, BFileDirMsg *replyPayload);
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
  
  /***************** BFileDir Events ****************/
  event void BFileDir.corruptionCheckDone(char *fileName, bool isCorrupt, error_t error) {
    ((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = EVENT_CORRUPTIONCHECKDONE;
    ((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->bool0 = isCorrupt;
    ((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    memset(((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->fileName, 0, FILENAME_LENGTH);
    memcpy(((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->fileName, fileName, FILENAME_LENGTH);
    post sendEventMsg();
  }  
  
  event void BFileDir.existsCheckDone(char *fileName, bool doesExist, error_t error) {
    ((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = EVENT_EXISTSCHECKDONE;
    ((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->bool0 = doesExist;
    ((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    memset(((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->fileName, 0, FILENAME_LENGTH);
    memcpy(((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->fileName, fileName, FILENAME_LENGTH);
    post sendEventMsg();
  }  
  
  event void BFileDir.nextFile(char *fileName, error_t error) {
    ((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short0 = EVENT_NEXTFILE;
    ((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->short1 = error;
    memset(((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->fileName, 0, FILENAME_LENGTH);
    memcpy(((BFileDirMsg *) call SerialPacket.getPayload(&eventMsg, NULL))->fileName, fileName, FILENAME_LENGTH);
    post sendEventMsg();
  }
  
  /***************** Tasks ****************/
  task void sendReplyMsg() {
    if(sendSerial) {
      
      if(call SerialReplySend.send(destination, &replyMsg, sizeof(BFileDirMsg)) != SUCCESS) {
        post sendReplyMsg();
      }
      
      
    } else {
      /** No radio
      call MessageTransport.setRetries(&replyMsg, 10);
      call MessageTransport.setRetryDelay(&replyMsg, 0);
      if(call RadioReplySend.send(destination, &replyMsg, sizeof(BFileDirMsg)) != SUCCESS) {
        post sendReplyMsg();
      }
      */
    }
  }
  
  task void sendEventMsg() {
    if(sendSerial) {
      
      if(call SerialEventSend.send(destination, &eventMsg, sizeof(BFileDirMsg)) != SUCCESS) {
        post sendEventMsg();
      }
      
      
    } else {
      /** No radio
      call MessageTransport.setRetries(&eventMsg, 10);
      call MessageTransport.setRetryDelay(&eventMsg, 0);
      if(call RadioReplySend.send(destination, &eventMsg, sizeof(BFileDirMsg)) != SUCCESS) {
        post sendEventMsg();
      }
      */
    }
  }
      
  /***************** Functions ****************/
  void execute(BFileDirMsg *inMsg, BFileDirMsg *replyPayload) {
    memset(replyPayload, 0, sizeof(BFileDirMsg));
    switch(inMsg->short0) {
      case CMD_GETTOTALFILES:
        replyPayload->short0 = REPLY_GETTOTALFILES;
        replyPayload->short1 = call BFileDir.getTotalFiles();
        post sendReplyMsg();
        break;

      case CMD_GETTOTALNODES:
        replyPayload->short0 = REPLY_GETTOTALNODES;
        replyPayload->int0 = call BFileDir.getTotalNodes();
        post sendReplyMsg();
        break;

      case CMD_GETFREESPACE:
        replyPayload->short0 = REPLY_GETFREESPACE;
        replyPayload->long0 = call BFileDir.getFreeSpace();
        post sendReplyMsg();
        break;

      case CMD_CHECKEXISTS:
        replyPayload->short0 = REPLY_CHECKEXISTS;
        replyPayload->short1 = call BFileDir.checkExists((char *) inMsg->fileName);
        post sendReplyMsg();
        break;

      case CMD_READFIRST:
        replyPayload->short0 = REPLY_READFIRST;
        replyPayload->short1 = call BFileDir.readFirst();
        post sendReplyMsg();
        break;

      case CMD_READNEXT:
        replyPayload->short0 = REPLY_READNEXT;
        replyPayload->short1 = call BFileDir.readNext((char *) inMsg->fileName);
        post sendReplyMsg();
        break;

      case CMD_GETRESERVEDLENGTH:
        replyPayload->short0 = REPLY_GETRESERVEDLENGTH;
        replyPayload->long0 = call BFileDir.getReservedLength((char *) inMsg->fileName);
        post sendReplyMsg();
        break;

      case CMD_GETDATALENGTH:
        replyPayload->short0 = REPLY_GETDATALENGTH;
        replyPayload->long0 = call BFileDir.getDataLength((char *) inMsg->fileName);
        post sendReplyMsg();
        break;

      case CMD_CHECKCORRUPTION:
        replyPayload->short0 = REPLY_CHECKCORRUPTION;
        replyPayload->short1 = call BFileDir.checkCorruption((char *) inMsg->fileName);
        post sendReplyMsg();
        break;

      default:
    }


  }
}
