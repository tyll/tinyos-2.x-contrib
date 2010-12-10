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
 * The DeviceCfp component contains the functions
 * and provides the components needed exclusively
 * for the device node. It gives the functionalities
 * to be able to use the GTS with a device node in
 * conjuntion with the CfpTransmiP, which has the common
 * functions that coordinator and device need to share.
 * 
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version  $Revision$
 * @modified 2010/11/19
 */

#include "TKN154_MAC.h"

module DeviceCfpP
{
	provides {
		interface Init;
		interface MLME_GTS;

		interface Get<ieee154_GTSentry_t*> as GetGtsDeviceDb;

	}uses {
		interface MLME_SYNC_LOSS;
		interface MLME_GET;

		interface GtsUtility;
		interface FrameUtility;

		interface Notify<ieee154_status_t> as HasCfpTimeSlots;
		interface Get<ieee154_GTSentry_t*> as GetCfpTimeSlots;

		interface Pool<ieee154_txframe_t> as TxFramePool;
		interface Pool<ieee154_txcontrol_t> as TxControlPool;

		// timer to wait gtsDescriptor
		interface Timer<TSymbolIEEE802154> as GTSDescPersistenceTimeout;

		interface FrameTx as GtsRequestTx;
	}
}
implementation
{

	norace ieee154_GTSentry_t deviceDb[2];
	/* ----------------------- Vars to GTS request ----------------------- */
	uint8_t m_payloadGtsRequest[2];
	norace bool m_gtsOngoingRequest = FALSE, m_gtsOngoing = FALSE;
	uint8_t m_gtsCharacteristicsType = GTS_DEALLOCATE_REQUEST;
	ieee154_GTSentry_t GtsEntryRequested;

	/***************************************************************************************
	 * INITIALIZE FUNCTIONS
	 ***************************************************************************************/
	error_t reset(error_t error)
	{
		call GtsUtility.setEmptyGtsEntry(deviceDb);
		call GtsUtility.setEmptyGtsEntry(deviceDb + 1 );
		return SUCCESS;
	}

	command error_t Init.init()
	{
		return reset(IEEE154_TRANSACTION_OVERFLOW);
	}

	event void MLME_SYNC_LOSS.indication (
			ieee154_status_t lossReason,
			uint16_t PANId,
			uint8_t LogicalChannel,
			uint8_t ChannelPage,
			ieee154_security_t *security
	)
	{
		// we lost sync to the coordinator -> spool out current packet
		reset(IEEE154_NO_BEACON);
		dbg_serial("DeviceCfp", "MLME_SYNC_LOSS.indication: GTS deallocated\n");
	}

	command ieee154_GTSentry_t* GetGtsDeviceDb.get() {return deviceDb;}

	/***************************************************************************************
	 * Send GTS requests commands
	 ***************************************************************************************/
	event void GtsRequestTx.transmitDone(ieee154_txframe_t *txFrame, ieee154_status_t status)
	{

		call TxControlPool.put((ieee154_txcontrol_t*) ((uint8_t*) txFrame->header - offsetof(ieee154_txcontrol_t, header)));
		call TxFramePool.put(txFrame);

		if (status != IEEE154_SUCCESS) {
			dbg_serial("CfsTransmitP", "transmitDone() failed!\n");
			signal MLME_GTS.confirm(call GtsUtility.getGtsCharacteristics(txFrame->payload, txFrame->payloadLen), status);

			atomic m_gtsOngoingRequest = FALSE;
		} else {

			if( m_gtsCharacteristicsType == GTS_DEALLOCATE_REQUEST) {
				// reset the stored characteristics
				call GtsUtility.setEmptyGtsEntry(deviceDb+GtsEntryRequested.direction);

				// GTS_DEALLOCATE_REQUEST
				signal MLME_GTS.confirm(call GtsUtility.setGtsCharacteristics(GtsEntryRequested.length,
								GtsEntryRequested.direction,
								m_gtsCharacteristicsType),
						IEEE154_SUCCESS);

				atomic m_gtsOngoingRequest = FALSE;
			} else if (m_gtsOngoingRequest) {
				// GTS_ALLOCATE_REQUEST
				call GTSDescPersistenceTimeout.startOneShot(
						IEEE154_aGTSDescPersistenceTime *
						(((uint32_t) 1 << call MLME_GET.macBeaconOrder()) + (uint32_t) 1) *
						(uint32_t) IEEE154_aBaseSuperframeDuration);
			}
		}
	}

	/*
	 * GTS allocation/deallocation check
	 ***************************************************************************************/
	event void HasCfpTimeSlots.notify( ieee154_status_t status ) {
		uint8_t i = 0;
		ieee154_GTSentry_t* val = call GetCfpTimeSlots.get();
		// 1. Check to signal events MLME_GTS.indication, MLME_GTS.confirm
		if (m_gtsOngoingRequest && m_gtsCharacteristicsType == GTS_ALLOCATE_REQUEST) {

			if( val[GtsEntryRequested.direction].startingSlot > 0 && val[GtsEntryRequested.direction].length == GtsEntryRequested.length) {
				status = IEEE154_SUCCESS;

				// the returned status could be SUCCESS or DENIED
				signal MLME_GTS.confirm(call GtsUtility.setGtsCharacteristics(GtsEntryRequested.length,
								GtsEntryRequested.direction,
								m_gtsCharacteristicsType),
						status);

				m_gtsOngoingRequest = FALSE;
				m_gtsOngoing = TRUE;

				call GTSDescPersistenceTimeout.stop(); // we receive the gts descriptor that we expect before timeout
			} else
			status = IEEE154_DENIED;

		}
		if(m_gtsOngoing) {
			for (i = 0; i < 2; i++ ) {
				//check if any allocated slot has been removed
				if(val[i].startingSlot == 0 && deviceDb[i].startingSlot > 0 ) {
					// send a deallocation
					signal MLME_GTS.indication(deviceDb[i].shortAddress,
							call GtsUtility.setGtsCharacteristics(deviceDb[i].length,
									deviceDb[i].direction, GTS_DEALLOCATE_REQUEST),
							NULL);
				}

			}
			// 2. Copy the slot from the BeaconSynchornize
			memcpy(deviceDb, val, 2*sizeof(ieee154_GTSentry_t));
			
			// 3. Check if we don't use the GTS anymore
			if ( ! deviceDb[GTS_RX_ONLY_REQUEST].length && ! deviceDb[GTS_TX_ONLY_REQUEST].length)
			m_gtsOngoing = FALSE;
		}

	}
	/***************************************************************************************
	 * Timers
	 ***************************************************************************************/
	event void GTSDescPersistenceTimeout.fired() {
		dbg_serial("CfpTransmitP","GTSDescPersistenceTimeout.fired()\n");

		signal MLME_GTS.confirm(call GtsUtility.setGtsCharacteristics(GtsEntryRequested.length,
						GtsEntryRequested.direction,
						m_gtsCharacteristicsType),
				IEEE154_NO_DATA);
	}

	/***************************************************************************************
	 * MLME_GTS commands
	 ***************************************************************************************/
	command ieee154_status_t MLME_GTS.request (
			uint8_t GtsCharacteristics,
			ieee154_security_t *security
	) {

		ieee154_status_t status = IEEE154_SUCCESS;
		ieee154_txframe_t *txFrame=0;
		ieee154_txcontrol_t *txControl=0;
		ieee154_address_t srcAddress;
		ieee154_macPANId_t srcPANId = call MLME_GET.macPANId();
		uint8_t GtsCharacteristicsV[3];

		srcAddress.shortAddress = call MLME_GET.macShortAddress();
		if (security && security->SecurityLevel)
		status = IEEE154_UNSUPPORTED_SECURITY; //status = IEEE154_INVALID_PARAMETER; condition 11
		else if (m_gtsOngoingRequest || !(txFrame = call TxFramePool.get()))
		status = IEEE154_TRANSACTION_OVERFLOW;
		else if (!(txControl = call TxControlPool.get())) {
			call TxFramePool.put(txFrame);
			status = IEEE154_TRANSACTION_OVERFLOW;
		} else if(srcAddress.shortAddress == 0xFFFE || srcAddress.shortAddress == 0xFFFF) {
			status = IEEE154_NO_SHORT_ADDRESS;
		}

		if (status == IEEE154_SUCCESS) {

			txFrame->header = &txControl->header;
			txFrame->metadata = &txControl->metadata;

			txFrame->headerLen = call FrameUtility.writeHeader(
					txFrame->header->mhr,
					ADDR_MODE_NOT_PRESENT,
					0,
					0,
					ADDR_MODE_SHORT_ADDRESS,
					srcPANId,
					&srcAddress,
					0);

			txFrame->header->mhr[MHR_INDEX_FC1] = FC1_ACK_REQUEST | FC1_FRAMETYPE_CMD;
			txFrame->header->mhr[MHR_INDEX_FC2] = FC2_SRC_MODE_SHORT;

			m_payloadGtsRequest[0] = CMD_FRAME_GTS_REQUEST;
			m_payloadGtsRequest[1] = GtsCharacteristics;
			txFrame->payload = m_payloadGtsRequest;
			txFrame->payloadLen = 2;
			m_gtsOngoingRequest = TRUE;

			//Save requestGTSEntry
			call GtsUtility.parseGtsCharacteristicsFromPayload(m_payloadGtsRequest, GtsCharacteristicsV);
			GtsEntryRequested.shortAddress = srcAddress.shortAddress;
			GtsEntryRequested.length = GtsCharacteristicsV[0];
			GtsEntryRequested.direction = GtsCharacteristicsV[1];
			m_gtsCharacteristicsType = GtsCharacteristicsV[2];

			if ((status = call GtsRequestTx.transmit(txFrame)) != IEEE154_SUCCESS) {
				m_gtsOngoingRequest = FALSE;
				call TxFramePool.put(txFrame);
				call TxControlPool.put(txControl);
			}
		} else {
			signal MLME_GTS.confirm(GtsCharacteristics, status);
		}

		return status;
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

}
