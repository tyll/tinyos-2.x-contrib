configuration GPRSTimer
{
  provides
  {
    interface StdControl;
    interface IGPRSTimer;
  }
}
implementation
{
  components GPRSTimerM, TimerC, LedsC as Leds, SrcAccumC;

  StdControl = GPRSTimerM.StdControl;
  IGPRSTimer = GPRSTimerM.IGPRSTimer;
  GPRSTimerM.Timer->TimerC.Timer[unique ("Timer")];
  GPRSTimerM.BlinkTimer->TimerC.Timer[unique ("Timer")];
  GPRSTimerM.OffTimer->TimerC.Timer[unique ("Timer")];
  GPRSTimerM.Leds -> Leds;
  GPRSTimerM.IAccum -> SrcAccumC.IAccum;
}
