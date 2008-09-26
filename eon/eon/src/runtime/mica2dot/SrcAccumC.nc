


configuration SrcAccumC
{
  provides
  {
    interface StdControl;
    interface IAccum;
  }

}

implementation
{
  components SrcAccumM, TimerC, DS2770C, DS2751C, SysTimeC, NoLeds as Leds;

  IAccum = SrcAccumM.IAccum;
  StdControl = SrcAccumM.StdControl;
  StdControl = TimerC.StdControl;
  

  SrcAccumM.Timer -> TimerC.Timer[unique ("Timer")];
  SrcAccumM.DS2770 -> DS2770C;
  SrcAccumM.DS2751 -> DS2751C;
  SrcAccumM.SysTime -> SysTimeC.SysTime;
  
  SrcAccumM.Leds -> Leds;


}
