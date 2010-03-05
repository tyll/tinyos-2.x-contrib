#include "Bcp.h"
module BcpRoutingEngineP{
  provides{
    interface BcpRouterForwarderIF as RouterForwarderIF;
    interface RootControl;
    interface StdControl;
    interface Init;
  }
  uses{
    interface Timer<TMilli> as BlacklistTimer;
    interface BcpDebugIF;
  }
}
implementation{
	
  uint8_t routingTableActive;
  routing_table_entry routingTable[ROUTING_TABLE_SIZE];
  bool state_is_root;  
  bool running = FALSE;
  
  // Declare this now, define it later.
  void routingTableInit();
	
  command error_t Init.init() {
    running = FALSE;
    state_is_root = FALSE;
    routingTableInit();
    dbg("Routing","%s: TreeRouting initialized.\n", __FUNCTION__); 
    return SUCCESS;
  }	
	
  command error_t StdControl.start() {
    //start will (re)start the sending of messages
    if (!running) {
      running = TRUE;
      dbg("Routing","%s Started.  running: %d\n", __FUNCTION__, running);
    }
    return SUCCESS;
  }
  
  command error_t StdControl.stop() {
    running = FALSE;
    dbg("Routing","%s Stopped.  running: %d\n", __FUNCTION__, running);
    return SUCCESS;
  }
       
   /* The routing table keeps info about neighbor's backpressure,
     * and is used when choosing a next hop.
     * The table is simple: 
     *   - not fragmented (all entries in 0..routingTableActive)
     *   - not ordered
     */

    void routingTableInit() 
    {
      routingTableActive = 0;
    }

    /* Returns the index of parent in the table or
     * routingTableActive if not found */
    uint8_t routingTableFind(am_addr_t neighbor_p) {
      uint8_t i;
      if (neighbor_p == TOS_BCAST_ADDR)
        return routingTableActive;
      for (i = 0; i < routingTableActive; i++) {
        if (routingTable[i].neighbor == neighbor_p)
          break;
      }
      return i;
    }


    error_t routingTableUpdateEntry(am_addr_t from_p, uint16_t backpressure_p)    {
        uint8_t idx;

        idx = routingTableFind(from_p);
        if (idx == ROUTING_TABLE_SIZE) {
            //Not found and table is full
            // Currently don't support replacement
            dbg("WARNING", "%s FAIL, table full\n", __FUNCTION__);
            return FAIL;
        }
        else if (idx == routingTableActive) {
            //not found and there is space
            atomic {
              routingTable[idx].neighbor = from_p;
              routingTable[idx].backpressure = backpressure_p;
              routingTable[idx].linkPacketTxTime = 1;  // Default to 1 MS 
              routingTable[idx].linkETX = 100;         // Initialize to losless link
              routingTable[idx].lastTxNoStreakID = 0;  // Initialization value doesn't really matter
              routingTable[idx].txNoStreakCount = 0;   // Start off with no burst successes
              routingTable[idx].isBurstyNow = 0;       // Start off without burst mode
              routingTableActive++;
            }
            dbg("Routing", "%s OK, new entry idx %d, neighbor %hhu, backpressure %d.\n", __FUNCTION__, routingTableActive-1, from_p, backpressure_p);
        } else {
          //found, just update
          routingTable[idx].backpressure = backpressure_p;
          dbg("Routing", "%s OK, updated entry idx %d, neighbor %hhu, backpressure %d.\n", __FUNCTION__, idx, from_p, backpressure_p);
        }
        return SUCCESS;
    }
	
  /**
   * Used for periodic log activities.
   */
  event void BlacklistTimer.fired()
  {
  }

  command error_t RouterForwarderIF.updateRouting( uint16_t localBackpressure_p ){
    uint8_t compareIdx = 0;
    int32_t compareWeight = 0;
    uint8_t maxWeightIdx = 0;
    int32_t maxWeight = -1;
    am_addr_t bestNeighbor = 0;
    bool     burstNeighborFound = 0;
    uint8_t  bestBurstNeighborIdx = 0;
    uint16_t bestBurstNeighborBackpressure = 0;
  
    if( routingTableActive == 0 )
    {
      // There are no neighbors
      return FAIL;
    }

    atomic{
      uint32_t longLocalBackpressure = localBackpressure_p;
      uint32_t longNeighborBackpressure = 0;
      uint32_t longLinkETX = 0;
      uint32_t longLinkRate = 0;
      for (compareIdx = 0; compareIdx < routingTableActive; compareIdx++) {
        // Scan through the routingTable and find the best neighbor
        //  This is the neighbor with the largest weight value, unless
        //  there exist neighbors with isBurstyNow set, in which case
        //  we send to the bursty neighbor so long as its backpressure value
        //  is strictly less than or equal to the best weight option.

        if( routingTable[compareIdx].isBurstyNow == 1 )
        {
          // Only evaluate an isBurstyNow link once.  If it is selected, then
          //  we will re-set the isBurstyNow bit which is cleared upon first failed
          //  data ack.
          routingTable[compareIdx].isBurstyNow = 0;
          if(  !burstNeighborFound || bestBurstNeighborBackpressure > routingTable[compareIdx].backpressure )
          { 
            burstNeighborFound = 1;
            bestBurstNeighborIdx = compareIdx;
            bestBurstNeighborBackpressure = routingTable[compareIdx].backpressure;
          }
        } else {
          // Convert link transmit time to packets / minute 
          longNeighborBackpressure = routingTable[compareIdx].backpressure;
          longLinkETX = LINK_LOSS_V * routingTable[compareIdx].linkETX / 100;
          longLinkRate = 10000 / routingTable[compareIdx].linkPacketTxTime; // Packets per minute
          compareWeight = (longLocalBackpressure - longNeighborBackpressure - longLinkETX) * longLinkRate;

          if (compareWeight > maxWeight )
          {
              maxWeightIdx = compareIdx;
              maxWeight = compareWeight; 
          }
        }
      }

      if( burstNeighborFound && routingTable[maxWeightIdx].backpressure >= bestBurstNeighborBackpressure )
      {
        // We'll use this burst neighbor, reset the isBurstyNow which we cleared for all bursty links
        maxWeight = (int32_t)localBackpressure_p - (int32_t)bestBurstNeighborBackpressure - LINK_LOSS_V;
        if( maxWeight > 0 )
        {
          // Only preserve isBurstyNow if we are going to route to it during this decisions point.
          //  But what if we are simply stalled, waiting for any neighbor to have proper backlog values?
          call BcpDebugIF.reportValues( localBackpressure_p,bestBurstNeighborBackpressure,0,0,0,0,bestNeighbor,0x12 );
          routingTable[bestBurstNeighborIdx].isBurstyNow = 1;
        }
        bestNeighbor = routingTable[bestBurstNeighborIdx].neighbor;
        maxWeightIdx = bestBurstNeighborIdx;
      } else {
        bestNeighbor = routingTable[maxWeightIdx].neighbor;
      }
    }
    
    if( maxWeight <= 0 )
    {
      // There exists no neighbor that we want to transmit to at this time,
      //  notify the forwarding engine!
      //call BcpDebugIF.reportValues(maxWeight,0,0,0,0,bestNeighbor,maxWeightIdx,0x10);
      return FAIL;
    } 

    // There is a neighbor we should be transmitting to
    //call BcpDebugIF.reportValues(burstNeighborFound, bestBurstNeighborBackpressure,0,0,
    //                             0,routingTable[bestBurstNeighborIdx].neighbor,bestBurstNeighborIdx,0x12);
    //call BcpDebugIF.reportValues(maxWeight,localBackpressure_p,routingTable[maxWeightIdx].backpressure,routingTable[maxWeightIdx].linkETX,
    //                             routingTable[maxWeightIdx].linkPacketTxTime,bestNeighbor,maxWeightIdx,0x11);
    signal RouterForwarderIF.setNextHopAddress(bestNeighbor, routingTable[maxWeightIdx].backpressure);
    return SUCCESS;
  }
  
  command void RouterForwarderIF.txAck(am_addr_t neighbor_p)
  {
  }

  command void RouterForwarderIF.txNoAck(am_addr_t neighbor_p)
  {
    uint8_t routingTableIdx; 
    // If operating on a bursty link, abort
    routingTableIdx = routingTableFind( neighbor_p );
    if (routingTableIdx == ROUTING_TABLE_SIZE) {
      // Trouble, couldn't find neighbor, bad mojo!
      call BcpDebugIF.reportError( 0xAF );
      return;
    }

    // If this link was a wonder child (bursty success) clear it!
    if( routingTable[ routingTableIdx ].isBurstyNow == 1 )
    {
      call BcpDebugIF.reportValues( 0,0,0,0,0,0,neighbor_p,0xA4 );
      routingTable[ routingTableIdx ].isBurstyNow = 0;
    }
  }

  command void RouterForwarderIF.updateLinkSuccess(am_addr_t neighbor_p, uint8_t txCount_p)
  {
    uint32_t newETX;
    uint16_t oldETX;
    uint8_t idx;

    idx = routingTableFind( neighbor_p );
    if( idx == routingTableActive ){
      // Could not find this neighbor, error!
      call BcpDebugIF.reportError( 0x58 );
      return;
    }

    oldETX = routingTable[idx].linkETX;

    // Found neighbor, update link loss rate!
    atomic{
      newETX = routingTable[idx].linkETX;
      newETX = (newETX * LINK_LOSS_ALPHA + txCount_p * 100 * (100 - LINK_LOSS_ALPHA ) ) / 100;
      routingTable[idx].linkETX = (uint16_t)newETX;
    }

    //call BcpDebugIF.reportValues( 0,0,0,oldETX,(uint16_t)newETX,neighbor_p,txCount_p,0x33 );

  }

  command void RouterForwarderIF.updateLinkRate(am_addr_t neighbor_p, uint16_t newLinkPacketTxTime_p)
  {
    uint16_t previousLinkPacketTxTime;
    uint16_t newLinkPacketTxTime;
    uint8_t routingTableIdx = routingTableFind( neighbor_p );

    // Do we need to recompute routes after a updateLinkRate call?
    //  I think perhaps we should (though this may not be absolutely necessary).
    //  Does incur an overhead.

    if( routingTableIdx == routingTableActive ){
      // Neighbor not found?? How is this?
      dbg("ERROR","%s: <neighbor,newLinkPacketTxTime_p>=<%hhu,%u> update failed, can't find neighbor?\n",__FUNCTION__, neighbor_p, newLinkPacketTxTime_p);
      return;
    }

    // Floor the delay value to 1 MS! Should be impossibly fast, but just in case.
    // Otherwise backpressure will be ignored for fast links.
    if(newLinkPacketTxTime_p == 0)
      newLinkPacketTxTime = 1;
    else
      newLinkPacketTxTime = newLinkPacketTxTime_p;

    atomic{
      previousLinkPacketTxTime = routingTable[routingTableIdx].linkPacketTxTime;

      // Update the estimated packet transmission time for the link.
      // Use exponential weighted avg.
      routingTable[routingTableIdx].linkPacketTxTime =
        ((LINK_EST_ALPHA * (uint32_t)routingTable[routingTableIdx].linkPacketTxTime) +
        (10 - LINK_EST_ALPHA)*(uint32_t)newLinkPacketTxTime) / 10;
    }

    dbg("LinkRate","%s: <neighbor_p,previousLinkPacketTxTime,newLinkPacketTxTime,linkPacketTxTime>=<%hhu,%u,%u,%u>\n",
         __FUNCTION__, neighbor_p,previousLinkPacketTxTime,newLinkPacketTxTime,
         routingTable[routingTableIdx].linkPacketTxTime);

    call BcpDebugIF.reportLinkRate(neighbor_p,previousLinkPacketTxTime, newLinkPacketTxTime, 
                                     routingTable[routingTableIdx].linkPacketTxTime, routingTable[routingTableIdx].linkETX);
  }
  
  command uint16_t RouterForwarderIF.getLinkRate(am_addr_t neighbor_p)
  {
    uint8_t routingTableIdx = routingTableFind( neighbor_p );
    
  	if( routingTableIdx == routingTableActive ){
      // Neighbor not found?? How is this?
      dbg("ERROR","%s: can't find neighbor?\n",__FUNCTION__);
      return 0xFFFF;
    }

    return routingTable[routingTableIdx].linkPacketTxTime;
  }

  command void RouterForwarderIF.updateNeighborBackpressure(am_addr_t neighbor_p, uint16_t rcvBackpressure_p)
  {
    /**
     * Update the backpressure associated with the overheard neighbor.
     */
    routingTableUpdateEntry(neighbor_p, rcvBackpressure_p);
  }

  command void RouterForwarderIF.updateNeighborSnoop(uint16_t localBackpressure_p, uint16_t snoopBackpressure_p, 
                                   uint16_t nhBackpressure_p, uint8_t nodeTxCount_p,
                                   am_addr_t neighbor_p, am_addr_t burstNotifyAddr)
  {
    uint8_t idx;

    //call BcpDebugIF.reportValues( localBackpressure_p,snoopBackpressure_p,nhBackpressure_p,0,burstNotifyAddr,nodeTxCount_p,neighbor_p,0xAA );

    /**
     * Update the backpressure associated with the overheard neighbor.
     */
    routingTableUpdateEntry(neighbor_p, snoopBackpressure_p);

    /**
     * Check for burst of successes on the link
     */
    idx = routingTableFind( neighbor_p );
    if( routingTable[idx].lastTxNoStreakID + 1 == nodeTxCount_p )
    {
      // The burst of successes continues! Kudos! Increment stuff.
      routingTable[idx].lastTxNoStreakID++;
      routingTable[idx].txNoStreakCount++;
      //call BcpDebugIF.reportValues( 0,0,0,0,routingTable[idx].lastTxNoStreakID,routingTable[idx].txNoStreakCount,neighbor_p,0xA0 );
      if( routingTable[idx].txNoStreakCount == 3 && localBackpressure_p < nhBackpressure_p)
      {
        // 3 successful sequential transmissions indicates that this is a good link and we
        //  checked that the local backpressure is less than that stored in the snooped packet
        // It's very likely that we are a good link option now, so attempt to notify this neighbor
        call BcpDebugIF.reportValues( 0,0,0,0,0,0,neighbor_p,0xA1 );
        signal RouterForwarderIF.setNotifyBurstyLinkNeighbor(neighbor_p);
      }
    } else {
      // Whoops, lost a transmission, bad! Reset streak
      //call BcpDebugIF.reportValues( 0,0,0,0,0,0,neighbor_p,0xA2 );
      routingTable[idx].lastTxNoStreakID = nodeTxCount_p;
      routingTable[idx].txNoStreakCount = 0;
    }
   
    /**
     * Check to see if this neighbor is telling us we have bursty successes to them.
     */
    if( burstNotifyAddr == TOS_NODE_ID )
    {
      // Set the isBurstyNow bit for this neighbor
      call BcpDebugIF.reportValues( 0,0,0,0,0,0,neighbor_p,0xA3 );
      routingTable[idx].isBurstyNow = 1;
    }
  }

    /* RootControl interface */
    /** sets the current node as a root, if not already a root */
    /*  returns FAIL if it's not possible for some reason      */
    command error_t RootControl.setRoot() {
      state_is_root = 1;
      dbg("Routing","%s I'm a root now!\n",__FUNCTION__);
      return SUCCESS;
    }

    command error_t RootControl.unsetRoot() {
      state_is_root = 0;
      dbg("Routing","%s I'm not a root now!\n",__FUNCTION__);
      return SUCCESS;
    }

    command bool RootControl.isRoot() {
        return state_is_root;
    }

}
