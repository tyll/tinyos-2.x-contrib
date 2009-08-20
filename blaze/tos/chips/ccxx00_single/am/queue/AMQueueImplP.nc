// $Id$
/*
* "Copyright (c) 2005 Stanford University. All rights reserved.
*
* Permission to use, copy, modify, and distribute this software and
* its documentation for any purpose, without fee, and without written
* agreement is hereby granted, provided that the above copyright
* notice, the following two paragraphs and the author appear in all
* copies of this software.
* 
* IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE TO ANY PARTY FOR
* DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
* ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
* IF STANFORD UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
* DAMAGE.
* 
* STANFORD UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
* INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
* MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
* PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND STANFORD UNIVERSITY
* HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
* ENHANCEMENTS, OR MODIFICATIONS."
*/

/**
 * An AM send queue that provides a Service Instance pattern for
 * formatted packets and calls an underlying AMSend in a round-robin
 * fashion. Used to share L2 bandwidth between different communication
 * clients.
 *
 * @author Philip Levis
 * @author David Moss
 * @date   Aug 14, 2009
 */ 

#include "AM.h"

generic module AMQueueImplP(int TOTAL_QUEUE_MESSAGES) {
  provides {
    interface Send[uint8_t client];
  }
  
  uses {
    interface AMSend[am_id_t id];
    interface AMPacket;
    interface Packet;
  }
}

implementation {
  
  uint8_t currentMsgId = TOTAL_QUEUE_MESSAGES;
  
  message_t *msgQueue[TOTAL_QUEUE_MESSAGES];
  
  
  /***************** Prototypes ****************/
  void tryToSend();
  task void errorTask();
  void nextPacket();
  void tryToSend();
  void sendDone(uint8_t last, message_t *msg, error_t err);

  /***************** Send Commands ****************/
  /**
   * Accepts a properly formatted AM packet for later sending.
   * Assumes that someone has filled in the AM packet fields
   * (destination, AM type).
   *
   * @param msg - the message to send
   * @param len - the length of the payload
   *
   */
  command error_t Send.send[uint8_t id](message_t* msg, uint8_t len) {
    error_t error = SUCCESS;
    
    if (id >= TOTAL_QUEUE_MESSAGES || msgQueue[id] != NULL) {
      return FAIL;
    }
    
    msgQueue[id] = msg;
    call Packet.setPayloadLength(msg, len);
  
    if (currentMsgId >= TOTAL_QUEUE_MESSAGES) { // queue empty
      currentMsgId = id;
      
      if ((error = call AMSend.send[call AMPacket.type(msg)](call AMPacket.destination(msg), msg, len)) != SUCCESS) {
        currentMsgId = TOTAL_QUEUE_MESSAGES;
        msgQueue[id] = NULL;
      }
    }
    
    return error;
  }

  command error_t Send.cancel[uint8_t id](message_t* msg) {
    return FAIL;
  }


  event void AMSend.sendDone[am_id_t id](message_t* msg, error_t err) {
    // Bug fix from John Regehr: if the underlying radio mixes things
    // up, we don't want to read memory incorrectly. This can occur
    // on the mica2.
    // Note that since all AM packets go through this queue, this
    // means that the radio has a problem. -pal
    if (currentMsgId >= TOTAL_QUEUE_MESSAGES) {
	  return;
    }
    
    if(msgQueue[currentMsgId] == msg) {
	  sendDone(currentMsgId, msg, err);
    }
  }
  
  command uint8_t Send.maxPayloadLength[uint8_t id]() {
    return call AMSend.maxPayloadLength[0]();
  }

  command void* Send.getPayload[uint8_t id](message_t* m, uint8_t len) {
    return call AMSend.getPayload[0](m, len);
  }
  
  /***************** Functions ****************/
  task void errorTask() {
    sendDone(currentMsgId, msgQueue[currentMsgId], FAIL);
  }
  
  void nextPacket() {
    uint8_t i = 0;
    
    do {
      currentMsgId++;
      currentMsgId %= TOTAL_QUEUE_MESSAGES;
      
      if(msgQueue[currentMsgId] != NULL) {
        return;
      }
      
      i++;
    } while(i < TOTAL_QUEUE_MESSAGES);
    
    currentMsgId = TOTAL_QUEUE_MESSAGES;
  }
  

  // NOTE: Increments currentMsgId!
  void tryToSend() {
    nextPacket();
    if (currentMsgId < TOTAL_QUEUE_MESSAGES) { // queue not empty
      if((call AMSend.send[call AMPacket.type(msgQueue[currentMsgId])](
          call AMPacket.destination(msgQueue[currentMsgId]), 
              msgQueue[currentMsgId], 
                  call Packet.payloadLength(msgQueue[currentMsgId]))) != SUCCESS) {
        post errorTask();
      }
    }
  }
  
  void sendDone(uint8_t last, message_t *msg, error_t err) {
    msgQueue[last] = NULL;
    tryToSend();
    signal Send.sendDone[last](msg, err);
  }
  

  /***************** Defaults ****************/
  default event void Send.sendDone[uint8_t id](message_t* msg, error_t err) {
    // Do nothing
  }
}
