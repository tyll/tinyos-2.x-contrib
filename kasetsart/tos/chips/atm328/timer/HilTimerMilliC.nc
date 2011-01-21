/**
 * Minimal implementation of TinyOS's HIL timer based on requirements
 * specified in TEP102 (Timers)
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
configuration HilTimerMilliC
{
  provides interface Init;
  provides interface Timer<TMilli> as TimerMilli[ uint8_t num ];
  provides interface LocalTime<TMilli>;
}
implementation
{
  components Atm328CounterAlarmMilliC;
  components new CounterToLocalTimeC(TMilli);
  components new AlarmToTimerC(TMilli);
  components new VirtualizeTimerC(TMilli, uniqueCount(UQ_TIMER_MILLI));

  CounterToLocalTimeC.Counter -> Atm328CounterAlarmMilliC;
  AlarmToTimerC.Alarm -> Atm328CounterAlarmMilliC;
  VirtualizeTimerC.TimerFrom -> AlarmToTimerC.Timer;

  // Export the required interfaces
  Init = Atm328CounterAlarmMilliC;
  TimerMilli = VirtualizeTimerC;
  LocalTime = CounterToLocalTimeC;
}
