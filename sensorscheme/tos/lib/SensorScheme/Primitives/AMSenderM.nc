/**
 * @author Leon Evers
 */


includes SensorScheme;

module AMSenderM {
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
    dbg("SensorSchemeC", "AMSender.eval. ");
    *addr = C_numVal(arg_1);
    dbg_clear("SensorSchemeC", "dest = %hx.\n", ss_numVal(arg_1));
    return arg_2;
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
    dbg("SensorSchemeC", "AMSender.send. %x, len %u \n", (call SSSender.getPayload(pkt))[0], dataEnd - call SSSender.getPayload(pkt));
    return call AMSend.send(addr, pkt, dataEnd - call SSSender.getPayload(pkt));
  }

}
