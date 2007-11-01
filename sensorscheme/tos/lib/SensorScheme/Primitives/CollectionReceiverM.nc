/**
 * @author Leon Evers
 */


includes SensorScheme;

module CollectionReceiverM {
  provides interface SSReceiver;
  uses {
    interface SSRuntime;
    interface StdControl;
    interface Packet;
    interface CtpInfo;
#ifdef COLLECTION_ROOT
    interface Receive;
    interface RootControl;
    interface CtpCongestion;
#endif
  }
}

implementation {

  command error_t SSReceiver.start() {
    return call StdControl.start();
  }

  command error_t SSReceiver.stop() {
    return call StdControl.stop();
  }

  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    return signal SSReceiver.receive(msg, call AMPacket.source(msg), payload, payload+len);
  }
  
#ifdef COLLECTION_ROOT
  event message_t* CollectionReceive.receive(message_t* msg,
				   void* payload, uint8_t len) {
    if (!call Pool.size() <= (POOL_SIZE << 2))  {
      call CtpCongestion.setClientCongested(TRUE);
    }
    return receive(RR_COLLECTION, msg, COLLECTION_ROOTNODE, payload, payload + len);
  }
#endif

  command uint8_t *SSReceiver.getPayload(message_t* pkt) {
    dbg("SensorSchemeC", "CollectionReceiver.getPayload\n");
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }
}
