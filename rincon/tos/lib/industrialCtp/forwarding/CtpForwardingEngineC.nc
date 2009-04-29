
/**
 * @author Philip Levis
 * @author Kyle Jamieson
 * @author David Moss
 */

#include "Ctp.h"

configuration CtpForwardingEngineC {
  provides {
    interface StdControl;
    interface Send[uint8_t client];
    interface Receive[collection_id_t id];
    interface Receive as Snoop[collection_id_t id];
    interface Intercept[collection_id_t id];
    interface CtpCongestion;
  }
  
  uses {
    interface CollectionId[uint8_t client];
  }
}

implementation {

  enum {
    CLIENT_COUNT = uniqueCount(UQ_CTP_CLIENT),
    QUEUE_SIZE = CLIENT_COUNT + FORWARD_COUNT,
  };
  
  components CtpForwardingEngineP;
  StdControl = CtpForwardingEngineP;
  Send = CtpForwardingEngineP;
  Receive = CtpForwardingEngineP.Receive;
  Snoop = CtpForwardingEngineP.Snoop;
  Intercept = CtpForwardingEngineP;
  CtpCongestion = CtpForwardingEngineP;
  CollectionId = CtpForwardingEngineP;
  
  components MainC;
  MainC.SoftwareInit -> CtpForwardingEngineP;
  
  components CtpDataPacketC;
  CtpForwardingEngineP.CtpPacket -> CtpDataPacketC;
  CtpForwardingEngineP.Packet -> CtpDataPacketC;
  
  components CtpRoutingEngineC;
  CtpForwardingEngineP.CtpInfo -> CtpRoutingEngineC;
  CtpForwardingEngineP.UnicastNameFreeRouting -> CtpRoutingEngineC;
  CtpForwardingEngineP.RootControl -> CtpRoutingEngineC;
  
  components new PoolC(message_t, FORWARD_COUNT) as MessagePoolP;
  CtpForwardingEngineP.MessagePool -> MessagePoolP;
  
  components new PoolC(fe_queue_entry_t, FORWARD_COUNT) as QEntryPoolP;
  CtpForwardingEngineP.QEntryPool -> QEntryPoolP;

  components new QueueC(fe_queue_entry_t*, QUEUE_SIZE) as SendQueueP;
  CtpForwardingEngineP.SendQueue -> SendQueueP;

  components new LruCtpMsgCacheC(CACHE_SIZE) as SentCacheP;
  CtpForwardingEngineP.SentCache -> SentCacheP;

  components LinkEstimatorC;
  CtpForwardingEngineP.LinkEstimator -> LinkEstimatorC;
  
  components new TimerMilliC() as RetransmitTimer;
  CtpForwardingEngineP.RetransmitTimer -> RetransmitTimer;

  components new TimerMilliC() as CongestionTimer;
  CtpForwardingEngineP.CongestionTimer -> CongestionTimer;
  
  components RandomC;
  CtpForwardingEngineP.Random -> RandomC;
  
  components ActiveMessageC;
  CtpForwardingEngineP.RadioSplitControl -> ActiveMessageC;
  CtpForwardingEngineP.NormalPacket -> ActiveMessageC;
  
  components new AMSenderC(AM_CTP_DATA);
  CtpForwardingEngineP.SubSend -> AMSenderC;
  CtpForwardingEngineP.NormalPacket -> AMSenderC;
  CtpForwardingEngineP.AMPacket -> AMSenderC;
  CtpForwardingEngineP.PacketAcknowledgements -> AMSenderC;
  
  components new AMReceiverC(AM_CTP_DATA);
  CtpForwardingEngineP.SubReceive -> AMReceiverC;
  
  components new AMSnooperC(AM_CTP_DATA);
  CtpForwardingEngineP.SubSnoop -> AMSnooperC;
  
  components LedsC;
  CtpForwardingEngineP.Leds -> LedsC;
  
  
}
