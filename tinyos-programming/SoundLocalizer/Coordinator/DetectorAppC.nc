#include "detector.h"

configuration DetectorAppC { }
implementation {
  components CoordinatorC, ActiveMessageC, MainC, LedsC;

  CoordinatorC -> MainC.Boot;
  CoordinatorC -> ActiveMessageC.SplitControl;
  CoordinatorC -> LedsC.Leds;

  components new TimerMilliC() as CTimer;
  components new AMSenderC(AM_COORDINATION_MSG) as CSend;

  CoordinatorC -> CTimer.Timer;
  CoordinatorC -> CSend.AMSend;

  components DetectorC, StatsC, LocalTimeMilliC;

  DetectorC -> MainC.Boot;
  DetectorC -> ActiveMessageC.SplitControl;
  DetectorC -> LedsC.Leds;
  DetectorC -> StatsC.Stats;
  DetectorC -> LocalTimeMilliC.LocalTime;

  components new AMReceiverC(AM_COORDINATION_MSG) as CReceive;
  components new TimerMilliC() as STimer;
  DetectorC.Coordination -> CReceive;
  DetectorC.Timer -> STimer;
}
