/**
 * @author Leon Evers
 */


includes Ctp;

configuration SSCollectionC {
  provides {
    interface SSSender as CollectSSSender;
    interface SSSender as InterceptSSSender;
    interface SSReceiver as InterceptSSReceiver;
    interface SSPrimitive as Parent;
  }
  uses {
    interface Send as CollectSend;
    interface Send as InterceptSend;
    interface Receive as CollectReceive;
    interface Receive as InterceptReceive;
  }
} 

implementation {
  components SensorSchemeC; 
    
  components CollectionM;
  components CollectionC;
  components SerialActiveMessageC;
  components new SerialAMSenderC(AM_SSCOLLECT_MSG);

  components LedsC;
  components new QueueC(message_t*, ROOT_QUEUE_SIZE);

  CollectSSSender = CollectionM.CollectSSSender;
  InterceptSSSender = CollectionM.InterceptSSSender;
  InterceptSSReceiver = CollectionM.InterceptSSReceiver;

  CollectSend = CollectionM.CollectSend;
  InterceptSend = CollectionM.InterceptSend;
  CollectReceive = CollectionM.CollectReceive;
  InterceptReceive = CollectionM.InterceptReceive;
    
  Parent = CollectionM.Parent;

  CollectionM.SerialSend -> SerialAMSenderC;

  CollectionM.SSRuntime -> SensorSchemeC;
  CollectionM.CollectControl -> CollectionC;
  CollectionM.RootControl -> CollectionC;
  CollectionM.Packet -> CollectionC;
  CollectionM.CtpInfo -> CollectionC;
  CollectionM.CtpCongestion -> CollectionC;
  CollectionM.CollectionPacket -> CollectionC;
  
  CollectionM.SerialControl -> SerialActiveMessageC;
  CollectionM.SerialPacket -> SerialActiveMessageC.AMPacket;

  CollectionM.Leds -> LedsC;
  CollectionM.Queue -> QueueC;
  CollectionM.Pool -> SensorSchemeC.MsgPool;
}
