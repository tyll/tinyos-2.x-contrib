configuration SendResponse
{
  provides
  {
    interface StdControl;
    interface ISendResponse;
  }
}
implementation
{
  components SendResponseM, ConnMgrC, RadioComm, TimerC, NoLeds as Leds;

  StdControl = SendResponseM.StdControl;
  ISendResponse = SendResponseM.ISendResponse;
  
  SendResponseM.ConnMgr -> ConnMgrC.ConnMgr;
  SendResponseM.SendMsg -> RadioComm.SendMsg[AM_OFFERMSG];
  SendResponseM.Timer -> TimerC.Timer[unique("Timer")];
  SendResponseM.Leds -> Leds;
}
