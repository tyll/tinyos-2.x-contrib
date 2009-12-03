interface UsartByteSend {

  async command error_t send( uint8_t byte );
  async command error_t enableReadyToSend();
  async command error_t disableReadyToSend();
  async command bool isReadyToSend();
  async event void readyToSend();

}
