


configuration SrcAccumSimC
{
  provides
  {
    interface StdControl;
    interface IAccum;
  }

}

implementation
{
  components SrcAccumSimM as SrcAccumM;
  components new TimerMilliC() as Timer0;
  components RuntimeM;
  components MainC;
  components SimEnergyC;
  
  MainC.SoftwareInit -> SrcAccumM.Init;
  

  IAccum = SrcAccumM.IAccum;
  StdControl = SrcAccumM.StdControl;

  SrcAccumM.Timer0 -> Timer0;
  
  SrcAccumM.RuntimeState -> RuntimeM.RuntimeState;
  SrcAccumM.Energy -> SimEnergyC.Energy;

}
