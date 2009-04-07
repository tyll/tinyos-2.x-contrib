/**
 * Build a TEP102 32 bit Counter from two M16c/62p hardware timers.
 *
 * @author Henrik Makitaavola
 */

generic module M16c62pCounter32C(typedef precision_tag) @safe()
{
  provides interface Counter<precision_tag, uint32_t> as Counter;
  uses interface HplM16c62pTimer as TimerLow;
  uses interface HplM16c62pTimer as TimerHigh;
}
implementation
{
  async command uint32_t Counter.get()
  {
    uint32_t time = 0;
    atomic
    {
      time = (((uint32_t)call TimerHigh.get()) << 16) + call TimerLow.get();
    }
    // The timers count down so the time needs to be inverted.
    return (0xFFFFFFFF) - time;
  }

  async command bool Counter.isOverflowPending()
  {
    return call TimerHigh.testInterrupt();
  }

  async command void Counter.clearOverflow()
  {
    call TimerHigh.clearInterrupt();
  }

  async event void TimerHigh.fired()
  {
    signal Counter.overflow();
  }

  async event void TimerLow.fired() {}
}

