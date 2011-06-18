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
 * The CoordCfp component contains the functions and provides
 * the components needed exclusively for the coordinator node.
 * It gives the functionalities to be able to use the GTS with
 * a coordinator node in conjuntion with the CfpTransmiP, which
 * has the common functions that coordinator and device need to share.
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version  $Revision$
 * @modified 2011/04/13
 */
#include "TKN154_MAC.h"
#include "printf.h"

module CoordCfpP
{
	provides
	{
		interface Init;
		interface WriteBeaconField as GtsInfoWrite;
		interface MLME_GTS;

		interface Get<ieee154_GTSdb_t*> as GetGtsCoordinatorDb;
		interface Get<ieee154_GTSdb_t*> as SetGtsCoordinatorDb;

		interface Notify<bool> as GtsSpecUpdated;
	}
	uses
	{
		interface Leds;
	
		interface MLME_GET;
		interface TimeCalc;

		//interface LocalTime<TSymbolIEEE802154>;
		interface IEEE154Frame as Frame;
		interface SuperframeStructure as SF;

		interface Pool<ieee154_txframe_t> as TxFramePool;
		interface Pool<ieee154_txcontrol_t> as TxControlPool;

		interface GtsUtility;

		interface FrameRx as GtsRequestRx;

		interface Notify<bool> as SubGtsSpecUpdated;
		interface PinDebug;
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

	uint8_t m_gtsSpecField[1 + GTS_DIRECTION_FIELD_LENGTH + GTS_LIST_MULTIPLY*CFP_NUMBER_SLOTS];

	/* variables that store the GTS entries
	 * we have two vector becuse we need to manage the slots for the next superframe
	 * and the slots to use in the current one. Otherwise the device/coordinator 
	 * are not synchronize 
	 */
	ieee154_GTSentry_t db[CFP_NUMBER_SLOTS];

	ieee154_GTSdb_t GTSdb;
	uint8_t indexGtsSlot = 0;


	/***************************************************************************************
	 * INITIALIZE FUNCTIONS
	 ***************************************************************************************/
	command error_t Init.init()
	{
		//Initialization of the coordinator db
		GTSdb.db = db;
		GTSdb.numGtsSlots = 0;

		return SUCCESS;
	}

	/***************************************************************************************
	 * BEACON FUNCTIONS
	 ***************************************************************************************/
	command uint8_t GtsInfoWrite.write(uint8_t *lastBytePtr, uint8_t maxlen)
	{
		/** 
		 * Writes a field inside a beacon frame (either "GTS fields" 
		 * or "Pending address field", see Fig. 44). IMPORTANT:
		 * the pointer <tt>lastBytePtr</tt> points to the address of
		 * the last byte that the callee may write. E.g. assume
		 * we want to write a GTS information field of total 4 byte, 
		 * the "GTS Specification" byte would be written at lastBytePtr[-3],
		 * the "GTS Directions" field at at lastBytePtr[-2] and so on.
		 *
		 * @param lastBytePtr Address of last byte to write
		 *
		 * @param maxlen Maximum number of bytes that may be written
		 * 
		 * @return The number of bytes that have actually been written
		 */
		/** write the current GTS spec at the given address
		 * this is the place to update the GTS Fields with db
		 * Here. the GTSdb = GTSdbnext because we update them at the
		 * end of the superframe
		 */
		// GTS Specification (1byte) + GTS Directions (0/4 byte) + GTS List (3bytes * #Slots)
		uint8_t len = 1 + ((GTSdb.numGtsSlots > 0) ? GTS_DIRECTION_FIELD_LENGTH + GTSdb.numGtsSlots * GTS_LIST_MULTIPLY: 0);
		uint32_t directionMask = 0x00;
		uint8_t i;
		uint8_t* gtsSpecField = lastBytePtr - len + 1;

		if (maxlen == 0)
		return 0;

		//GTS Specification
		//gtsSpecField[0] = ( GTSdb.numGtsSlots << 0) | (call MLME_GET.macGTSPermit() << 7);
		gtsSpecField[0] = ( GTSdb.numGtsSlots << 0) | (1 << 7);
		//jump the GTS_DIRECTION_FIELD_LENGTH -1
		gtsSpecField += GTS_DIRECTION_FIELD_LENGTH+1;
		
		if(GTSdb.numGtsSlots > 0) {
			//GTS List
			for(i = 0; i < GTSdb.numGtsSlots; i++) {

				directionMask = directionMask | (db[i].direction << i);
				gtsSpecField[0] = db[i].shortAddress;
				gtsSpecField[1] = db[i].shortAddress >> 8;
				gtsSpecField[2] = ( (db[i].length << GTS_LENGTH_OFFSET) & GTS_LENGTH_MASK )
				| ( db[i].startingSlot & GTS_STARTING_SLOT_MASK );

				gtsSpecField = gtsSpecField + GTS_LIST_MULTIPLY;
			}
			printfflush();

			//GTS Directions
			gtsSpecField = lastBytePtr - len + 1;
			// we have little endian, so don't confuse with the sniffer
			gtsSpecField[4] = (directionMask >> 0) & GTS_DIRECTIONS_MASK;
			gtsSpecField[3] = (directionMask >> 8) & GTS_DIRECTIONS_MASK;
			gtsSpecField[2] = (directionMask >> 16) & GTS_DIRECTIONS_MASK;
			gtsSpecField[1] = (directionMask >> 24) & GTS_DIRECTIONS_MASK;

		}
		
		
		return len;
	}

	command ieee154_GTSdb_t* GetGtsCoordinatorDb.get() {return &GTSdb;}
	command ieee154_GTSdb_t* SetGtsCoordinatorDb.get() {return &GTSdb;}
	/***************************************************************************************
	 * GTS commands
	 ***************************************************************************************/

	/*
	 * GTS Allocation && GTS Deallocation from the device
	 ***************************************************************************************/

	/*
	 *  GtsRequestRx.received
	 *  store the request in the queue for allocating or deallocating
	 ***************************************************************************************/
	event message_t* GtsRequestRx.received(message_t* frame){return frame;}

	/***************************************************************************************
	 * MLME_GTS commands
	 ***************************************************************************************/
	command ieee154_status_t MLME_GTS.request (
			uint8_t GtsCharacteristics,
			ieee154_security_t *security
	) {
		// it is signalled when a MLME_GTS start a GTS Deallocations. It only happened in this component becuase
		// we need the id, which is not in the MLME_GTS.request command 

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

	event void SubGtsSpecUpdated.notify(bool val){ signal GtsSpecUpdated.notify(val);}

}
