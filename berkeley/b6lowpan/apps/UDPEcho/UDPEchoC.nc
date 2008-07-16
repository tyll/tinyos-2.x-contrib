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
  components UDPC, UDPEchoP;

  UDPEchoP.Boot -> MainC;
  UDPEchoP.Leds -> LedsC;

  UDPEchoP.RadioControl -> UDPC;
  UDPEchoP.UDPReceive -> UDPC.UDPReceive[7];
  UDPEchoP.UDPSend -> UDPC.UDPSend[7];

  UDPEchoP.BufferPool -> UDPC;


  components new TimerMilliC();

  components IPDispatchC;

  UDPEchoP.RouteTimer -> TimerMilliC;
  UDPEchoP.RouteSend  -> UDPC.UDPSend[7000];
  UDPEchoP.IPPacket   -> IPDispatchC;
  UDPEchoP.UdpPacket  -> UDPC;

  UDPEchoP.IPStats -> IPDispatchC.IPStats;
  UDPEchoP.RouteStats -> IPDispatchC.RouteStats;
  UDPEchoP.ICMPStats -> IPDispatchC.ICMPStats;

  components RandomC;
  UDPEchoP.Random -> RandomC;
}
