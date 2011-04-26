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
 * Basic interface to control the pair-wise and network-wide synchronization
 * algorithms.
 *
 * This interface allows other components to control the behaviour of the underlying
 * pair-wise and network-wide synchronization algorithms.
 *
 * @author Hugo Freire <hugo.freire@ist.utl.pt>
**/

interface TimeSyncControl {
	async command error_t sendMsg();
	event void foundRoot(uint32_t syncPeriod, uint16_t nodeID);
	event void foundFalseRoot();
	event void synced();
	event void msgReceived();	
	event void sendDone();
	event void currentPrecisionError(uint8_t currentSeqNum, uint16_t nodeID, uint32_t currentTimePrecisionError);
	command error_t clearTable();
	command error_t setRoot();
	command error_t setSyncPeriod(uint32_t syncPeriod);
	command void removeOldestSyncPoint();
}