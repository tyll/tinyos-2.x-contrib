// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$

/*									tab:4
 * "Copyright (c) 2000-2003 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/*
 * Authors: Phil Buonadonna, David Culler, Matt Welsh
 * Authors: Rodrigo Fonseca (some changes for BVR)
 * 
 * $Revision$
 *
 * This MODULE implements queued send with optional retransmit.  
 * NOTE: This module only queues POINTERS to the application messages.
 * IT DOES NOT COPY THE MESSAGE DATA ITSELF! Applications must maintain 
 * their own data queues if more than one outstanding message is required.
 * 
 */

/* This is an altered version of QueuedSendM.nc, not to be used normally.
 * It assumes that all unicast packets sent are from CBRouter, and 
 * logs them as such. This is a cross-layer interaction for the sole purpose
 * of performing a test of the link-level retransmission.
 * It is QueuedSend that knows about retransmissions, and what we are doing here
 * is just a way of associating the packets with a particular multihop message,
 * so that we can make the analysis easier.
 * Rodrigo, 05/08/04
 */
 
/**
 * @author Phil Buonadonna
 * @author David Culler
 * @author Matt Welsh
 */


/* To use this without dependencies and interactions with BVR application
 * code, define NO_BVR_INTROSPECT */

includes AM;
#ifndef NO_BVR_INTROSPECT
includes BVR;
includes Logging;
#endif


#ifndef SEND_QUEUE_SIZE
#define SEND_QUEUE_SIZE	32
#endif

#ifndef MAX_QUEUE_RETRANSMITS
#define MAX_QUEUE_RETRANSMITS 5
#endif

module S4QueuedSendM {
  provides {
    interface Init;
    interface StdControl;
    interface AMSend as QueueSendMsg[uint8_t id];
    interface QueueControl;
    interface QueueCommand;
  }

  uses {
    interface AMSend as AirSendMsg[uint8_t id];
    interface Leds;
    interface PacketAcknowledgements as Acks;
#ifdef SERIAL_LOGGING    
    interface AMPacket as SerialActiveMessagePkt;
    interface AMSend as SerialAMSend;
    interface SplitControl as SerialAMControl;
    interface Packet as SerialPacketInterface;
#endif
    
#ifndef NO_BVR_INTROSPECT
    //interface Logger;
#endif

;


#ifdef EXP_BACKOFF
    interface Timer<TMilli> as QueueRetransmitTimer;
    interface Random;
#endif
  
  }
}

