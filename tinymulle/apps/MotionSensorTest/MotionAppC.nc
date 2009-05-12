
#include "Motion.h"

configuration MotionAppC
{
}
implementation
{
  components MainC, MotionC as App;
  components MotionSensorC;
  components new AMSenderC(AM_MOTION_MSG) as Send;
  components ActiveMessageC as Radio;

  App -> MainC.Boot;
  App.Init -> MotionSensorC;
  App.Motion -> MotionSensorC;
  App.MotionControl->MotionSensorC;
  App.MotionLeds -> MotionSensorC;
  App.RadioControl -> Radio;
  App.RadioSend -> Send;
  App.Packet -> Radio;


}

