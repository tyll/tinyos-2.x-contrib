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

 /* This app uses Bluetooth to stream 3 Accelerometer channels and 2 ECG channels 
    of data to a BioMOBIUS PC application. 
    Tested on SHIMMER Base Board Rev 1.3, SHIMMER ECG board Rev 1.1. */

/*
 * @author Adrian Burns 
 * @date November, 2007
 *
 * @author Mike Healy
 * @date May 13, 2009 - ported to TinyOS 2.x 
 */


configuration AccelECGAppC {
}
implementation {
  components MainC, AccelECGC;
  AccelECGC -> MainC.Boot; 

  components FastClockC;
  AccelECGC.FastClockInit -> FastClockC;
  AccelECGC.FastClock     -> FastClockC;
  
  components LedsC;
  AccelECGC.Leds -> LedsC;

  components new TimerMilliC() as SampleTimer;
  AccelECGC.SampleTimer -> SampleTimer;
  components new TimerMilliC() as SetupTimer;
  AccelECGC.SetupTimer    -> SetupTimer;
  components new TimerMilliC() as ActivityTimer;
  AccelECGC.ActivityTimer -> ActivityTimer;
  
  components Counter32khz32C as Counter;
  components new CounterToLocalTimeC(T32khz);
  CounterToLocalTimeC.Counter -> Counter;
  AccelECGC.LocalTime -> CounterToLocalTimeC;
  
  components RovingNetworksC;
  AccelECGC.BluetoothInit -> RovingNetworksC.Init;
  AccelECGC.BTStdControl -> RovingNetworksC.StdControl;
  AccelECGC.Bluetooth    -> RovingNetworksC;

  components AccelC;
  AccelECGC.AccelInit -> AccelC;
  AccelECGC.Accel -> AccelC;

  components shimmerAnalogSetupC, Msp430DmaC;
  MainC.SoftwareInit -> shimmerAnalogSetupC.Init;
  AccelECGC.shimmerAnalogSetup -> shimmerAnalogSetupC;
  AccelECGC.DMA0 -> Msp430DmaC.Channel0;

}

