


configuration SolarSrc
{
  provides
  {
    interface StdControl;
    interface IEnergySrc;
  }

}

implementation
{
  components SolarSrcM, TimerC, SrcAccumC;

  IEnergySrc = SolarSrcM.IEnergySrc;
  StdControl = SolarSrcM.StdControl;
  StdControl = TimerC.StdControl;
  StdControl = SrcAccumC.StdControl;
  

  SolarSrcM.Timer = TimerC.Timer[unique ("Timer")];
  SolarSrcM.IAccum = SrcAccumC.IAccum;  


}
