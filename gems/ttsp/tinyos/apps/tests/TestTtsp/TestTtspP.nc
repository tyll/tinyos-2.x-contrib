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

#include "BeaconBroadcaster.h"

module TestTtspP {
	uses {
		interface Boot;
		interface SplitControl as RadioControl;
		interface Receive;
		interface AMSend;
		interface Packet;
		interface StdControl as TtspControl;
		interface AdaptiveTimeSync;
		interface GlobalTime<TMilli>;
		interface LocalTime<TMilli>;
		interface TimeSyncInfo;
		interface Leds;
		interface Timer<TMilli>;
	}
} implementation {
	
	bool busy = FALSE;
	message_t sendBuffer;
	
	event void Boot.booted() {
		call AdaptiveTimeSync.setMaxPrecisionError(TTSP_MAX_PRECISION_ERROR);
		call TtspControl.start();
		call RadioControl.start();
	}

	event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
		BeaconMsg_t* beacon_msg = (BeaconMsg_t*)(call Packet.getPayload(msg, sizeof(BeaconMsg_t)));
		TestTtspMsg_t* ttsp_msg = (TestTtspMsg_t*)call Packet.getPayload(&sendBuffer, sizeof(TestTtspMsg_t));
		
		if (!busy) {
			ttsp_msg->srcAddr = TOS_NODE_ID;
			ttsp_msg->localTime = call LocalTime.get();

			ttsp_msg->globalTime = call GlobalTime.get(ttsp_msg->localTime);
			ttsp_msg->offset = call GlobalTime.getOffset(ttsp_msg->localTime);
			ttsp_msg->beaconId = beacon_msg->beaconId;
			ttsp_msg->rootId = call TimeSyncInfo.getRootId();
			ttsp_msg->maxPrecisionError = TTSP_MAX_PRECISION_ERROR;
			ttsp_msg->syncPeriod = call AdaptiveTimeSync.getSyncPeriod();

			call Timer.startOneShot(TOS_NODE_ID * 64);
			
			busy = TRUE;
		}
		return msg;
	}
	
	event void Timer.fired() {
		call AMSend.send(AM_BROADCAST_ADDR, &sendBuffer, sizeof(TestTtspMsg_t));
		
		busy = FALSE;
	}
	
	event void RadioControl.startDone(error_t err) {}
	event void RadioControl.stopDone(error_t error) {}	
	event void AMSend.sendDone(message_t* ptr, error_t success) {}
}
