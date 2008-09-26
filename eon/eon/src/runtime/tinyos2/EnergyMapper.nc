


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
  components EnergyMapperM;
#ifdef TOSSIM  
  components SrcAccumSimC as Accum;
#else
  components SrcAccumC as Accum;
#endif

  IEnergyMap = EnergyMapperM.IEnergyMap;
  StdControl = EnergyMapperM.StdControl;
  StdControl = Accum.StdControl;
  
  EnergyMapperM.IAccum -> Accum.IAccum;  



}
