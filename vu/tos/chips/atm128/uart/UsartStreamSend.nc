interface UsartStreamSend {

  async command error_t send( uint8_t* buf, uint16_t len );
  async event void sendDone( uint8_t* buf, uint16_t len, error_t error, uint8_t** bufPtr, uint16_t* lenPtr );
  async command void requestSendDone();
}
