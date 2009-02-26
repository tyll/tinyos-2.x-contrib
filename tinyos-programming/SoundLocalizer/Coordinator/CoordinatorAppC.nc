#include "../Detector/detector.h"

configuration CoordinatorAppC { }
implementation {
  components CoordinatorC, ReporterC, SerialActiveMessageC, ActiveMessageC, MainC, LedsC;

  CoordinatorC -> MainC.Boot;
  CoordinatorC -> ActiveMessageC.SplitControl;
  CoordinatorC -> LedsC.Leds;

  components new TimerMilliC() as CTimer;
  components new AMSenderC(AM_COORDINATION_MSG) as CSend;

  CoordinatorC -> CTimer.Timer;
  CoordinatorC -> CSend.AMSend;

  components new SerialAMSenderC(AM_DETECTION_MSG) as RForward;
  components new AMReceiverC(AM_DETECTION_MSG) as RDetection;

  ReporterC.Boot -> MainC;
  ReporterC.SerialControl -> SerialActiveMessageC;
  ReporterC.Detection -> RDetection;
  ReporterC.Forward -> RForward;
}
