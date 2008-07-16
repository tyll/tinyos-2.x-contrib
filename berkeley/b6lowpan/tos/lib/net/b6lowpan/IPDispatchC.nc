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

/*
 * Provides message dispatch based on the next header field of IP packets.
 *
 */
#include "IPDispatch.h"

configuration IPDispatchC {
  provides {
    interface SplitControl;
    interface IPSend[uint8_t nxt];
    interface IPReceive[uint8_t nxt];
    interface BufferPool[uint8_t nxt];
    interface BasicPacket;
    interface IPPacket;

    interface Statistics<ip_statistics_t> as IPStats;
    interface Statistics<route_statistics_t> as RouteStats;
    interface Statistics<icmp_statistics_t> as ICMPStats;
  }
} implementation {
  components MainC, CC2420MessageC, IPDispatchP;
  components LedsC;

  SplitControl = CC2420MessageC;
  IPSend = IPDispatchP;
  IPReceive = IPDispatchP;
  IPPacket = IPDispatchP;
  BasicPacket = IPDispatchP;

  IPDispatchP.Boot -> MainC;

  IPDispatchP.IEEE154Send -> CC2420MessageC;
  IPDispatchP.IEEE154Receive -> CC2420MessageC;
  IPDispatchP.IEEE154Packet -> CC2420MessageC;
  IPDispatchP.PacketLink -> CC2420MessageC;
  IPDispatchP.Packet -> CC2420MessageC;
  IPDispatchP.CC2420Config -> CC2420MessageC;
  IPDispatchP.CC2420Packet -> CC2420MessageC;

  IPDispatchP.Leds -> LedsC;

  components new TimerMilliC();
  IPDispatchP.ExpireTimer -> TimerMilliC;

  components new PoolC(send_entry_t, 5), new QueueC(send_entry_t *, 5);
  IPDispatchP.Pool -> PoolC;
  IPDispatchP.Queue -> QueueC;

  components new BufferPoolC(0,5,1);
  BufferPool = BufferPoolC;
  IPDispatchP.BufferPool -> BufferPoolC.BufferPool[0];

  components ICMPResponderC;
  ICMPResponderC.BufferPool -> BufferPoolC.BufferPool[IANA_ICMP];
  IPDispatchP.ICMP -> ICMPResponderC;
  IPRoutingP.ICMP  -> ICMPResponderC;
  IPDispatchP.RadioControl -> CC2420MessageC;

  components IPRoutingP;
  IPDispatchP.IPRouting -> IPRoutingP;
  IPRoutingP.Boot -> MainC;
  IPRoutingP.Leds -> LedsC;

  IPStats    = IPDispatchP;
  RouteStats = IPRoutingP;
  ICMPStats  = ICMPResponderC;

  components new TimerMilliC() as RouteTimer;
  IPRoutingP.SortTimer -> RouteTimer;

}
