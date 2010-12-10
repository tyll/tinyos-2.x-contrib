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
/** Empty placeholder component for CoordCfpP.
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version  $Revision$
 * @modified 2010/11/16
 */

#include "TKN154_MAC.h"
module NoCoordCfpP
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

		//		interface Notify<bool> as GtsDbUpdated;
		//	interface Notify<bool> as GTSDescPersistenceTimeout;

#ifdef TKN154_ONE_REQUEST_QUEUE
		interface Queue<ieee154_rxframe_gts_t> as GtsRequestQueue;
#else
		interface Queue<ieee154_rxframe_gts_t> as GtsAllocationQueue;
		interface Queue<ieee154_rxframe_gts_t> as GtsDeallocationQueue;
#endif
	}

}
implementation
{
	command error_t Init.init()
	{
		// initialize any module variables
		return SUCCESS;
	}

	command uint8_t GtsInfoWrite.write(uint8_t *lastBytePtr, uint8_t maxlen)
	{
		if (maxlen == 0)
		return 0;
		else {
			lastBytePtr[0] = 0; // GTS Specificationtos2
			return 1;
		}
	}
	command ieee154_GTSdb_t* GetGtsCoordinatorDb.get() {return NULL;}

	event void HasCfpExpired.notify(bool val) {return;}
	event void HasGtsSlotExpired.notify( uint8_t val ) {return;}

	event message_t* GtsRequestRx.received(message_t* frame) {return frame;}

	/***************************************************************************************
	 * MLME_GTS commands
	 ***************************************************************************************/
	command ieee154_status_t MLME_GTS.request (
			uint8_t GtsCharacteristics,
			ieee154_security_t *security
	) {	return IEEE154_INVALID_GTS;}

	/***************************************************************************************
	 * DEFAULTS spec updated commands
	 ***************************************************************************************/
	command error_t GtsSpecUpdated.enable() {return FAIL;}
	command error_t GtsSpecUpdated.disable() {return FAIL;}
	default event void GtsSpecUpdated.notify( bool val ) {return;}

}
