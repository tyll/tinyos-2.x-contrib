interface BcpRouterForwarderIF{
  /**
   * Determines whether a next-hop neighbor exists with
   *  positive weight.
   *  If one does, signals SUCCESS and signals setNextHopAddress()
   *  If not returns FAIL
   */
  command error_t updateRouting( uint16_t localBackpressure_p );

  /**
   * Establishes the next-hop neighbor to be used
   *  by the Forwarding Engine
   *
   *  Also passes on the backpresure value of that neighbor
   * @return active status of the forwarder.
   */
  event void setNextHopAddress(am_addr_t nextHopAddress_p, uint16_t nextHopBackpressure_p);
 
  /**
   * Notifies the forwarding engine that there exist neighbors that have good temporary links,
   *  and that the next data packet header should include this information with the hope that
   *  the neighbor snoops it and re-evaluates the link with the new ETX 1.0
   */
  event void setNotifyBurstyLinkNeighbor(am_addr_t neighbor_p);
 
  /**
   * The following are used to track link transmission
   *  success statistics.
   */
  command void txNoAck(am_addr_t neighbor_p);
  command void txAck(am_addr_t neighbor_p);
  command void updateLinkSuccess(am_addr_t neighbor_p, uint8_t txCount_p);  

  /**
   * updateLinkRate submits a new packet transmit time for exponential averaging.
   *  statistics are kept per link.
   */
  command void     updateLinkRate(am_addr_t neighbor_p, uint16_t newLinkPacketTxTime_p);
  command uint16_t getLinkRate(am_addr_t neighbor_p);

  /**
   * Updates to the backlog information arriving through
   *  either beacons or received data packet headers.
   */
  command void updateNeighborBackpressure(am_addr_t neighbor_p, uint16_t rcvBackpressure_p );

  /**
   * Updates to the backlog information arriving through
   *  snooped neighbor packet headers.
   * Also passes information needed to detect burst link availability (STLE)
   */
  command void updateNeighborSnoop(uint16_t localBackpressure_p, uint16_t snoopBackpressure_p,
                                   uint16_t nhBackpressure_p, uint8_t nodeTxCount_p,
                                   am_addr_t neighbor_p, am_addr_t burstNotifyAddr);
}
