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
 * Reference broadcaster application.
 * 
 * A reference broadcaster is used to periodically broadcast a time query
 * and consequently listen to its answer.
 *
 * @author Hugo Freire <hugo.freire@ist.utl.pt>
**/

#include "ReferenceBroadcaster.h"

configuration ReferenceBroadcasterC {
}
implementation {
  components MainC, ReferenceBroadcasterP, LedsC;
  components ActiveMessageC as Radio, TimeSyncMessageC as TimeSyncRadio, SerialActiveMessageC as Serial;
  components Counter32khz32C, new CounterToLocalTimeC(T32khz) as LocalTime32khzC;
  components new TimerMilliC() as TimerC;
  components DelugeC;
  
  MainC.Boot <- ReferenceBroadcasterP;

  ReferenceBroadcasterP.RadioControl -> Radio;
  ReferenceBroadcasterP.SerialControl -> Serial;
  
  ReferenceBroadcasterP.UartSend -> Serial;
  ReferenceBroadcasterP.UartReceive -> Serial.Receive;
  ReferenceBroadcasterP.UartPacket -> Serial;
  ReferenceBroadcasterP.UartAMPacket -> Serial;
  
  ReferenceBroadcasterP.RadioSend -> Radio.AMSend;
  ReferenceBroadcasterP.TimeSyncRadioSend -> TimeSyncRadio.TimeSyncAMSend32khz[AM_REFERENCEMSG];
  ReferenceBroadcasterP.RadioReceive -> Radio.Receive;
  ReferenceBroadcasterP.RadioSnoop -> Radio.Snoop;
  ReferenceBroadcasterP.RadioPacket -> Radio;
  ReferenceBroadcasterP.RadioAMPacket -> Radio;
  
  LocalTime32khzC.Counter -> Counter32khz32C;
  ReferenceBroadcasterP.LocalTime     -> LocalTime32khzC;

  ReferenceBroadcasterP.Timer -> TimerC;  
  
  ReferenceBroadcasterP.Leds -> LedsC;

  DelugeC.Leds -> LedsC;
}
