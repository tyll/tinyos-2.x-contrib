configuration SerialSend
{
  provides
  {
    interface StdControl;
    interface ISerialSend;
  }
}
implementation
{
  components SerialSendM, ConsoleC, HPLUARTC;
  components SCache, LedsC as Leds;
  components TimerC, RadioComm as Comm;
  components XE1205RadioC as Radio;

  StdControl = SerialSendM.StdControl;
  StdControl = SCache.StdControl;
  StdControl = Radio.StdControl;
  
  ISerialSend = SerialSendM.ISerialSend;
  
  SerialSendM.ICache -> SCache.ICache;
  SerialSendM.Console -> ConsoleC;
  ConsoleC.HPLUART -> HPLUARTC;
  SerialSendM.Leds -> Leds;
  SerialSendM.Timer -> TimerC.Timer[unique("Timer")];
  SerialSendM.SendMsg -> Comm.SendMsg[AM_ACTIVATEMSG];
  SerialSendM.XE1205Control -> Radio.XE1205Control;
  SerialSendM.XE1205LPL -> Radio.XE1205LPL;
  SerialSendM.CSMAControl -> Radio.CSMAControl;
}
