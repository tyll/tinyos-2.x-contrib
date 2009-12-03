configuration Atm1281UsartStreamC {
  provides {
    interface SplitControl;
    interface UsartStreamReceive as StreamReceive;
    interface UsartStreamSend  as StreamSend;    
  }
  uses interface HplAtm1281Usart as Hpl;  
} implementation {
  components Atm1281UsartByteC as UsartByteP;
  components Atm1281UsartStreamReceiveP as StreamReceiveP, Atm1281UsartStreamSendP as StreamSendP;
  
  UsartByteP.Hpl = Hpl;
  
  SplitControl = UsartByteP;
  
  StreamReceive  = StreamReceiveP;
  StreamSend  = StreamSendP;
  
  StreamReceiveP.ByteReceive -> UsartByteP;
  StreamSendP.ByteSend -> UsartByteP;
  
}
