/*
 * SenZip: a distributed compression service over standard networking components provided here by Collection Tree Protocol (CTP)
 *
 * @ author        Sundeep Pattem
 * @ affiliation   Autonomous Networks Research Group
 * @ institution   University of Southern California
 */

#include "Senzip.h"

configuration SenZipP {
  provides {
    interface StdControl;
    interface Send[uint8_t client];
    interface Receive[collection_id_t id];
    interface Receive as Snoop[collection_id_t];
    interface Intercept[collection_id_t id];

    interface Packet;
    interface CollectionPacket;
    interface CtpPacket;

    interface CtpInfo;
    interface LinkEstimator;
    interface CtpCongestion;
    interface RootControl;    

    interface Set<uint16_t> as Measurements;
    interface StartGathering;
    
    
  }

  uses {
    interface CollectionId[uint8_t client];
    interface CollectionDebug;
  }
}

implementation {

  components MainC, CtpP, LedsC;
  components ActiveMessageC;

  components new AMSenderC(AM_SENZIP_AGG_HEADER) as AggSend;
  components new AMReceiverC(AM_SENZIP_AGG_HEADER) as AggReceive;

  components new AggregationP(AGG_TABLE_SIZE) as Aggregation;

  StdControl = Aggregation;
  MainC.SoftwareInit -> Aggregation;
  Aggregation.RadioControl -> ActiveMessageC;
  Aggregation.AggBeaconSend -> AggSend;
  Aggregation.AggBeaconReceive -> AggReceive;
  Aggregation.Packet -> AggSend;
  
  // choose routing engine
  
  // 1. CTP (dynamic routing) - comment out next line if using fixed routing
  Aggregation.Routing -> CtpP.Compression;

  // 2. Fixed routing - uncomment for testing etc
  /*
  components FixedRoutingP as RouteFixer;
  components new AMReceiverC(AM_FIXRT_MSG) as FixRtReceive;
  Aggregation.Routing -> RouteFixer.Routing;
  RouteFixer.Receive -> FixRtReceive;
  RouteFixer.Leds -> LedsC;
  */
  
  Aggregation.Leds -> LedsC;


  CtpP.FixedRouting -> Aggregation;

  components new PoolC(agg_table_entry_t, 2*MAX_NUM_CHILDREN) as AggTablePoolP;
  Aggregation.TablePool -> AggTablePoolP;

  components new PoolC(agg_queue_entry_t, AGG_BEACON_COUNT) as AggMsgPoolP;
  Aggregation.QEntryPool -> AggMsgPoolP;

  components new QueueC(agg_queue_entry_t*, AGG_BEACON_COUNT) as AggSendQueueP;
  Aggregation.SendQueue -> AggSendQueueP;

  components new TimerMilliC() as BeaconTimer;
  Aggregation.BeaconTimer -> BeaconTimer;

  components new CompressionTempP(AGG_TABLE_SIZE) as Compression;

  StdControl = Compression;
  MainC.SoftwareInit -> Compression;
  Compression.Table -> Aggregation.Table;
  Compression.Intercept -> CtpP.Intercept[0];
  Measurements = Compression;
  StartGathering = Compression;

  components new PoolC(buffer_t, MAX_NUM_CHILDREN) as StoragePoolP;
  Compression.StoragePool -> StoragePoolP;

  components new PoolC(comp_queue_entry_t, COMP_PACKET_COUNT) as CompPoolP;
  Compression.QEntryPool -> CompPoolP;

  components new QueueC(comp_queue_entry_t*, COMP_PACKET_COUNT) as CompSendQueueP;
  Compression.SendQueue -> CompSendQueueP;

  Compression.Send -> CtpP.Send[unique(UQ_CTP_CLIENT)];
  Compression.Packet -> CtpP.Packet;
  components new TimerMilliC() as AllRxTimer;
  Compression.AllRxTimer -> AllRxTimer;
  components new TimerMilliC() as PostSendTaskTimer;
  Compression.PostSendTaskTimer -> PostSendTaskTimer;
  Compression.Leds -> LedsC;

  components new TimerMilliC() as RawDataTimer;
  Compression.RawDataTimer -> RawDataTimer;
  
  components new AMReceiverC(AM_SENZIP_START_MSG) as StartRecC;
  components new AMSenderC(AM_SENZIP_START_MSG) as StartSendC;
  Compression.StartReceive -> StartRecC.Receive;
  Compression.StartSend -> StartSendC.AMSend;
  Compression.StartPacket -> StartSendC.Packet;
  
  
  //Log-Flash
  components RWFlashStorage as storage;
  Aggregation.RWLogger -> storage;
  Aggregation.StorageControl -> storage;

  StdControl = CtpP;
  Send = CtpP;
  Receive = CtpP.Receive;
  Snoop = CtpP.Snoop;
  Intercept = CtpP;

  Packet = CtpP;
  CollectionPacket = CtpP;
  CtpPacket = CtpP;

  CtpInfo = CtpP;
  CtpCongestion = CtpP;
  RootControl = CtpP;

  CollectionId = CtpP;
  CollectionDebug = CtpP;

  LinkEstimator = CtpP;

}
