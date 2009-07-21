/*
 * "Copyright (c) 2005 The Regents of the University  of California.  
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
 */

/** 
 *  This is a stripped down routing engine for a root node.  Dedicated
 *  root nodes don't need to keep track of their neighbors, so we save a lot
 *  of memory by dumbing it down to the minimum functionality.
 *  
 *  @author Rodrigo Fonseca
 *  @author Philip Levis (added trickle-like updates)
 *  @author David Moss
 *  Acknowledgment: based on MintRoute, MultiHopLQI, BVR tree construction, Berkeley's MTree
 *  
 *  @see Net2-WG
 */
 
#include "CtpRoutingEngine.h"
#include "CtpDebugMsg.h"

module CtpRoutingEngineP {
  provides {
    interface Init;
    interface StdControl;
    interface UnicastNameFreeRouting;
    interface RootControl;
    interface CtpInfo;

    interface CompareBit;
  }
  
  uses {
    interface AMSend as BeaconSend;
    interface Receive as BeaconReceive;
    interface LinkEstimator;
    interface CtpRoutingPacket;
    interface AMPacket;
    interface SplitControl as RadioSplitControl;
    interface Timer<TMilli> as BeaconTimer;
    interface Random;
    interface CollectionDebug;
    interface CtpCongestion;
  }
}


