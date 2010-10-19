
includes S4;
includes nexthopinfo;

interface S4Neighborhood {
  /* This function returns a set of next hop candidates to dest which have
   * distance smaller than min_dist.
   * The next_hop(s) in fallback mode are returned as well
   * The entries in nextHopInfo are ordered:
   *   - by distance
   *   - by quality
   * The fallback entries are located in the same list, after the normal mode
   * entries. 
   * The first fallback entry is TOS_LOCAL_ADDR if and only if we are the closest
   * node to the destination
   */
  
  
  



  #ifdef CRROUTING
  
  command error_t getNextHops( uint16_t dest_addr, uint8_t closest_beacon, uint16_t* next_hop);

  #ifdef FAILURE_RECOVERY
  
  command error_t FR_getNextHops(Coordinates* dest, uint16_t dest_addr, uint16_t min_dist, nextHopInfo* next_hops);

  #endif
  #endif
  
  command am_addr_t getClosestBeaconAddr(uint16_t addr);
  
    


  
}

