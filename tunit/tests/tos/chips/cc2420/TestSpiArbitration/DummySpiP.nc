
module DummySpiP {
  provides {
    interface SpiByte;
    interface SpiPacket;
  }
}

implementation {

  async command uint8_t SpiByte.write( uint8_t tx ) {
    return 0;
  }
  
  async command error_t SpiPacket.send( uint8_t* txBuf, uint8_t* rxBuf, uint16_t len ) {
    return FAIL;
  }

}

