/*
 * TTSP - Tagus Time Synchronization Protocol
 *
 * Copyright (c) 2010 Hugo Freire and IT - Instituto de Telecomunicacoes
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * Address:
 * Instituto Superior Tecnico - Taguspark Campus
 * Av. Prof. Dr. Cavaco Silva, 2744-016 Porto Salvo
 *
 * E-Mail:
 * hugo.freire@ist.utl.pt
 */

/**
 * TTSP test application.
 *
 * This component implements a basic test application where the node
 * with the lower TOS_NODE_ID will be declared the time synchronization
 * root and every other available node will synchronize its time with it.
 *
 * @author Hugo Freire <hugo.freire@ist.utl.pt>
**/

#include "TestTtsp.h"
#include "BeaconBroadcaster.h"

configuration TestTtspAppC {
} implementation {
  components MainC, TestTtspP;
	components AdaptiveTimeSyncC;
	components LocalTimeMilliC;
	components ActiveMessageC;
	components LedsC, DelugeC;
	components new TimerMilliC();
	
  TestTtspP.Boot -> MainC;
  TestTtspP.AdaptiveTimeSync -> AdaptiveTimeSyncC;
  TestTtspP.TtspControl -> AdaptiveTimeSyncC;
  TestTtspP.TimeSyncInfo -> AdaptiveTimeSyncC;
  TestTtspP.GlobalTime -> AdaptiveTimeSyncC;
  TestTtspP.LocalTime -> LocalTimeMilliC;
  TestTtspP.RadioControl -> ActiveMessageC;
  TestTtspP.Receive -> ActiveMessageC.Receive[AM_BEACONMSG];
	TestTtspP.AMSend -> ActiveMessageC.AMSend[AM_TESTTTSPMSG];
  TestTtspP.Packet -> ActiveMessageC;
  TestTtspP.Leds -> LedsC;
  TestTtspP.Timer -> TimerMilliC;
  
	DelugeC.Leds -> LedsC;
}
