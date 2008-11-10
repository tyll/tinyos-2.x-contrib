/*
* Copyright (c) 2007 University of Iowa 
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* - Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
* - Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the
*   distribution.
* - Neither the name of The University of Iowa  nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Timesync suite of interfaces, components, testing tools, and documents.
 * @author Ted Herman
 * Development supported in part by NSF award 0519907. 
 */
//--EOCpr712 (do not remove this line, which terminates copyright include)

configuration TsyncC {
  provides interface OTime;
  provides interface Tsync;
  provides interface Boot as componentBoot;
  provides interface Neighbor[uint8_t type];
  }
implementation {
  components TsyncP, WakkerC, PowConC, OTimeC, TnbrhoodC; 
  components MainC;
  components LedsC, NoLedsC;
  components new PowCommC(AM_BEACON) as CommBeacon;
  components new PowCommC(AM_UART) as CommUART;
  components new PowCommC(AM_BEACON_PROBE) as CommProbe;
  components new PowCommC(AM_PROBE_ACK) as CommProbeAck;
  components new PowCommC(AM_PROBE_DEBUG) as CommProbeDebug;
  components MarginC;
  #if defined(PLATFORM_TELOSB)
  // components Counter32khz16C;
  #elif defined(PLATFORM_MICAZ)
  // components MicaCounter32khz16C as Counter32khz16C;
  #endif
  #ifdef TRACK
  components TskewC;
  #endif
  componentBoot = TsyncP.componentBoot;
  Tsync = TsyncP;
  OTime = OTimeC;
  Neighbor = TnbrhoodC;
  TsyncP.Boot -> MainC;
  TsyncP.AMControl -> PowConC;
  TsyncP.Wakker -> WakkerC.Wakker[unique("Wakker")];
  TsyncP.PowCon -> PowConC.PowCon[unique("PowCon")];
  TsyncP.OTime -> OTimeC.OTime;
  TsyncP.Tnbrhood -> TnbrhoodC.Tnbrhood;
  TsyncP.Neighbor -> TnbrhoodC.Neighbor[0];
  #ifdef TUART
  TsyncP.UARTSend -> CommUART.AMSend;
  #endif
  TsyncP.BeaconReceive -> CommBeacon.Receive;
  TsyncP.ProbeSend -> CommProbeAck.AMSend;
  TsyncP.ProbeDebug -> CommProbeDebug.AMSend;
  TsyncP.ProbeReceive -> CommProbe.Receive;
  TsyncP.MsgLeds -> NoLedsC.Leds;
  TsyncP.Leds -> LedsC.Leds;
  // TsyncP.Counter -> Counter32khz16C;
  // following is for a demonstration mode
  #ifdef DEMO_LIGHTS
  TsyncP.ShowLeds -> LedsC.Leds;
  #endif
  // RadioStack Specific
  components CC2420TimeSyncMessageC;
  components CC2420PacketC;
  TsyncP.PacketTimeStamp -> CC2420PacketC;
  TsyncP.BeaconSend -> CC2420TimeSyncMessageC.TimeSyncAMSendMicro[AM_BEACON];
  TsyncP.TimeSyncPacket -> CC2420TimeSyncMessageC.TimeSyncPacketMicro;
  }

