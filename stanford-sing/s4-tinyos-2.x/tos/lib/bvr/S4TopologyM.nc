module S4TopologyM{
  provides interface S4Topology;
      
  provides interface Init;
}
implementation {

#ifdef TOSSIM
    uint8_t root_beacon_id[N_NODES];
#else
    uint8_t* root_beacon_id;
#endif

    uint8_t n_root_beacons;
    
    command error_t Init.init() {
      int i =0 ;
      n_root_beacons = 0;
  
      dbg("S4-beacon", "S4TopologyM - Init.init\n");
      
#ifdef TOSSIM   

      for (i = 0; i< N_NODES; i++) {
        root_beacon_id[i] = hc_root_beacon_id[i];
        
        if (root_beacon_id[i] != INVALID_BEACON_ID)  {
          n_root_beacons++;
        }
      }
      
      dbg("S4-beacon" , "S4TopologyM; Number of beacons: %d\n", n_root_beacons);
      copy_hc_root_beacon_id[TOS_NODE_ID] = root_beacon_id;      
      
#else

      root_beacon_id = hc_root_beacon_id;
      
#endif

      return SUCCESS;
    }

    command error_t S4Topology.getRootBeaconIDs(uint8_t* array) {
      uint16_t i =0 ;      
    
      for (i = 0; i< N_NODES; i++) {
        array[i] = root_beacon_id[i];
      } 
      
      return SUCCESS; 
    }

    command uint8_t* S4Topology.getRootBeaconIDsPtr() {
      return root_beacon_id;
    }
    
    command error_t S4Topology.setRootBeaconID(uint16_t pos, uint8_t val) {
      if (pos >= N_NODES)
        return FAIL;
     
      root_beacon_id[pos] = val;
      
      return SUCCESS;
    }

    command uint16_t S4Topology.getRootNodesCount() {
      return n_root_beacons;
    }


    command void S4Topology.setRootNodesCount(uint16_t nodesCount){
      n_root_beacons = nodesCount;
    }

}
