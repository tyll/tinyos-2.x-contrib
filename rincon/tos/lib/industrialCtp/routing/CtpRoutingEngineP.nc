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
 *  The TreeRoutingEngine is responsible for computing the routes for
 *  collection.  It builds a set of trees rooted at specific nodes (roots) and
 *  maintains these trees using information provided by the link estimator on
 *  the quality of one hop links.
 * 
 *  <p>Each node is part of only one tree at any given time, but there is no
 *  difference from the node's point of view of which tree it is part. In other
 *  words, a message is sent towards <i>a</i> root, but which one is not
 *  specified. It is assumed that the roots will work together to have all data
 *  aggregated later if need be.  The tree routing engine's responsibility is
 *  for each node to find the path with the least number of transmissions to
 *  any one root.
 *
 *  <p>The tree is proactively maintained by periodic beacons sent by each
 *  node. These beacons are jittered in time to prevent synchronizations in the
 *  network. All nodes maintain the same <i>average</i> beacon sending rate
 *  (defined by BEACON_INTERVAL +- 50%). The beacon contains the node's parent,
 *  the current hopcount, and the cumulative path quality metric. The metric is
 *  defined as the parent's metric plus the bidirectional quality of the link
 *  between the current node and its parent.  The metric represents the
 *  expected number of transmissions along the path to the root, and is 0 by
 *  definition at the root.
 * 
 *  <p>Every time a node receives an update from a neighbor it records the
 *  information if the node is part of the neighbor table. The neighbor table
 *  keeps the best candidates for being parents i.e., the nodes with the best
 *  path metric. The neighbor table does not store the full path metric,
 *  though. It stores the parent's path metric, and the link quality to the
 *  parent is only added when the information is needed: (i) when choosing a
 *  parent and (ii) when choosing a route. The nodes in the neighbor table are
 *  a subset of the nodes in the link estimator table, as a node is not
 *  admitted in the neighbor table with an estimate of infinity.
 * 
 *  <p>There are two uses for the neighbor table, as mentioned above. The first
 *  one is to select a parent. The parent is just the neighbor with the best
 *  path metric. It serves to define the node's own path metric and hopcount,
 *  and the set of child-parent links is what defines the tree. In a sense the
 *  tree is defined to form a coherent propagation substrate for the path
 *  metrics. The parent is (re)-selected periodically, immediately before a
 *  node sends its own beacon, in the updateRouteTask.
 *  
 *  <p>The second use is to actually choose a next hop towards any root at
 *  message forwarding time.  This need not be the current parent, even though
 *  it is currently implemented as such.
 *
 *  <p>The operation of the routing engine has two main tasks and one main
 *  event: updateRouteTask is called periodically and chooses a new parent;
 *  sendBeaconTask broadcasts the current route information to the neighbors.
 *  The main event is the receiving of a neighbor's beacon, which updates the
 *  neighbor table.
 *  
 *  <p> The interface with the ForwardingEngine occurs through the nextHop()
 *  call.
 * 
 *  <p> Any node can become a root, and routed messages from a subset of the
 *  network will be routed towards it. The RootControl interface allows
 *  setting, unsetting, and querying the root state of a node. By convention,
 *  when a node is root its hopcount and metric are 0, and the parent is
 *  itself. A root always has a valid route, to itself.
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
    interface Timer<TMilli> as RouteTimer;
    interface Random;
    interface CollectionDebug;
    interface CtpCongestion;
  }
}


