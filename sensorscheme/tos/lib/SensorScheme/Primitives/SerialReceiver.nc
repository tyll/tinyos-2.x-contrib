/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration SerialReceiver {
  provides interface SSReceiver;
}

implementation {
  components SerialReceiverM;
  components SensorSchemeC;

  components SerialActiveMessageC as MessageC;
  components new SerialAMReceiverC(AM_SENSORSCHEME_MSG) as ReceiverC;
  
  SSReceiver = SerialReceiverM;
  SerialReceiverM.SSRuntime -> SensorSchemeC;

  SerialReceiverM.SplitControl -> MessageC;
  SerialReceiverM.AMPacket -> MessageC;  
  SerialReceiverM.Packet -> MessageC;
  SerialReceiverM.Receive -> ReceiverC;

}
