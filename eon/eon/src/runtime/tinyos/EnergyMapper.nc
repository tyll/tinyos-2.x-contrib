


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
  components EnergyMapperM, SrcAccumC as Accum, NoLeds as Leds;

  IEnergyMap = EnergyMapperM.IEnergyMap;
  StdControl = EnergyMapperM.StdControl;
  
  StdControl = Accum.StdControl;
  

  //EnergyMapperM.Timer -> TimerC.Timer[unique ("Timer")];
  EnergyMapperM.IAccum -> Accum.IAccum;  
  //EnergyMapperM.LocalTime -> TimerC.LocalTime;
  //EnergyMapperM.SysTime -> SysTimeC.SysTime;
  EnergyMapperM.Leds -> Leds;


}
