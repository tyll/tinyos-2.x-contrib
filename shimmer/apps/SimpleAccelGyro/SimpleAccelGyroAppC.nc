/*
 * Copyright (c) 2011, Shimmer Research, Ltd.
 * All rights reserved
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:

 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of Shimmer Research, Ltd. nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Steve Ayer
 * @date   February, 2011
 * accel gyro over 802.15.4 active message transport
 */

#include "SimpleAccelGyro.h"

configuration SimpleAccelGyroAppC {
}

implementation {
  components MainC, SimpleAccelGyroC;
  SimpleAccelGyroC.Boot -> MainC.Boot;

  components LedsC;
  SimpleAccelGyroC.Leds -> LedsC;

  components shimmerAnalogSetupC, Msp430DmaC;
  MainC.SoftwareInit -> shimmerAnalogSetupC.Init;
  SimpleAccelGyroC.shimmerAnalogSetup -> shimmerAnalogSetupC;
  SimpleAccelGyroC.DMA0 -> Msp430DmaC.Channel0;

  components AccelC;
  SimpleAccelGyroC.AccelInit    -> AccelC;
  SimpleAccelGyroC.Accel        -> AccelC;

  components GyroBoardC;
  SimpleAccelGyroC.GyroInit       -> GyroBoardC;
  SimpleAccelGyroC.GyroStdControl -> GyroBoardC;
  SimpleAccelGyroC.GyroBoard      -> GyroBoardC;

  components TiltDetectorC;
  SimpleAccelGyroC.tiltNotify -> TiltDetectorC;

  components new AlarmMilli16C() as sampleTimer;
  SimpleAccelGyroC.sampleTimerInit -> sampleTimer;
  SimpleAccelGyroC.sampleTimer   -> sampleTimer;

  components new TimerMilliC() as motionTimer;
  SimpleAccelGyroC.motionTimer -> motionTimer;

  components new TimerMilliC() as blinkTimer;
  SimpleAccelGyroC.blinkTimer -> blinkTimer;

  components ActiveMessageC;
  SimpleAccelGyroC.AMRadioControl -> ActiveMessageC;

  components new AMSenderC(AM_SYNCD_TIMING_MSG);
  SimpleAccelGyroC.Packet -> AMSenderC;
  SimpleAccelGyroC.AMRadioSend -> AMSenderC;

  components new AMReceiverC(AM_SYNCD_TIMING_MSG);
  SimpleAccelGyroC.Receive -> AMReceiverC;
}
