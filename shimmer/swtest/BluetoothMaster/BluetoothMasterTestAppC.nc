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
 *         August, 2010
 *
 * @author Steve Ayer
 * @date December, 2010
 */

 /* This app uses Bluetooth to stream 3 Accelerometer channels and 1 GSR channel
    of data to a BioMOBIUS PC application.
    Tested on SHIMMER Base Board Rev 1.3 and SEDA Rev.1 */

configuration BluetoothMasterTestAppC {
}
implementation {
  components MainC, BluetoothMasterTestC;
  BluetoothMasterTestC -> MainC.Boot;

  components FastClockC;
  BluetoothMasterTestC.FastClockInit -> FastClockC;
  BluetoothMasterTestC.FastClock     -> FastClockC;

  components LedsC;
  BluetoothMasterTestC.Leds  -> LedsC;

  components new TimerMilliC() as SampleTimer;
  BluetoothMasterTestC.SampleTimer -> SampleTimer;
  components new TimerMilliC() as ConnectTimer;
  BluetoothMasterTestC.ConnectTimer -> ConnectTimer;
  components new TimerMilliC() as BluetoothMasterTestTimer;
  BluetoothMasterTestC.BluetoothMasterTestTimer -> BluetoothMasterTestTimer;
  
  components Counter32khz32C as Counter;
  components new CounterToLocalTimeC(T32khz);
  CounterToLocalTimeC.Counter -> Counter;
  BluetoothMasterTestC.LocalTime -> CounterToLocalTimeC;

  components RovingNetworksC;
  BluetoothMasterTestC.BluetoothInit  -> RovingNetworksC;
  BluetoothMasterTestC.BTStdControl   -> RovingNetworksC;
  BluetoothMasterTestC.Bluetooth      -> RovingNetworksC;

  components AccelC;
  BluetoothMasterTestC.AccelInit -> AccelC;
  BluetoothMasterTestC.Accel     -> AccelC;

  components GyroBoardC;
  BluetoothMasterTestC.GyroInit        -> GyroBoardC;
  BluetoothMasterTestC.GyroStdControl  -> GyroBoardC;
  BluetoothMasterTestC.GyroBoard       -> GyroBoardC;

  components shimmerAnalogSetupC, Msp430DmaC;
  MainC.SoftwareInit -> shimmerAnalogSetupC.Init;
  BluetoothMasterTestC.shimmerAnalogSetup -> shimmerAnalogSetupC;
  BluetoothMasterTestC.DMA0 -> Msp430DmaC.Channel0;
}

