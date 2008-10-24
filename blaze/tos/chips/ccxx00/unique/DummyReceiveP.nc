
module DummyReceiveP {
  provides {
    interface Receive;
  }
}

implementation {

  default event message_t *Receive.receive(message_t *msg,
      void *payload, uint8_t len) {
  }
  
}
