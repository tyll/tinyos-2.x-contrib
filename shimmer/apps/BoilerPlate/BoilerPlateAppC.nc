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
 * @author Mike Healy
 * @date   November, 2010
 */

configuration BoilerPlateAppC {
}
implementation {
   components MainC, BoilerPlateC;
   BoilerPlateC -> MainC.Boot; 

   components LedsC;
   BoilerPlateC.Leds -> LedsC;

   components new TimerMilliC() as SampleTimer;
   BoilerPlateC.SampleTimer   -> SampleTimer;
   components new TimerMilliC() as SetupTimer;
   BoilerPlateC.SetupTimer    -> SetupTimer;
   components new TimerMilliC() as ActivityTimer;
   BoilerPlateC.ActivityTimer -> ActivityTimer;
  
   components Counter32khz32C as Counter;
   components new CounterToLocalTimeC(T32khz);
   CounterToLocalTimeC.Counter -> Counter;
   BoilerPlateC.LocalTime      -> CounterToLocalTimeC;
  
   components RovingNetworksC;
   BoilerPlateC.BluetoothInit -> RovingNetworksC.Init;
   BoilerPlateC.BTStdControl  -> RovingNetworksC.StdControl;
   BoilerPlateC.Bluetooth     -> RovingNetworksC;

   components AccelC;
   BoilerPlateC.AccelInit -> AccelC;
   BoilerPlateC.Accel     -> AccelC;

   components shimmerAnalogSetupC, Msp430DmaC;
   MainC.SoftwareInit               -> shimmerAnalogSetupC.Init;
   BoilerPlateC.shimmerAnalogSetup  -> shimmerAnalogSetupC;
   BoilerPlateC.DMA0                -> Msp430DmaC.Channel0;
/*
   components GyroBoardC;
   BoilerPlateC.GyroInit       -> GyroBoardC.Init;
   BoilerPlateC.GyroStdControl -> GyroBoardC.StdControl;
   BoilerPlateC.GyroBoard      -> GyroBoardC.GyroBoard;
*/
   components GyroMagBoardC;
   BoilerPlateC.GyroMagInit       -> GyroMagBoardC.Init;
   BoilerPlateC.GyroMagStdControl -> GyroMagBoardC.StdControl;
   BoilerPlateC.GyroMagBoard      -> GyroMagBoardC.GyroMagBoard;

   components BPCommandParserC;
   BoilerPlateC.BPCommandParser -> BPCommandParserC;

   components InternalFlashC;
   BoilerPlateC.InternalFlash -> InternalFlashC;

#ifdef USE_8MHZ_CRYSTAL
   components FastClockC;
   BoilerPlateC.FastClockInit -> FastClockC;
   BoilerPlateC.FastClock     -> FastClockC;
#endif
}
