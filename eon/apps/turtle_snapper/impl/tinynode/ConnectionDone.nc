configuration ConnectionDone
{
  provides
  {
    interface StdControl;
    interface IConnectionDone;
  }
}
implementation
{
  components ConnectionDoneM, ConnMgrC;

  StdControl = ConnectionDoneM.StdControl;
  IConnectionDone = ConnectionDoneM.IConnectionDone;
  ConnectionDoneM.ConnEnd -> ConnMgrC.ConnEnd;
}
