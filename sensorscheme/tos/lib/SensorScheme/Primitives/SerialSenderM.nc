/**
 * @author Leon Evers
 */


includes SensorScheme;

module SerialSenderM {
  provides interface SSSender;
  uses {
    interface SSRuntime;
    interface SplitControl;
    interface Packet;
    interface AMPacket;
    interface AMSend;
  }
}

implementation {

  command error_t SSSender.start() {
    return call SplitControl.start();
  }

  command error_t SSSender.stop() {
    return call SplitControl.stop();
  }

  event void SplitControl.startDone(error_t error) {
  }
  
  event void SplitControl.stopDone(error_t error) {
  }

  event void AMSend.sendDone(message_t *msg, error_t error) {
    signal SSSender.sendDone(msg, error);
  }
  
  command ss_val_t SSSender.eval(am_addr_t *addr) {
    dbg("SensorSchemeC", "FN_BCAST.\n");
    *addr = AM_BROADCAST_ADDR;
    return arg_1;
  }
  
  command uint8_t *SSSender.getPayload(message_t* pkt) {
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }
  
  command uint8_t *SSSender.getPayloadEnd(message_t* pkt) {
    return call SSSender.getPayload(pkt) + call Packet.maxPayloadLength();
  }
  
  command am_addr_t SSSender.getDestination(message_t* pkt) {
    return call AMPacket.destination(pkt);
  }
  
  command error_t SSSender.send(am_addr_t addr, message_t* pkt, uint8_t *dataEnd) {
    return call AMSend.send(addr, pkt, dataEnd - call SSSender.getPayload(pkt));
  }

}
