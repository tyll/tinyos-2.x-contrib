
configuration UARTInterceptComm 
{
  provides {
    interface StdControl;
    interface SendMsg[ uint8_t am ];
    interface ReceiveMsg[ uint8_t am ];
  }
  uses {
    interface StdControl as BottomStdControl;
    interface SendMsg as BottomSendMsg[ uint8_t am ];     
    interface ReceiveMsg as BottomReceiveMsg[ uint8_t am ];
  }
}

implementation {
  components UARTInterceptCommM as Comm
           , DBGSendMsg as UARTPacket
           ;

  StdControl = Comm;
  SendMsg = Comm;
  ReceiveMsg = Comm;

  Comm.BottomStdControl = BottomStdControl;
  Comm.BottomSendMsg    = BottomSendMsg;
  Comm.BottomReceiveMsg = BottomReceiveMsg;

  Comm.UARTControl -> UARTPacket.Control;
  Comm.UARTSend    -> UARTPacket.Send;
}

