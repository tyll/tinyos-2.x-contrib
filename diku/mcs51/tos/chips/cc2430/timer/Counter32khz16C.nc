//#include "Timer.h"

configuration Counter32khz16C
{
  provides interface Counter<T32khz,uint16_t> as Counter;
}
implementation {
  components HplCC2430Timer1AlarmCounterC;

  Counter = HplCC2430Timer1AlarmCounterC.Counter;
}
