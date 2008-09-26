


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
  components SrcAccumM, DS2770C, DS2751C;
  components new TimerMilliC() as Timer0;
  components RuntimeM;
  components MainC;
  
  MainC.SoftwareInit -> SrcAccumM.Init;
  

  IAccum = SrcAccumM.IAccum;
  StdControl = SrcAccumM.StdControl;

  SrcAccumM.Timer0 -> Timer0;
  SrcAccumM.DS2770 -> DS2770C;
  SrcAccumM.DS2751 -> DS2751C;
  
  SrcAccumM.RuntimeState -> RuntimeM.RuntimeState;


}
