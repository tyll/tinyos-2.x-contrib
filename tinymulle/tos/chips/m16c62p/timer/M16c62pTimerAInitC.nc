/**
 * Initialise an M16c/62p TimerA to a particular mode. Expected to be
 * used at boot time.
 * @param mode The desired mode of the timer.
 * @param count_src Count source if applicable.
 *
 * @author Henrik Makitaavola
 */
#include "M16c62pTimer.h"
generic module M16c62pTimerAInitC(uint8_t mode,
                                  uint8_t count_src,
                                  uint16_t reload,
                                  bool enable_interrupt,
                                  bool start) @safe()
{
  provides interface Init @atleastonce();
  uses interface HplM16c62pTimerACtrl as TimerCtrl;
  uses interface HplM16c62pTimer as Timer;
}
implementation
{
  command error_t Init.init()
  {
    st_timer timer = {0};
    sta_counter counter = {0};
    sta_one_shot one_shot = {0};

    atomic
    {
      if (mode == TMR_TIMER_MODE)
      {
        timer.gate_func = M16C_TMR_TMR_GF_NO_GATE;
        timer.count_src = count_src;

        call TimerCtrl.setTimerMode(timer);
        call Timer.set(reload);
      }
      else if (mode == TMR_COUNTER_MODE)
      {
        // 'tmp' only used for avoiding "large integer
        // implicitly truncated to unsigned type" warning 
        counter.event_source = count_src;

        call TimerCtrl.setCounterMode(counter);
        call Timer.set(reload);
      }
      else if (mode == TMR_ONE_SHOT_MODE)
      {
        one_shot.trigger = M16C_TMRA_OS_T_TAiOS;
        one_shot.count_src = count_src;
        call TimerCtrl.setOneShotMode(one_shot);
      }
      if (enable_interrupt)
      {
        call Timer.enableInterrupt();
      }
      if (start)
      {
        call Timer.on();
      }

    }
    return SUCCESS;
  }

  async event void Timer.fired() {}
}
