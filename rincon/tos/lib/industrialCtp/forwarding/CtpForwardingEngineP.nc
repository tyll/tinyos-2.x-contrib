/*
 * Copyright (c) 2006 Stanford University.
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
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 *  The ForwardingEngine is responsible for queueing and scheduling outgoing
 *  packets in a collection protocol. It maintains a pool of forwarding messages 
 *  and a packet send 
 *  queue. A ForwardingEngine with a forwarding message pool of size <i>F</i> 
 *  and <i>C</i> CollectionSenderC clients has a send queue of size
 *  <i>F + C</i>. This implementation has a large number of configuration
 *  constants, which can be found in <code>ForwardingEngine.h</code>.
 *
 *  <p>Packets in the send queue are sent in FIFO order, with head-of-line
 *  blocking. Because this is a tree collection protocol, all packets are going
 *  to the same destination, and so the ForwardingEngine does not distinguish
 *  packets from one another: packets from CollectionSenderC clients are
 *  treated identically to forwarded packets.</p>
 *
 *  <p>If ForwardingEngine is on top of a link layer that supports
 *  synchronous acknowledgments, it enables them and retransmits packets
 *  when they are not acked. It transmits a packet up to MAX_RETRIES times
 *  before giving up and dropping the packet.</p> 
 *
 *  <p>The ForwardingEngine detects routing loops and tries to correct
 *  them. It assumes that the collection tree is based on a gradient,
 *  such as hop count or estimated transmissions. When the ForwardingEngine
 *  sends a packet to the next hop, it puts the local gradient value in
 *  the packet header. If a node receives a packet to forward whose
 *  gradient value is less than its own, then the gradient is not monotonically
 *  decreasing and there may be a routing loop. When the ForwardingEngine
 *  receives such a packet, it tells the RoutingEngine to advertise its
 *  gradient value soon, with the hope that the advertisement will update
 *  the node who just sent a packet and break the loop.
 *  
 *  <p>ForwardingEngine times its packet transmissions. It differentiates
 *  between four transmission cases: forwarding, success, ack failure, 
 *  and loop detection. In each case, the
 *  ForwardingEngine waits a randomized period of time before sending the next
 *  packet. This approach assumes that the network is operating at low
 *  utilization; its goal is to prevent correlated traffic -- such as 
 *  nodes along a route forwarding packets -- from interfering with itself.
 *
 *  <table>
 *    <tr>
 *      <td><b>Case</b></td>
 *      <td><b>CC2420 Wait (ms)</b></td>
 *      <td><b>Other Wait (ms)</b></td>
 *      <td><b>Description</b></td>
 *    </tr>
 *    <tr>
 *      <td>Forwarding</td>
 *      <td>Immediate</td>
 *      <td>Immediate</td>
 *      <td>When the ForwardingEngine receives a packet to forward and it is not
 *          already sending a packet (queue is empty). In this case, it immediately
 *          forwards the packet.</td>
 *    </tr>
 *    <tr>
 *      <td>Success</td>
 *      <td>16-31</td>
 *      <td>128-255</td>
 *      <td>When the ForwardingEngine successfully sends a packet to the next
 *          hop, it waits this long before sending the next packet in the queue.
 *          </td>
 *    </tr>
 *    <tr>
 *      <td>Ack Failure</td>
 *      <td>8-15</td>
 *      <td>128-255</td>
 *      <td>If the link layer supports acks and the ForwardingEngine did not
 *          receive an acknowledgment from the next hop, it waits this long before
 *          trying a retransmission. If the packet has exceeded the retransmission
 *          count, ForwardingEngine drops the packet and uses the Success timer instead. </td>
 *    </tr>
 *    <tr>
 *      <td>Loop Detection</td>
 *      <td>32-63</td>
 *      <td>512-1023</td>
 *      <td>If the ForwardingEngine is asked to forward a packet from a node that
 *          believes it is closer to the root, the ForwardingEngine pauses its
 *          transmissions for this interval and triggers the RoutingEngine to 
 *          send an update. The goal is to let the gradient become consistent before
 *          sending packets, in order to prevent routing loops from consuming
 *          bandwidth and energy.</td>
 *    </tr>
 *  </table>  
 *
 *  <p>The times above are all for CC2420-based platforms. The timings for
 *  other platforms depend on their bit rates, as they are based on packet
 *  transmission times.</p>
 *
 * @author Philip Levis
 * @author Kyle Jamieson
 * @author David Moss
 */

