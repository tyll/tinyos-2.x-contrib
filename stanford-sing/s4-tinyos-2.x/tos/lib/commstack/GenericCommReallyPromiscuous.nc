
configuration GenericCommReallyPromiscuous
{
  provides interface Init;
  provides interface StdControl;
  provides interface AMSend[ uint8_t am ];
  provides interface Receive[ uint8_t am ];
}
implementation
{
  components GenericCommReallyPromiscuousM as Comm
           , ActiveMessageC
           , new AMSenderC(AM_S4_APP_MSG)
           , new AMReceiverC(AM_S4_APP_MSG)
           
           , new AMSenderC(AM_S4_BEACON_MSG) as AMBeaconSenderC
           , new AMReceiverC(AM_S4_BEACON_MSG) as AMBeaconReceiverC
           
           , new AMSenderC(AM_LE_REVERSE_LINK_ESTIMATION_MSG) as AMLESenderC
           , new AMReceiverC(AM_LE_REVERSE_LINK_ESTIMATION_MSG) as AMLEReceiverC
           
           , new AMSenderC(AM_DV_MSG) as AMDVSenderC
           , new AMReceiverC(AM_DV_MSG) as AMDVReceiverC
#if defined(PLATFORM_MICA2) || defined (PLATFORM_MICA2DOT)
           , CC1000RadioC as RadioC
#endif
	       ;

  Init = Comm;
  StdControl = Comm;
  AMSend    = Comm;
  Receive = Comm;

  //Comm.BottomStdControl -> BottomComm;
  Comm.BottomSendMsg[AM_S4_APP_MSG] -> AMSenderC;
  Comm.BottomReceiveMsg[AM_S4_APP_MSG] -> AMReceiverC;
  
  Comm.BottomSendMsg[AM_S4_BEACON_MSG] -> AMBeaconSenderC;
  Comm.BottomReceiveMsg[AM_S4_BEACON_MSG] -> AMBeaconReceiverC;
  
  Comm.BottomSendMsg[AM_LE_REVERSE_LINK_ESTIMATION_MSG] -> AMLESenderC;
  Comm.BottomReceiveMsg[AM_LE_REVERSE_LINK_ESTIMATION_MSG] -> AMLEReceiverC;
  
  Comm.BottomSendMsg[AM_DV_MSG] -> AMDVSenderC;
  Comm.BottomReceiveMsg[AM_DV_MSG] -> AMDVReceiverC;
  
  
  Comm.Packet -> AMSenderC.Packet;
  
  Comm.Acks-> ActiveMessageC;

#if defined(PLATFORM_MICA2) || defined(PLATFORM_MICA2DOT)
  Comm.MacControl -> RadioC;
#endif

}
