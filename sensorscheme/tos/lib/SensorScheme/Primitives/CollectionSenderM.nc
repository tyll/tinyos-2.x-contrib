/**
 * @author Leon Evers
 */


includes SensorScheme;

module CollectionSenderM {
  provides interface SSSender;
  uses {
    interface SSRuntime;

    interface StdControl;
    interface Send;
    interface Packet;
    interface CtpInfo;
  }
}

implementation {

  command error_t SSSender.start() {
    return call StdControl.start();
  }

  command error_t SSSender.stop() {
    return call StdControl.stop();
  }

  event void SSSender.sendDone(message_t *msg, error_t error) {
    dbg("SensorSchemeC", "BaseSend completed.\n");
    signal SSSender.sendDone(msg, error);
  }
  
  command ss_val_t SSSender.eval(am_addr_t *addr) {
    dbg("SensorSchemeC", "FN_SEND_LOCAL.\n");
    *addr = C_numVal(arg1);
    return arg2;
  }
  
  command uint8_t *SSSender.getPayload(message_t* pkt) {
    dbg("SensorSchemeC", "CollectionSender.getPayload\n");
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }
  
  command uint8_t *SSSender.getPayloadEnd(message_t* pkt) {
    dbg("SensorSchemeC", "CollectionSender.getPayloadEnd\n");
    return call SSSender.getPayload(pkt) + call Packet.maxPayloadLength();
  }
  
  command am_addr_t SSSender.getDestination(message_t* pkt) {
    dbg("SensorSchemeC", "CollectionSender.getDestination\n");
/* If running in TOSSIM return the COLLECTION_ROOTNODE id (0). else
 * if this node is the root return the id of this node.
 * else return the ID of the parent node.... Not sure if this is the
 * correct behaviour. Might need some debugging
 */
#ifdef TOSSIM
    return COLLECTION_ROOTNODE;
#elif defined(COLLECTION_ROOT)
    return TOS_NODE_ID;
#else
    am_addr_t parent;
    call CtpInfo.getParent(&parent);
    return parent;
#endif
  }
  
  command error_t SSSender.send(am_addr_t addr, message_t* pkt, uint8_t *dataEnd) {
    dbg("SensorSchemeC", "CollectionSender.send\n");
    return call Send.send(pkt, dataEnd - call SSSender.getPayload(pkt));
  }

}
