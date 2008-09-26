configuration RxData
{
  provides
  {
    interface StdControl;
    interface IRxData;
  }
}
implementation
{
  components RxDataM, RadioComm as Comm;


  StdControl = RxDataM.StdControl;
  IRxData = RxDataM.IRxData;
  
  StdControl = Comm.Control;
  
  RxDataM.ReceiveMsg -> Comm.ReceiveMsg[AM_INFECTMSG];
}
