includes fluxconst;

configuration GetGPS
{
  provides
  {
    interface StdControl;
    interface IGetGPS;
  }
}
implementation
{
  components GetGPSM, GpsC, TimerC, SysTimeC, ConnMgrC;//, Water;
  components Main, XE1205RadioC as Radio;
  components SrcAccumC;
  components NoLeds as Leds;

  //StdControl = Water.StdControl;
  StdControl = GetGPSM.StdControl;
  IGetGPS = GetGPSM.IGetGPS;
  
  GetGPSM.GpsControl -> GpsC.StdControl;
  GetGPSM.GpsFix -> GpsC.GpsFix;
  GetGPSM.GpsTimer -> TimerC.Timer[unique("Timer")];
  GetGPSM.SNRTimer -> TimerC.Timer[unique("Timer")];
  GetGPSM.LockTimer -> TimerC.Timer[unique("Timer")];
  GetGPSM.SysTime -> SysTimeC.SysTime;
  GetGPSM.ConnMgr -> ConnMgrC.ConnMgr;
  GetGPSM.IAccum -> SrcAccumC.IAccum;
  GetGPSM.Leds -> Leds;
  //GetGPSM.getLevel -> Water.getLevel;
  //GetGPSM.RadioControl -> Radio.StdControl;
}
