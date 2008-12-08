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
    interface Intercept;
  }
} 

implementation {
  components SensorSchemeC; 
    
  components CollectionM;
  components CollectionC;
  components SerialActiveMessageC as Serial;

  components LedsC;
  components new QueueC(message_t*, ROOT_QUEUE_SIZE);

  CollectSSSender = CollectionM.CollectSSSender;
  InterceptSSSender = CollectionM.InterceptSSSender;
  InterceptSSReceiver = CollectionM.InterceptSSReceiver;

  CollectSend = CollectionM.CollectSend;
  InterceptSend = CollectionM.InterceptSend;
  CollectReceive = CollectionM.CollectReceive;
  InterceptReceive = CollectionM.InterceptReceive;
  Intercept = CollectionM.Intercept;
    
  Parent = CollectionM.Parent;

  CollectionM.SerialSend -> Serial;

  CollectionM.SSRuntime -> SensorSchemeC;
  CollectionM.CollectControl -> CollectionC;
  CollectionM.RootControl -> CollectionC;
  CollectionM.Packet -> CollectionC;
  CollectionM.CtpInfo -> CollectionC;
  CollectionM.CtpCongestion -> CollectionC;
  CollectionM.CollectionPacket -> CollectionC;
  
  CollectionM.SerialControl -> Serial;
  CollectionM.SerialPacket -> Serial.Packet;
  CollectionM.SerialAMPacket -> Serial.AMPacket;

  CollectionM.Leds -> LedsC;
  CollectionM.Queue -> QueueC;
  CollectionM.Pool -> SensorSchemeC.MsgPool;
}
