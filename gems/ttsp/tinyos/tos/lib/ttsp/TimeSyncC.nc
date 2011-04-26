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
 * TTSP pair-wise and network-wide synchronization implementation.
 *
 * This component implements the pair-wise and network-wide synchronization
 * algorithms used by TTSP synchronization protocol.
 *
 * @author Hugo Freire <hugo.freire@ist.utl.pt>
**/

#include "TimeSyncMsg.h"

configuration TimeSyncC {
	provides {
		interface GlobalTime<TMilli>;
		interface StdControl;
		interface TimeSyncControl;
		interface TimeSyncInfo;
	}
} implementation {
	components MainC, new TimeSyncP(TMilli);
	components TimeSyncMessageC;
	components HilTimerMilliC, LedsC;
	
	GlobalTime = TimeSyncP;
	StdControl = TimeSyncP;
	TimeSyncControl = TimeSyncP;
	TimeSyncInfo = TimeSyncP;
	
	MainC.SoftwareInit -> TimeSyncP;
	
	TimeSyncP.Boot -> MainC;
  TimeSyncP.RadioControl -> TimeSyncMessageC;
  TimeSyncP.Send -> TimeSyncMessageC.TimeSyncAMSendMilli[AM_TTSPMSG];
  TimeSyncP.Receive -> TimeSyncMessageC.Receive[AM_TTSPMSG];
  TimeSyncP.TimeSyncPacket -> TimeSyncMessageC;	
  TimeSyncP.Packet -> TimeSyncMessageC;
  TimeSyncP.LocalTime -> HilTimerMilliC;
}