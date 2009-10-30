/*
 * "Copyright (c) 2008 The Regents of the University  of California.
 * All rights reserved."
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

#include <6lowpan.h>
#ifdef DBG_TRACK_FLOWS
#include "TestDriver.h"
#endif

configuration UDPServicesC {

} implementation {
  components MainC, LedsC;
  components UDPServicesP;

  UDPServicesP.Boot -> MainC;
  UDPServicesP.Leds -> LedsC;

  components new TimerMilliC();
  components IPDispatchC;

  UDPServicesP.RadioControl -> IPDispatchC;
  components new UdpSocketC() as Echo,
      new UdpSocketC() as Status,
      new UdpSocketC() as Services;

  UDPServicesP.Echo -> Echo;

  UDPServicesP.Status -> Status;
  UDPServicesP.StatusTimer -> TimerMilliC;

  UDPServicesP.Services -> Services;
  UDPServicesP.ServicesPushTimer -> TimerMilliC;

  components UdpC;
  UDPServicesP.IPStats -> IPDispatchC.IPStats;
  UDPServicesP.UDPStats -> UdpC;
  UDPServicesP.RouteStats -> IPDispatchC.RouteStats;
  UDPServicesP.ICMPStats -> IPDispatchC.ICMPStats;

  components RandomC;
  UDPServicesP.Random -> RandomC;

  components UDPShellC;

  components new ShellCommandC("id");
  UDPServicesP.ShellCommand -> ShellCommandC;

#ifdef SIM
  components BaseStationC;
#endif
#ifdef DBG_TRACK_FLOWS
  components TestDriverP, SerialActiveMessageC as Serial;
  components ICMPResponderC, IPRoutingP;
  TestDriverP.Boot -> MainC;
  TestDriverP.SerialControl -> Serial;
  TestDriverP.ICMPPing -> ICMPResponderC.ICMPPing[unique("PING")];
  TestDriverP.CmdReceive -> Serial.Receive[AM_TESTDRIVER_MSG];
  TestDriverP.IPRouting -> IPRoutingP;
  TestDriverP.DoneSend -> Serial.AMSend[AM_TESTDRIVER_MSG];
  TestDriverP.AckSend -> Serial.AMSend[AM_TESTDRIVER_ACK];
  TestDriverP.RadioControl -> IPDispatchC;
#endif
#ifdef DBG_FLOWS_REPORT
  components TrackFlowsC;
#endif

#if defined(PLATFORM_TELOSB)
  components Ds2411C;
  UDPServicesP.SerialId -> Ds2411C;

  components MoteIdDbC;
  UDPServicesP.MoteIdDb -> MoteIdDbC;

  components IPAddressC;
  UDPServicesP.IPAddress -> IPAddressC;

  components CC2420ControlC;
  UDPServicesP.CC2420Config -> CC2420ControlC;
#endif

}
