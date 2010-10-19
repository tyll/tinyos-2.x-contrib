
configuration S4RouterC {
  provides {
    interface StdControl;
    interface S4Send;
    interface S4Receive;
  }
  
}
implementation {
  components  S4RouterM   //StdControl provided
            , S4StateC    //StdControl here
            , S4CommStack //StdControl here 
            //, S4CommandC  //StdControl here
#if defined(PLATFORM_MICA2) || defined(PLATFORM_MICA2DOT)
            , CC1000RadioC
#endif
            
            , RandomLfsrC as Random
            , new TimerMilliC() as Timer
            , new TimerMilliC() as FRSendReplyTimer
            , new TimerMilliC() as FRWaitReplyTimer
            , new TimerMilliC() as PeriodicTimer
            , ActiveMessageC      
            , S4ActiveMessageC 
            
            ;

  #ifdef FAILURE_RECOVERY ////////////// 
     ,LinkEstimatorC
  #endif
  
  components S4TopologyC;

  
  //external
  S4Send = S4RouterM;
  S4Receive = S4RouterM;

  //RouteToInterface = S4CommandC;

  //internal
  
  
  StdControl = S4CommStack;
  StdControl = S4StateC;
  //StdControl = S4CommandC;
  
  StdControl = S4RouterM;
  
  S4RouterM.S4Topology -> S4TopologyC;
  
  S4RouterM.Neighborhood -> S4StateC.S4Neighborhood;
  S4RouterM.Locator -> S4StateC.S4Locator;
  S4RouterM.AMSend -> S4CommStack.AMSend[AM_S4_APP_MSG];
  S4RouterM.Receive -> S4CommStack.Receive[AM_S4_APP_MSG];

  S4RouterM.ForwardDelayTimer -> Timer;
  S4RouterM.Random -> Random;
  S4RouterM.PeriodicTimer -> PeriodicTimer;

  S4RouterM.Packet -> S4ActiveMessageC;
  S4RouterM.AMPacket -> S4ActiveMessageC;
  
  
#ifdef SERIAL_LOGGING  
  components new SerialAMSenderC(AM_SERIALPACKET);
  components new SerialAMSenderC(AM_BEACONSLISTPACKET) as BeaconsListAMSenderC;  
  components SerialActiveMessageC;
  
  S4RouterM.SerialAMSend ->SerialAMSenderC;
  S4RouterM.SerialAMControl -> SerialActiveMessageC;
  S4RouterM.SerialPacketInterface ->SerialAMSenderC;
  
  S4RouterM.BeaconsAMSend -> BeaconsListAMSenderC;  
  S4RouterM.BeaconsPacketInterface -> BeaconsListAMSenderC;
#endif
  
  
  
  #ifdef FAILURE_RECOVERY  ////////////////  
  
  S4RouterM.FRReqSendMsg->S4CommStack.SendMsg[AM_FRREQ_MSG];
  S4RouterM.FRReqReceiveMsg->S4CommStack.ReceiveMsg[AM_FRREQ_MSG];
  S4RouterM.FRRepSendMsg->S4CommStack.SendMsg[AM_FRREQ_MSG];
  S4RouterM.FRRepReveiveMsg->S4CommStack.ReceiveMsg[AM_FRREQ_MSG];
  S4RouterM.FRSendReplyTimer->FRSendReplyTimer;
  S4RouterM.FRWaitReplyTimer->FRWaitReplyTimer;
  S4RouterM.LinkEstimator->LinkEstimatorC;
  
  
  /////////////////////////////////////////
  #endif
 
  
}
