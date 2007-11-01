/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration AMReceiver {
  provides interface SSReceiver;
}

implementation {
  components AMReceiverM;
  components SensorSchemeC;

  components ActiveMessageC as MessageC;
  components new AMReceiverC(AM_SENSORSCHEME_MSG) as ReceiverC;
  
  SSReceiver = AMReceiverM;
  AMReceiverM.SSRuntime -> SensorSchemeC;

  AMReceiverM.SplitControl -> MessageC;
  AMReceiverM.AMPacket -> MessageC;  
  AMReceiverM.Packet -> MessageC;
  AMReceiverM.Receive -> ReceiverC;

}
