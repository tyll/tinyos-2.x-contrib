
configuration Msp430TimerCommonP
{
  provides interface Msp430TimerEvent as VectorTimerA0;
  provides interface Msp430TimerEvent as VectorTimerA1;
  provides interface Msp430TimerEvent as VectorTimerB0;
  provides interface Msp430TimerEvent as VectorTimerB1;
}
implementation {
    components Msp430TimerCommonImplP, ResourceContextsC;
    Msp430TimerCommonImplP.CPUContext -> ResourceContextsC.CPUContext;

    VectorTimerA0 = Msp430TimerCommonImplP.VectorTimerA0;
    VectorTimerA1 = Msp430TimerCommonImplP.VectorTimerA1;
    VectorTimerB0 = Msp430TimerCommonImplP.VectorTimerB0;
    VectorTimerB1 = Msp430TimerCommonImplP.VectorTimerB1;
}
