/*
 * Copyright (c) 2012, Shimmer Research, Ltd.
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
 * @date   July, 2012
 */

#include "FatFs.h"

configuration ParamLoggingC {
}
implementation {
  components MainC, ParamLoggingP;
  ParamLoggingP -> MainC.Boot;

  // this auto-wires in the 8mhz xt2, running smclk at 4mhz
  components FastClockC;
  MainC.SoftwareInit -> FastClockC;

  components LedsC;
  ParamLoggingP.Leds -> LedsC;
  
  components new AlarmMilli16C() as sampleTimer;
  ParamLoggingP.sampleTimerInit -> sampleTimer;
  ParamLoggingP.sampleTimer   -> sampleTimer;

  components new TimerMilliC() as warningTimer;
  ParamLoggingP.warningTimer -> warningTimer;

  components shimmerAnalogSetupC, Msp430DmaC;
  MainC.SoftwareInit -> shimmerAnalogSetupC.Init;
  ParamLoggingP.shimmerAnalogSetup -> shimmerAnalogSetupC;
  ParamLoggingP.DMA0 -> Msp430DmaC.Channel0;

  components AccelC;
  ParamLoggingP.AccelInit    -> AccelC;
  ParamLoggingP.Accel        -> AccelC;

  components GyroBoardC;
  ParamLoggingP.GyroInit       -> GyroBoardC;
  ParamLoggingP.GyroStdControl -> GyroBoardC;
  ParamLoggingP.GyroBoard      -> GyroBoardC;

  components MagnetometerC;
  ParamLoggingP.MagInit -> MagnetometerC;
  ParamLoggingP.Magnetometer     -> MagnetometerC;

  components GsrC;
  ParamLoggingP.GsrInit -> GsrC.Init;
  ParamLoggingP.Gsr     -> GsrC;

  components StrainGaugeC;
  ParamLoggingP.StrainGaugeInit -> StrainGaugeC.Init;
  ParamLoggingP.StrainGauge     -> StrainGaugeC.StrainGauge;

  
  components FatFsP, diskIOC;
  FatFsP.diskIO             -> diskIOC;
  FatFsP.diskIOStdControl   -> diskIOC;
  ParamLoggingP.FatFs     -> FatFsP;

  components new Msp430Usart0C();
  ParamLoggingP.Usart     -> Msp430Usart0C;

  components HplDs2411C;
  ParamLoggingP.IDChip     -> HplDs2411C;

  components TimeC;
  MainC.SoftwareInit   -> TimeC;
  ParamLoggingP.Time -> TimeC;
  
}
