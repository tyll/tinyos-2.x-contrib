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
  components GetGPSM, GpsC, TimerC, NoLeds as Leds, SysTimeC, Water;
  components Main;

  StdControl = Water.StdControl;
  StdControl = GetGPSM.StdControl;
  IGetGPS = GetGPSM.IGetGPS;
  
  GetGPSM.GpsControl -> GpsC.StdControl;
  GetGPSM.GpsFix -> GpsC.GpsFix;
  GetGPSM.GpsTimer -> TimerC.Timer[unique("Timer")];
  GetGPSM.CountTimer -> TimerC.Timer[unique("Timer")];
  GetGPSM.Leds -> Leds.Leds;
  GetGPSM.SysTime -> SysTimeC.SysTime;
  
  GetGPSM.getLevel -> Water.getLevel;
  
}
