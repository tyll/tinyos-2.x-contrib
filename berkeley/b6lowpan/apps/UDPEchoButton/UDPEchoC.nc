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

configuration UDPEchoC {

} implementation {
  components MainC, LedsC;
  components UDPEchoP;

  UDPEchoP.Boot -> MainC;
  UDPEchoP.Leds -> LedsC;

  components new TimerMilliC() as StatusTimerC;
  components IPDispatchC;

  UDPEchoP.RadioControl -> IPDispatchC;
  UDPEchoP.Echo -> IPDispatchC.UDP[7];
  UDPEchoP.Status -> IPDispatchC.UDP[7000];

  UDPEchoP.StatusTimer -> StatusTimerC;

  UDPEchoP.IPStats -> IPDispatchC.IPStats;
  UDPEchoP.RouteStats -> IPDispatchC.RouteStats;
  UDPEchoP.ICMPStats -> IPDispatchC.ICMPStats;

  components RandomC;
  UDPEchoP.Random -> RandomC;

  components UDPShellC;
  UDPShellC.UDP -> IPDispatchC.UDP[0xF0B0];

  components new TimerMilliC() as DebugTimerC;
  UDPEchoP.DebugTimer -> DebugTimerC;

  //// UserButtonC component is added and wired
  //components UserButtonC;
  //UDPEchoP.Get -> UserButtonC;
  //UDPEchoP.Notify -> UserButtonC;
}
