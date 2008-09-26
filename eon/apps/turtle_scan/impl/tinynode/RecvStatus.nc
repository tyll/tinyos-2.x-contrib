configuration RecvStatus
{
  provides
  {
    interface StdControl;
    interface IRecvStatus;
  }
}
implementation
{
  components RecvStatusM;
  components RadioComm as Comm;
  components SCache, LedsC as Leds;

  StdControl = RecvStatusM.StdControl;
  IRecvStatus = RecvStatusM.IRecvStatus;
  
  RecvStatusM.ReceiveMsg -> Comm.ReceiveMsg[AM_STATUSMSG];
  RecvStatusM.ICache -> SCache;
  RecvStatusM.Leds -> Leds;
}
