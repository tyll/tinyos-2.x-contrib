/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration CollectionReceiver {
  provides interface SSReceiver;
}

implementation {
  components CollectionReceiverM;
  components SensorSchemeC;

  components CollectionC as Collector;
  components new CollectionSenderC(CL_SENSORSCHEME_MSG);
  
  SSReceiver = CollectionReceiverM;
  CollectionReceiverM.SSRuntime -> SensorSchemeC;

  CollectionReceiverM.SplitControl -> MessageC;
  CollectionReceiverM.AMPacket -> MessageC;  
  CollectionReceiverM.Packet -> MessageC;
  CollectionReceiverM.Receive -> ReceiverC;

}
