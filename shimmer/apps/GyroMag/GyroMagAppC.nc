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
this is the third-generation of adrian burns' biomobius accelgyro app, 
going into tinyos-2.x and now altering the input i/o to handle a non-analog
signal from a magnetometer.  
***********************************************************************************/
/*
 * @author Adrian Burns 
 * @date November, 2007
 *
 * @author Mike Healy
 * @date May 7, 2009 - ported to TinyOS 2.x 
 *
 * @author Steve Ayer
 * @date July, 2010   
 * this application is significantly modified to replace accel channels with mag.
 * @date February, 2011
 * modified to use separated gyroboard and magnetometer interfaces/implementations 
 * (gyromagboard now abandoned)
 */


configuration GyroMagAppC {
}
implementation {
  components MainC, GyroMagC;
  GyroMagC -> MainC.Boot; 

  components LedsC;
  GyroMagC.Leds -> LedsC;

  components FastClockC;
  GyroMagC.FastClockInit -> FastClockC;
  GyroMagC.FastClock -> FastClockC;
  
  components new TimerMilliC() as SampleTimer;
  GyroMagC.SampleTimer -> SampleTimer;
  components new TimerMilliC() as SetupTimer;
  GyroMagC.SetupTimer    -> SetupTimer;
  components new TimerMilliC() as ActivityTimer;
  GyroMagC.ActivityTimer -> ActivityTimer;
  
  components Counter32khz32C as Counter;
  components new CounterToLocalTimeC(T32khz);
  CounterToLocalTimeC.Counter -> Counter;
  GyroMagC.LocalTime -> CounterToLocalTimeC;
  
  components RovingNetworksC;
  GyroMagC.BluetoothInit -> RovingNetworksC.Init;
  GyroMagC.BTStdControl -> RovingNetworksC.StdControl;
  GyroMagC.Bluetooth    -> RovingNetworksC;

  components shimmerAnalogSetupC, Msp430DmaC;
  MainC.SoftwareInit -> shimmerAnalogSetupC.Init;
  GyroMagC.shimmerAnalogSetup -> shimmerAnalogSetupC;
  GyroMagC.DMA0 -> Msp430DmaC.Channel0;

  components GyroBoardC;
  GyroMagC.GyroInit         -> GyroBoardC.Init;
  GyroMagC.GyroStdControl   -> GyroBoardC.StdControl;
  GyroMagC.GyroBoard        -> GyroBoardC.GyroBoard;
  
  components MagnetometerC;
  GyroMagC.MagInit      -> MagnetometerC.Init;
  GyroMagC.Magnetometer -> MagnetometerC.Magnetometer;
}

