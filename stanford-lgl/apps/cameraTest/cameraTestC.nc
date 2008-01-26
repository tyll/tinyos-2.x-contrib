/*
* Copyright (c) 2006 Stanford University.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/ 
/**
 * @brief EnaLab camera board test application
 * @author Brano Kusy (branislav.kusy@gmail.com)
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
