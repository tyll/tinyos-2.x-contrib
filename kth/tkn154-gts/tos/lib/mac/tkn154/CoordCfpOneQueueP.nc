/*
 * Copyright (c) 2010, KTH Royal Institute of Technology
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions 
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright 
 *   notice, this list of conditions and the following disclaimer in the 
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the KTH Royal Institute of Technology nor the names 
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY 
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */
/**
 * This components would deal with the GTS for an outcoming superframe from 
 * the perspective of a coordinator. It contains the functions and variables 
 * necessaries for the coordinator to be able to transmit, receive and manage
 * the GTS.
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version  $Revision$
 * @modified 2010/11/19
 */

#include "TKN154_MAC.h"

#warning "Beacon transmission enabled -> COORDINADOR"
#warning "GTS enabled"

module CoordCfpOneQueueP
{
	provides
	{
		interface Init;
		interface WriteBeaconField as GtsInfoWrite;
		interface MLME_GTS;

		interface Get<ieee154_GTSdb_t*> as GetGtsCoordinatorDb;

		interface Notify<bool> as GtsSpecUpdated;
	}
	uses
	{
		interface MLME_GET;
		interface TimeCalc;

		interface LocalTime<TSymbolIEEE802154>;
		interface IEEE154Frame as Frame;
		interface SuperframeStructure as SF;

		interface Pool<ieee154_txframe_t> as TxFramePool;
		interface Pool<ieee154_txcontrol_t> as TxControlPool;

		interface GtsUtility;

		interface FrameRx as GtsRequestRx;

		interface Notify<uint8_t> as HasGtsSlotExpired;
		interface Notify<bool> as HasCfpExpired;

		interface Queue<ieee154_rxframe_gts_t> as GtsRequestQueue;
	}
}
implementation
{
	enum {
		RADIO_TRANSFER_TO = RADIO_CLIENT_BEACONTRANSMIT,
	};

	uint8_t m_state;

	enum {
		PROCESS_DONE_PENDING = 0x01,
		REQUEST_PENDING = 0x2,
	};

	uint8_t m_gtsSpecField[GTS_LIST_MULTIPLY*CFP_NUMBER_SLOTS+2];

	/* variables that store the GTS entries
	 * we have two vector becuse we need to manage the slots for the next superframe
	 * and the slots to use in the current one. Otherwise the device/coordinator 
	 * are not synchronize 
	 */
	ieee154_GTSentry_t db[CFP_NUMBER_SLOTS];
	ieee154_GTSentry_t dbNext[CFP_NUMBER_SLOTS];

	ieee154_GTSdb_t GTSdb;
	ieee154_GTSdb_t GTSdbNext;
	uint8_t indexGtsSlot = 0;

	/* ----------------------- Vars to GTS request ----------------------- */
	uint8_t m_gtsCharacteristicsType = GTS_DEALLOCATE_REQUEST;
	ieee154_GTSentry_t GtsEntryRequested;

	ieee154_GTSentry_t* currentEntry;
	norace uint16_t m_expiredTimeout;

	/* ----------------------- Vars to deallocation ----------------------- */
	ieee154_GTSentry_t GtsEntryDeallocate[CFP_NUMBER_SLOTS]; // store the deallocations
	uint8_t m_gtsDeallocateIn; //point to the new position
	uint8_t m_gtsDeallocateOut; //point to the last

	/* ----------------------- Special Functions ----------------------- */
	task void processGtsRequestTask();
	task void processGtsQueueTask();
	task void processGtsQueueTaskDone();
	task void processGtsRequestTaskDone();

	bool isGtsRequestDonePending() {return (m_state & PROCESS_DONE_PENDING) ? TRUE : FALSE;}
	void setGtsRequestDonePending() {m_state |= PROCESS_DONE_PENDING;}
	void resetGtsRequestDonePending() {m_state &= ~PROCESS_DONE_PENDING;}
	// set when we need to start/stop to serve gts request
	bool isGtsRequestWaitPending() {return (m_state & REQUEST_PENDING) ? TRUE : FALSE;}
	void setGtsRequestWaitPending() {m_state |= REQUEST_PENDING;}
	void resetGtsRequestWaitPending() {m_state &= ~REQUEST_PENDING;}

	/***************************************************************************************
	 * INITIALIZE FUNCTIONS
	 ***************************************************************************************/
	command error_t Init.init()
	{
		//Initialization of the coordinator db
		GTSdb.db = db;
		GTSdb.numGtsSlots = 0;

		GTSdbNext.db = dbNext;
		GTSdbNext.numGtsSlots = 0;

		atomic {
			m_gtsDeallocateIn = 0;
			m_gtsDeallocateOut = 0;
		}
		m_state = 0x00;

		return SUCCESS;
	}

	/***************************************************************************************
	 * BEACON FUNCTIONS
	 ***************************************************************************************/
	command uint8_t GtsInfoWrite.write(uint8_t *gtsSpecField, uint8_t maxlen)
	{
		/* write the current GTS spec at the given address
		 * this is the place to update the GTS Fields with db
		 * Here. the GTSdb = GTSdbnext because we update them at the
		 * end of the superframe
		 */

		uint8_t len = call GtsInfoWrite.getLength();
		uint8_t directionMask = 0x00;
		uint8_t i;

		if (len > maxlen)
		return 0;

		//GTS Specification
		//gtsSpecField[0] = ( GTSdbNext.numGtsSlots << 0) | (call MLME_GET.macGTSPermit() << 7);

		gtsSpecField[0] = ( GTSdbNext.numGtsSlots << 0) | (1 << 7);

		if(GTSdbNext.numGtsSlots > 0) {
			//GTS List
			for(i = 0; i < GTSdbNext.numGtsSlots; i++) {
				directionMask = directionMask | (dbNext[i].direction << i);
				gtsSpecField[2] = dbNext[i].shortAddress;
				gtsSpecField[3] = dbNext[i].shortAddress >> 8;
				gtsSpecField[4] = ( (dbNext[i].length << GTS_LENGTH_OFFSET) & GTS_LENGTH_MASK )
				| ( dbNext[i].startingSlot & GTS_STARTING_SLOT_MASK );

				gtsSpecField = gtsSpecField + GTS_LIST_MULTIPLY;
			}

			//GTS Directions
			gtsSpecField = gtsSpecField - GTS_LIST_MULTIPLY*i;
			gtsSpecField[1] = directionMask & GTS_DIRECTIONS_MASK;
		}

		return len;
	}

	command uint8_t GtsInfoWrite.getLength()
	{
		// GTS Specification (1byte) + GTS Directions (0/1 byte) + GTS List (3bytes * #Slots)
		return 1 + ((GTSdbNext.numGtsSlots > 0) ? 1 + GTSdbNext.numGtsSlots * GTS_LIST_MULTIPLY: 0);
	}

	command ieee154_GTSdb_t* GetGtsCoordinatorDb.get() {return &GTSdb;}

	/***************************************************************************************
	 * GTS commands
	 ***************************************************************************************/

	/*
	 * GTS Allocation && GTS Deallocation from the device
	 ***************************************************************************************/
	event message_t* GtsRequestRx.received(message_t* frame)
	{
		ieee154_rxframe_gts_t rxFrame;
		ieee154_address_t srcAddress;
		uint8_t gtsCharacteristics[3];

		if (call GtsUtility.parseGtsCharacteristicsFromFrame(frame, gtsCharacteristics) == IEEE154_SUCCESS) {
			rxFrame.timestamp = call SF.sfStartTime();

			//gtsCharacteristics[3] = [length, direction, gtsCharacteristics]
			call Frame.getSrcAddr(frame, &srcAddress);

			rxFrame.gtsEntry.shortAddress = srcAddress.shortAddress;
			rxFrame.gtsEntry.length = gtsCharacteristics[0];
			rxFrame.gtsEntry.direction = gtsCharacteristics[1];
			rxFrame.type = gtsCharacteristics[2];

			if (call GtsRequestQueue.enqueue(rxFrame) == SUCCESS) {
				//printf("ADDED: id=%u ; len=%u ; dir=%u \n",rxFrame.gtsEntry.shortAddress,rxFrame.gtsEntry.length, rxFrame.gtsEntry.direction );
				post processGtsQueueTask();
			}
		}

		return frame;
	}
	task void processGtsQueueTaskDone() {
		if (call GtsRequestQueue.size()) {
			// we serve next GTS request if there are space on the superframe
			if (GTSdbNext.numGtsSlots < CFP_NUMBER_SLOTS)
			post processGtsQueueTask();
			else
			setGtsRequestWaitPending(); //we need to wait to serve the request
		}
	}

	task void processGtsQueueTask() {

		// We have items on the queue && We are not processing anythign && There is space avaible 
		if (!isGtsRequestDonePending() && call GtsRequestQueue.size() && !isGtsRequestWaitPending()) {
			ieee154_rxframe_gts_t rxFrame;

			rxFrame = call GtsRequestQueue.head();

			// check if the request is still valid
			if (call TimeCalc.timeElapsed(rxFrame.timestamp, call SF.sfStartTime())
					/ (((uint32_t) 1 << call MLME_GET.macBeaconOrder()) * IEEE154_aBaseSuperframeDuration) < IEEE154_aGTSDescPersistenceTime ) {
				// Process the next item that we have in the queue
				m_gtsCharacteristicsType = rxFrame.type;
				memcpy(&GtsEntryRequested, &rxFrame.gtsEntry, sizeof(ieee154_GTSentry_t));
				setGtsRequestDonePending();

				post processGtsRequestTask();

			} else {
				// the request has been on the queue more than IEEE154_aGTSDescPersistenceTime
				// we discard the element
				call GtsRequestQueue.dequeue();

				post processGtsQueueTaskDone();
			}
		}
	}

	task void processGtsRequestTaskDone() {
		/*
		 * This functtion dequeue the process element
		 */
		// dequeu the element from the queue
		call GtsRequestQueue.dequeue();
		// processing has finished.
		resetGtsRequestDonePending();

		post processGtsQueueTaskDone();
	}

	task void processGtsRequestTask() {
		uint8_t beaconOrder = (uint8_t) call MLME_GET.macBeaconOrder();
		uint8_t iElement = 0, i = 0;
		uint8_t
		lastSlot =
		(GTSdbNext.numGtsSlots > 0 ? GTSdbNext.db[GTSdbNext.numGtsSlots
				- 1].startingSlot
				: IEEE154_aNumSuperframeSlots);
		uint8_t startingSlot = 0;

		m_expiredTimeout = 2 * (beaconOrder <= 8 ? ((uint16_t) 1 << (8 - beaconOrder)) : 1);

		// GTS allocation
		if (m_gtsCharacteristicsType == GTS_ALLOCATE_REQUEST) {

			/* 1. Exists?
			 * 	  Do we already have the slots?
			 *    It is being deallocated?	
			 */
			if ( (iElement = call GtsUtility.getGtsEntryIndex(&GTSdbNext, GtsEntryRequested.shortAddress, GtsEntryRequested.direction))
					!= CFP_NUMBER_SLOTS+1) {
				//starting slot: could be zero if the PAN shall initiate the GTS deallocation
				startingSlot = IEEE154_aNumSuperframeSlots;
				//let's compute the lenght from the previous slots
				for (i = 0; i <= iElement; i++)
				startingSlot -= GTSdbNext.db[i].length;
				GTSdbNext.db[iElement].startingSlot = startingSlot;
				GTSdbNext.db[iElement].expirationTimeout = m_expiredTimeout;

				// generate the GTS descriptor with the requested specifications
				signal GtsSpecUpdated.notify(TRUE);
				signal MLME_GTS.indication(GtsEntryRequested.shortAddress,
						call GtsUtility.setGtsCharacteristics(GtsEntryRequested.length,
								GtsEntryRequested.direction,
								m_gtsCharacteristicsType ),
						NULL);

				post processGtsRequestTaskDone();
				return;
			}

			/* 2. 7 slots maximun
			 * 	  Do we have the 7 slots allocated?
			 */
			if ((GTSdbNext.numGtsSlots + 1) > CFP_NUMBER_SLOTS) {
				// The device will discard the MLME_GTS.request after aGTSDescPersistenceTime
				post processGtsRequestTaskDone();
				return;
			}

			/* 3. aMinCAPLength?
			 * 	  If we allocated the new slot, the aMinCAPLength shall be respected or not?
			 */
			if (lastSlot == 0) {
				lastSlot = IEEE154_aNumSuperframeSlots;
				//let's compute the lenght from the previous slots
				for (i = 0; i < GTSdbNext.numGtsSlots; i++)
				lastSlot -= GTSdbNext.db[i].length;
			}
			startingSlot = lastSlot - GtsEntryRequested.length;

			if ( ( startingSlot < IEEE154_aNumSuperframeSlots && (startingSlot * call SF.sfSlotDuration()) < IEEE154_aMinCAPLength ) ||
					startingSlot > IEEE154_aNumSuperframeSlots ) {
				// The device will discard the MLME_GTS.request after aGTSDescPersistenceTime
				return;
			}

			/* 4. Allocate the slots
			 * 	  The PAN coordinator has space avaible for the new slot
			 */
			call GtsUtility.addGtsEntry(&GTSdbNext, GtsEntryRequested.shortAddress, startingSlot,
					GtsEntryRequested.length, GtsEntryRequested.direction );

			GTSdbNext.db[GTSdbNext.numGtsSlots - 1].expirationTimeout = m_expiredTimeout;

			// generate the GTS descriptor with the requested specifications
			signal GtsSpecUpdated.notify(TRUE);
			signal MLME_GTS.indication(GtsEntryRequested.shortAddress,
					call GtsUtility.setGtsCharacteristics(GtsEntryRequested.length,
							GtsEntryRequested.direction,
							m_gtsCharacteristicsType ),
					NULL);

			post processGtsRequestTaskDone();

			return;

			// GTS deallocation
		} else if ( (iElement = call GtsUtility.getGtsEntryIndex(&GTSdbNext, GtsEntryRequested.shortAddress, GtsEntryRequested.direction))
				!= CFP_NUMBER_SLOTS+1) {

			// if the GTS ccharacteristics do not match the characteristics of a known GTS, the PAN
			// coordinator ignores the request
			call GtsUtility.purgeGtsEntry(&GTSdbNext, GtsEntryRequested.shortAddress,
					GtsEntryRequested.direction, iElement);
			signal GtsSpecUpdated.notify(TRUE);

			signal MLME_GTS.indication(GtsEntryRequested.shortAddress,
					call GtsUtility.setGtsCharacteristics(GtsEntryRequested.length,
							GtsEntryRequested.direction,
							m_gtsCharacteristicsType ),
					NULL);

			resetGtsRequestWaitPending();
			post processGtsRequestTaskDone();
			return;

		}
		return;
	}

	/*
	 * GTS expiration
	 ***************************************************************************************/
	event void HasGtsSlotExpired.notify( uint8_t val ) {
		/* This event is signalled after each gts slot in order to detect if
		 * it is being used or not
		 */
		ieee154_GTSentry_t* currentEntryRead = db + val; //entry of the current superframe (GTSdb)
		indexGtsSlot = call GtsUtility.getGtsEntryIndex( &GTSdbNext, currentEntryRead->shortAddress, currentEntryRead->direction );

		if (indexGtsSlot != CFP_NUMBER_SLOTS+1) {
			atomic {
				currentEntry = dbNext + indexGtsSlot; // entry of the next superframe

				/* The CfpTransmitP component is working with the GTSdb (currentEntryRead)
				 * and it updates the expiration for the slots
				 * We update the expiration flag and set it in the GTSdbNext
				 */
				currentEntry->expiration = currentEntryRead->expiration;

				if (currentEntry->expiration && currentEntry->startingSlot != 0) {
					currentEntry->expirationTimeout --;

					if (currentEntry->expirationTimeout == 0) {
#ifndef TKN154_STD_DEALLOCATION
						currentEntry->startingSlot = 0; //set its starting slot to zero
						// add the entry to the GtsEntryDeallocate
						memcpy( GtsEntryDeallocate + m_gtsDeallocateIn, currentEntry, sizeof(ieee154_GTSentry_t));
						GtsEntryDeallocate[m_gtsDeallocateIn].expirationTimeout = IEEE154_aGTSDescPersistenceTime;

						signal GtsSpecUpdated.notify(TRUE);

						// send the request
						call MLME_GTS.request(call GtsUtility.setGtsCharacteristics(GtsEntryDeallocate[m_gtsDeallocateIn].length,
										GtsEntryDeallocate[m_gtsDeallocateIn].direction, GTS_DEALLOCATE_REQUEST)
								,NULL);

						// indicate to the high layer the deallocation		
						signal MLME_GTS.indication(GtsEntryDeallocate[m_gtsDeallocateIn].shortAddress,
								call GtsUtility.setGtsCharacteristics(GtsEntryDeallocate[m_gtsDeallocateIn].length,
										GtsEntryDeallocate[m_gtsDeallocateIn].direction, GTS_DEALLOCATE_REQUEST), NULL);
						m_gtsDeallocateIn = m_gtsDeallocateIn + 1 % CFP_NUMBER_SLOTS;
#else

						call GtsUtility.purgeGtsEntry(&GTSdbNext,currentEntry->shortAddress,
								currentEntry->direction, indexGtsSlot);

						//enable the processing for new request if any
						resetGtsRequestWaitPending();
						if(call GtsRequestQueue.size()) post processGtsQueueTask();

						signal GtsSpecUpdated.notify(TRUE);

						// send the request
						call MLME_GTS.request(call GtsUtility.setGtsCharacteristics(currentEntry->length,
										currentEntry->direction, GTS_DEALLOCATE_REQUEST)
								,NULL);

						// indicate to the high layer the deallocation		
						signal MLME_GTS.indication(currentEntry->shortAddress,
								call GtsUtility.setGtsCharacteristics(currentEntry->length,
										currentEntry->direction, GTS_DEALLOCATE_REQUEST), NULL);
#endif

					}
				} else
				currentEntry->expirationTimeout = m_expiredTimeout;
			}

		}

		return;
	}

	event void HasCfpExpired.notify( bool val ) {
		/* This event is signalled when the radio token is tranferred to the CFP
		 * component
		 */
#ifndef TKN154_STD_DEALLOCATION

		// check deallocation expiration
		atomic {
			uint8_t i = m_gtsDeallocateOut;

			while(i != m_gtsDeallocateIn) {
				GtsEntryDeallocate[i].expirationTimeout --;

				if (GtsEntryDeallocate[i].expirationTimeout == 0) {

					call GtsUtility.purgeGtsEntry(&GTSdbNext, GtsEntryDeallocate[i].shortAddress,
							GtsEntryDeallocate[i].direction, indexGtsSlot);

					signal GtsSpecUpdated.notify(TRUE);
					m_gtsDeallocateOut = m_gtsDeallocateOut +1 % CFP_NUMBER_SLOTS;
				}
				i = i + 1 % CFP_NUMBER_SLOTS;
			}
		}
#else
		// we have removed the GTS entry before (HasGtsSlotExpired)
#endif

		// Update db with the request processed
		GTSdb.numGtsSlots = GTSdbNext.numGtsSlots;
		memcpy(db, dbNext, CFP_NUMBER_SLOTS*sizeof(ieee154_GTSentry_t));

		//enable the processing for new request if any
		resetGtsRequestWaitPending();
		if(call GtsRequestQueue.size()) post processGtsQueueTask();
	}

	/***************************************************************************************
	 * MLME_GTS commands
	 ***************************************************************************************/
	command ieee154_status_t MLME_GTS.request (
			uint8_t GtsCharacteristics,
			ieee154_security_t *security
	) {
		// it is signalled when a MLME_GTS start a GTS Deallocations. It only happened in this component becuase
		// we need the id, which is not in the MLME_GTS.request command 

		//enable the processing for new requests if any
		resetGtsRequestWaitPending();

		return IEEE154_SUCCESS;
	}

	/*
	 * DEFAULTS MLME_GTS commands
	 ***************************************************************************************/
	default event void MLME_GTS.confirm (
			uint8_t GtsCharacteristics,
			ieee154_status_t status
	) {}

	default event void MLME_GTS.indication (
			uint16_t DeviceAddress,
			uint8_t GtsCharacteristics,
			ieee154_security_t *security
	) {}

	/***************************************************************************************
	 * DEFAULTS spec updated commands
	 ***************************************************************************************/
	command error_t GtsSpecUpdated.enable() {return FAIL;}
	command error_t GtsSpecUpdated.disable() {return FAIL;}
	default event void GtsSpecUpdated.notify( bool val ) {return;}

}
