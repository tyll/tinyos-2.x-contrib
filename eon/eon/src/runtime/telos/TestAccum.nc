


configuration TestAccum
{
  provides
  {
    interface StdControl;
  }
  

}

implementation
{
  components TestAccumM, RadioComm, TimerC, 
  			EnergyMapper as Mapper, SrcAccumC as Accum;


  StdControl = TestAccumM.StdControl;
  StdControl = TimerC.StdControl;
  StdControl = Mapper.StdControl;
  

  TestAccumM.Timer -> TimerC.Timer[unique ("Timer")];
  TestAccumM.IEnergyMap -> Mapper.IEnergyMap; 
  TestAccumM.SendMsg -> RadioComm.SendMsg[3]; 
  TestAccumM.IAccum -> Accum.IAccum;

}
