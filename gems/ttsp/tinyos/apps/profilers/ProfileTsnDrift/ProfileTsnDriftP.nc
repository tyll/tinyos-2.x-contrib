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
 * Tagus-SensorNet drift profile application.
 *
 * This component implements a test application to profile the
 * existent drift on Tagus-SensorNet sensor nodes.
 *
 * @author Hugo Freire <hugo.freire@ist.utl.pt>
**/

#include "Sensors.h"
#include "ReferenceBroadcaster.h"

module ProfileTsnDriftP {
	uses {
		interface Boot;
		interface SplitControl as RadioControl;
		interface Receive;
		interface AMSend as Send;
		interface TimeSyncPacket<T32khz,uint32_t>;
		interface Packet;
		interface Leds;
//		interface Read<uint16_t> as Sensors[uint8_t type];
		interface Timer<TMilli>;
	}
} implementation {

	message_t buf;
	bool busy = FALSE;
	
	event void Boot.booted() {
		call RadioControl.start();
	}
	
	event void RadioControl.startDone(error_t err) {}
	
	event void RadioControl.stopDone(error_t error){}
	
	event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
		
		if (busy == FALSE) {
			ReportMsg_t *report = (ReportMsg_t*) call Packet.getPayload(&buf, sizeof(ReportMsg_t));
			
			if ((call TimeSyncPacket.isValid(msg)) == TRUE) {
				busy = TRUE;
				
				report->srcAddr = TOS_NODE_ID;
				report->refId = ((ReferenceMsg_t*) payload)->refId;
				report->refTimestamp = ((ReferenceMsg_t*) payload)->refTimestamp;
				report->localTimestamp = call TimeSyncPacket.eventTime(msg);

//				call Sensors.read[SENSOR_TYPE_TEMP]();
				report->temperature = 0;
				
				
				call Timer.startOneShot((TOS_NODE_ID-100)*30);
			}
			
		}
		return msg;
	}
	
	event void Send.sendDone(message_t *msg, error_t success) {
		call Leds.led0Toggle();
		busy = FALSE;
	}
	
/*	event void Sensors.readDone[uint8_t type](error_t result, uint16_t data) {
		if (result == SUCCESS) {
			ReportMsg_t *report = (ReportMsg_t*) call Packet.getPayload(&buf, sizeof(ReportMsg_t));
			
			report->temperature = data;

			call Leds.led0Toggle();
			call Send.send(AM_BROADCAST_ADDR, &buf, sizeof(ReportMsg_t));
		}
		busy = FALSE;
	}
	
	default command error_t Sensors.read[uint8_t type]() {
		return FAIL;
	} */
	
	event void Timer.fired() {
		call Leds.led0Toggle();
		call Send.send(AM_BROADCAST_ADDR, &buf, sizeof(ReportMsg_t));
	}
}
