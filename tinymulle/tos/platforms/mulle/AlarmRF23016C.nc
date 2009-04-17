/**
 * AlarmRF23016C provides a 16-bit TRadio alarm.
 * It uses 1 hw timer that is used as a alarm and runs with
 * speed MAIN_CRYSTAL_SPEED / 8.
 *
 * @author Henrik Makitaavola
 */

#include "RF230TimerConfig.h"
#include <RadioConfig.h>

configuration AlarmRF23016C
{
  provides interface Alarm<TRadio,uint16_t>;
}
implementation
{
  components new M16c62pAlarm16C(TRadio) as AlarmFrom;
  components new M16c62pTimerBInitC(TMR_TIMER_MODE, M16C_TMR_CS_F8, 0, false, false) as AlarmInit;
  components McuSleepC;

  components HplM16c62pTimerC as Timers,
      CounterRF23016C,
      PlatformP;

  AlarmFrom -> Timers.ALARM_RF23016;
  AlarmFrom.Counter -> CounterRF23016C;
  AlarmFrom.McuPowerState -> McuSleepC;

  AlarmInit -> Timers.ALARM_RF23016;
  AlarmInit -> Timers.ALARM_RF23016_CTRL;
  PlatformP.SubInit -> AlarmInit.Init;
  Alarm = AlarmFrom;
}
  

