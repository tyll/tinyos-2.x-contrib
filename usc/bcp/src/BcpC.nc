#include "Bcp.h"

configuration BcpC{
  provides
  {
    interface StdControl;
    interface Send;
    interface Receive;

    interface Packet;
    interface CollectionPacket;
    interface BcpPacket;

    interface RootControl; 

    interface Get<uint16_t> as getBackpressure;
  }
  uses
  {
    interface BcpDebugIF; 
  }
}
implementation{	
  components BcpForwardingEngineP as Forwarder;	
  components BcpRoutingEngineP as Router;
  components MainC;
  components ActiveMessageC;
  components CC2420PacketC;
  components new PoolC(message_t, FORWARDING_QUEUE_SIZE + SNOOP_QUEUE_SIZE) as MessagePoolP;
  components new PoolC(fe_queue_entry_t, FORWARDING_QUEUE_SIZE) as QEntryPoolP;
  components new PoolC(message_t, SNOOP_QUEUE_SIZE) as SnoopPoolP;
  components new StackC(fe_queue_entry_t*, FORWARDING_QUEUE_SIZE-1) as SendStack;
  components new QueueC(message_t*, SNOOP_QUEUE_SIZE) as SnoopQueue;
  components new TimerMilliC() as RoutingBeaconTimer;
  components new TimerMilliC() as txRetryTimer;
  components new TimerMilliC() as DelayPacketTimer;
  components new AMSenderC(AM_BCP_DATA) as DataSend;
  components new AMReceiverC(AM_BCP_DATA) as DataReceive;
  components new AMSnooperC(AM_BCP_DATA) as DataSnoop;
  components new AMSenderC(AM_BCP_BEACON) as BeaconSend;
  components new AMReceiverC(AM_BCP_BEACON) as BeaconReceive;  
  
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
  
  Forwarder.SendStack   -> SendStack.Stack;
  Forwarder.SnoopQueue  -> SnoopQueue;
  Forwarder.QEntryPool  -> QEntryPoolP;
  Forwarder.MessagePool -> MessagePoolP;
  Forwarder.SnoopPool   -> SnoopPoolP; 
  Forwarder.BeaconTimer -> RoutingBeaconTimer;
  Forwarder.SubSend -> DataSend;
  Forwarder.SubReceive -> DataReceive.Receive;
  Forwarder.SubSnoop -> DataSnoop;
  Forwarder.SubPacket -> DataSend;
  Forwarder.RootControl -> Router.RootControl; 
  Forwarder.RadioControl -> ActiveMessageC.SplitControl;
  Forwarder.DataPacketAcknowledgements -> DataSend.Acks;
  Forwarder.AMDataPacket -> DataSend;
  Forwarder.RouterForwarderIF -> Router.RouterForwarderIF;
  Forwarder.DelayPacketTimer -> DelayPacketTimer;
  Forwarder.BeaconReceive -> BeaconReceive.Receive;
  Forwarder.BeaconSend -> BeaconSend.AMSend;
  Forwarder.BcpDebugIF    =  BcpDebugIF; 
  Forwarder.CC2420PacketBody -> CC2420PacketC;
  Forwarder.txRetryTimer -> txRetryTimer;
  Forwarder.getBackpressure = getBackpressure;
  
  Router.BlacklistTimer -> txRetryTimer;
  Router.BcpDebugIF       =  BcpDebugIF;
 
  MainC.SoftwareInit -> Router.Init;    
  MainC.SoftwareInit -> Forwarder.Init;
  
  StdControl = Router.StdControl;
  StdControl = Forwarder.StdControl;
  
  RootControl = Router.RootControl;

  CollectionPacket = Forwarder.CollectionPacket;
  Packet = Forwarder.Packet;
  Send = Forwarder;
  Receive = Forwarder;
  BcpPacket = Forwarder;
  

}
