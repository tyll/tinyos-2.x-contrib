/**
 * CounterRF23016C provides a 16-bit TRadio counter.
 * It uses 1 hw timer that counts in MAIN_CRYSTAL_SPEED / 8.
 *
 * @author Henrik Makitaavola
 */

#include "RF230TimerConfig.h"
#include <RadioConfig.h>

configuration CounterRF23016C
{
  provides interface Counter<TRadio,uint16_t>;
}
implementation
{
  components new M16c62pCounter16C(TRadio) as CounterFrom;
  components new M16c62pTimerAInitC(TMR_TIMER_MODE, M16C_TMR_CS_F8, 0xFFFF, true, true) as CounterInit;

  components HplM16c62pTimerC as Timers,
      PlatformP;
  
  CounterFrom.Timer -> Timers.COUNTER_RF23016;
  CounterInit -> Timers.COUNTER_RF23016;
  CounterInit -> Timers.COUNTER_RF23016_CTRL;
  PlatformP.SubInit -> CounterInit;
  Counter = CounterFrom;
}
