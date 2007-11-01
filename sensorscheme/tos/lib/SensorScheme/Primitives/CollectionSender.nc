/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration CollectionSender {
  provides interface SSSender;
}

implementation {
  components CollectionSenderM;
  components SensorSchemeC;

  components CollectionC as Collector;
  components new CollectionSenderC(CL_SENSORSCHEME_MSG);
  
  SSSender = CollectionSenderM;
  CollectionSenderM.SSRuntime -> SensorSchemeC;

  CollectionSenderM.SplitControl -> MessageC;
  CollectionSenderM.AMPacket -> MessageC;  
  CollectionSenderM.Packet -> MessageC;
  CollectionSenderM.AMSend -> SenderC;

}