#include "CtpForwardingEngine.h"
#include "CtpDebugMsg.h"
   
module CtpForwardingEngineP {
  provides {
    interface Init;
    
    interface StdControl;
    interface Send[uint8_t client];
    interface Receive[collection_id_t id];
    interface Receive as Snoop[collection_id_t id];
    interface Intercept[collection_id_t id];
    interface CtpCongestion;
  }
  
  uses {
    interface AMSend as SubSend;
    
    interface Receive as SubReceive;
    interface Receive as SubSnoop;
    
    interface PacketAcknowledgements;
    interface Packet;
    interface Packet as NormalPacket;
    interface AMPacket;
    
    interface UnicastNameFreeRouting;
    interface CollectionId[uint8_t client];
    interface RootControl;
    interface CtpInfo;
    interface CollectionDebug;
    interface CtpPacket;
    interface LinkEstimator;
    
    interface SplitControl as RadioSplitControl;
    
    interface Queue<fe_queue_entry_t*> as SendQueue;
    interface Pool<fe_queue_entry_t> as QEntryPool;
    interface Pool<message_t> as MessagePool;
    interface Cache<message_t*> as SentCache;
    
    interface Timer<TMilli> as RetransmitTimer;
    interface Timer<TMilli> as CongestionTimer;
    
    interface Random;
    interface Leds;
    
  }
}

