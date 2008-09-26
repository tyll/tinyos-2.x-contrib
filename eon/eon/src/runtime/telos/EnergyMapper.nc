


configuration EnergyMapper
{
  provides
  {
    interface StdControl;
    interface IEnergyMap;
  }

}

implementation
{
  components EnergyMapperM, TimerC, SrcAccumC as Accum;

  IEnergyMap = EnergyMapperM.IEnergyMap;
  StdControl = EnergyMapperM.StdControl;
  StdControl = TimerC.StdControl;
  StdControl = Accum.StdControl;
  

  EnergyMapperM.Timer -> TimerC.Timer[unique ("Timer")];
  EnergyMapperM.IAccum -> Accum.IAccum;  
  EnergyMapperM.LocalTime -> TimerC.LocalTime;


}
