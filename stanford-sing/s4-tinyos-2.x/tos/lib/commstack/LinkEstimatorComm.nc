

configuration LinkEstimatorComm
{
  provides {
    interface Init;
    interface StdControl;
    interface AMSend[ uint8_t am ];
    interface Receive[ uint8_t am ];

    interface FreezeThaw;
  }
  uses {
    interface Init as BottomStdControlInit;
    interface StdControl as BottomStdControl;
    interface AMSend as BottomSendMsg[uint8_t id];
    interface Receive as BottomReceiveMsg[uint8_t id];
  }
}

implementation
{
  components LinkEstimatorCommM as Comm
           , new TimerMilliC() as MinRateTimer
           , LinkEstimatorC as LinkEstimator
           , RandomLfsrC as Random 
#ifdef TOSSIM
#else
           , CC2420PacketC             ///extra
#endif
#ifdef SERIAL_LOGGING
           , new SerialAMSenderC(BVR_UART_ADDR)  //extra 
#endif
           , S4ActiveMessageC  //extra
           , ActiveMessageC    //extra       
	   ;

  Init = Comm;
  StdControl = Comm;
  AMSend = Comm;
  Receive = Comm;

  Comm.BottomStdControlInit = BottomStdControlInit;
  Comm.BottomStdControl = BottomStdControl;
  Comm.BottomSendMsg = BottomSendMsg;
  Comm.BottomReceiveMsg = BottomReceiveMsg;

  FreezeThaw = Comm;
  
 

  Comm.LinkEstimator -> LinkEstimator;
  Comm.LinkEstimatorControl -> LinkEstimator;
  
  Comm.LinkEstimatorControlInit -> LinkEstimator;  ///extra
#ifdef TOSSIM
#else
  Comm.CC2420Packet -> CC2420PacketC;///extra
#endif
  Comm.Packet -> ActiveMessageC;///extra
  Comm.AMPacket -> ActiveMessageC;///extra
  
#ifdef SERIAL_LOGGING  
  Comm.SerialActiveMessagePacket -> SerialAMSenderC.AMPacket;///extra
  Comm.SerialAMSend -> SerialAMSenderC.AMSend;///extra
#endif  
  
  Comm.MinRateTimer -> MinRateTimer;  ///change

  Comm.Random -> Random;
}

