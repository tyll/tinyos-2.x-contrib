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
 * Beacon broadcaster application.
 * 
 * A beacon broadcaster is used to periodically broadcast a time query
 * and consequently listen to its answer.
 *
 * @author Hugo Freire <hugo.freire@ist.utl.pt>
**/

#include "BeaconBroadcaster.h"

configuration BeaconBroadcasterC {
}
implementation {
  components MainC, BeaconBroadcasterP, LedsC;
  components ActiveMessageC as Radio;
  components ActiveMessageC as BeaconRadio;
  components SerialActiveMessageC as Serial;
  components LocalTimeMilliC;
  components new TimerMilliC() as TimerC;
  components DelugeC;
  
  MainC.Boot <- BeaconBroadcasterP;

  BeaconBroadcasterP.RadioControl -> Radio;
  BeaconBroadcasterP.SerialControl -> Serial;
  
  BeaconBroadcasterP.UartSend -> Serial;
  BeaconBroadcasterP.UartReceive -> Serial.Receive;
  BeaconBroadcasterP.UartPacket -> Serial;
  BeaconBroadcasterP.UartAMPacket -> Serial;
  
  BeaconBroadcasterP.RadioSend -> Radio.AMSend;
  BeaconBroadcasterP.AMSend -> BeaconRadio.AMSend[AM_BEACONMSG];
  BeaconBroadcasterP.RadioReceive -> Radio.Receive;
  BeaconBroadcasterP.RadioSnoop -> Radio.Snoop;
  BeaconBroadcasterP.RadioPacket -> Radio;
  BeaconBroadcasterP.RadioAMPacket -> Radio;

  BeaconBroadcasterP.LocalTime  -> LocalTimeMilliC;

  BeaconBroadcasterP.Timer -> TimerC;  
  
  BeaconBroadcasterP.Leds -> LedsC;

  DelugeC.Leds -> LedsC;
}
