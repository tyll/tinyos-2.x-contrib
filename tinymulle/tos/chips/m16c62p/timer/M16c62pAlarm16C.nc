/**
 * Build a TEP102 16bits Alarm from a counter and a M16c62p hardware timers.
 * Use the counter to get the "current time" and the hw timer to count down the
 * remaining time for the alarm to be fired.
 *
 * @author Henrik Makitaavola
 */

generic module M16c62pAlarm16C(typedef precision_tag) @safe()
{
  provides interface Alarm<precision_tag, uint16_t> as Alarm @atmostonce();

  uses interface HplM16c62pTimer as ATimer; // Alarm Timer
  uses interface Counter<precision_tag, uint16_t>;
  uses interface McuPowerState;
}
implementation
{
  uint16_t alarm = 0;
  async command uint16_t Alarm.getNow()
  {
    return call Counter.get();
  }

  async command uint16_t Alarm.getAlarm()
  {
    return alarm;
  }

  async command bool Alarm.isRunning()
  {
    return call ATimer.isInterruptOn();
  }

  async command void Alarm.stop()
  {
    atomic {
      call ATimer.off();
      call ATimer.disableInterrupt();
      call McuPowerState.update();
    }
  }

  async command void Alarm.start( uint16_t dt ) 
  {
    call Alarm.startAt( call Alarm.getNow(), dt);
  }

  async command void Alarm.startAt( uint16_t t0, uint16_t dt )
  {
    atomic
    {
      uint16_t now, elapsed, expires;

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
        
      call ATimer.off();
      call ATimer.set(expires);
      call ATimer.clearInterrupt();
      call ATimer.enableInterrupt();
      call ATimer.on();
      call McuPowerState.update();
    }
  }

  async event void ATimer.fired()
  {
    call Alarm.stop();
    signal Alarm.fired();
  }

  async event void Counter.overflow() {}
}