implementation {


  // Maximimum it takes to hear four beacons
  enum {
    DEATH_TEST_INTERVAL = (CTP_MAX_BEACON_INTERVAL * 4) / (BEACON_INTERVAL / 1024),
  };
  


  /** Don't send updates if the radio is off */
  bool radioOn = FALSE;
  
  /** Controls whether the node's periodic timer will fire. */
  bool running = FALSE;
  
  /** Tells updateNeighbor that the parent was just evicted.*/ 
  bool justEvicted = FALSE;

  /** Route Info */
  route_info_t routeInfo;
  
  /** TRUE if this node is a root node */
  bool isRoot;
  
  /** Buffer for a beacon message */
  message_t beaconMsgBuffer;
  
  /** Routing info about neighbors */
  routing_table_entry routingTable[NEIGHBOR_TABLE_SIZE];
  
  /** XXX */
  uint8_t routingTableActive;

  /** Parent change statistics */
  uint32_t parentChanges;

  /** Route update timer count XXX */
  uint32_t routeUpdateTimerCount;

  uint32_t currentInterval = CTP_MIN_BEACON_INTERVAL;

  uint32_t t; 

  bool tHasPassed;

  
  /***************** Prototypes ****************/
  task void updateRouteTask();
  task void sendBeaconTask();
  
  void chooseAdvertiseTime();
  void resetInterval();
  void decayInterval();
  void remainingInterval();
  bool passLinkEtxThreshold(uint16_t etx);
  uint16_t evaluateEtx(uint16_t quality);
  uint8_t routingTableFind(am_addr_t neighbor);
  error_t routingTableUpdateEntry(am_addr_t from, am_addr_t parent, uint16_t etx);
  error_t routingTableEvict(am_addr_t neighbor);
  void routeInfoInit(route_info_t *ri);
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    routeUpdateTimerCount = 0;
    radioOn = FALSE;
    running = FALSE;
    parentChanges = 0;
    isRoot = 0;
    routeInfoInit(&routeInfo);
    routingTableActive = 0;
    return SUCCESS;
  }

  /***************** StdControl Commands ****************/
  command error_t StdControl.start() {
    
    if (!running) {
      running = TRUE;
      resetInterval();
      call RouteTimer.startPeriodic(BEACON_INTERVAL);
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
  event void RouteTimer.fired() {
    if (radioOn && running) {
      post updateRouteTask();
    }
  }
  
  event void BeaconTimer.fired() {
    if (radioOn && running) {
      if (!tHasPassed) {
        post updateRouteTask();
        post sendBeaconTask();
        ////printf("RoutingTimer Beacon timer fired at %s\n\r");
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
    am_addr_t from;
    ctp_routing_header_t *receiveBeacon;
    bool congested;
    uint16_t currentEtx;
    
    if(!running) {
      return msg;
    }
    
    // Received a beacon, but it's not from us.
    if (len != sizeof(ctp_routing_header_t)) {
      ///printf("LITest: %s, received beacon of size %hhu, expected %i\n\r", __FUNCTION__, len, (int) sizeof(ctp_routing_header_t));
      return msg;
    }
    
    from = call AMPacket.source(msg);
    receiveBeacon = (ctp_routing_header_t *) payload;
    congested = call CtpRoutingPacket.getOption(msg, CTP_OPT_ECN);
    call CtpInfo.getEtx(&currentEtx);
    
    ///printf("TreeRouting: %s from: %d  [ parent: %d etx: %d ]\n\r", __FUNCTION__, from, receiveBeacon->parent, receiveBeacon->etx);
    
    // Update the neighbor table
    if (receiveBeacon->parent != INVALID_ADDR) {

      if (receiveBeacon->etx < currentEtx) {
        call LinkEstimator.insertNeighbor(from);
        
        if(receiveBeacon->etx == 0) {
          call LinkEstimator.pinNeighbor(from);
        }
      }
      
      routingTableUpdateEntry(from, receiveBeacon->parent, receiveBeacon->etx);
      call CtpInfo.setNeighborCongested(from, congested);
    }
    
    if (call CtpRoutingPacket.getOption(msg, CTP_OPT_PULL)) {
      if(routeInfo.parent != INVALID_ADDR) {
        resetInterval();
      }
    }
    
    return msg;
  }


  /***************** LinkEstimator Events ****************/
  /**
   * Signals that a neighbor is no longer reachable. We need special care if
   * that neighbor is our parent
   */
  event void LinkEstimator.evicted(am_addr_t neighbor) {
    routingTableEvict(neighbor);
    
    if(routeInfo.parent == neighbor) {
      routeInfoInit(&routeInfo);
      justEvicted = TRUE;
      post updateRouteTask();
    }
  }


  /***************** UnicastNameFreeRounting Commands ****************/
  command am_addr_t UnicastNameFreeRouting.nextHop() {
    return routeInfo.parent;  
  }
  
  command bool UnicastNameFreeRouting.hasRoute() {
    return (routeInfo.parent != INVALID_ADDR);
  }
   
  
  /***************** CtpInfo Commands ****************/
  command error_t CtpInfo.getParent(am_addr_t* parent) {
    if (parent == NULL || routeInfo.parent == INVALID_ADDR) {
      return FAIL;
    }
    
    *parent = routeInfo.parent;
    return SUCCESS;
  }

  command error_t CtpInfo.getEtx(uint16_t* etx) {
    if (etx == NULL || routeInfo.parent == INVALID_ADDR) {
      return FAIL;
    }
    
    if (isRoot == 1) {
      *etx = 0;
      
    } else {
      // path etx = etx(parent) + etx(link to the parent)
      *etx = routeInfo.etx + evaluateEtx(call LinkEstimator.getLinkQuality(routeInfo.parent));
    }
    return SUCCESS;
  }

  command void CtpInfo.recomputeRoutes() {
    post updateRouteTask();
  }

  command void CtpInfo.triggerRouteUpdate() {
    resetInterval();
  }

  command void CtpInfo.triggerImmediateRouteUpdate() {
    resetInterval();
  }

  command void CtpInfo.setNeighborCongested(am_addr_t n, bool congested) {
#if ECN_ON
    uint8_t idx;
      
    idx = routingTableFind(n);
    
    if (idx < routingTableActive) {
      routingTable[idx].info.congested = congested;
    }
  
    if (routeInfo.congested && !congested) {
      post updateRouteTask();
      
    } else if (routeInfo.parent == n && congested) 
      post updateRouteTask();
    }
#endif
  }

  command bool CtpInfo.isNeighborCongested(am_addr_t n) {
#if ECN_ON
    uint8_t idx;    

    idx = routingTableFind(n);
    if (idx < routingTableActive) {
      return routingTable[idx].info.congested;
    }
#endif

    return FALSE;
  }
  
  command uint8_t CtpInfo.numNeighbors() {
    return routingTableActive;
  }
  
  command uint16_t CtpInfo.getNeighborLinkQuality(uint8_t n) {
    if (n < routingTableActive) {
      return call LinkEstimator.getLinkQuality(routingTable[n].neighbor);
    }
    
    return 0xFFFF;
  }
  
  command uint16_t CtpInfo.getNeighborRouteQuality(uint8_t n) {
    if (n < routingTableActive) {
      return call LinkEstimator.getLinkQuality(routingTable[n].neighbor) + routingTable[n].info.etx;
    }
    
    return 0xFFFF;
  }
  
  command am_addr_t CtpInfo.getNeighborAddr(uint8_t n) {
    if(n < routingTableActive) {
      return routingTable[n].neighbor;
    }
    
    return AM_BROADCAST_ADDR;
  }
  
  /***************** RootControl Commands ****************/
  /** 
   * Sets the current node as a root, if not already a root
   * @return FAIL if it's not possible for some reason
   */
  command error_t RootControl.setRoot() {
    bool routeFound = FALSE;
    routeFound = (routeInfo.parent == INVALID_ADDR);
    
    atomic {
      isRoot = TRUE;
      routeInfo.parent = call AMPacket.address(); //myself
      routeInfo.etx = 0;
    }
    
    if (routeFound) {
      signal UnicastNameFreeRouting.routeFound();
    }
    
    ////printf("TreeRouting: %s I'm a root now!\n\r",__FUNCTION__);
    call CollectionDebug.logEventRoute(NET_C_TREE_NEW_PARENT, routeInfo.parent, 0, routeInfo.etx);
    return SUCCESS;
  }

  command error_t RootControl.unsetRoot() {
    atomic {
      isRoot = FALSE;
      routeInfoInit(&routeInfo);
    }
    
    ////printf("TreeRouting: %s I'm not a root now!\n\r",__FUNCTION__);
    post updateRouteTask();
    return SUCCESS;
  }

  command bool RootControl.isRoot() {
    return isRoot;
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
    
    bool found = FALSE;
    uint16_t pathEtx;
    uint16_t neighEtx;
    int i;
    routing_table_entry *entry;
    ctp_routing_header_t *receiveBeacon;

    if ((call AMPacket.type(msg) != AM_CTP_ROUTING) || (len != sizeof(ctp_routing_header_t))) {
      return FALSE;
    }
    
    receiveBeacon = (ctp_routing_header_t *) payload;
    
    if (receiveBeacon->parent == INVALID_ADDR) {
      return FALSE;
    }
    
    // The node is a root, recommend insertion!
    if (receiveBeacon->etx == 0) {
      return TRUE;
    }
    
    pathEtx = receiveBeacon->etx;

    // See if we find some neighbor that is worse
    for (i = 0; i < routingTableActive && !found; i++) {
      entry = &routingTable[i];
      
      // Ignore parent, since we can't replace it
      if (entry->neighbor != routeInfo.parent) {
        neighEtx = entry->info.etx;
        found |= (pathEtx < neighEtx); 
      }
    }
    
    return found;
  }

  
  /***************** Tasks ****************/
  
  /* updates the routing information, using the info that has been received
   * from neighbor beacons. Two things can cause this info to change: 
   * neighbor beacons, changes in link estimates, including neighbor eviction */
  task void updateRouteTask() {
    uint8_t i;
    routing_table_entry* entry;
    routing_table_entry* best;
    uint16_t minEtx;
    uint16_t currentEtx;
    uint16_t linkEtx;
    uint16_t pathEtx;

    if (isRoot) {
      return;
    }
     
    best = NULL;
    
    /* Minimum etx found among neighbors, initially infinity */
    minEtx = MAX_METRIC;
    
    /* Metric through current parent, initially infinity */
    currentEtx = MAX_METRIC;

    ///printf("TreeRouting: %s\n\r",__FUNCTION__);

    /* Find best path in table, other than our current */
    for (i = 0; i < routingTableActive; i++) {
      entry = &routingTable[i];

      // Avoid bad entries and 1-hop loops
      if (entry->info.parent == INVALID_ADDR || entry->info.parent == call AMPacket.address()) {
        ///printf("TreeRouting: routingTable[%d]: neighbor: [id: %d parent: %d  etx: NO ROUTE]\n\r", i, entry->neighbor, entry->info.parent);
        continue;
      }
      
      // Compute this neighbor's path metric
      linkEtx = evaluateEtx(call LinkEstimator.getLinkQuality(entry->neighbor));
      
      ///printf("TreeRouting: routingTable[%d]: neighbor: [id: %d parent: %d etx: %d]\n\r", i, entry->neighbor, entry->info.parent, linkEtx);
      
      pathEtx = linkEtx + entry->info.etx;
      
      // Operations specific to the current parent
      if (entry->neighbor == routeInfo.parent) {
        ///printf("TreeRouting:    already parent.\n\r");
        
        currentEtx = pathEtx;
        // update routeInfo with parent's current info
        
        routeInfo.etx = entry->info.etx;
        routeInfo.congested = entry->info.congested;        
        continue;
      }
      
      /* Ignore links that are congested or did not pass the threshold */
      if (entry->info.congested || !passLinkEtxThreshold(linkEtx)) {
        continue;
      }
      
      if (pathEtx < minEtx) {
        minEtx = pathEtx;
        best = entry;
      }  
    }
    
    
    /* 
     * Now choose between the current parent and the best neighbor
     *
     * Requires: 
     *   1. at least another neighbor was found with ok quality and not congested
     *   2. the current parent is congested and the other best route is at least as good
     *   3. or the current parent is not congested and the neighbor quality is better by 
     *     the PARENT_SWITCH_THRESHOLD.
     *
     * Note: if our parent is congested, in order to avoid forming loops, we try to select
     * a node which is not a descendent of our parent. routeInfo.ext is our parent's
     * etx. Any descendent will be at least that + 10 (1 hop), so we restrict the 
     * selection to be less than that.
     */
    if (minEtx != MAX_METRIC) {
      if (currentEtx == MAX_METRIC ||
          (routeInfo.congested && (minEtx < (routeInfo.etx + 10))) ||
              minEtx + PARENT_SWITCH_THRESHOLD < currentEtx) {
              
        /*
         * The routeInfo.metric will not store the composed metric.
         * Since the linkMetric may change, we will compose whenever
         * we need it: 
         *   i. when choosing a parent (here); 
         *   ii. when choosing a next hop
         */
        parentChanges++;

        ///printf("TreeRouting: Changed parent. from %d to %d\n\r", routeInfo.parent, best->neighbor);
        call CollectionDebug.logEventDbg(NET_C_TREE_NEW_PARENT, best->neighbor, best->info.etx, minEtx);
        call LinkEstimator.unpinNeighbor(routeInfo.parent);
        call LinkEstimator.pinNeighbor(best->neighbor);
        call LinkEstimator.clearDLQ(best->neighbor);
        
        ///printf("TreeRouting: Attempting to evict %d\n\r", routeInfo.parent);
        call LinkEstimator.evict(routeInfo.parent);
        justEvicted = TRUE;
         
        routeInfo.parent = best->neighbor;
        routeInfo.etx = best->info.etx;
        routeInfo.congested = best->info.congested;
      }
    }
    
    /* 
     * Finally, tell people what happened:
     * We can only lose a route to a parent if it has been evicted. If it 
     * hasn't been just evicted then we already did not have a route 
     */
    if (justEvicted && routeInfo.parent == INVALID_ADDR) {
      signal UnicastNameFreeRouting.noRoute();
      
    /* 
     * On the other hand, if we didn't have a parent (no currentEtx) and now we
     * do, then we signal route found. The exception is if we just evicted the 
     * parent and immediately found a replacement route: we don't signal in this 
     * case 
     */
    } else if (!justEvicted && currentEtx == MAX_METRIC && minEtx != MAX_METRIC) {
      signal UnicastNameFreeRouting.routeFound();
    }
    
    justEvicted = FALSE;
  }

  

  /* 
   * Send a beacon advertising this node's routeInfo
   */
  task void sendBeaconTask() {
    ctp_routing_header_t *beaconMsg = call BeaconSend.getPayload(&beaconMsgBuffer, call BeaconSend.maxPayloadLength());
    
    beaconMsg->options = 0;
    beaconMsg->parent = routeInfo.parent;
    
    /* Congestion notification: am I congested? */
    if (call CtpCongestion.isCongested()) {
      beaconMsg->options |= CTP_OPT_ECN;
    }
    
    if (isRoot) {
      beaconMsg->etx = routeInfo.etx;

    } else if (routeInfo.parent == INVALID_ADDR) {
      beaconMsg->etx = routeInfo.etx;
      call CtpRoutingPacket.setOption(&beaconMsgBuffer, CTP_OPT_PULL);

    } else {
      beaconMsg->etx = routeInfo.etx + evaluateEtx(call LinkEstimator.getLinkQuality(routeInfo.parent));
    }

    ///printf("TreeRouting: %s parent: %d etx: %d\n\r", __FUNCTION__, beaconMsg->parent, beaconMsg->etx);
    
    call CollectionDebug.logEventRoute(NET_C_TREE_SENT_BEACON, beaconMsg->parent, 0, beaconMsg->etx);

    if(call BeaconSend.send(AM_BROADCAST_ADDR, &beaconMsgBuffer, sizeof(ctp_routing_header_t)) == EOFF) {
      radioOn = FALSE;
      ///printf("TreeRouting: %s running: %d radioOn: %d\n\r", __FUNCTION__, running, radioOn);
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
  
  /* Is this quality measure better than the minimum threshold? */
  // Implemented assuming quality is EETX
  bool passLinkEtxThreshold(uint16_t etx) {
    return (etx < ETX_THRESHOLD);
  }

  /* 
   * Converts the output of the link estimator to path metric
   * units, that can be *added* to form path metric measures 
   */
  uint16_t evaluateEtx(uint16_t quality) {
    return (quality + 10);
  }
  
    
  /**
   * Returns the index of parent in the table or routingTableActive if not found 
   */
  uint8_t routingTableFind(am_addr_t neighbor) {
    uint8_t i;
    if (neighbor == INVALID_ADDR) {
      return routingTableActive;
    }
    
    for (i = 0; i < routingTableActive; i++) {
      if (routingTable[i].neighbor == neighbor) {
        break;
      }
    }
    
    return i;
  }


  error_t routingTableUpdateEntry(am_addr_t from, am_addr_t parent, uint16_t etx)  {
    uint8_t idx;
    uint16_t linkEtx;
    
    linkEtx = evaluateEtx(call LinkEstimator.getLinkQuality(from));

    idx = routingTableFind(from);
    
    if (idx == NEIGHBOR_TABLE_SIZE) {
      // Not found and table is full.  This probably should never happen
      // if the LinkEstimator thinks this neighbor is worthy enough to be
      // in our routing table anyway.
      return FAIL;
      
    } else if (idx == routingTableActive) {
      // Not found and there is space
      if (passLinkEtxThreshold(linkEtx)) {
        routingTable[idx].neighbor = from;
        routingTable[idx].info.parent = parent;
        routingTable[idx].info.etx = etx;
        routingTable[idx].info.haveHeard = 1;
        routingTable[idx].info.congested = FALSE;
        routingTableActive++;
        ///printf("TreeRouting: %s OK, new entry\n\r", __FUNCTION__);  
      }
      
    } else {
      //found, just update
      routingTable[idx].neighbor = from;
      routingTable[idx].info.parent = parent;
      routingTable[idx].info.etx = etx;
      routingTable[idx].info.haveHeard = 1;

      ///printf("TreeRouting: %s OK, updated entry, etx=%d\n\r", __FUNCTION__, etx);
    }
    return SUCCESS;
  }
  
  /**
   * If this gets expensive, introduce indirection through an array of pointers 
   */
  error_t routingTableEvict(am_addr_t neighbor) {
    uint8_t idx;
    int i;
    idx = routingTableFind(neighbor);
    
    if (idx == routingTableActive) {
      return FAIL;
    }
    
    routingTableActive--;
    
    for (i = idx; i < routingTableActive; i++) {
      routingTable[i] = routingTable[i+1];  
    } 
    
    return SUCCESS; 
  }
  
  void routeInfoInit(route_info_t *ri) {
    ri->parent = INVALID_ADDR;
    ri->etx = 0;
    ri->haveHeard = 0;
    ri->congested = FALSE;
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
