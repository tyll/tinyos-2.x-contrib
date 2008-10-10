/**
 * @author Leon Evers
 */


includes SensorScheme;
includes message;

module AckReceiverM {
  provides interface SSReceiver;
  uses {
    interface SSRuntime;
    interface SplitControl;
    interface Packet;
    interface AMPacket;
    interface Receive;
  }
}

implementation {
  uint8_t seqno = 0;
  am_addr_t addr = 0;
  
  command error_t SSReceiver.start() {
    return call SplitControl.start();
  }

  command error_t SSReceiver.stop() {
    return call SplitControl.stop();
  }

  event void SplitControl.startDone(error_t error) {
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    dbg("SensorSchemeDebug", "received AckReceiverM.receive from %u.\n", call AMPacket.source(msg));
    if (((uint8_t *)payload)[0] & MSGSEQ_START) {
      // hold small cache of recent messages
      if (((uint8_t *)payload)[0] == seqno && call AMPacket.source(msg) == addr) {
        dbg("SensorSchemeC", "received duplicate %hhx, %hu", seqno, addr);
        return msg; // copy of previous message, ignore
      }
        seqno = ((uint8_t *)payload)[0];
        addr = call AMPacket.source(msg);
    }
    return signal SSReceiver.receive(msg, call AMPacket.source(msg), payload, payload+len);
  }
  
  command uint8_t *SSReceiver.getPayload(message_t* pkt) {
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }
}
