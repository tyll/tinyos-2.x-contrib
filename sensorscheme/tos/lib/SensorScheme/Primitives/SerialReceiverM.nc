/**
 * @author Leon Evers
 */


includes SensorScheme;

module SerialReceiverM {
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
    return signal SSReceiver.receive(msg, call AMPacket.source(msg), payload, payload+len);
  }
  
  command uint8_t *SSReceiver.getPayload(message_t* pkt) {
    dbg("SensorSchemeC", "SerialReceiver.getPayload\n");
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }
}
