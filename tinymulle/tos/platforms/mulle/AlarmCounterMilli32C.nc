/**
 * AlarmCounterMilli32C provides a 32-bit TMilli alarm and counter.
 *
 * @author Henrik Makitaavola
 * @see  Please refer to TEP 102 for more information about this component.
 */

#include "TimerConfig.h"

configuration AlarmCounterMilli32C
{
  provides interface Counter<TMilli,uint32_t>;
  provides interface Alarm<TMilli,uint32_t>;
  provides interface Init;
}
implementation
{
  components new M16c62pCounter16C(TMilli) as CounterFrom;
  components new M16c62pTimerAInitC(TMR_COUNTER_MODE, M16C_TMRA_TES_TA_NEXT, 0xFFFF, true, true) as CounterInit;
  components new TransformCounterC(TMilli,uint32_t, TMilli,uint16_t, 0,uint16_t) as TCounter;
  
  components new M16c62pAlarm16C(TMilli) as AlarmFrom;
  components new TransformAlarmC(TMilli,uint32_t,TMilli,uint16_t,0) as TAlarm;
  components new M16c62pTimerAInitC(TMR_COUNTER_MODE, M16C_TMRA_TES_TA_PREV, 0, false, false) as AlarmInit;
  
  components new M16c62pTimerAInitC(TMR_TIMER_MODE, M16C_TMR_CS_F1_2, (1000 * MAIN_CRYSTAL_SPEED) - 1, false, true) as TimerSourceInit;

  components HplM16c62pTimerC as Timers,
      McuSleepC;

  // Counter
  CounterFrom.Timer -> Timers.COUNTER_MILLI32;
  CounterInit -> Timers.COUNTER_MILLI32;
  CounterInit -> Timers.COUNTER_MILLI32_CTRL;
  Init = CounterInit;

  // Alarm
  AlarmFrom -> Timers.ALARM_MILLI32;
  AlarmFrom.Counter -> CounterFrom;
  AlarmFrom.McuPowerState -> McuSleepC;
  AlarmInit -> Timers.ALARM_MILLI32;
  AlarmInit -> Timers.ALARM_MILLI32_CTRL;
  Init = AlarmInit.Init;

  // Timer source
  TimerSourceInit -> Timers.MILLI32_SOURCE;
  TimerSourceInit -> Timers.MILLI32_SOURCE_CTRL;
  Init = TimerSourceInit;

  // Transformations
  TCounter.CounterFrom -> CounterFrom;
  Counter = TCounter;
  TAlarm.AlarmFrom -> AlarmFrom;
  TAlarm.Counter -> TCounter;
  Alarm = TAlarm;
}

