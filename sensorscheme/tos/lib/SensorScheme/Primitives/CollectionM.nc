/**
 * @author Leon Evers
 */


includes SensorScheme;

module CollectionM {
  provides {
    interface SSSender as CollectSSSender;
    interface SSSender as InterceptSSSender;
    interface SSReceiver as InterceptSSReceiver;
    interface SSPrimitive as Parent;
    interface SSPrimitive as Neighbors;
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

    interface AMPacket as SerialPacket;
    interface AMSend as SerialSend;

    interface Queue<message_t*>;
    interface Pool<message_t>;
    interface Leds;
  }
}

implementation {
  task void serialEchoTask();

  error_t startCollector() {
    error_t result = call CollectControl.start();
    if (result == SUCCESS && TOS_NODE_ID  == COLLECTION_ROOTNODE) {
	    call RootControl.setRoot();
      return call SerialControl.start();
    }
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
    return COLLECTION_ROOTNODE;
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
    return msg; 
  }
  
  task void serialEchoTask() {
    if (call Queue.empty()) {
      return;
    } else {
      uint8_t len, i;
      message_t* msg = call Queue.dequeue();
      uint8_t *ptr = call Packet.getPayload(msg, &len);
      dbg("CollectionM", "Sending packet to serial (from %hu):", call SerialPacket.source(msg));
      for (i = 0; i <  + len; i++) {
        dbg_clear("CollectionM", " %hhx", ptr[i]);
      } dbg_clear("CollectionM", "\n");
      if (!call SerialSend.send(0xffff, msg, call Packet.payloadLength(msg)) == SUCCESS) {
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
  
  event bool Intercept.forward(message_t *msg, void *payload, uint16_t len) {
    signal InterceptSSReceiver.receive(msg, call SerialPacket.source(msg), payload, payload+len);
    return FALSE;
  }
  
  command uint8_t *InterceptSSReceiver.getPayload(message_t* pkt) {
    return (uint8_t *) call Packet.getPayload(pkt, 0);
  }

  event void SerialSend.sendDone(message_t *msg, error_t error) {
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
    return COLLECTION_ROOTNODE;
  }
  
  command error_t InterceptSSSender.send(am_addr_t addr, message_t* pkt, uint8_t *dataEnd) {
    return call CollectSend.send(pkt, dataEnd - call InterceptSSSender.getPayload(pkt));
  }

  default error_t command CollectSend.send(message_t *msg, uint8_t len) {
    return FAIL;
  }
  
  command ss_val_t Parent.eval() {
    am_addr_t parent;
    return ss_makeNum(call CtpInfo.getParent(&parent));
  };
  
  command ss_val_t Neighbors.eval() {
    uint8_t n;
    ss_val_t res = SYM_NIL;
    for(n = call CtpInfo.numNeighbors(); n > 0; n--) {
      res = ss_cons(ss_makeNum(call CtpInfo.getNeighborAddr(n)), res);
    }
    return res;
  };
}
