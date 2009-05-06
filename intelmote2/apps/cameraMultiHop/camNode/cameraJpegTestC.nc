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
#include "cameraJpegTest.h"

configuration cameraJpegTestC { }
implementation {
  components MainC, LedsC, SendBigMsgC, cameraJpegTestM, JpegM;
  cameraJpegTestM.Boot -> MainC;
  cameraJpegTestM.Leds -> LedsC;
  cameraJpegTestM.SendBigMsg -> SendBigMsgC;
  cameraJpegTestM.Jpeg ->JpegM;
  JpegM.Leds -> LedsC;
  components new TimerMilliC() as Timer0;
  cameraJpegTestM.Timer0 -> Timer0;

  // Sccb interface
  components EnalabCamC;
  cameraJpegTestM.EnalabCam -> EnalabCamC;
  cameraJpegTestM.CameraInit -> EnalabCamC;

  // Serial Forwarder

  components ActiveMessageC as Serial;
  cameraJpegTestM.SerialControl -> Serial;
  cameraJpegTestM.Packet -> Serial;

  components DisseminationC;
  components new DisseminatorC(cmd_msg_t, CMD_KEY) as CmdMsgC;


  cameraJpegTestM.DisseminationControl -> DisseminationC;
  cameraJpegTestM.DisseminationCmdMsgReceive -> CmdMsgC;
  cameraJpegTestM.DisseminationCmdMsgSend -> CmdMsgC;

  components CollectionC as Collector;
  components new CollectionSenderC(AM_CTP_IMG_STAT) as SendImgStat;

  cameraJpegTestM.RoutingControl -> Collector;
  cameraJpegTestM.RootControl -> Collector;
  cameraJpegTestM.ImgStatSend -> SendImgStat;
  cameraJpegTestM.CollectionPacket -> Collector;
  cameraJpegTestM.CtpInfo -> Collector;
  cameraJpegTestM.CtpCongestion -> Collector;

  components HplOV7649C;
  cameraJpegTestM.OVAdvanced -> HplOV7649C;
}
