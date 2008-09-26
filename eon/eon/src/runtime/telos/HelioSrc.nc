


configuration HelioSrc
{
  provides
  {
    interface StdControl;
    interface IEnergySrc;
  }

}

implementation
{
  components HelioSrcM, TimerC, SrcAccumC;

  IEnergySrc = HelioSrcM.IEnergySrc;
  StdControl = HelioSrcM.StdControl;
  StdControl = TimerC.StdControl;
  StdControl = SrcAccumC.StdControl;
  

  HelioSrcM.Timer = TimerC.Timer[unique ("Timer")];
  HelioSrcM.IAccum = SrcAccumC.IAccum;  


}