implementation {

  enum {
    MESSAGE_QUEUE_SIZE = SEND_QUEUE_SIZE,
    MAX_RETRANSMIT_COUNT = MAX_QUEUE_RETRANSMITS,
  };

  uint8_t max_retransmit_count;
  
  bool initialized = FALSE;

  struct _msgq_entry {
    uint16_t address;
    uint8_t length;
    uint8_t id;
    uint8_t xmit_count;
    message_t* pMsg;
  } msgqueue[MESSAGE_QUEUE_SIZE];

  uint16_t enqueue_next, dequeue_next;
  bool retransmit;
  bool fQueueIdle = TRUE;
  
  bool serialPortLocked = FALSE;
  
  message_t loggingPacket;    
  void sendTestSerialPacket(uint16_t origin,  uint16_t dest, uint8_t type) {     
#ifndef TOSSIM
#ifdef SERIAL_LOGGING
      RTLoggingPacket* sp = (RTLoggingPacket*) call SerialPacketInterface.getPayload(&loggingPacket, NULL);      
      sp->origin = origin;
      sp->dest = dest;
      sp->type = type;
      if (call SerialAMSend.send(AM_BROADCAST_ADDR, &loggingPacket, sizeof(RTLoggingPacket)) == SUCCESS){
  	 serialPortLocked = TRUE;
      }
#endif
#endif
  }
  
  
  command error_t Init.init() {
    int i;
    max_retransmit_count = MAX_RETRANSMIT_COUNT;
    for (i = 0; i < MESSAGE_QUEUE_SIZE; i++) {
      msgqueue[i].length = 0;
    }
#if PLATFORM_MICA2|| PLATFORM_MICA2DOT || TOSSIM
    retransmit = TRUE;  // Set to TRUE to enable retransmission
#else
    retransmit = TRUE;  // Set to FALSE to disable retransmission
#endif
    enqueue_next = 0;
    dequeue_next = 0;
    
    dbg("BVR-debug", "BVRQueuedSendM.Init.init called\n");
    
    fQueueIdle = TRUE;
    
    initialized = TRUE;
#ifdef SERIAL_LOGGING    
    call SerialAMControl.start();
#endif    
    return SUCCESS;
  }

  command error_t StdControl.start() {
    if (!initialized) {
      call Init.init();
    }
    
    return SUCCESS;
  }
  
  command error_t StdControl.stop() {
    return SUCCESS;
  }

  command error_t QueueCommand.setRetransmitCount(uint8_t r) {
    max_retransmit_count = r;
    return SUCCESS;
  }

  command uint8_t QueueCommand.getRetransmitCount() {
    return max_retransmit_count;
  }
  
  /* added by FENG WANG
   * implement a simple backoff timeout before each retransmission
   * the timeout value depends on the xmit_count
   */
#ifndef EXP_BACKOFF

  task void QueueServiceTask() {
    uint8_t id;
    // Try to send next message (ignore xmit_count)
    if (msgqueue[dequeue_next].length != 0) {
      
      id = msgqueue[dequeue_next].id;
      //XXX: help to the mac layer: setting the ack bit to 0, just in case
      //msgqueue[dequeue_next].pMsg->ack = 0;
      
      if (id != AM_S4_LOG_MSG && msgqueue[dequeue_next].address != TOS_BCAST_ADDR) {
              call Acks.requestAck(msgqueue[dequeue_next].pMsg);
      }

      if ((call AirSendMsg.send[id](msgqueue[dequeue_next].address, 
      				     msgqueue[dequeue_next].pMsg,	
					msgqueue[dequeue_next].length
					)) != SUCCESS) {

	dbg(DBG_USR2, "QueuedSend: send request failed. stuck in queue\n");
      }
      else {
       
      }
    }
    else {
      fQueueIdle = TRUE;
    }
  }

#else

  /* Queue data structure
     Circular Buffer
     enqueue_next indexes first empty entry
     buffer full if incrementing enqueue_next would wrap to dequeue
     empty if dequeue_next == enqueue_next
     or msgqueue[dequeue_next].length == 0
  */

  task void QueueServiceTask() {
    uint8_t id;
    // Try to send next message (ignore xmit_count)
    if (msgqueue[dequeue_next].length != 0) {
      if (msgqueue[dequeue_next].xmit_count > 0) {
        uint16_t delay = call Random.rand32() % (20*msgqueue[dequeue_next].xmit_count) + 1;
        call QueueRetransmitTimer.startOneShot(delay);
        dbg("TestBVR", "Will retransmit after delay=%d\n", delay);
        return;
      } 
      
      dbg("BVR-debug", "QueuedSend: sending msg (0x%x)\n", dequeue_next);
      id = msgqueue[dequeue_next].id;
      //XXX: help to the mac layer: setting the ack bit to 0, just in case
      //msgqueue[dequeue_next].pMsg->ack = 0;

      if (id != AM_S4_LOG_MSG && id != AM_BVR_LOG_MSG && msgqueue[dequeue_next].address != TOS_BCAST_ADDR) {
        call Acks.requestAck(msgqueue[dequeue_next].pMsg);
      }
                 
      if (id == AM_S4_LOG_MSG || id == AM_BVR_LOG_MSG) {        
        
      }
      else if ((call AirSendMsg.send[id](msgqueue[dequeue_next].address, 
				        	msgqueue[dequeue_next].pMsg, 
				        	msgqueue[dequeue_next].length)) != SUCCESS) {
	      dbg("S4-debug", "QueuedSend: send request failed. stuck in queue\n");
      }
      else {
        
      }
      
    }
    else {
      fQueueIdle = TRUE;
    }    
  }
  
  event void QueueRetransmitTimer.fired() {
      uint8_t id;
      S4AppMsg* pS4Msg;
      //retransmission timer expires        
  
      id = msgqueue[dequeue_next].id;
      //XXX: help to the mac layer: setting the ack bit to 0, just in case
      //msgqueue[dequeue_next].pMsg->ack = 0;
      if (id != AM_S4_LOG_MSG && id != AM_BVR_LOG_MSG && msgqueue[dequeue_next].address != TOS_BCAST_ADDR) {
              call Acks.requestAck(msgqueue[dequeue_next].pMsg);
      }
  
      if (call AirSendMsg.send[id](msgqueue[dequeue_next].address,msgqueue[dequeue_next].pMsg, 
  			                                msgqueue[dequeue_next].length
  					                            ) != SUCCESS) {
  	    dbg("S4-debug", "QueuedSend: send request failed. stuck in queue\n");
      }
      
      pS4Msg = (S4AppMsg*) msgqueue[dequeue_next].pMsg->data;        
      return;
  }
#endif

  command error_t QueueSendMsg.send[uint8_t id](uint16_t address, message_t* msg, uint8_t length) {
    dbg("BVR-debug", "QueuedSend: queue msg enq %d deq %d\n", enqueue_next, dequeue_next);
        
    //don't enqueue UART messages in TOSSIM
    if (id == AM_S4_LOG_MSG) {      
      call Leds.led1Toggle();
#ifdef TOSSIM
      return FAIL;
#endif
    }

    if (((enqueue_next + 1) % MESSAGE_QUEUE_SIZE) == dequeue_next) {
      // Fail if queue is full
      return FAIL;
    }
    msgqueue[enqueue_next].address = address;
    msgqueue[enqueue_next].length = length;
    msgqueue[enqueue_next].id = id;
    msgqueue[enqueue_next].pMsg = msg;
    msgqueue[enqueue_next].xmit_count = 0;
    //msgqueue[enqueue_next].pMsg->ack = 0;

   

    enqueue_next++; enqueue_next %= MESSAGE_QUEUE_SIZE;

    dbg("BVR-debug", "QueuedSend: Successfully queued msg to 0x%x, id %d enq %d, deq %d\n", address, id, enqueue_next, dequeue_next);

    dbg("BVR-debug", "QueuedSend: X fQueueIdle: %d\n",fQueueIdle);
    
    
   
    if (fQueueIdle) {
      fQueueIdle = FALSE;
      if (post QueueServiceTask() == FAIL)
        dbg("BVR-error","QueueSendM: post QueueServiceTask returned error!!\n");
    }
    
    return SUCCESS;

  }

  /* Warning: this is the place that interacts with BVR code, but is not
   * essential for the functionality of the module. The purpose of this is
   * to log retransmissions in a way that is easy to correlate with the
   * application messages. A layering violation for the progress (or
   * debugging) of science... */
  event void AirSendMsg.sendDone[uint8_t id](message_t* msg, error_t success) {

#ifndef NO_BVR_INTROSPECT
    S4AppMsg* pS4Msg;
    uint16_t app_msg_id;
    pS4Msg = (S4AppMsg*)msg->data;
    app_msg_id = *(uint16_t*)(&pS4Msg->type_data.data);
#endif

    if (id==AM_S4_APP_MSG)
      call Leds.led0Toggle();

    dbg("BVR-debug","QueueSendM$AirSendMsg$sendDone: result:%d ack:%d  is_BCAST:%d\n",success,call Acks.wasAcked(msg), 
            (msgqueue[dequeue_next].address == TOS_BCAST_ADDR));

    if (msg != msgqueue[dequeue_next].pMsg) {
      dbg("BVR-debug","QueuedSendM$AirSendMsg$sendDone: Internal Error: buffer mismatch!\n");
      return ;		// This would be internal error
    }

#ifndef NO_BVR_INTROSPECT
    //Logging of retransmissions
    if (id == AM_S4_APP_MSG && 
        (retransmit) && 
        (call Acks.wasAcked(msg) != 0) &&          
        (msgqueue[dequeue_next].address != TOS_BCAST_ADDR)) {
      /* Rodrigo: logging for retransmission test */
      
    }
#endif
     
    // filter out non-queuesend msgs
    if ((!retransmit) || (call Acks.wasAcked(msg) != FALSE) ||  msgqueue[dequeue_next].address == TOS_BCAST_ADDR) {      
      signal QueueSendMsg.sendDone[id](msg,success);
      msgqueue[dequeue_next].length = 0;
      dbg("BVR-debug", "qent %d dequeued.\n", dequeue_next);
      dequeue_next++; dequeue_next %= MESSAGE_QUEUE_SIZE;

    }
    else {      
    
            //added by Feng Wang on Sept. 22, to log # of retransmissions
        if (id == AM_S4_APP_MSG) {
            pS4Msg->type_data.rexmit_count++;
        }	
      
      if ((++(msgqueue[dequeue_next].xmit_count) > max_retransmit_count)) {
        // Tried to send too many times, just drop        

        signal QueueSendMsg.sendDone[id](msg,FAIL);
        msgqueue[dequeue_next].length = 0;
        dequeue_next++; dequeue_next %= MESSAGE_QUEUE_SIZE;
      }
    }
    
    // Send next
      if (post QueueServiceTask() == FAIL)
        dbg("BVR-error","QueueSendM: post QueueServiceTask returned error!!\n");

    return ;
  }
  
  command uint16_t QueueControl.getOccupancy() {
    uint16_t uiOutstanding = enqueue_next - dequeue_next;
    uiOutstanding %= MESSAGE_QUEUE_SIZE;

    return uiOutstanding;
  }
  
  command uint8_t QueueControl.getXmitCount() {
    if (msgqueue[dequeue_next].length != 0)
      return msgqueue[dequeue_next].xmit_count;
    return 0;
  }
  
  default event void QueueSendMsg.sendDone[uint8_t id](message_t* msg, error_t success) {
    return ;
  }
  
  command error_t QueueSendMsg.cancel[uint8_t id]( message_t* msg){
    return call AirSendMsg.cancel[id](msg);
  }
  
  command void* QueueSendMsg.getPayload[uint8_t id]( message_t* msg, uint8_t len){
    return call AirSendMsg.getPayload[id](msg, len);
  }
  
  command uint8_t QueueSendMsg.maxPayloadLength[uint8_t id]( ){
    return call AirSendMsg.maxPayloadLength[id]();
  }


  default command error_t AirSendMsg.send[uint8_t id](uint16_t address, message_t* msg, uint8_t length)
    {
      return SUCCESS;
    }
#ifdef SERIAL_LOGGING    
  event void SerialAMSend.sendDone(message_t* msg, error_t success) {
    if (msg == &loggingPacket)
          serialPortLocked = FALSE;   
  }
  
  event void SerialAMControl.startDone(error_t err){
    if (err != SUCCESS) {
      call SerialAMControl.start();
    }
  }
    
  event void SerialAMControl.stopDone(error_t err){
    if (err != SUCCESS) {
      call SerialAMControl.stop();
    }
  }
#endif  
}
