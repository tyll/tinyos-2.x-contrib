configuration ListenConnection
{
  provides
  {
    interface StdControl;
    interface IListenConnection;
  }
}
implementation
{
  components ListenConnectionM, RadioComm;

  StdControl = ListenConnectionM.StdControl;
  StdControl = RadioComm;
  
  IListenConnection = ListenConnectionM.IListenConnection;
  ListenConnectionM.ReceiveMsg -> RadioComm.ReceiveMsg[AM_ACCEPTMSG];
  
}
