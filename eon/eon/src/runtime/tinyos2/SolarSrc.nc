


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
  components SolarSrcM;
#ifndef TOSSIM
	components SrcAccumC as Accum;
#else
	components SrcAccumSimC as Accum;
#endif

  components new TimerMilliC() as Timer0;
  
  components MainC;
  MainC.SoftwareInit -> SolarSrcM.Init;
  
  
  IEnergySrc = SolarSrcM.IEnergySrc;
  StdControl = SolarSrcM.StdControl;
  StdControl = Accum.StdControl;
  

  SolarSrcM.Timer0 -> Timer0;
  SolarSrcM.IAccum -> Accum.IAccum;  


}
