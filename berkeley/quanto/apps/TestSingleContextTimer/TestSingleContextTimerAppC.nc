#include <Timer.h>

configuration TestSingleContextTimerAppC
{
}
implementation
{
  components MainC, TestSingleContextTimerC, LedsC, RandomC;
  components UserButtonC;
  components QuantoLogRawUARTC as CLog;
  components ResourceContextsC;
  components new TimerMilliC() as TimerA;
  components new TimerMilliC() as TimerB;

  TestSingleContextTimerC -> MainC.Boot;

  TestSingleContextTimerC.Leds -> LedsC;
  TestSingleContextTimerC.Random -> RandomC;
  TestSingleContextTimerC.UserButtonNotify -> UserButtonC;
  TestSingleContextTimerC.TimerA -> TimerA;
  TestSingleContextTimerC.TimerB -> TimerB;
  TestSingleContextTimerC.QuantoLog -> CLog;
  TestSingleContextTimerC.CPUContext -> ResourceContextsC.CPUContext;
  TestSingleContextTimerC.LED0Context -> ResourceContextsC.LED0Context;
  TestSingleContextTimerC.LED2Context -> ResourceContextsC.LED2Context;
}
