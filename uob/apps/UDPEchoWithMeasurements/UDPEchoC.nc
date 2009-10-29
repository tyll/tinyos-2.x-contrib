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

configuration UDPEchoC {

} implementation {
  components MainC, LedsC;
  components UDPEchoP;

  UDPEchoP.Boot -> MainC;
  UDPEchoP.Leds -> LedsC;

  components new TimerMilliC();
  components IPDispatchC;

  UDPEchoP.RadioControl -> IPDispatchC;
  components
    new UdpSocketC() as Echo,
    new UdpSocketC() as Status,
    new UdpSocketC() as Measurements;

  UDPEchoP.Echo -> Echo;
  UDPEchoP.Status -> Status;
  UDPEchoP.Measurements -> Measurements;

  UDPEchoP.StatusTimer -> TimerMilliC;
  UDPEchoP.MeasurementTimer -> TimerMilliC;

  components UdpC;
  UDPEchoP.IPStats -> IPDispatchC.IPStats;
  UDPEchoP.UDPStats -> UdpC;
  UDPEchoP.RouteStats -> IPDispatchC.RouteStats;
  UDPEchoP.ICMPStats -> IPDispatchC.ICMPStats;

  components RandomC;
  UDPEchoP.Random -> RandomC;

  components UDPShellC;

  components new ShellCommandC("id") as Id;
  UDPEchoP.IdShellCommand -> Id;
  components new ShellCommandC("measure") as Meas;
  UDPEchoP.MeasShellCommand -> Meas;
  components new ShellCommandC("set") as Set;
  UDPEchoP.SetShellCommand -> Set;

  components MeasurementCollectorC;
  UDPEchoP.MeasCollector -> MeasurementCollectorC;
  MeasurementCollectorC.Leds -> LedsC;

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
  UDPEchoP.SerialId -> Ds2411C;

  components MoteIdDbC;
  UDPEchoP.MoteIdDb -> MoteIdDbC;

  components IPAddressC;
  UDPEchoP.IPAddress -> IPAddressC;

  components CC2420ControlC;
  UDPEchoP.CC2420Config -> CC2420ControlC;
#endif

}
