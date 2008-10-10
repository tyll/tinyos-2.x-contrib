/**
 * @author Leon Evers
 */


includes SensorScheme;

module AckSenderM {
  provides interface SSSender;
  uses {
    interface SSRuntime;
    interface SplitControl;
    interface Packet;
    interface AMPacket;
    interface PacketAcknowledgements;
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
    if (!call PacketAcknowledgements.wasAcked(msg)) {
      dbg("SensorSchemeC", "NO ACK from AckSender %x, len %u \n", (call SSSender.getPayload(msg))[0], call SSSender.getPayloadEnd(msg) - call SSSender.getPayload(msg));
      if ((call SSSender.getPayload(msg))[call Packet.maxPayloadLength()-1]-- > 0) {
		am_addr_t addr = call AMPacket.destination(msg);
		error_t err;
        dbg("SensorSchemeC", "AckSenderM.sendDone resending.\n");
        err = call AMSend.send(addr, msg, call Packet.payloadLength(msg));
		if (err != SUCCESS) signal SSSender.sendDone(msg, err);
      } else {
        dbg("SensorSchemeC", "AckSenderM.sendDone no more retries.\n");
        signal SSSender.sendDone(msg, FAIL);
      }
    } else {
      dbg("SensorSchemeC", "AckSender %x, len %u was acked\n", (call SSSender.getPayload(msg))[0], call SSSender.getPayloadEnd(msg) - call SSSender.getPayload(msg));
      signal SSSender.sendDone(msg, error);
    }
  }
  
  command ss_val_t SSSender.eval(am_addr_t *addr) {
    dbg("SensorSchemeC", "AckSender.eval.\n");
    *addr = C_numVal(arg_1);
    return arg_2;
  }
  
  command uint8_t *SSSender.getPayload(message_t* pkt) {
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }
  
  command uint8_t *SSSender.getPayloadEnd(message_t* pkt) {
    return call SSSender.getPayload(pkt) + call Packet.maxPayloadLength() - 1;
  }
  
  command am_addr_t SSSender.getDestination(message_t* pkt) {
    return call AMPacket.destination(pkt);
  }
  
  command error_t SSSender.send(am_addr_t addr, message_t* pkt, uint8_t *dataEnd) {
    error_t err = call PacketAcknowledgements.requestAck(pkt);
    dbg("SensorSchemeC", "AckSender.send. %x, len %u \n", (call SSSender.getPayload(pkt))[0], dataEnd - call SSSender.getPayload(pkt));
    if (err == SUCCESS) {
      (call SSSender.getPayload(pkt))[call Packet.maxPayloadLength()-1] = 2;
      return call AMSend.send(addr, pkt, dataEnd - call SSSender.getPayload(pkt));
    } else {
      return err;
    }
  }

}
