/**
* Tells the cpls to fill the requested memory with a simple test pattern of
* 0 to 255 repeating.  Note that this is actually disabled on the CPLD and
* so will only return 0s unless enabled.
*/
#include "camera.h"

configuration cameraTestC { }
implementation {
  components MainC, LedsC, cameraTestM;
  
  cameraTestM.Boot -> MainC;

  // LEDs and timer interface
  cameraTestM.Leds -> LedsC;
  components new TimerMilliC() as Timer0;
  components new AlarmMilliC() as AlarmC;
  cameraTestM.Timer0 -> Timer0;
  cameraTestM.Alarm -> AlarmC;
  cameraTestM.AlarmInit -> AlarmC;
  
  // Sccb interface
  components EnalabCamC;
  cameraTestM.EnalabCam -> EnalabCamC;
  cameraTestM.CameraInit -> EnalabCamC;
 
  // Serial Forwarder
  components SerialActiveMessageC as Serial;
  cameraTestM.SerialControl -> Serial; 
  cameraTestM.Packet -> Serial;
  cameraTestM.FrameSend     -> Serial.AMSend[AM_FRAME_PART];
  cameraTestM.CmdReceive  -> Serial.Receive[AM_CMD];

  components HplOV7649C;
  cameraTestM.OVAdvanced -> HplOV7649C;
  cameraTestM.OVDbgReceive  -> Serial.Receive[AM_OV_DBG];
  cameraTestM.OVDbgSend     -> Serial.AMSend[AM_OV_DBG];
  cameraTestM.PXADbgReceive  -> Serial.Receive[AM_PXA_DBG];
  cameraTestM.PXADbgSend     -> Serial.AMSend[AM_PXA_DBG];
}
