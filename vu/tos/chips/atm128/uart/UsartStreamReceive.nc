interface UsartStreamReceive {

  async command error_t receive( uint8_t* buf, uint16_t len );
  async event void receiveDone( uint8_t* buf, uint16_t len, error_t error, uint8_t** newBuf, uint16_t* newLen );
  async command void requestReceiveDone();
  
}
