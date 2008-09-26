


configuration SolarSrc
{
  provides
  {
    interface StdControl;
    interface IEnergySrc;
	interface IDayNight;
  }

}

implementation
{
  components SolarSrcM, TimerC, SrcAccumC;

  IEnergySrc = SolarSrcM.IEnergySrc;
  StdControl = SolarSrcM.StdControl;
  StdControl = TimerC.StdControl;
  StdControl = SrcAccumC.StdControl;
  IDayNight = SolarSrcM.IDayNight;

  SolarSrcM.Timer -> TimerC.Timer[unique ("Timer")];
  SolarSrcM.IAccum -> SrcAccumC.IAccum;  
  SolarSrcM.IDummyDayNight -> SolarSrcM.IDayNight;

}
