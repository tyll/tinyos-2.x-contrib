interface S4Topology{
    command error_t getRootBeaconIDs(uint8_t* array);
    
    command error_t setRootBeaconID(uint16_t pos, uint8_t val);
    
    command uint16_t getRootNodesCount();
    
    command void setRootNodesCount(uint16_t nodesCount);

    command uint8_t* getRootBeaconIDsPtr() ;

}
