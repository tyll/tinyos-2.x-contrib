/**
 * Build TEP102 Counter and Alarm from Atmega328 hardware timer.
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
configuration Atm328CounterAlarmMilliC
{
  provides 
  {
    interface Init;
    interface Alarm<TMilli, uint32_t>;
    interface Counter<TMilli, uint32_t>;
  }
}
implementation
{
  components Atm328CounterAlarmMilliP, McuSleepC, MainC;

  McuSleepC.McuPowerOverride -> Atm328CounterAlarmMilliP;
  MainC.SoftwareInit -> Atm328CounterAlarmMilliP;

  Init    = Atm328CounterAlarmMilliP;
  Alarm   = Atm328CounterAlarmMilliP;
  Counter = Atm328CounterAlarmMilliP;
}
