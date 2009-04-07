/**
 * Build a TEP102 16bits Counter from an M16c/62p hardware timer.
 *
 * @author Henrik Makitaavola
 */

generic module M16c62pCounter16C(typedef precision_tag) @safe()
{
  provides interface Counter<precision_tag, uint16_t> as Counter;
  uses interface HplM16c62pTimer as Timer;
}
implementation
{
  async command uint16_t Counter.get()
  {
    // The timer counts down so the time needs to be inverted.
    return (0xFFFF) - call Timer.get();
  }

  async command bool Counter.isOverflowPending()
  {
    return call Timer.testInterrupt();
  }

  async command void Counter.clearOverflow()
  {
    call Timer.clearInterrupt();
  }

  async event void Timer.fired()
  {
    signal Counter.overflow();
  }
}

