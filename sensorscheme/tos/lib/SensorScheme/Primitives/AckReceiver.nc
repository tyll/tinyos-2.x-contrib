/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration AckReceiver {
  provides interface SSReceiver;
}

implementation {
  components AckReceiverM;
  components SensorSchemeC;

  components ActiveMessageC as MessageC;
  components new AMReceiverC(ACK_SENSORSCHEME_MSG) as ReceiverC;
  
  SSReceiver = AckReceiverM;
  AckReceiverM.SSRuntime -> SensorSchemeC;

  AckReceiverM.SplitControl -> MessageC;
  AckReceiverM.AMPacket -> MessageC;  
  AckReceiverM.Packet -> MessageC;
  AckReceiverM.Receive -> ReceiverC;

}
