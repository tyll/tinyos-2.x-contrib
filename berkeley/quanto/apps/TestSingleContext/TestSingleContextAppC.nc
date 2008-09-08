#include <Timer.h>

configuration TestSingleContextAppC
{
}
implementation
{
  components MainC, TestSingleContextC, LedsC, RandomC;
  components UserButtonC;
  components QuantoLogRawUARTC as CLog;
  components ResourceContextsC;

  TestSingleContextC -> MainC.Boot;

  TestSingleContextC.Leds -> LedsC;
  TestSingleContextC.Random -> RandomC;
  TestSingleContextC.CPUContext -> ResourceContextsC.CPUContext;
  TestSingleContextC.QuantoLog -> CLog;
  TestSingleContextC.UserButtonNotify -> UserButtonC;
}
