

configuration S4CommStack {
  provides {
    interface StdControl;
    interface AMSend[ uint8_t am];
    interface Receive[ uint8_t am];
  }
}

implementation {
  components
             FilterLocalCommM
           , LinkEstimatorComm
           , S4QueuedSendComm
           , LinkEstimatorTaggerCommM
           , GenericCommReallyPromiscuous
           , S4ActiveMessageC    ////////////////////////Extra
           , ActiveMessageC       ////////////////////////Extra
#ifdef SERIAL_LOGGING
           , new SerialAMSenderC(BVR_UART_ADDR) ///////////Extra
#endif
           
           ;

/*********** ************/

  StdControl = FilterLocalCommM;
  AMSend    = FilterLocalCommM;
  Receive = FilterLocalCommM;

  S4ActiveMessageC.S4AMPacket -> ActiveMessageC;  ///All BVRActivemessege are extra ????
  S4ActiveMessageC.S4Packet -> ActiveMessageC;
  S4ActiveMessageC.SplitControl -> ActiveMessageC;
  S4ActiveMessageC.S4Acks -> ActiveMessageC;

  FilterLocalCommM.BottomStdControlInit -> LinkEstimatorComm.Init;
  FilterLocalCommM.BottomStdControl -> LinkEstimatorComm.StdControl;
  FilterLocalCommM.BottomSendMsg    -> LinkEstimatorComm.AMSend;
  FilterLocalCommM.BottomReceiveMsg -> LinkEstimatorComm.Receive;
  FilterLocalCommM.AMPacket -> S4ActiveMessageC;////////////////////////??????
  

  LinkEstimatorComm.BottomStdControlInit -> S4QueuedSendComm.Init;
  LinkEstimatorComm.BottomStdControl -> S4QueuedSendComm.StdControl;
  LinkEstimatorComm.BottomSendMsg    -> S4QueuedSendComm.AMSend;
  LinkEstimatorComm.BottomReceiveMsg -> S4QueuedSendComm.Receive;
  
  S4QueuedSendComm.BottomStdControl -> LinkEstimatorTaggerCommM.StdControl;   ///StdControl int is not used Why????
  S4QueuedSendComm.BottomSendMsg    -> LinkEstimatorTaggerCommM.AMSend;
  S4QueuedSendComm.BottomReceiveMsg -> LinkEstimatorTaggerCommM.Receive;

  
  LinkEstimatorTaggerCommM.BottomStdControlInit -> GenericCommReallyPromiscuous;
  LinkEstimatorTaggerCommM.BottomStdControl -> GenericCommReallyPromiscuous;
  LinkEstimatorTaggerCommM.BottomSendMsg    -> GenericCommReallyPromiscuous;
  LinkEstimatorTaggerCommM.BottomReceiveMsg -> GenericCommReallyPromiscuous;
  
  
  LinkEstimatorTaggerCommM.Packet -> S4ActiveMessageC;  /////////Extra added ///place in endif?
  LinkEstimatorTaggerCommM.AMPacket -> S4ActiveMessageC;  ///Extra added

#ifdef SERIAL_LOGGING  
  LinkEstimatorTaggerCommM.SerialActiveMessagePkt -> SerialAMSenderC;  ///extra added
  LinkEstimatorTaggerCommM.SerialAMSend -> SerialAMSenderC.AMSend;  ////extra added
#endif  
  


}
