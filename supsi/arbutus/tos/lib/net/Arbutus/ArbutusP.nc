

#include "Arbutus.h"



configuration ArbutusP {
  provides {
    interface StdControl;
    interface Send[uint8_t client];
    interface Receive[collection_id_t id];
    interface Intercept[collection_id_t id];

    interface Packet;
    interface dataToControl;
    interface controlToData;
    interface RootControl;    
    interface ArbutusInfo;
  }

  uses {
    interface CollectionId[uint8_t client];
  

    
  }
}

implementation {
  enum {
    CLIENT_COUNT = uniqueCount(UQ_ARBUTUS_CLIENT),
    FORWARD_COUNT = 12,
    QUEUE_SIZE = CLIENT_COUNT + FORWARD_COUNT,
    CACHE_SIZE = 4,
  };

  components ActiveMessageC;
  components RoutingTableP as RoutingTable;
  components new ArbutusDataPlaneP() as DataPlane;
  components new ArbutusControlPlaneP() as ControlPlane;
  components MainC, LedsC;
  components CC2420ActiveMessageC as CC2420;

  
  
  Send = DataPlane;
  StdControl = DataPlane;
  Receive = DataPlane.Receive;
  Intercept = DataPlane;
  Packet = DataPlane;
  CollectionId = DataPlane;
  controlToData = DataPlane;
  dataToControl = ControlPlane;
  DataPlane.dataToControl -> ControlPlane;
  ControlPlane.controlToData -> DataPlane;
  ControlPlane.Packet -> DataPlane;
  ControlPlane.CC2420Packet -> CC2420;
  RoutingTable.CC2420Packet -> CC2420;  
 ControlPlane.Parent -> RoutingTable;

 RoutingTable.SerialSend -> TableEntrySend;
 RoutingTable.TableEntryTimer -> TableEntryTimer;

  StdControl = RoutingTable;

  
  


  components new TimerMilliC() as TableEntryTimer;

  components new TimerMilliC() as RoutingBeaconTimer;

  components new TimerMilliC() as StatsTimer;

  components new TimerMilliC() as PinTimer;
  
 

  components new AMSenderC(AM_ARBUTUS_DATA);
  components new AMReceiverC(AM_ARBUTUS_DATA);
  
  components new AMSenderC(AM_ARBUTUS_ROUTING) as BeaconSend;
  components new SerialAMSenderC(AM_STATS_MSG) as StatsSend;
  components new SerialAMSenderC(AM_ENTRY_MSG) as TableEntrySend;
  components new AMReceiverC(AM_ARBUTUS_ROUTING) as BeaconReceive;


  StdControl = ControlPlane;
  RootControl = ControlPlane;


  MainC.SoftwareInit -> ControlPlane;


RoutingTable.SubAMPacket -> BeaconReceive.AMPacket;
RoutingTable.SubPacket -> BeaconReceive.Packet;

  ControlPlane.AMPacket -> ActiveMessageC;
  ControlPlane.RadioControl -> ActiveMessageC;
  ControlPlane.BeaconTimer -> RoutingBeaconTimer;
   ControlPlane.StatsTimer -> StatsTimer;
   ControlPlane.PinTimer -> PinTimer;


  ControlPlane.BeaconSend -> BeaconSend;
  ControlPlane.StatsSend ->StatsSend;
  RoutingTable.SubReceive -> BeaconReceive;
  ControlPlane.BeaconReceive -> RoutingTable.Receive;
  
  components new TimerMilliC() as RetxmitTimer;
  DataPlane.RetxmitTimer -> RetxmitTimer;
  
    
  components new TimerMilliC() as Watchdog;
  DataPlane.Watchdog -> Watchdog;

  RoutingTable.dataToControl -> ControlPlane;


  components RandomC;
  ControlPlane.Random -> RandomC;
  DataPlane.Random -> RandomC;
  RoutingTable.Random -> RandomC;

  RoutingTable.Routing -> ControlPlane;

  MainC.SoftwareInit -> DataPlane;
  DataPlane.SubSend -> AMSenderC;
  DataPlane.SubReceive -> AMReceiverC;
  DataPlane.SubPacket -> AMSenderC;
  DataPlane.RootControl -> ControlPlane;
  DataPlane.UnicastNameFreeRouting -> ControlPlane.Routing;
  DataPlane.RadioControl -> ActiveMessageC;
  DataPlane.PacketAcknowledgements -> AMSenderC.Acks;
  DataPlane.AMPacket -> AMSenderC;
  DataPlane.Leds -> LedsC;
  ControlPlane.Leds -> LedsC;

  ArbutusInfo=DataPlane;
  
  RoutingTable.dataPlaneFeedback -> DataPlane;
  



 

#if defined(PLATFORM_TELOSB) || defined(PLATFORM_MICAZ)
#ifndef TOSSIM
  components CC2420ActiveMessageC as PlatformActiveMessageC;
#else
  components DummyActiveMessageP as PlatformActiveMessageC;
#endif
#elif defined (PLATFORM_MICA2) || defined (PLATFORM_MICA2DOT)
  components CC1000ActiveMessageC as PlatformActiveMessageC;
#else
  components DummyActiveMessageP as PlatformActiveMessageC;
#endif






}
