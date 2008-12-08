/**
 * @author Leon Evers
 */


includes printf;

includes SensorScheme;

module CollectionM {
  provides {
    interface SSSender as CollectSSSender;
    interface SSSender as InterceptSSSender;
    interface SSReceiver as InterceptSSReceiver;
    interface SSPrimitive as Etx;
    interface SSPrimitive as Parent;
    interface SSPrimitive as Neighbors;
    interface SSPrimitive as NeighQuality;
  }
  uses {
    interface SSRuntime;

    interface StdControl as CollectControl;
    interface SplitControl as SerialControl;

    interface RootControl;
    interface Send as CollectSend;
    interface Send as InterceptSend;
    interface Receive as CollectReceive;
    interface Receive as InterceptReceive;
    interface Intercept;
    interface Packet;

    interface CollectionPacket;
    interface CtpInfo;
    interface CtpCongestion;

    interface Packet as SerialPacket;
    interface AMPacket as SerialAMPacket;
    interface AMSend as SerialSend[am_id_t id];

    interface Queue<message_t*>;
    interface Pool<message_t>;
    interface Leds;
  }
}

implementation {
  task void serialEchoTask();

  error_t startCollector() {
    error_t result = call CollectControl.start();
    dbg("CollectionM", "running startCollector\n");
    
#if defined(COLLECTION_ROOT) || defined(TOSSIM) 
    if (result == SUCCESS) {
#ifdef TOSSIM
      if (TOS_NODE_ID == 0)
#endif
      {
        dbg("CollectionM", "setting this node as root\n");    
  	    call RootControl.setRoot();
        return call SerialControl.start();
      }
    }
#endif
    return result;
  }
  
  error_t stopCollector() {
    call SerialControl.stop();
    return call CollectControl.stop();
  }

  event void SerialControl.startDone(error_t error) {
  }
  
  event void SerialControl.stopDone(error_t error) {
  }
  
  command error_t CollectSSSender.start() {
    return startCollector();
  }

  command error_t CollectSSSender.stop() {
    return stopCollector();
  }

  command error_t InterceptSSSender.start() {
    return startCollector();
  }

  command error_t InterceptSSSender.stop() {
    return stopCollector();
  }

  event void CollectSend.sendDone(message_t *msg, error_t error) {
    signal CollectSSSender.sendDone(msg, error);
  }
  
  event void InterceptSend.sendDone(message_t *msg, error_t error) {
    signal InterceptSSSender.sendDone(msg, error);
  }
  
  default event void InterceptSSSender.sendDone(message_t *msg, error_t error) {
  }
  
  command ss_val_t CollectSSSender.eval(am_addr_t *addr) {
    //*addr = C_numVal(arg_1);
    return arg_1;
  }
  
  command uint8_t *CollectSSSender.getPayload(message_t* pkt) {
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }
  
  command uint8_t *CollectSSSender.getPayloadEnd(message_t* pkt) {
    return call CollectSSSender.getPayload(pkt) + call Packet.maxPayloadLength();
  }
  
  command am_addr_t CollectSSSender.getDestination(message_t* pkt) {
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
  
  command error_t CollectSSSender.send(am_addr_t addr, message_t* pkt, uint8_t *dataEnd) {
    return call CollectSend.send(pkt, dataEnd - call CollectSSSender.getPayload(pkt));
  }

  command error_t InterceptSSReceiver.start() {
    return startCollector();
  }

  command error_t InterceptSSReceiver.stop() {
    return stopCollector();
  }

  message_t* rootReceive(message_t* msg, void* payload, uint8_t len) {
    dbg("CollectionM", "Received packet at %s from node %hu (tp %hhu, seqno %hhu).\n", 
          sim_time_string(), 
          call CollectionPacket.getOrigin(msg), 
          call CollectionPacket.getType(msg),           
          call CollectionPacket.getSequenceNumber(msg));
    call Leds.led1Toggle();    
    if (!call Queue.size() <= call Queue.maxSize() << 2)  {
      call CtpCongestion.setClientCongested(TRUE);
    }
    if (!call Pool.empty() && call Queue.size() < call Queue.maxSize()) {
      message_t* tmp = call Pool.get();
      call Queue.enqueue(msg);
      post serialEchoTask();
      dbg("CollectionM", "Queuing for serial, size = %hu.\n", call Queue.size());
      return tmp;
    }
    dbg("CollectionM", "Not queued for serial, size = %hu.\n", call Queue.size());
    return msg; 
  }
  
  task void serialEchoTask() {
    if (call Queue.empty()) {
      return;
    } else {
      message_t* msg = call Queue.dequeue();
      uint8_t *ptr = call SerialPacket.getPayload(msg, 0);
      uint8_t i, len = call SerialPacket.payloadLength(msg);      
      am_id_t id = call SerialAMPacket.type(msg);
      am_addr_t addr = call SerialAMPacket.destination(msg);
      dbg("CollectionM", "Sending packet to serial (from %hu):", call SerialAMPacket.source(msg));
      for (i = 0; i <  + len; i++) {
        dbg_clear("CollectionM", " %hhx", ptr[i]);
      } dbg_clear("CollectionM", "\n");
      if (!call SerialSend.send[id](addr, msg, len) == SUCCESS) {
        call Pool.put(msg);
      } 
    }
  }
 
  event message_t* CollectReceive.receive(message_t* msg, void* payload, uint8_t len) {
    return rootReceive(msg, payload, len);
  }
  
  event message_t *InterceptReceive.receive(message_t *msg, void *payload, uint8_t len) {
    return rootReceive(msg, payload, len);
  }
  
  event bool Intercept.forward(message_t *msg, void *payload, uint8_t len) {
    signal InterceptSSReceiver.receive(msg, call SerialAMPacket.source(msg), payload, payload+len);
    return FALSE;
  }
  
  command uint8_t *InterceptSSReceiver.getPayload(message_t* pkt) {
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }

  event void SerialSend.sendDone[am_id_t id](message_t *msg, error_t error) {
    dbg("CollectionM", "Serial send done.\n");
    call Pool.put(msg);
    if (!call Queue.empty()) {
      post serialEchoTask();
    } 
    else {
        call CtpCongestion.setClientCongested(FALSE);
    }
  }

  command ss_val_t InterceptSSSender.eval(am_addr_t *addr) {
    // *addr = C_numVal(arg_1);
    return arg_1;
  }
  
  command uint8_t *InterceptSSSender.getPayload(message_t* pkt) {
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }
  
  command uint8_t *InterceptSSSender.getPayloadEnd(message_t* pkt) {
    return call InterceptSSSender.getPayload(pkt) + call Packet.maxPayloadLength();
  }
  
  command am_addr_t InterceptSSSender.getDestination(message_t* pkt) {
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
  
  command error_t InterceptSSSender.send(am_addr_t addr, message_t* pkt, uint8_t *dataEnd) {
    return call InterceptSend.send(pkt, dataEnd - call InterceptSSSender.getPayload(pkt));
  }

  default error_t command CollectSend.send(message_t *msg, uint8_t len) {
    return FAIL;
  }

  command ss_val_t Etx.eval(){
    uint16_t etx;
    error_t ret;
    ret=call CtpInfo.getEtx(&etx);
    if(ret==SUCCESS){
      return ss_makeNum(etx);
    } else {
      return SYM_FALSE;
    }
  }; 
 
  command ss_val_t Parent.eval() {
    am_addr_t parent;
    error_t res;
    res=call CtpInfo.getParent(&parent);
    if(res==SUCCESS){
      return ss_makeNum(parent);
    } else {
      return SYM_FALSE;
    }
  };
  
  command ss_val_t Neighbors.eval() {
    int8_t n;
    ss_val_t res = SYM_NIL;
    for(n = call CtpInfo.numNeighbors()-1; n >= 0; n--) {
      res = ss_cons(ss_makeNum(call CtpInfo.getNeighborAddr(n)), res);
    }
    return res;
  };

  command ss_val_t NeighQuality.eval() {
    int8_t n;
    ss_val_t res = SYM_NIL;
    for(n = call CtpInfo.numNeighbors()-1; n >= 0; n--) {
      res = ss_cons(ss_cons(ss_makeNum(call CtpInfo.getNeighborAddr(n)), 
        ss_cons(ss_makeNum(call CtpInfo.getNeighborLinkQuality(n)),
          ss_cons(ss_makeNum(call CtpInfo.getNeighborRouteQuality(n)), SYM_NIL))), res);
    }
    return res;
  };
}
