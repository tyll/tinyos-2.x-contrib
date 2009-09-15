

interface DepthControl {


    event void depthUpdate(uint8_t hopcount);
    
    event void slowDown();
    event void speedUp();
    
    command am_addr_t myaddress();
    
}
