/**
 * RV8564AlarmCounterMilli32C provides a 32-bit TMilli alarm and counter.
 * The counter and alarm is driven by the RV8564 chip on Mulle. This
 * allows the M16c/62p mcu to be put into stop mode even when the timers
 * are running.
 *
 * @author Henrik Makitaavola
 * @see  Please refer to TEP 102 for more information about this component.
 */

#include "TimerConfig.h"

configuration RV8564AlarmCounterMilli32C
{
  provides interface Counter<TMilli,uint32_t>;
  provides interface Alarm<TMilli,uint32_t>;
  provides interface Init;
}
implementation
{
  components new M16c62pCounter32C(TMilli) as CounterFrom;
  components new M16c62pTimerAInitC(TMR_COUNTER_MODE, M16C_TMRA_TES_TB2, 0xFFFF, false, true) as CounterInit1;
  components new M16c62pTimerAInitC(TMR_COUNTER_MODE, M16C_TMRA_TES_TA_PREV, 0xFFFF, true, true) as CounterInit2;
  
  components new M16c62pAlarm32C(TMilli) as AlarmFrom;
  components new M16c62pTimerAInitC(TMR_COUNTER_MODE, M16C_TMRA_TES_TB2, 0, false, false) as AlarmInit1;
  components new M16c62pTimerAInitC(TMR_COUNTER_MODE, M16C_TMRA_TES_TA_PREV, 0, false, false) as AlarmInit2;
  
  components new M16c62pTimerBInitC(TMR_COUNTER_MODE, M16C_TMRB_CTR_ES_TBiIN, 0, false, true) as TimerSourceInit1;
  components new M16c62pTimerBInitC(TMR_COUNTER_MODE, M16C_TMRB_CTR_ES_TBj, 0, false, true) as TimerSourceInit2;
  components new M16c62pTimerBInitC(TMR_COUNTER_MODE, M16C_TMRB_CTR_ES_TBj, 0, false, true) as TimerSourceInit3;

  components HplM16c62pTimerC as Timers,
      RV8564AlarmCounterMilli32P,
      HplM16c62pInterruptC as Irqs,
      HplM16c62pGeneralIOC as IOs;

  // Setup the IO pin that RV8564 generates the clock to.
  RV8564AlarmCounterMilli32P -> IOs.PortP90;
  Init = RV8564AlarmCounterMilli32P;
  
  // Counter
  CounterFrom.TimerLow -> Timers.COUNTER_MILLI32_LOW;
  CounterFrom.TimerHigh -> Timers.COUNTER_MILLI32_HIGH;
  CounterInit1 -> Timers.COUNTER_MILLI32_LOW;
  CounterInit1 -> Timers.COUNTER_MILLI32_LOW_CTRL;
  CounterInit2 -> Timers.COUNTER_MILLI32_HIGH;
  CounterInit2 -> Timers.COUNTER_MILLI32_HIGH_CTRL;
  Init = CounterInit1;
  Init = CounterInit2;
  Counter = CounterFrom;

  // Alarm
  AlarmFrom.ATimerLow -> Timers.ALARM_MILLI32_LOW;
  AlarmFrom.ATimerHigh -> Timers.ALARM_MILLI32_HIGH;
  AlarmFrom.Counter -> CounterFrom;
  AlarmInit1 -> Timers.ALARM_MILLI32_LOW;
  AlarmInit1 -> Timers.ALARM_MILLI32_LOW_CTRL;
  AlarmInit2 -> Timers.ALARM_MILLI32_HIGH;
  AlarmInit2 -> Timers.ALARM_MILLI32_HIGH_CTRL;
  Init = AlarmInit1;
  Init = AlarmInit2;
  Alarm = AlarmFrom;

  // Timer source
  TimerSourceInit1 -> Timers.MILLI32_SOURCE1;
  TimerSourceInit1 -> Timers.MILLI32_SOURCE1_CTRL;
  TimerSourceInit2 -> Timers.MILLI32_SOURCE2;
  TimerSourceInit2 -> Timers.MILLI32_SOURCE2_CTRL;
  TimerSourceInit3 -> Timers.MILLI32_SOURCE3;
  TimerSourceInit3 -> Timers.MILLI32_SOURCE3_CTRL;
  Init = TimerSourceInit1;
  Init = TimerSourceInit2;
  Init = TimerSourceInit3;
}

