/**
 * Build a TEP102 32bit Alarm from a counter and two M16c62p hardware timers.
 * Use the counter to get the "current time" and the hw timer to count down the
 * remaining time for the alarm to be fired.
 *
 * @author Henrik Makitaavola
 */

generic module M16c62pAlarm32C(typedef precision_tag) @safe()
{
  provides interface Alarm<precision_tag, uint32_t> as Alarm @atmostonce();

  uses interface HplM16c62pTimer as ATimerLow; // Alarm Timer low bits
  uses interface HplM16c62pTimer as ATimerHigh; // Alarm Timer high bits
  uses interface Counter<precision_tag, uint32_t>;
}
implementation
{
  uint32_t alarm = 0;

  async command uint32_t Alarm.getNow()
  {
    return call Counter.get();
  }

  async command uint32_t Alarm.getAlarm()
  {
    atomic return alarm;
  }

  async command bool Alarm.isRunning()
  {
      return call ATimerLow.isInterruptOn() || call ATimerHigh.isInterruptOn();
  }

  async command void Alarm.stop()
  {
    atomic {
      call ATimerLow.off();
      call ATimerLow.disableInterrupt();
      call ATimerHigh.off();
      call ATimerHigh.disableInterrupt();
    }
  }

  async command void Alarm.start( uint32_t dt ) 
  {
    call Alarm.startAt( call Alarm.getNow(), dt);
  }

  async command void Alarm.startAt( uint32_t t0, uint32_t dt )
  {
    atomic
    {
      uint32_t now, elapsed, expires;

      now = call Alarm.getNow();
      elapsed = now - t0;
        
      if (elapsed >= dt)
      {
        expires = 0;
      }
      else
      {
        expires = dt - elapsed - 1;
      }
      
      alarm = expires;

      call Alarm.stop();
      
      if (expires <= 0xFFFF)
      {
        call ATimerLow.set((uint16_t)expires);
        call ATimerLow.clearInterrupt();
        call ATimerLow.enableInterrupt();
        call ATimerLow.on();
      }
      else
      {
        uint16_t high_bits;

        high_bits = expires >> 16;
        call ATimerHigh.set(high_bits-1);
        call ATimerHigh.clearInterrupt();
        call ATimerHigh.enableInterrupt();
        call ATimerHigh.on();
        call ATimerLow.set(0xFFFF);
        call ATimerLow.on();
      }
    }
  }

  async event void ATimerLow.fired()
  {
    call Alarm.stop();
    signal Alarm.fired();
  }
  
  async event void ATimerHigh.fired()
  {
    atomic
    {
      uint16_t remaining;
      
      call Alarm.stop();
      
      // All the high bits should have been cleared so only the
      // low should remain.
      remaining = (uint16_t)(alarm & 0xFFFF);
      if (remaining != 0)
      {
        call ATimerLow.set(remaining);
        call ATimerLow.clearInterrupt();
        call ATimerLow.enableInterrupt();
        call ATimerLow.on();
      }
      else
      {
        signal Alarm.fired();
      }
    }
  }
  async event void Counter.overflow() {}
}
