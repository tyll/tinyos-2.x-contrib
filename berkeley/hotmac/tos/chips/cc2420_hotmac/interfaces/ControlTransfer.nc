
interface ControlTransfer {

  async event void beacon(message_t* msg, void* payload, uint8_t len);

  event bool xfer();
}
