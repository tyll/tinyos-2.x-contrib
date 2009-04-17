/**
 * AlarmMicro16C provides a 16-bit micro alarm.
 * It uses 2 hw timers, one generates a micro tick and the other
 * counts the ticks. It also uses the CounterMicro16C component.
 *
 * @author Henrik Makitaavola
 * @see  Please refer to TEP 102 for more information about this component.
 */

#include "RF230TimerConfig.h"

configuration AlarmMicro16C
{
  provides interface Alarm<TMicro,uint16_t>;
}
implementation
{
  components new M16c62pAlarm16C(TMicro) as AlarmFrom;
  components new M16c62pTimerAInitC(TMR_COUNTER_MODE, M16C_TMRA_TES_TA_NEXT, 0, false, false) as AlarmInit;
  components new M16c62pTimerAInitC(TMR_TIMER_MODE, M16C_TMR_CS_F1_2, (MAIN_CRYSTAL_SPEED - 1), false, true) as TimerSourceInit;

  components HplM16c62pTimerC as Timers,
      CounterMicro16C,
      PlatformP,
      McuSleepC;

  AlarmFrom -> Timers.ALARM_MICRO16;
  AlarmFrom.Counter -> CounterMicro16C;
  AlarmFrom.McuPowerState -> McuSleepC;

  AlarmInit -> Timers.ALARM_MICRO16;
  AlarmInit -> Timers.ALARM_MICRO16_CTRL;
  PlatformP.SubInit -> AlarmInit.Init;
  Alarm = AlarmFrom;

  // Timer source
  TimerSourceInit -> Timers.ALARM_MICRO16_SOURCE;
  TimerSourceInit -> Timers.ALARM_MICRO16_SOURCE_CTRL;
  PlatformP.SubInit -> TimerSourceInit;

}
  

