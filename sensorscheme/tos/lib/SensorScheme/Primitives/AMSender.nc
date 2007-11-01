/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration AMSender {
  provides interface SSSender;
}

implementation {
  components AMSenderM;
  components SensorSchemeC;

  components ActiveMessageC as MessageC;
  components new AMSenderC(AM_SENSORSCHEME_MSG) as SenderC;
  
  SSSender = AMSenderM;
  AMSenderM.SSRuntime -> SensorSchemeC;

  AMSenderM.SplitControl -> MessageC;
  AMSenderM.AMPacket -> MessageC;  
  AMSenderM.Packet -> MessageC;
  AMSenderM.AMSend -> SenderC;

}
