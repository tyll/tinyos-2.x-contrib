/**
 * CounterMicro16C provides a 16-bit TMicro counter.
 * It uses 2 hw timers, one generates a micro tick and the other
 * counts the ticks.
 *
 * @author Henrik Makitaavola
 * @see  Please refer to TEP 102 for more information about this component.
 */

#include "TimerConfig.h"

configuration CounterMicro16C
{
  provides interface Counter<TMicro,uint16_t>;
}
implementation
{
  components new M16c62pCounter16C(TMicro) as CounterFrom;
  components new M16c62pTimerBInitC(TMR_COUNTER_MODE, M16C_TMRB_CTR_ES_TBj, 0xFFFF, true, true) as CounterInit;
  components new M16c62pTimerBInitC(TMR_TIMER_MODE, M16C_TMR_CS_F1_2, (MAIN_CRYSTAL_SPEED - 1), false, true) as TimerSourceInit;

  components HplM16c62pTimerC as Timers,
      PlatformP;
  
  CounterFrom.Timer -> Timers.COUNTER_MICRO16;
  CounterInit -> Timers.COUNTER_MICRO16;
  CounterInit -> Timers.COUNTER_MICRO16_CTRL;
  PlatformP.SubInit -> CounterInit;
  Counter = CounterFrom;

  // Timer source
  TimerSourceInit -> Timers.COUNTER_MICRO16_SOURCE;
  TimerSourceInit -> Timers.COUNTER_MICRO16_SOURCE_CTRL;
  PlatformP.SubInit -> TimerSourceInit;
}
