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
 * TTSP Protocol.
 *
 * This component implements the TTSP time synchronization protocol.
 *
 * @author Hugo Freire <hugo.freire@ist.utl.pt>
**/

configuration AdaptiveTimeSyncC {
	provides {
		interface AdaptiveTimeSync;
		interface GlobalTime<TMilli>;
		interface StdControl;
		interface TimeSyncInfo;
	}
} implementation {
	components MainC;
	components AdaptiveTimeSyncP, TimeSyncC;
	components new TimerMilliC() as TimerC, LedsC;
	
	AdaptiveTimeSync = AdaptiveTimeSyncP;
	GlobalTime = TimeSyncC;
	StdControl = AdaptiveTimeSyncP;
	TimeSyncInfo = TimeSyncC;
	
	MainC.SoftwareInit -> AdaptiveTimeSyncP;
	
	AdaptiveTimeSyncP.Boot -> MainC;
	AdaptiveTimeSyncP.TimeSyncControl -> TimeSyncC;
	AdaptiveTimeSyncP.TimeSyncStdControl -> TimeSyncC;
	AdaptiveTimeSyncP.TimeSyncInfo -> TimeSyncC;
	AdaptiveTimeSyncP.Timer -> TimerC;
	AdaptiveTimeSyncP.Leds -> LedsC;
}