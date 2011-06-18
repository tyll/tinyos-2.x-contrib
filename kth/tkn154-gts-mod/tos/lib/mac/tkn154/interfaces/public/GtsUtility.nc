/*
 * Copyright (c) 2010, KTH Royal Institute of Technology
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 *  - Redistributions of source code must retain the above copyright notice, this list
 * 	  of conditions and the following disclaimer.
 * 
 * 	- Redistributions in binary form must reproduce the above copyright notice, this
 *    list of conditions and the following disclaimer in the documentation and/or other
 *	  materials provided with the distribution.
 * 
 * 	- Neither the name of the KTH Royal Institute of Technology nor the names of its 
 *    contributors may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY 
 * OF SUCH DAMAGE.
 */
/** 
 * The GtsUtility interface allows to access and provides useful functions for the
 * management and information about the GTS descriptor, and everything related with 
 * the GTS
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version  $Revision$
 * @modified 2011/04/13
 * 
 * @see PibC.nc for implementation 
 */


#include <TKN154.h>
#include <message.h>

interface GtsUtility
{

	/***************************************************************************************
	 * Frame functions
	 ***************************************************************************************/

	/** 
	 * Get the Gts Characteristics from a frame payload
	 * 
	 * @param *payloadGts	Pointer to the frame payload with the GTS information
	 * @param payloadLen		Size of the payload
	 * 
	 * @return uint8_t	the GTS characteristics
	 *  */
	command uint8_t getGtsCharacteristics(uint8_t* payloadGts, uint8_t payloadLen);

	/**
	 * Return the GtsCharacteristics uint8_t to create a frame
	 * 
	 * @param length		Length of the requested slot
	 * @param direction	Direction of the requested slot 
	 * 					{0: Device to Coord; 1: Coord to Device}
	 * @param characteristicsType	Indicates if the requested slot, is to allocate 
	 * 								or deallocate
	 * 
	 * @return uint8_t the GTS characteristics to be writen in the payload
	 */
	async command uint8_t setGtsCharacteristics(uint8_t length, uint8_t direction, uint8_t characteristicsType);

	/**
	 * Parse a frame to get the GtsCharacteristics
	 * 
	 * @param *frame		Pointer to the frme, where we get the characteristics vector
	 * @param *GtsCharacteristics	Vector to store the characteristics
	 * 
	 * @return ieee154_status_t
	 */
	command ieee154_status_t parseGtsCharacteristicsFromFrame(message_t *frame, uint8_t* GtsCharacteristics);

	/**
	 * Parse a payload to get the GtsCharacteristics
	 *
	 * @param *payloadGts		Pointer to the payload where we get the characteristics vector
	 * @param *GtsCharacteristics	Vector to store the characteristics
	 * 
	 * @return ieee154_status_t
	 */
	command ieee154_status_t parseGtsCharacteristicsFromPayload(uint8_t* payloadGts, uint8_t* GtsCharacteristics);
	
	

	/***************************************************************************************
	 * BeaconFrame functions
	 ***************************************************************************************/
	
	/**
	 * Get the GTS entry index, in case we have it, otherwise return the new one
	 * 
	 * @param GTS_db	Coordinator db with all the gts entries
	 * @param shortAddress	Adress of the GTS entry we want to find
	 * @param direction		Directio nof the GTS entry we want to find
	 * 
	 * @return uint8_t Index of the slot, if it doesn't exist the CFP_NUMBER_SLOTS+1 is returned
	 */
	command uint8_t getGtsEntryIndex(ieee154_GTSdb_t* GTS_db, uint16_t shortAddress, uint8_t direction );

	/**
	 * Add the new entry to the coordinator db
	 * 
	 * @param GTS_db	Coordinator db with all the gts entries
	 * @param shortAddress	Adress of the GTS entry
	 * @param startingSlot	Starting slot, provided to that entry
	 * @param length	Length of the slot
	 * @param direction		Direction of the GTS entry
	 * 
	 * @return              <code>FAIL</code> if the frame is not a beacon frame,
	 *                      <code>SUCCESS</code> otherwise
	 */	
	command error_t addGtsEntry(ieee154_GTSdb_t* GTS_db, uint16_t shortAddress, uint8_t startingSlot,
			uint8_t length, uint8_t direction);


	/**
	 * Purge the entry in the coordinator db. It reallocates the rest of the slots, to keep it in order
	 * 
	 * @param GTS_db	Coordinator db with all the gts entries
	 * @param shortAddress	Adress of the GTS entry
	 * @param direction		Direction of the GTS entry
	 * 
	 * @return              <code>FAIL</code> if the frame is not a beacon frame,
	 *                      <code>SUCCESS</code> otherwise
	 */	
	command error_t purgeGtsEntry(ieee154_GTSdb_t* GTS_db, uint16_t shortAddress,
			uint8_t direction, uint8_t indexP);

	/**
	 * Reads the GTS Fields of a beacon frame (except GTS List).
	 *
	 * @param macPayloadField         the beacon MAC payload
	 * @param gtsDescriptorCount      a pointer to where the GTS Descriptor
	 * 			            count should be written
	 * @param gtsDirectionsMask       a pointer to where the GTS Directions Mask
	 *                                should be written
	 * 
	 * @return              <code>FAIL</code> if the frame is not a beacon frame,
	 *                      <code>SUCCESS</code> otherwise
	 */
	command error_t getGtsFields(uint8_t *macPayloadField,
			uint8_t* gtsDescriptorCount, uint32_t* gtsDirectionsMask);
	
	/**
	 * Get the slots from the beacon for the selected ID. It will
	 * store the two GTSentry for the current TOS_NODE_ID.
	 * 
	 * @param payload		the beacon MAC payload
	 * @param numGtsSlots	number of GTS slots to analyse
	 * @param GTSdb			pointer to the two positions vector to store 
	 * 						the GTSentry for Rx and Tx
	 * 
	 * @return              <code>FAIL</code> if the frame is not a beacon frame,
	 *                      <code>SUCCESS</code> otherwise
	 */
	command ieee154_status_t getSlotsById(uint8_t* payload, uint8_t numGtsSlots, ieee154_GTSentry_t* GTSdb);

	
	/**
	 * Empty the slot. Set the length and startting slot to zero; directio to two (invalid)
	 * and expiration to <code>FAIL</code>
	 *
	 * @param GTSentry*	   entry to empty
	 * 
	 */
	command void setEmptyGtsEntry(ieee154_GTSentry_t* GTSentry);

}
