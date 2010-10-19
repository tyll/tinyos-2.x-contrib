
includes AM;
includes S4;

interface S4StateCommand {
    /* Set this node's coordinates do the value pointed to by coords
     * The coordinates should be copied, coords must not be assumed safe,
     * and may be changed.
     */
    command error_t setCoordinates(Coordinates * coords);

    /* Get this node's coordinates. coords is made to point to this nodes
     * coords, so that the caller should not change the value pointed to
     * by coords.
     */
    command error_t getCoordinates(Coordinates ** coords);

    /**/
    command error_t startRootBeacon();
    command error_t stopRootBeacon();
    
    #ifdef FW_ROOTBEACON CMD
    ///////////// 
    
    command error_t setRootBeacon(uint8_t n);
    command error_t isRootBeacon(bool *value);
    
    #endif  
    ///////////// 

    command error_t getRootInfo(uint8_t n , S4RootBeacon **r);
    command error_t getNumNeighbors(uint8_t *n);


    ////////////// 
     command uint16_t get_routing_state();
     command uint16_t get_sent_bv();
     command uint16_t get_sent_dv();
    
    ////////////////////////////////


}
