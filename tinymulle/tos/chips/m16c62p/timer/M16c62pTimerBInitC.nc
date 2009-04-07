/**
 * Initialise an M16c/62p TimerB to a particular mode. Expected to be
 * used at boot time.
 * @param mode The desired mode of the timer.
 * @param count_src Count source if applicable.
 *
 * @author Henrik Makitaavola
 */
generic module M16c62pTimerBInitC(uint8_t mode,
                                  uint8_t count_src,
                                  uint16_t reload,
                                  bool enable_interrupt,
                                  bool start) @safe()
{
  provides interface Init @atleastonce();
  uses interface HplM16c62pTimerBCtrl as TimerCtrl;
  uses interface HplM16c62pTimer as Timer;
}
implementation
{
  command error_t Init.init()
  {
    uint8_t tmp;
    error_t ret = SUCCESS;
    st_timer timer = {0};
    stb_counter counter = {0};

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
        tmp =  count_src & 1; 
        counter.event_source = tmp;

        call TimerCtrl.setCounterMode(counter);
        call Timer.set(reload);
      }
      else
      {
        ret = FAIL;
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
    return ret;
  }

  async event void Timer.fired() {}
}
