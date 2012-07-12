/*
 * Copyright (c) 2010, Shimmer Research, Ltd.
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
 * @date   May, 2010
 *
 */

#include "FatFs.h"

configuration HostTimeLoggingC {
}
implementation {
  components MainC, HostTimeLoggingP;
  HostTimeLoggingP.Boot -> MainC.Boot;

  components FastClockC;
  MainC.SoftwareInit -> FastClockC;

  components LedsC;
  HostTimeLoggingP.Leds -> LedsC;

  components new AlarmMilli16C() as sampleTimer;
  components new TimerMilliC() as warningTimer;
  HostTimeLoggingP.sampleTimerInit -> sampleTimer;
  HostTimeLoggingP.sampleTimer   -> sampleTimer;
  HostTimeLoggingP.warningTimer  -> warningTimer;

  components shimmerAnalogSetupC, Msp430DmaC;
  MainC.SoftwareInit -> shimmerAnalogSetupC.Init;
  HostTimeLoggingP.shimmerAnalogSetup -> shimmerAnalogSetupC;
  HostTimeLoggingP.DMA0 -> Msp430DmaC.Channel0;

  components AccelC;
  HostTimeLoggingP.AccelInit    -> AccelC;
  HostTimeLoggingP.Accel        -> AccelC;

  components FatFsP, diskIOC;
  HostTimeLoggingP.FatFs     -> FatFsP;
  FatFsP.diskIO             -> diskIOC;
  FatFsP.diskIOStdControl   -> diskIOC;

  components PowerSupplyMonitorC;
  MainC.SoftwareInit -> PowerSupplyMonitorC;
  HostTimeLoggingP.PSMStdControl      -> PowerSupplyMonitorC;
  HostTimeLoggingP.PowerSupplyMonitor -> PowerSupplyMonitorC;

  // we're writing this for shimmer*, so skipping the ifdef...
  components HplDs2411C;
  HostTimeLoggingP.IDChip     -> HplDs2411C;

  components TimeC;
  MainC.SoftwareInit   -> TimeC;
  HostTimeLoggingP.Time -> TimeC;

  components HostTimeC;
  MainC.SoftwareInit        -> HostTimeC;
  HostTimeLoggingP.HostTime -> HostTimeC;

  // these two sections for getting/acknowledging wall time from host
  components HplMsp430Usart0C;
  HostTimeLoggingP.UARTControl -> HplMsp430Usart0C.HplMsp430Usart;
  HostTimeLoggingP.UARTData    -> HplMsp430Usart0C.HplMsp430UsartInterrupts;

  components UserButtonC;
  HostTimeLoggingP.buttonNotify -> UserButtonC;

}
