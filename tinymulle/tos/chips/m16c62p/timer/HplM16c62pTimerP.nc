/**
 * Implementation of a generic HplM16c62pTimer interface.
 *
 * @author Henrik Makitaavola
 */
generic module HplM16c62pTimerP (uint16_t timer_addr,
                                 uint16_t interrupt_addr,
                                 uint16_t start_addr,
                                 uint8_t start_bit)
{
  provides interface HplM16c62pTimer as Timer;
  uses interface HplM16c62pTimerInterrupt as IrqSignal;
}
implementation
{
#define timer (*TCAST(volatile uint16_t* ONE, timer_addr))
#define start (*TCAST(volatile uint8_t* ONE, start_addr))
#define interrupt (*TCAST(volatile uint8_t* ONE, interrupt_addr))

  async command uint16_t Timer.get() { return timer; }
  
  async command void Timer.set( uint16_t t )
  {
    // If the timer is on it must be turned off, else the value will
    // only be written to the reload register.
    atomic
    {
      if(call Timer.isOn())
      {
        call Timer.off();
        timer = t;
        call Timer.on();
      }
      else
      {
        timer = t;
      }
    }
  }

  // When the timer is turned on in one-shot mode on TimerA
  // the timer also needs an trigger event to start counting.
  async command void Timer.on() { SET_BIT(start, start_bit); }
  async command void Timer.off() { CLR_BIT(start, start_bit); }
  async command bool Timer.isOn() { return READ_BIT(start, start_bit); }
  
  async command void Timer.clearInterrupt() { CLR_BIT(interrupt, 3); }
  async command void Timer.enableInterrupt() { SET_BIT(interrupt, 0); }
  async command void Timer.disableInterrupt() { CLR_BIT(interrupt, 0); }
  async command bool Timer.testInterrupt() { return READ_BIT(interrupt, 3); }
  async command bool Timer.isInterruptOn() { return READ_BIT(interrupt, 0); }
 
  // Forward the timer interrupt event.  
  async event void IrqSignal.fired() { signal Timer.fired(); }

  default async event void Timer.fired() { } 
}
