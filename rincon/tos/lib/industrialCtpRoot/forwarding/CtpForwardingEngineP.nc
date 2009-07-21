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
    
    interface Random;
    interface Leds;
    
  }
}

implementation {
  
  enum {
    CLIENT_COUNT = uniqueCount(UQ_CTP_CLIENT)
  };
  
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
   * Keeps track of whether the packet on the head of the queue
   * is being used, and control access to the data-link layer.
   */
  bool sending = FALSE;
  
  /* 
   * The loopback message is for when a collection roots calls
   * Send.send. Since Send passes a pointer but Receive allows
   * buffer swaps, the forwarder copies the sent packet into 
   * the &loopbackMsg and performs a buffer swap with it.
   * See sendTask(). 
   */  
  message_t loopbackMsg;
  
  uint8_t seqno;
  
  /***************** Prototypes ****************/
  
  ctp_data_header_t *getHeader(message_t* m);
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
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
    radioOn = TRUE;
  }
 
  
  event void RadioSplitControl.stopDone(error_t err) {
    radioOn = FALSE;
  }

  /***************** UnicastNameFreeRouting Events ****************/
  /* 
   * If the ForwardingEngine has stopped sending packets because
   * these has been no route, then as soon as one is found, start
   * sending packets.
   */ 
  event void UnicastNameFreeRouting.routeFound() {
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
    collection_id_t collectid = call CollectionId.fetch[client]();
    
    if (!running) {
      return EOFF;
    }
    
    if (len > call Send.maxPayloadLength[client]()) {
      return ESIZE;
    }
    
    call Packet.setPayloadLength(msg, len);
    
    hdr = getHeader(msg);
    
    hdr->origin = call AMPacket.address();
    hdr->originSeqNo = seqno++;
    hdr->type = call CollectionId.fetch[client]();
    hdr->thl = 0;
    
    // Immediate loop back.
    signal Receive.receive[collectid](msg, 
          call Packet.getPayload(msg, call Packet.payloadLength(msg)), 
          call Packet.payloadLength(msg));
    
    signal Send.sendDone[client](msg, SUCCESS);
    return SUCCESS;
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
    return FALSE;
  }

  command void CtpCongestion.setClientCongested(bool congested) {
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

    return signal Receive.receive[collectid](msg, 
        call Packet.getPayload(msg, call Packet.payloadLength(msg)), 
        call Packet.payloadLength(msg));
  }

  event message_t* SubSnoop.receive(message_t* msg, void *payload, uint8_t len) {
    //am_addr_t parent = call UnicastNameFreeRouting.nextHop();
    if(!running) {
      return msg;
    }
    
    // Check for the pull bit (P) [TEP123] and act accordingly.  This
    // check is made for all packets, not just ones addressed to us.
    if (call CtpPacket.option(msg, CTP_OPT_PULL)) {
      call CtpInfo.triggerRouteUpdate();
    }
    
    return signal Snoop.receive[call CtpPacket.getType(msg)](msg, 
        payload + sizeof(ctp_data_header_t), 
        len - sizeof(ctp_data_header_t));
        
  }
  
  
  /***************** Timer Events ****************/

  
  /***************** LinkEstimator Events ****************/
  event void LinkEstimator.evicted(am_addr_t neighbor) {
  }
  
  /***************** Tasks ****************/
  
  /***************** Functions ****************/
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
