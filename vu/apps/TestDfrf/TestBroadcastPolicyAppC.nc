/*
 * Copyright (c) 2009, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai
 */

#include "CounterPacket.h"
configuration TestBroadcastPolicyAppC {
} implementation {
  components TestBroadcastPolicyC as App, MainC, BroadcastPolicyC as Policy, new TimerMilliC() as Timer, LedsC, ActiveMessageC as AM;
  components new DfrfClientC(APPID_COUNTER, counter_packet_t, sizeof(counter_packet_t), 15) as DfrfService;

  // initialization and startup
  App -> MainC.Boot;
  App.AMControl -> AM.SplitControl;

  // routing control/send/receive/policy
  App.DfrfControl -> DfrfService.StdControl;
  App.DfrfSend -> DfrfService;
  App.DfrfReceive -> DfrfService;
  DfrfService.Policy -> Policy;

  // app wirings
  App.Timer -> Timer;
  App.Leds -> LedsC;
  App.AMPacket -> AM;

#if defined(DFRF_MICRO)
  components LocalTimeMicroC as LocalTimeProviderC;
#elif defined(DFRF_32KHZ)
  components LocalTime32khzC as LocalTimeProviderC;
#else
  components HilTimerMilliC as LocalTimeProviderC;
#endif
  App.LocalTime -> LocalTimeProviderC;

  // RemoteControll components
  components LedCommandsC;
}
