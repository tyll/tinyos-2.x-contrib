/*
 * Copyright (c) 2007, Intel Corporation
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * Redistributions of source code must retain the above copyright notice, 
 * this list of conditions and the following disclaimer. 
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution. 
 *
 * Neither the name of the Intel Corporation nor the names of its contributors
 * may be used to endorse or promote products derived from this software 
 * without specific prior written permission. 
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Author: Adrian Burns
 *         November, 2007
 */

/***********************************************************************************

   This app uses Bluetooth to stream 3 Accelerometer channels and 3 Gyro channels 
   of data to a BioMOBIUS PC application. 
   Tested on SHIMMER Base Board Rev 1.3, SHIMMER GyroDB 1.0 board.

***********************************************************************************/
/*
 * @author Adrian Burns 
 * @date November, 2007
 *
 * @author Mike Healy
 * @date May 7, 2009 - ported to TinyOS 2.x 
 */


configuration AccelGyroAppC {
}
implementation {
  components MainC, AccelGyroC;
  AccelGyroC -> MainC.Boot; 

  components FastClockC;
  AccelGyroC.FastClockInit -> FastClockC;
  AccelGyroC.FastClock     -> FastClockC;
  
  components LedsC;
  AccelGyroC.Leds -> LedsC;

  components new TimerMilliC() as SampleTimer;
  AccelGyroC.SampleTimer -> SampleTimer;
  components new TimerMilliC() as SetupTimer;
  AccelGyroC.SetupTimer    -> SetupTimer;
  components new TimerMilliC() as ActivityTimer;
  AccelGyroC.ActivityTimer -> ActivityTimer;
  
  components Counter32khz32C as Counter;
  components new CounterToLocalTimeC(T32khz);
  CounterToLocalTimeC.Counter -> Counter;
  AccelGyroC.LocalTime -> CounterToLocalTimeC;
  
  components RovingNetworksC;
  AccelGyroC.BluetoothInit -> RovingNetworksC.Init;
  AccelGyroC.BTStdControl -> RovingNetworksC.StdControl;
  AccelGyroC.Bluetooth    -> RovingNetworksC;

  components AccelC;
  AccelGyroC.AccelInit -> AccelC;
  AccelGyroC.Accel -> AccelC;

  components shimmerAnalogSetupC, Msp430DmaC;
  MainC.SoftwareInit -> shimmerAnalogSetupC.Init;
  AccelGyroC.shimmerAnalogSetup -> shimmerAnalogSetupC;
  AccelGyroC.DMA0 -> Msp430DmaC.Channel0;

  components GyroBoardC;
  AccelGyroC.GyroInit           -> GyroBoardC.Init;
  AccelGyroC.GyroStdControl     -> GyroBoardC.StdControl;
  AccelGyroC.GyroBoard      -> GyroBoardC.GyroBoard;

  
#ifdef USE_8MHZ_CRYSTAL
  //   components BusyWaitMicroC;
  //   AccelGyroC.BusyWait -> BusyWaitMicroC;
#endif
}

