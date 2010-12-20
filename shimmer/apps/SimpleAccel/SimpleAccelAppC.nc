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
 * @date   October, 2010
 */

/***********************************************************************************

   This app uses Bluetooth to stream 3 Accelerometer channels 

***********************************************************************************/

configuration SimpleAccelAppC {
}
implementation {
   components MainC, SimpleAccelC;
   SimpleAccelC -> MainC.Boot; 

   components LedsC;
   SimpleAccelC.Leds -> LedsC;

   components new TimerMilliC() as SampleTimer;
   SimpleAccelC.SampleTimer -> SampleTimer;
   components new TimerMilliC() as ActivityTimer;
   SimpleAccelC.ActivityTimer -> ActivityTimer;

   components RovingNetworksC;
   SimpleAccelC.BluetoothInit -> RovingNetworksC.Init;
   SimpleAccelC.BTStdControl  -> RovingNetworksC.StdControl;
   SimpleAccelC.Bluetooth     -> RovingNetworksC;

   components AccelC;
   SimpleAccelC.AccelInit -> AccelC;
   SimpleAccelC.Accel     -> AccelC;

   components shimmerAnalogSetupC, Msp430DmaC;
   MainC.SoftwareInit              -> shimmerAnalogSetupC.Init;
   SimpleAccelC.shimmerAnalogSetup -> shimmerAnalogSetupC;
   SimpleAccelC.DMA0               -> Msp430DmaC.Channel0;
}
