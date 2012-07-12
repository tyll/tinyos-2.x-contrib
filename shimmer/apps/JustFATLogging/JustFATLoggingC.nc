/*
 * Copyright (c) 2009, Shimmer Research, Ltd.
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
 * @date   September, 2009
 * ported to tos-2.x
 * @date   January, 2010
 */

#include "FatFs.h"

configuration JustFATLoggingC {
}
implementation {
  components MainC, JustFATLoggingP;
  JustFATLoggingP -> MainC.Boot;

  components FastClockC;
  MainC.SoftwareInit -> FastClockC;

  components LedsC;
  JustFATLoggingP.Leds -> LedsC;
  
  components new AlarmMilli16C() as sampleTimer;
  components new TimerMilliC() as warningTimer;
  JustFATLoggingP.sampleTimerInit -> sampleTimer;
  JustFATLoggingP.sampleTimer   -> sampleTimer;
  JustFATLoggingP.warningTimer  -> warningTimer;

  components shimmerAnalogSetupC, Msp430DmaC;
  MainC.SoftwareInit -> shimmerAnalogSetupC.Init;
  JustFATLoggingP.shimmerAnalogSetup -> shimmerAnalogSetupC;
  JustFATLoggingP.DMA0 -> Msp430DmaC.Channel0;

  //  components Mma7260P;
  components AccelC;
  JustFATLoggingP.AccelInit    -> AccelC;  //Mma7260P;
  JustFATLoggingP.Accel        -> AccelC;  //Mma7260P;

  components FatFsP, diskIOC;
  JustFATLoggingP.FatFs     -> FatFsP;
  FatFsP.diskIO             -> diskIOC;
  FatFsP.diskIOStdControl   -> diskIOC;

  components PowerSupplyMonitorC;
  MainC.SoftwareInit -> PowerSupplyMonitorC;
  JustFATLoggingP.PSMStdControl      -> PowerSupplyMonitorC;
  JustFATLoggingP.PowerSupplyMonitor -> PowerSupplyMonitorC;

  // we're writing this for shimmer*, so skipping the ifdef...
  components HplDs2411C;
  JustFATLoggingP.IDChip     -> HplDs2411C;

  components TimeC;
  MainC.SoftwareInit   -> TimeC;
  JustFATLoggingP.Time -> TimeC;
}
