interface CC2420Transmit {

  command error_t resend(bool useCca);
  async event void sendDone(message_t* msg, error_t error);

}
