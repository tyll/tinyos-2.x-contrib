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
*   from this software without specific prior written permission
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
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 
/**
 * Modified for ov7670
 * @author Ralph Kling
 */
/*
 * Modified by: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */
#include "cameraModule.h"


configuration cameraModuleC {

	provides {
		interface cameraModule;	
	}

 }
implementation {
  components MainC, LedsC, RadioMsgC, cameraModuleM, JpegM, DpcmM;
  cameraModule = cameraModuleM.cameraModule;
  cameraModuleM.Boot -> MainC;
  cameraModuleM.Leds -> LedsC;
  cameraModuleM.RadioMsg -> RadioMsgC;
  cameraModuleM.Jpeg ->JpegM;
  cameraModuleM.Dpcm ->DpcmM;
  JpegM.Leds -> LedsC;
  DpcmM.Leds -> LedsC;
  components new TimerMilliC() as TimerPause;
  components new TimerMilliC() as TimerAcquire;
  components new TimerMilliC() as TimerVideoSend;
  cameraModuleM.TimerPause -> TimerPause;
  cameraModuleM.TimerAcquire -> TimerAcquire;
  cameraModuleM.TimerVideoSend -> TimerVideoSend;

  // Sccb interface
  components XbowCamC;
  cameraModuleM.XbowCam -> XbowCamC;
  cameraModuleM.CameraInit -> XbowCamC;

  // Serial Forwarder
  components SerialActiveMessageC as Serial;
  cameraModuleM.Packet -> Serial; 
  cameraModuleM.CmdReceive  -> Serial.Receive[AM_CMD_MSG];


}
