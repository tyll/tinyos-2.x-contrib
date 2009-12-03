interface UsartByteReceive {

  async command error_t enableReceive();
  async command error_t disableReceive();
  async event void receive( uint8_t byte );
  async event void receiveError();
  async command void flush();
}
