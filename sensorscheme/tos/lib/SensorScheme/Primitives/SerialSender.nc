/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration SerialSender {
  provides interface SSSender;
}

implementation {
  components SerialSenderM;
  components SensorSchemeC;

  components ActiveMessageC as MessageC;
  components new AMSenderC(AM_SENSORSCHEME_MSG) as SenderC;
  components new AMReceiverC(AM_SENSORSCHEME_MSG) as ReceiverC;
  
  SSSender = SerialSenderM;
  SerialSenderM.SSRuntime -> SensorSchemeC;

  SerialSenderM.SplitControl -> MessageC;
  SerialSenderM.AMPacket -> MessageC;  
  SerialSenderM.Packet -> MessageC;
  SerialSenderM.AMSend -> SenderC;
}
