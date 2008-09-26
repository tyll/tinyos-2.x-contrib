includes ServerE;

configuration Listen
{
  provides
  {
    interface StdControl;
    interface IListen;
  }
}
implementation
{
  components ListenM, RadioComm, LedsC as Leds,TimerC;

  StdControl = ListenM.StdControl;
  StdControl = RadioComm.Control;
  IListen = ListenM.IListen;
  ListenM.ReceiveMsg -> RadioComm.ReceiveMsg[AM_REQUESTMSG];
  ListenM.Leds -> Leds;
  
}