implementation {
  
  enum {
    CLIENT_COUNT = uniqueCount(UQ_CTP_CLIENT)
  };


  /* Indicates whether our client is congested */
  bool clientCongested = FALSE;

  /* Threshold for congestion */
  uint8_t congestionThreshold;

  /* 
   * Keeps track of whether the routing layer is running; if not,
   * it will not send packets. 
   */
  bool running = FALSE;

  /* 
   * Keeps track of whether the radio is on; no sense sending packets
   * if the radio is off. 
   */
  bool radioOn = FALSE;

  /* 
   * Keeps track of whether an ack is pending on an outgoing packet,
   * so that the engine can work unreliably when the data-link layer
   * does not support acks. 
   */
  bool ackPending = FALSE;

  /* 
   * Keeps track of whether the packet on the head of the queue
   * is being used, and control access to the data-link layer.
   */
  bool sending = FALSE;

  /* 
   * Keep track of the last parent address we sent to, so that
   * unacked packets to an old parent are not incorrectly attributed
   * to a new parent. 
   */
  am_addr_t lastParent;
  
  /* 
   * Network-level sequence number, so that receivers
   * can distinguish retransmissions from different packets. 
   */
  uint8_t seqno;

  /* 
   * Each sending client has its own reserved queue entry.
   * If the client has a packet pending, its queue entry is in the 
   * queue, and its clientPtr is NULL. If the client is idle,
   * its queue entry is pointed to by clientPtrs. 
   */
  fe_queue_entry_t clientEntries[CLIENT_COUNT];
  
  fe_queue_entry_t* clientPtrs[CLIENT_COUNT];

  /* 
   * The loopback message is for when a collection roots calls
   * Send.send. Since Send passes a pointer but Receive allows
   * buffer swaps, the forwarder copies the sent packet into 
   * the loopbackMsgPtr and performs a buffer swap with it.
   * See sendTask(). 
   */  
  message_t loopbackMsg;
  
  message_t* loopbackMsgPtr;

  /***************** Prototypes ****************/
  task void sendTask();
  
  void startRetransmitTimer(uint16_t mask, uint16_t offset);
  void startCongestionTimer(uint16_t mask, uint16_t offset);  
  void putInPools(message_t *msg, fe_queue_entry_t *queueEntry);
  message_t *forward(message_t *m);
  ctp_data_header_t *getHeader(message_t* m);
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;
    for (i = 0; i < CLIENT_COUNT; i++) {
      clientPtrs[i] = clientEntries + i;
    }
    
    congestionThreshold = (call SendQueue.maxSize()) >> 1;
    loopbackMsgPtr = &loopbackMsg;
    lastParent = call AMPacket.address();
    seqno = 0;
    return SUCCESS;
  }

  /***************** StdControl Commands ****************/
  command error_t StdControl.start() {
    running = TRUE;
    return SUCCESS;
  }

  command error_t StdControl.stop() {
    running = FALSE;
    return SUCCESS;
  }
  
  /***************** RadioSplitControl Commands ****************/ 
  /**
   * ForwardingEngine keeps track of whether the underlying
   * radio is powered on. If not, it enqueues packets;
   * when it turns on, it then starts sending packets.
   */
  event void RadioSplitControl.startDone(error_t error) {
    if(error) {
      return;
    }
    
    radioOn = TRUE;

    if(!call SendQueue.empty()) {
      post sendTask();
    }
  }
 
  
  event void RadioSplitControl.stopDone(error_t err) {
    if (err == SUCCESS) {
      radioOn = FALSE;
    }
  }

  /***************** UnicastNameFreeRouting Events ****************/
  /* 
   * If the ForwardingEngine has stopped sending packets because
   * these has been no route, then as soon as one is found, start
   * sending packets.
   */ 
  event void UnicastNameFreeRouting.routeFound() {
    post sendTask();
  }

  /**
   * Depend on the sendTask to take care of this case;
   * if there is no route the component will just resume
   * operation on the routeFound event
   */
  event void UnicastNameFreeRouting.noRoute() {
  }
  
  
  /**************** Send Commands ****************/
  /*
   * The send call from a client. Return EBUSY if the client is busy
   * (clientPtrs is NULL), otherwise configure its queue entry
   * and put it in the send queue. If the ForwardingEngine is not
   * already sending packets (the RetransmitTimer isn't running), post
   * sendTask. It could be that the engine is running and sendTask
   * has already been posted, but the post-once semantics make this
   * not matter.
   */ 
  command error_t Send.send[uint8_t client](message_t* msg, uint8_t len) {
    ctp_data_header_t *hdr;
    fe_queue_entry_t *qe;
    
    if (!running) {
      return EOFF;
    }
    
    if (len > call Send.maxPayloadLength[client]()) {
      return ESIZE;
    }
    
    if (clientPtrs[client] == NULL) {
      return EBUSY;
    }
    
    call Packet.setPayloadLength(msg, len);
    
    hdr = getHeader(msg);
    
    hdr->origin = call AMPacket.address();
    hdr->originSeqNo = seqno++;
    hdr->type = call CollectionId.fetch[client]();
    hdr->thl = 0;
    
    qe = clientPtrs[client];
    qe->msg = msg;
    qe->client = client;
    qe->retries = MAX_RETRIES;
    
    if (call SendQueue.enqueue(qe) == SUCCESS) {
      if (radioOn && !call RetransmitTimer.isRunning()) {
        post sendTask();
      }
      
      clientPtrs[client] = NULL;
      return SUCCESS;
      
    } else {
      ////printf("Forwarder", "%s: send failed as packet could not be enqueued.\n\r", __FUNCTION__);
      call CollectionDebug.logEvent(NET_C_FE_SEND_QUEUE_FULL);
      return FAIL;
    }
  }

  command error_t Send.cancel[uint8_t client](message_t* msg) {
    return FAIL;
  }

  command uint8_t Send.maxPayloadLength[uint8_t client]() {
    return call Packet.maxPayloadLength();
  }

  command void* Send.getPayload[uint8_t client](message_t* msg, uint8_t len) {
    return call Packet.getPayload(msg, len);
  }
  
  
  /***************** CtpCongestion Commands ****************/
  command bool CtpCongestion.isCongested() {
    return ((call SendQueue.size() > congestionThreshold) || clientCongested);
  }

  command void CtpCongestion.setClientCongested(bool congested) {
    bool wasCongested = call CtpCongestion.isCongested();
    clientCongested = congested;
    
    if (!wasCongested && congested) {
      call CtpInfo.triggerImmediateRouteUpdate();
      
    } else if (wasCongested && ! (call CtpCongestion.isCongested())) {
      call CtpInfo.triggerRouteUpdate();
    }
  }

  /***************** SubSend Events ****************/
  /*
   * The second phase of a send operation; based on whether the transmission was
   * successful, the ForwardingEngine either stops sending or starts the
   * RetransmitTimer with an interval based on what has occured. If the send was
   * successful or the maximum number of retransmissions has been reached, then
   * the ForwardingEngine dequeues the current packet. If the packet is from a
   * client it signals Send.sendDone(); if it is a forwarded packet it returns
   * the packet and queue entry to their respective pools.
   */
  event void SubSend.sendDone(message_t* msg, error_t error) {
    fe_queue_entry_t *qe = call SendQueue.head();
    uint8_t client;
    
    //printf("Forwarder: %s to %hu and %hhu\n\r", __FUNCTION__, call AMPacket.destination(msg), error);
    
    if (qe == NULL || qe->msg != msg) {
      return;
    } 
    
    if (!running) {
      // Don't bother trying again.
      if (qe->client < CLIENT_COUNT) {
        clientPtrs[qe->client] = qe;
        signal Send.sendDone[qe->client](msg, EOFF);
        
        call CollectionDebug.logEventMsg(NET_C_FE_SENDDONE_FAIL_ACK_SEND, 
            call CtpPacket.getSequenceNumber(msg), 
            call CtpPacket.getOrigin(msg), 
            call AMPacket.destination(msg));
                                     
      } else {
        putInPools(qe->msg, qe);
        
        call CollectionDebug.logEventMsg(NET_C_FE_SENDDONE_FAIL_ACK_FWD, 
            call CtpPacket.getSequenceNumber(msg), 
            call CtpPacket.getOrigin(msg), 
            call AMPacket.destination(msg));
      }
      
      call SendQueue.dequeue();
      sending = FALSE;
      startRetransmitTimer(SENDDONE_OK_WINDOW, SENDDONE_OK_OFFSET);
      
    } else if (error != SUCCESS) {
      // Immediate retransmission is the worst thing to do.
      ///printf("Forwarder: %s: send failed\n\r", __FUNCTION__);
      call CollectionDebug.logEventMsg(NET_C_FE_SENDDONE_FAIL, 
          call CtpPacket.getSequenceNumber(msg), 
          call CtpPacket.getOrigin(msg), 
          call AMPacket.destination(msg));
          
      startRetransmitTimer(SENDDONE_FAIL_WINDOW, SENDDONE_FAIL_OFFSET);
      
    } else if (ackPending && !call PacketAcknowledgements.wasAcked(msg)) {
      // AckPending is for case when data link layer cannot support acks.
      call LinkEstimator.txNoAck(call AMPacket.destination(msg));
      call CtpInfo.recomputeRoutes();
      
      if (--qe->retries) {
        // Wait a bit and then try sending the packet again.
        call CollectionDebug.logEventMsg(NET_C_FE_SENDDONE_WAITACK, 
            call CtpPacket.getSequenceNumber(msg), 
            call CtpPacket.getOrigin(msg), 
            call AMPacket.destination(msg));
            
        startRetransmitTimer(SENDDONE_NOACK_WINDOW, SENDDONE_NOACK_OFFSET);
        
      } else {
        // Max retries, dropping packet
        ///printf("Forwarder: %s: max retries, dropping packet.\n\r", __FUNCTION__);
        if (qe->client < CLIENT_COUNT) {
            clientPtrs[qe->client] = qe;
            signal Send.sendDone[qe->client](msg, FAIL);
            
            call CollectionDebug.logEventMsg(NET_C_FE_SENDDONE_FAIL_ACK_SEND, 
                call CtpPacket.getSequenceNumber(msg), 
                call CtpPacket.getOrigin(msg), 
                call AMPacket.destination(msg));
        
        } else {
           putInPools(qe->msg, qe);
           
           call CollectionDebug.logEventMsg(NET_C_FE_SENDDONE_FAIL_ACK_FWD, 
               call CtpPacket.getSequenceNumber(msg), 
               call CtpPacket.getOrigin(msg), 
               call AMPacket.destination(msg));
               
        }
        
        call SendQueue.dequeue();
        sending = FALSE;
        startRetransmitTimer(SENDDONE_OK_WINDOW, SENDDONE_OK_OFFSET);
      }
      
    } else if (qe->client < CLIENT_COUNT) {
      client = qe->client;
      
      ////printf("Forwarder: %s: our packet for client %hhu, remove %p from queue\n\r", __FUNCTION__, client, qe);
      call CollectionDebug.logEventMsg(NET_C_FE_SENT_MSG, 
          call CtpPacket.getSequenceNumber(msg), 
          call CtpPacket.getOrigin(msg), 
          call AMPacket.destination(msg));
          
      call LinkEstimator.txAck(call AMPacket.destination(msg));
      clientPtrs[client] = qe;
      call SendQueue.dequeue();
      
      signal Send.sendDone[client](msg, SUCCESS);
      sending = FALSE;
      startRetransmitTimer(SENDDONE_OK_WINDOW, SENDDONE_OK_OFFSET);
      
    } else if (call MessagePool.size() < call MessagePool.maxSize()) {
      // A successfully forwarded packet.
      ////printf("Forwarder,Route: %s: successfully forwarded packet (client: %hhu), message pool is %hhu/%hhu.\n\r", __FUNCTION__, qe->client, call MessagePool.size(), call MessagePool.maxSize());
      call CollectionDebug.logEventMsg(NET_C_FE_FWD_MSG, 
          call CtpPacket.getSequenceNumber(msg), 
          call CtpPacket.getOrigin(msg), 
          call AMPacket.destination(msg));
                                         
      call LinkEstimator.txAck(call AMPacket.destination(msg));
      call SentCache.insert(qe->msg);
      call SendQueue.dequeue();
      putInPools(qe->msg, qe);
      
      sending = FALSE;
      startRetransmitTimer(SENDDONE_OK_WINDOW, SENDDONE_OK_OFFSET);
    }
  }

  /***************** Receive Events ****************/
  /*
   * Received a message to forward. Check whether it is a duplicate by
   * checking the packets currently in the queue as well as the 
   * send history cache (in case we recently forwarded this packet).
   * The cache is important as nodes immediately forward packets
   * but wait a period before retransmitting after an ack failure.
   * If this node is a root, signal receive.
   */ 
  event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len) {
    collection_id_t collectid;
    fe_queue_entry_t *qe;
    uint8_t i;

    if(!running) {
      return msg;
    }

    collectid = call CtpPacket.getType(msg);

    // Update the THL here, since it has lived another hop, and so
    // that the root sees the correct THL.
    call CtpPacket.setThl(msg, call CtpPacket.getThl(msg) + 1);
    
    if (len > call SubSend.maxPayloadLength()) {
      return msg;
    }

    // See if we remember having seen this packet
    // We look in the sent cache ...
    if(call SentCache.lookup(msg)) {
      call CollectionDebug.logEvent(NET_C_FE_DUPLICATE_CACHE);
      return msg;
    }
    
    //... and in the queue for duplicates
    if (call SendQueue.size() > 0) {
      for (i = call SendQueue.size(); --i;) {
        qe = call SendQueue.element(i);
        if (call CtpPacket.matchInstance(qe->msg, msg)) {
          call CollectionDebug.logEvent(NET_C_FE_DUPLICATE_QUEUE);
          return msg;
        }
      }
    }
    
    // If I'm the root, signal receive. 
    if (call RootControl.isRoot()) {
      return signal Receive.receive[collectid](msg, 
          call Packet.getPayload(msg, call Packet.payloadLength(msg)), 
          call Packet.payloadLength(msg));
   
    } else if (!signal Intercept.forward[collectid](msg, 
        call Packet.getPayload(msg, call Packet.payloadLength(msg)), 
        call Packet.payloadLength(msg))) {
                                                  
      // I'm on the routing path and Intercept indicates that I
      // should not forward the packet.
      return msg;
      
    } else {
      ////printf("Route: Forwarding packet from %hu.\n\r", getHeader(msg)->origin);
      return forward(msg);
    }
  }

  event message_t* SubSnoop.receive(message_t* msg, void *payload, uint8_t len) {
    //am_addr_t parent = call UnicastNameFreeRouting.nextHop();
    am_addr_t proximalSrc = call AMPacket.source(msg);

    if(!running) {
      return msg;
    }
    
    // Check for the pull bit (P) [TEP123] and act accordingly.  This
    // check is made for all packets, not just ones addressed to us.
    if (call CtpPacket.option(msg, CTP_OPT_PULL)) {
      call CtpInfo.triggerRouteUpdate();
    }

    call CtpInfo.setNeighborCongested(proximalSrc, call CtpPacket.option(msg, CTP_OPT_ECN));
    return signal Snoop.receive[call CtpPacket.getType(msg)](msg, 
        payload + sizeof(ctp_data_header_t), 
        len - sizeof(ctp_data_header_t));
        
  }
  
  
  /***************** Timer Events ****************/
  event void RetransmitTimer.fired() {
    sending = FALSE;
    post sendTask();
  }

  event void CongestionTimer.fired() {
    post sendTask();
  }
  
  
  /***************** LinkEstimator Events ****************/
  event void LinkEstimator.evicted(am_addr_t neighbor) {
  }
  
  /***************** Tasks ****************/
  /**
   * These is where all of the send logic is. When the ForwardingEngine
   * wants to send a packet, it posts this task. The send logic is
   * independent of whether it is a forwarded packet or a packet from
   * a send client. 
   *
   * The task first checks that there is a packet to send and that
   * there is a valid route. It then marshals the relevant arguments
   * and prepares the packet for sending. If the node is a collection
   * root, it signals Receive with the loopback message. Otherwise,
   * it sets the packet to be acknowledged and sends it. It does not
   * remove the packet from the send queue: while sending, the 
   * packet being sent is at the head of the queue; a packet is dequeued
   * in the sendDone handler, either due to retransmission failure
   * or to a successful send.
   */
  task void sendTask() {
    error_t subsendResult;
    fe_queue_entry_t* qe;
    uint8_t payloadLen;
    am_addr_t dest;
    uint16_t gradient;
    
    ////printf("Forwarder: %s: Trying to send a packet. Queue size is %hhu.\n\r", __FUNCTION__, call SendQueue.size());
    
    if (sending) {
      ////printf("Forwarder: %s: busy, don't send\n\r", __FUNCTION__);
      call CollectionDebug.logEvent(NET_C_FE_SEND_BUSY);
      return;
      
    } else if (call SendQueue.empty()) {
      ////printf("Forwarder: %s: queue empty, don't send\n\r", __FUNCTION__);
      call CollectionDebug.logEvent(NET_C_FE_SENDQUEUE_EMPTY);
      return;
      
    } else if (!call RootControl.isRoot() && !call UnicastNameFreeRouting.hasRoute()) {
      ////printf("Forwarder: %s: no route, don't send, start retry timer\n\r", __FUNCTION__);
      startRetransmitTimer(SENDDONE_OK_WINDOW, SENDDONE_OK_OFFSET);
      call CollectionDebug.logEvent(NET_C_FE_NO_ROUTE);
      return;


    } else {
      qe = call SendQueue.head();
      payloadLen = call NormalPacket.payloadLength(qe->msg);
      dest = call UnicastNameFreeRouting.nextHop();
      
      
      if (call CtpInfo.isNeighborCongested(dest)) {
        // Our parent is congested. We should wait.
        // Don't repost the task, CongestionTimer will do the job
        if (!call CongestionTimer.isRunning()) {
          startCongestionTimer(CONGESTED_WAIT_WINDOW, CONGESTED_WAIT_OFFSET);
        }
        
        return;
      } 
      
      /*
       * Once we are here, we have decided to send the packet.
       */
      if (call SentCache.lookup(qe->msg)) {
        call CollectionDebug.logEvent(NET_C_FE_DUPLICATE_CACHE_AT_SEND);
        call SendQueue.dequeue();
        putInPools(qe->msg, qe);
        post sendTask();
        return;
      }
      
      /* 
       * If our current parent is not the same as the last parent
       * we sent do, then reset the count of unacked packets: don't
       * penalize a new parent for the failures of a prior one.
       */
      if (dest != lastParent) {
        qe->retries = MAX_RETRIES;
        lastParent = dest;
      }
      
      if (call RootControl.isRoot()) {
        collection_id_t collectid = getHeader(qe->msg)->type;
        memcpy(loopbackMsgPtr, qe->msg, sizeof(message_t));
        ackPending = FALSE;
        
        ////printf("Forwarder: %s: I'm a root, so loopback and signal receive.\n\r", __FUNCTION__);
        loopbackMsgPtr = signal Receive.receive[collectid](loopbackMsgPtr, 
            call Packet.getPayload(loopbackMsgPtr, call Packet.payloadLength(loopbackMsgPtr)), 
            call Packet.payloadLength(loopbackMsgPtr));
            
        signal SubSend.sendDone(qe->msg, SUCCESS);
        return;
      }
      
      // Loop-detection functionality:
      if (call CtpInfo.getEtx(&gradient) != SUCCESS) {
        // If we have no metric, set our gradient conservatively so
        // that other nodes don't automatically drop our packets.
        gradient = 0;
      }
      
      call CtpPacket.setEtx(qe->msg, gradient);
      
      ackPending = (call PacketAcknowledgements.requestAck(qe->msg) == SUCCESS);

      // Set or clear the congestion bit on *outgoing* packets.
      if (call CtpCongestion.isCongested()) {
        call CtpPacket.setOption(qe->msg, CTP_OPT_ECN);
        
      } else {
        call CtpPacket.clearOption(qe->msg, CTP_OPT_ECN);
      }
      
      subsendResult = call SubSend.send(dest, qe->msg, payloadLen);
      
      if (subsendResult == SUCCESS) {
        sending = TRUE;
        ///printf("Forwarder: %s: subsend succeeded with %p.\n\r", __FUNCTION__, qe->msg);
        
      } else if (subsendResult == EOFF) {
        radioOn = FALSE;
        ///printf("Forwarder: %s: subsend failed from EOFF.\n\r", __FUNCTION__);
        call CollectionDebug.logEvent(NET_C_FE_SUBSEND_OFF);

      } else if (subsendResult == ESIZE) {
        ///printf("Forwarder: %s: subsend failed from ESIZE: truncate packet.\n\r", __FUNCTION__);
        call Packet.setPayloadLength(qe->msg, call Packet.maxPayloadLength());
        post sendTask();
        call CollectionDebug.logEvent(NET_C_FE_SUBSEND_SIZE);
      }
    }
  }
  
  /***************** Functions ****************/
  void startRetransmitTimer(uint16_t mask, uint16_t offset) {
    uint16_t r = call Random.rand16();
    r &= mask;
    r += offset;
    call RetransmitTimer.startOneShot(r);
    ////printf("Forwarder: Retransmit timer will fire in %hu ms\n\r", r);
  }

  void startCongestionTimer(uint16_t mask, uint16_t offset) {
    uint16_t r = call Random.rand16();
    r &= mask;
    r += offset;
    call CongestionTimer.startOneShot(r);
    ////printf("Forwarder: Congestion timer will fire in %hu ms\n\r", r);
  }
  
  void putInPools(message_t *msg, fe_queue_entry_t *queueEntry) {
    if(call MessagePool.put(msg) != SUCCESS) {
      call CollectionDebug.logEvent(NET_C_FE_PUT_MSGPOOL_ERR);
    }
        
    if(call QEntryPool.put(queueEntry) != SUCCESS) {
      call CollectionDebug.logEvent(NET_C_FE_PUT_QEPOOL_ERR);
    }       
  }
  
  /*
   * Function for preparing a packet for forwarding. Performs
   * a buffer swap from the message pool. If there are no free
   * message in the pool, it returns the passed message and does not
   * put it on the send queue.
   */
  message_t* forward(message_t* m) {
    message_t* newMsg;
    fe_queue_entry_t *qe;
    uint16_t gradient;
  
    if (call MessagePool.empty()) {
      ////printf("Route: %s cannot forward, message pool empty.\n\r", __FUNCTION__);
      call CollectionDebug.logEvent(NET_C_FE_MSG_POOL_EMPTY);
      
    } else if (call QEntryPool.empty()) {
      ////printf("Route: %s cannot forward, queue entry pool empty.\n\r",  __FUNCTION__);
      call CollectionDebug.logEvent(NET_C_FE_QENTRY_POOL_EMPTY);
    
    } else {
      if ((qe = call QEntryPool.get()) == NULL) {
        call CollectionDebug.logEvent(NET_C_FE_GET_MSGPOOL_ERR);
        return m;
      }
      
      if ((newMsg = call MessagePool.get()) == NULL) {
        call CollectionDebug.logEvent(NET_C_FE_GET_QEPOOL_ERR);
        return m;
      }
      
      memset(newMsg, 0, sizeof(message_t));
      memset(m->metadata, 0, sizeof(message_metadata_t));
      
      qe->msg = m;
      qe->client = 0xff;
      qe->retries = MAX_RETRIES;
      
      if (call SendQueue.enqueue(qe) == SUCCESS) {
      
        ////printf("Forwarder,Route: %s forwarding packet %p with queue size %hhu\n\r", __FUNCTION__, m, call SendQueue.size());
        // Loop-detection code:
        if (call CtpInfo.getEtx(&gradient) == SUCCESS) {
        
          // We only check for loops if we know our own metric
          if (call CtpPacket.getEtx(m) <= gradient) {
          
            /*
             * If our etx metric is less than or equal to the etx value
             * on the packet (etx of the previous hop node), then we believe
             * we are in a loop.
             * Trigger a route update and backoff.
             */
            call CtpInfo.triggerImmediateRouteUpdate();
            startRetransmitTimer(LOOPY_WINDOW, LOOPY_OFFSET);
            call CollectionDebug.logEventMsg(NET_C_FE_LOOP_DETECTED,
                call CtpPacket.getSequenceNumber(m), 
                call CtpPacket.getOrigin(m), 
                call AMPacket.destination(m));
          }
        }
        
        if (!call RetransmitTimer.isRunning()) {
          // sendTask is only immediately posted if we don't detect a
          // loop.
          post sendTask();
        }
        
        return newMsg;
        
      } else {
        // There was a problem enqueuing to the send queue.
        putInPools(newMsg, qe);
      }
    }
    
    // NB: at this point, we have a resource acquistion problem.
    // Log the event, and drop the
    // packet on the floor.
    
    call CollectionDebug.logEvent(NET_C_FE_SEND_QUEUE_FULL);
    return m;
  }
  
  ctp_data_header_t *getHeader(message_t* m) {
    return (ctp_data_header_t*) call NormalPacket.getPayload(m, sizeof(ctp_data_header_t));
  }
  
  /***************** Defaults ****************/
  default event void Send.sendDone[uint8_t client](message_t *msg, error_t error) {
  }
  
  default event bool Intercept.forward[collection_id_t collectid](message_t* msg, void* payload, uint8_t len) {
    return TRUE;
  }
  
  default event message_t *Receive.receive[collection_id_t collectid](message_t *msg, void *payload, uint8_t len) {
    return msg;
  }
  
  default event message_t *Snoop.receive[collection_id_t collectid](message_t *msg, void *payload, uint8_t len) {
    return msg;
  }
  
  default command collection_id_t CollectionId.fetch[uint8_t client]() {
    return 0;
  }
  
  default command error_t CollectionDebug.logEvent(uint8_t type) {
    return SUCCESS;
  }
  
  default command error_t CollectionDebug.logEventSimple(uint8_t type, uint16_t arg) {
    return SUCCESS;
  }
  
  default command error_t CollectionDebug.logEventDbg(uint8_t type, uint16_t arg1, uint16_t arg2, uint16_t arg3) {
    return SUCCESS;
  }
  
  default command error_t CollectionDebug.logEventMsg(uint8_t type, uint16_t msg, am_addr_t origin, am_addr_t node) {
    return SUCCESS;
  }
  
  default command error_t CollectionDebug.logEventRoute(uint8_t type, am_addr_t parent, uint8_t hopcount, uint16_t metric) {
    return SUCCESS;
  }
  
}