implementation {

  
  /** Don't send updates if the radio is off */
  bool radioOn = FALSE;
  
  /** Controls whether the node's periodic timer will fire. */
  bool running = FALSE;
  
  /** Buffer for a beacon message */
  message_t beaconMsgBuffer;
  
  uint32_t currentInterval = CTP_MIN_BEACON_INTERVAL;

  uint32_t t; 

  bool tHasPassed;

  
  /***************** Prototypes ****************/
  void sendBeaconTask();
  
  void chooseAdvertiseTime();
  void resetInterval();
  void decayInterval();
  void remainingInterval();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    radioOn = FALSE;
    running = FALSE;
    return SUCCESS;
  }

  /***************** StdControl Commands ****************/
  command error_t StdControl.start() {
    if (!running) {
      running = TRUE;
      sendBeaconTask();
      resetInterval();
    }
    
    return SUCCESS;
  }

  command error_t StdControl.stop() {
    running = FALSE;
    return SUCCESS;
  } 

  /***************** RadioSplitControl Events ****************/
  event void RadioSplitControl.startDone(error_t error) {
    uint16_t nextInt;
    radioOn = TRUE;
    
    if (running) {
      nextInt = call Random.rand16() % BEACON_INTERVAL;
      nextInt += BEACON_INTERVAL >> 1;
      call BeaconTimer.startOneShot(nextInt);
    }
  } 

  event void RadioSplitControl.stopDone(error_t error) {
    radioOn = FALSE;
  }


  /***************** BeaconSend Events ****************/
  event void BeaconSend.sendDone(message_t* msg, error_t error) {
  }

  /***************** Timer Events ****************/
  event void BeaconTimer.fired() {
    if (radioOn && running) {
      if (!tHasPassed) {
        sendBeaconTask();
        remainingInterval();
        
      } else {
        decayInterval();
      }
    }
  }

  
  /***************** Receive Events ****************/
  /**
   * Handle the receiving of beacon messages from the neighbors. We update the
   * table, but wait for the next route update to choose a new parent 
   */
  event message_t *BeaconReceive.receive(message_t *msg, void *payload, uint8_t len) {
    if(!running) {
      return msg;
    }
    
    // Received a beacon, but it's not from us.
    if (len != sizeof(ctp_routing_header_t)) {
      return msg;
    }
    
    if (call CtpRoutingPacket.getOption(msg, CTP_OPT_PULL)) {
      resetInterval();
    }
    
    return msg;
  }


  /***************** LinkEstimator Events ****************/
  /**
   * Signals that a neighbor is no longer reachable. We need special care if
   * that neighbor is our parent
   */
  event void LinkEstimator.evicted(am_addr_t neighbor) {
  }


  /***************** UnicastNameFreeRounting Commands ****************/
  command am_addr_t UnicastNameFreeRouting.nextHop() {
    return call AMPacket.address();  
  }
  
  command bool UnicastNameFreeRouting.hasRoute() {
    return TRUE;
  }
   
  
  /***************** CtpInfo Commands ****************/
  command error_t CtpInfo.getParent(am_addr_t* parent) {
    *parent = call AMPacket.address();
    return SUCCESS;
  }

  command error_t CtpInfo.getEtx(uint16_t* etx) {
    *etx = 0;
    return SUCCESS;
  }

  command void CtpInfo.recomputeRoutes() {
  }

  command void CtpInfo.triggerRouteUpdate() {
    resetInterval();
  }

  command void CtpInfo.triggerImmediateRouteUpdate() {
    resetInterval();
  }

  command void CtpInfo.setNeighborCongested(am_addr_t n, bool congested) {
  }

  command bool CtpInfo.isNeighborCongested(am_addr_t n) {
    return FALSE;
  }
  
  command uint8_t CtpInfo.numNeighbors() {
    return 0;
  }
  
  command uint16_t CtpInfo.getNeighborLinkQuality(uint8_t n) {
    return 0xFFFF;
  }
  
  command uint16_t CtpInfo.getNeighborRouteQuality(uint8_t n) {
    return 0xFFFF;
  }
  
  command am_addr_t CtpInfo.getNeighborAddr(uint8_t n) {
    return AM_BROADCAST_ADDR;
  }
  
  /***************** RootControl Commands ****************/
  /** 
   * Sets the current node as a root, if not already a root
   * @return FAIL if it's not possible for some reason
   */
  command error_t RootControl.setRoot() {
    return SUCCESS;
  }

  command error_t RootControl.unsetRoot() {
    return FAIL;
  }

  command bool RootControl.isRoot() {
    return TRUE;
  }


  /***************** CompareBit Commands ****************/
  /** 
   * This should see if the node should be inserted in the table.
   * 
   * If the whiteBit is set, this means the link layer believes this is a good
   * first hop link. 
   * 
   * The link will be recommended for insertion if it is better* than some
   * link in the routing table that is not our parent.
   * 
   * We are comparing the path quality up to the node, and ignoring the link
   * quality from us to the node. This is because of a couple of things:
   * 
   *   1. Because of the white bit, we assume that the 1-hop to the candidate
   *    link is good (say, etx=1)
   *
   *   2. We are being optimistic to the nodes in the table, by ignoring the
   *    1-hop quality to them (which means we are assuming it's 1 as well)
   *    This actually sets the bar a little higher for replacement
   *
   *   3. This is faster
   *
   *   4. It doesn't require the link estimator to have stabilized on a link
   */
   command bool CompareBit.shouldInsert(message_t *msg, void* payload, uint8_t len, bool whiteBit) {
    return FALSE;
  }

  
  /***************** Tasks ****************/
  

  /* 
   * Send a beacon advertising this node's routeInfo
   */
  void sendBeaconTask() {
    ctp_routing_header_t *beaconMsg = call BeaconSend.getPayload(&beaconMsgBuffer, call BeaconSend.maxPayloadLength());
    
    beaconMsg->options = 0;
    beaconMsg->parent = call AMPacket.address();
    beaconMsg->etx = 0;

    if(call BeaconSend.send(AM_BROADCAST_ADDR, &beaconMsgBuffer, sizeof(ctp_routing_header_t)) == EOFF) {
      radioOn = FALSE;
    }
  }
  

  /***************** Functions ****************/
  void chooseAdvertiseTime() {
     t = currentInterval;
     t /= 2;
     t += call Random.rand32() % t;
     tHasPassed = FALSE;
     call BeaconTimer.startOneShot(t);
  }
  
  void resetInterval() {
    currentInterval = CTP_MIN_BEACON_INTERVAL;
    chooseAdvertiseTime();
  }
  
  void decayInterval() {
    currentInterval *= 2;
    
    if(call BeaconTimer.getNow() < CTP_SETUP_DURATION) {
      if(currentInterval > CTP_SETUP_MAX_BEACON_INTERVAL) {
        currentInterval = CTP_SETUP_MAX_BEACON_INTERVAL;
      }

    } else {
      if (currentInterval > CTP_MAX_BEACON_INTERVAL) {
        currentInterval = CTP_MAX_BEACON_INTERVAL;
      }
    }
    
    chooseAdvertiseTime();
  }

  void remainingInterval() {
     uint32_t remaining = currentInterval;
     remaining -= t;
     tHasPassed = TRUE;
     call BeaconTimer.startOneShot(remaining);
  }
  
  
  
  /***************** Defaults ****************/
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
  
  default command error_t CollectionDebug.logEventRoute(uint8_t type, am_addr_t parent, uint8_t hopcount, uint16_t etx) {
    return SUCCESS;
  }

  
  default event void UnicastNameFreeRouting.noRoute() {
  }
  
  default event void UnicastNameFreeRouting.routeFound() {
  }
  
} 
