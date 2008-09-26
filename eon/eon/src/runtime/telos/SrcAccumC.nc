
includes adcs;

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
  components SrcAccumM, TimerC, DS2770C, ADCC;

  IAccum = SrcAccumM.IAccum;
  StdControl = SrcAccumM.StdControl;
  StdControl = TimerC.StdControl;
  StdControl = ADCC.StdControl;

  SrcAccumM.Timer -> TimerC.Timer[unique ("Timer")];
  SrcAccumM.DS2770 -> DS2770C;
  SrcAccumM.ADC -> ADCC.ADC[TOS_ADC_A0_PORT];
  SrcAccumM.ADCControl -> ADCC;
  SrcAccumM.LocalTime -> TimerC.LocalTime;


}
