configuration WaterCheck
{
  provides
  {
    interface StdControl;
    interface IWaterCheck;
  }
}
implementation
{
  components WaterCheckM, Water, TimerC, LedsC as Leds;

  StdControl = WaterCheckM.StdControl;
  StdControl = TimerC.StdControl;
  
  IWaterCheck = WaterCheckM.IWaterCheck;
  WaterCheckM.WaterControl -> Water.StdControl;
  WaterCheckM.Timer -> TimerC.Timer[unique("Timer")];
  WaterCheckM.Leds -> Leds;
  WaterCheckM.getLevel -> Water.getLevel;
}
