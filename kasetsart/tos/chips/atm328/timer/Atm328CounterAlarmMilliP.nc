#include <Atm328Timer.h>

/**
 * Internal implementation of Counter/Alarm using ATmega328's Timer2
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

module Atm328CounterAlarmMilliP @safe() 
{
  provides 
  {
    interface Init @atleastonce();
    interface Counter<TMilli, uint32_t>;
    interface Alarm<TMilli, uint32_t>;
    interface McuPowerOverride;
  }
}
implementation
{
#define TCNT2_OFFSET 73 // overflow every ~ 1/1024 sec

  uint32_t counter, alarmExpire;
  bool isAlarmRunning;

  /******************************************
   * Init interface
   ******************************************/
  command error_t Init.init()
  {
    TCCR2B = ATM328_T2_DIVIDE_64;
    TCNT2 = TCNT2_OFFSET;
    SET_BIT(TIMSK2,TOIE2); // enable overflow interrupt

    counter = 0;
    isAlarmRunning = FALSE;

    return SUCCESS;
  }

  /******************************************
   * Counter interface
   ******************************************/
  async command uint32_t Counter.get()
  {
    return counter;
  }

  async command bool Counter.isOverflowPending()
  {
    return FALSE;
  }

  async command void Counter.clearOverflow() { }

  default async event void Counter.overflow() { }

  /******************************************
   * Alarm interface
   ******************************************/
  async command void Alarm.start(uint32_t dt) 
  { 
    atomic
    {
      call Alarm.startAt(counter, dt);
    }
  }

  async command void Alarm.stop() 
  { 
    atomic { isAlarmRunning = FALSE; }
  }

  default async event void Alarm.fired() { }

  async command bool Alarm.isRunning()
  {
    return isAlarmRunning;
  }

  async command void Alarm.startAt(uint32_t t0, uint32_t dt) 
  { 
    atomic
    {
      alarmExpire = t0 + dt;
      isAlarmRunning = TRUE;
    }
  }

  async command uint32_t Alarm.getNow() 
  {
    atomic { return counter; }
  }

  async command uint32_t Alarm.getAlarm() 
  {
    atomic { return alarmExpire; }
  }

  /******************************************
   * McuPowerOverride interface
   ******************************************/
  async command mcu_power_t McuPowerOverride.lowestState() 
  {
    // TODO: The lowest possible power saving mode is POWER-SAVE.  However,
    // EXTENDED-STANDBY is currently used due to the problem about the timer
    // being counted slower than it should be.
    //
    // TODO: The best power-saving solution is to run Timer/Counter2
    // asynchronously.  But this involves *hardware redesign* (i.e., replacing
    // the current 12MHz crystal with 32.768KHz)
    //return ATM328_POWER_EXT_STANDBY;
    return ATM328_POWER_EXT_STANDBY;
  }

  /******************************************
   * Interrupt handler
   ******************************************/
  AVR_ATOMIC_HANDLER(TIMER2_OVF_vect)
  {
    TCNT2  = TCNT2_OFFSET; // reset the timer/counter
    counter++;
    if (counter == 0) // overflow
      signal Counter.overflow();
    if (isAlarmRunning == TRUE && counter == alarmExpire)
    {
      isAlarmRunning = FALSE;
      signal Alarm.fired();
    }
  }
}
