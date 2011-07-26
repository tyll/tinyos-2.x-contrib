/* 
 * Copyright (c) 2008, Technische Universitaet Berlin
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
 * - Neither the name of the Technische Universitaet Berlin nor the names
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
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */
#include "TKN154.h"
#include "printf.h"

module TestPromiscuousC
{
	uses {
		interface Boot;
		interface MLME_RESET;
		interface MLME_SET;
		interface MLME_GET;
		interface MCPS_DATA;
		interface Leds;
		interface IEEE154Frame as Frame;
		interface IEEE154BeaconFrame as BeaconFrame;
		interface SplitControl as PromiscuousMode;
	}
}implementation {

	const char *m_frametype[] = {"Beacon", "Data","Acknowledgement","MAC command", "Unknown"};
	const char *m_cmdframetype[] = {"unknown command", "Association request","Association response",
		"Disassociation notification","Data request","PAN ID conflict notification",
		"Orphan notification", "Beacon request", "Coordinator realignment", "GTS request"};

	enum {
		RADIO_CHANNEL = 0x10,
	};

	uint8_t m_payload[IEEE154_aMaxBeaconPayloadLength];
	uint8_t m_header[IEEE154_aMaxBeaconPayloadLength];

	void parseBeacon(uint8_t* payload);
	void parseGTSDescriptor(uint8_t* payload, uint8_t m_numGtsSlots);
	bool compareBeacon(uint8_t* payload, uint8_t payloadLen);

	event void Boot.booted() {
		call MLME_RESET.request(TRUE);
	}

	event void MLME_RESET.confirm(ieee154_status_t status)
	{
		call MLME_SET.phyCurrentChannel(RADIO_CHANNEL);
		call PromiscuousMode.start();
	}

	event message_t* MCPS_DATA.indication (message_t* frame)
	{
		uint8_t i;
		uint8_t *payload = call Frame.getPayload(frame);
		uint8_t payloadLen = call Frame.getPayloadLength(frame);
		uint8_t *header = call Frame.getHeader(frame);
		uint8_t headerLen = call Frame.getHeaderLength(frame);
		uint8_t SrcAddrMode, DstAddrMode;
		uint8_t frameType, cmdFrameType;
		ieee154_address_t SrcAddress, DstAddress;
		uint16_t SrcPANId=0, DstPANId=0;

		if (call Frame.hasStandardCompliantHeader(frame)) {
			frameType = call Frame.getFrameType(frame);
			if (frameType > FRAMETYPE_CMD)
			frameType = 4;
			call Frame.getSrcPANId(frame, &SrcPANId);
			call Frame.getDstPANId(frame, &DstPANId);
			call Frame.getSrcAddr(frame, &SrcAddress);
			call Frame.getDstAddr(frame, &DstAddress);
			SrcAddrMode = call Frame.getSrcAddrMode(frame);
			DstAddrMode = call Frame.getDstAddrMode(frame);

			printf("----------------\n");
			/*
			 * R E - P L O T  R E S U L T S
			 */

			//Timestamp and FrameType
			printf("[%ld - 0x%02X] %s", call Frame.getDSN(frame),
					call Frame.getTimestamp(frame), m_frametype[frameType]);

			//Src Address and PANID
			if (SrcAddrMode == ADDR_MODE_SHORT_ADDRESS) {
				printf(" 0x%02X", SrcAddress.shortAddress);
				printf(" 0x%02X", SrcPANId);
			} else if (SrcAddrMode == ADDR_MODE_EXTENDED_ADDRESS) {
				for (i=0; i<8; i++)
				printf(" 0x%02X ", ((uint8_t*) &(SrcAddress.extendedAddress))[i]);
				printf(" 0x%02X\n", SrcPANId);
			}

			//Dest Address and PANID
			if ( DstAddrMode == ADDR_MODE_SHORT_ADDRESS) {
				printf(" 0x%02X\n", DstAddress.shortAddress);
				printf(" 0x%02X\n", DstPANId);
			} else if ( DstAddrMode == ADDR_MODE_EXTENDED_ADDRESS) {
				for (i=0; i<8; i++)
				printf(" 0x%02X ", ((uint8_t*) &(DstAddress.extendedAddress))[i]);
				printf(" 0x%02X\n", DstPANId);
			}

			if (frameType != 0) {
				printf("\n\t\t");

				// Data Frame
				for (i=0; i<payloadLen; i++) {
					printf("0x%02X ", payload[i]);
				}
			} else {
				printf("\n");

				//Beacom Frame
				parseBeacon(payload);
			}

			//			else if (frameType == 0) {
			//				// parse the beacon with the new GTS Descriptor
			//				compareBeacon(payload, payloadLen);
			//
			//				memcpy(m_payload, payload, payloadLen);
			//				memcpy(m_payload+payloadLen, NULL, IEEE154_aMaxBeaconPayloadLength - payloadLen);
			//
			//				//compareBeacon(header, headerLen);
			//
			//				memcpy(m_header, header, headerLen);
			//				memcpy(m_header+headerLen, NULL, IEEE154_aMaxBeaconPayloadLength - headerLen);
			//
			//				parseBeacon(payload);
			//			}

			printfflush();
		}
		call Leds.led1Toggle();
		return frame;
	}

	event void MCPS_DATA.confirm( message_t *msg, uint8_t msduHandle, ieee154_status_t status, uint32_t Timestamp) {}
	event void PromiscuousMode.startDone(error_t error)
	{
		printf("\n*** Radio is now in promiscuous mode, listening on channel %d ***\n", RADIO_CHANNEL);
		printfflush();
	}
	event void PromiscuousMode.stopDone(error_t error) {}

	bool compareBeacon(uint8_t* payload, uint8_t payloadLen) {
		uint8_t i;
		for (i=0; i<payloadLen; i++) {
			if ( payload[i] != m_payload[i]) {
				printf("Payload: ");
				for (i=0; i<payloadLen; i++) {
					printf("0x%02X ", payload[i]);
				}
				printf("\n Prev Payload: ");
				for (i=0; i<payloadLen; i++) {
					printf("0x%02X ", m_payload[i]);
				}
				printf("\n");
				return FALSE;;
			}
		}
		return TRUE;
	}
	void parseBeacon(uint8_t* payload) {
		uint8_t pendAddrSpecOffset = GTS_LIST_MULTIPLY + (((payload[BEACON_INDEX_GTS_SPEC] & GTS_DESCRIPTOR_COUNT_MASK) > 0) ?
				GTS_DIRECTION_FIELD_LENGTH + (payload[BEACON_INDEX_GTS_SPEC] & GTS_DESCRIPTOR_COUNT_MASK) * GTS_LIST_MULTIPLY: 0); // skip GTS
		uint8_t pendAddrSpec = payload[pendAddrSpecOffset];
		uint8_t *beaconPayload = payload + pendAddrSpecOffset + 1;
		uint8_t pendingAddrMode = ADDR_MODE_NOT_PRESENT;
		uint8_t frameLen = ((uint8_t*) payload)[0] & FRAMECTL_LENGTH_MASK;
		uint8_t gtsFieldLength;
		uint8_t m_numGtsSlots, m_numCapSlots, m_superframeOrder, m_sfSlotDuration
		,m_battLifeExtDuration, m_beaconOrder, m_framePendingBit;

		m_numGtsSlots = payload[BEACON_INDEX_GTS_SPEC] & GTS_DESCRIPTOR_COUNT_MASK;
		gtsFieldLength = 1 + ((m_numGtsSlots > 0) ? GTS_DIRECTION_FIELD_LENGTH + m_numGtsSlots * GTS_LIST_MULTIPLY: 0);
		if (m_numGtsSlots != IEEE154_aNumSuperframeSlots)
			m_numCapSlots = ((payload[BEACON_INDEX_SF_SPEC2] & SF_SPEC2_FINAL_CAPSLOT_MASK) >> SF_SPEC2_FINAL_CAPSLOT_OFFSET) + 1;
		else
		m_numCapSlots = 0;
		
		m_superframeOrder = (payload[BEACON_INDEX_SF_SPEC1] & SF_SPEC1_SO_MASK) >> SF_SPEC1_SO_OFFSET;
		m_sfSlotDuration = (((uint32_t) 1) << (m_superframeOrder)) * IEEE154_aBaseSlotDuration;

		
		m_battLifeExtDuration = 0;

		m_beaconOrder = (payload[BEACON_INDEX_SF_SPEC1] & SF_SPEC1_BO_MASK) >> SF_SPEC1_BO_OFFSET;
		printf("\t\tSF Spec: BO=%u ; SO=%u ; CAP slots=%u ; BatteryLife=%u\n"
				, m_beaconOrder, m_superframeOrder, m_numCapSlots, m_battLifeExtDuration);
		printf("\t\tGTS Spec: DescCount=%u ; Length=%u bytes\n", m_numGtsSlots, gtsFieldLength);

		if (m_numGtsSlots > 0)
		parseGTSDescriptor(&payload[BEACON_INDEX_GTS_SPEC], m_numGtsSlots);

	}
	void parseGTSDescriptor(uint8_t* payload, uint8_t m_numGtsSlots) {
		uint8_t* gtsSpec = payload+1;
		uint8_t i=0, direction;
		uint32_t gtsDirectionsMask;

		gtsDirectionsMask = 0x0;

		gtsDirectionsMask |= ( (uint32_t) *(gtsSpec++) << 24 );
		gtsDirectionsMask |= ( (uint32_t) *(gtsSpec++) << 16 );
		gtsDirectionsMask |= ( (uint32_t) *(gtsSpec++) << 8 );
		gtsDirectionsMask |= ( (uint32_t) *(gtsSpec++) << 0 );

		for (i = 0; i < m_numGtsSlots; i++) {
			direction = (gtsDirectionsMask >> i) & 1;

			printf("\t\t\t\t[%u] address=0x%x ; length=%u ; direction=%u \n"
					, gtsSpec[2] & GTS_STARTING_SLOT_MASK
					,(gtsSpec[1] << 8 ) | gtsSpec[0]
					, ((gtsSpec[2] & GTS_LENGTH_MASK ) >> GTS_LENGTH_OFFSET)
					, direction);

			gtsSpec += GTS_LIST_MULTIPLY;
		}

	}
}
