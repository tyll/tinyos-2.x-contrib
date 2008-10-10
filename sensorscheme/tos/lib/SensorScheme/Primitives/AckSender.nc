/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration AckSender {
  provides interface SSSender;
}

implementation {
  components AckSenderM;
  components SensorSchemeC;

  components ActiveMessageC as MessageC;
  components new AMSenderC(ACK_SENSORSCHEME_MSG) as SenderC;
  
  SSSender = AckSenderM;
  AckSenderM.SSRuntime -> SensorSchemeC;

  AckSenderM.SplitControl -> MessageC;
  AckSenderM.AMPacket -> MessageC;  
  AckSenderM.Packet -> MessageC;
  AckSenderM.PacketAcknowledgements -> MessageC;
  AckSenderM.AMSend -> SenderC;

}
