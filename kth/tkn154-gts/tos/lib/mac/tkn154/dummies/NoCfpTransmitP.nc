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
/** Empty placeholder component for CfpTransmitP.
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version  $Revision$
 * @modified 2010/11/16
 */

#include "TKN154_MAC.h"

module NoCfpTransmitP
{
	provides
		{
			interface Init;

			interface FrameTx as CfpTx;
			interface FrameRx as CfpRx;

			interface Notify<bool> as WasRxEnabled;
	#ifndef IEEE154_BEACON_TX_DISABLED
			interface Notify<uint8_t> as HasGtsSlotExpired;
			interface Notify<bool> as HasCfpExpired;
	#endif
		}
		uses
		{
			interface Leds;
			interface TransferableResource as RadioToken;
			interface GetNow<token_requested_t> as IsRadioTokenRequested;

			// TimeSlot timers
			interface Alarm<TSymbolIEEE802154,uint32_t> as CfpSlotAlarm;
			interface Alarm<TSymbolIEEE802154,uint32_t> as CfpEndAlarm;

			interface TimeCalc;
			interface GetNow<bool> as IsRxEnableActive;
			interface Notify<bool> as RxEnableStateChange;
			interface Notify<const void*> as PIBUpdateMacRxOnWhenIdle;

			interface SuperframeStructure as SF;
			interface RadioTx;
			interface RadioRx;
			interface RadioOff;

			interface MLME_GET;
			interface MLME_SET;

			interface IEEE154Frame as Frame;

	#ifndef IEEE154_BEACON_TX_DISABLED
			interface Get<ieee154_GTSdb_t*> as GetGtsCoordinatorDb;
	#else
			interface Get<ieee154_GTSentry_t*> as GetGtsDeviceDb;
	#endif
		}
}
implementation {


	/***************************************************************************************
	 * INITIALIZE functions
	 ***************************************************************************************/
	error_t reset(error_t error)
	{
		return SUCCESS;
	}

	command error_t Init.init() {
		return reset(IEEE154_TRANSACTION_OVERFLOW);
	}

	/***************************************************************************************
	 * GTS SEND FUNCTIONS
	 ***************************************************************************************/
	command ieee154_status_t CfpTx.transmit(ieee154_txframe_t *frame)
	{	return IEEE154_INVALID_GTS;}

	/***************************************************************************************
	 * ALARMS FUNCTIONS {Fired and init}
	 ***************************************************************************************/
	async event void CfpEndAlarm.fired() {}
	async event void CfpSlotAlarm.fired() {}


	/***************************************************************************************
	 * RADIO FUNCTIONS
	 ***************************************************************************************/

	async event void RadioToken.transferredFrom(uint8_t fromClient)
	{	
	#ifndef IEEE154_BEACON_TX_DISABLED
		call RadioToken.transferTo(RADIO_CLIENT_BEACONTRANSMIT);
	#else
		call RadioToken.transferTo(RADIO_CLIENT_BEACONSYNCHRONIZE);
	#endif
	}

	async event void RadioTx.transmitDone(ieee154_txframe_t *frame, const ieee154_timestamp_t *timestamp, error_t result) {}

	async event void RadioOff.offDone() {}

	async event void RadioRx.enableRxDone() {}

	event void RadioToken.granted()
	{
		ASSERT(0); // should never happen, because we never call RadioToken.request()
	}
	event message_t* RadioRx.received(message_t* frame, const ieee154_timestamp_t *timestamp) {return frame;}

	default event message_t* CfpRx.received(message_t* data) {return data;}

	/***************************************************************************************
	 * RxEnabled FUNCTIONS
	 ***************************************************************************************/
	command error_t WasRxEnabled.enable() {return FAIL;}
	command error_t WasRxEnabled.disable() {return FAIL;}

	event void RxEnableStateChange.notify(bool whatever) {}
	event void PIBUpdateMacRxOnWhenIdle.notify( const void* val ) {}
	
#ifndef IEEE154_BEACON_TX_DISABLED
	command error_t HasGtsSlotExpired.enable() {return FAIL;}
	command error_t HasGtsSlotExpired.disable() {return FAIL;}
	default event void HasGtsSlotExpired.notify( uint8_t val ) {return;}

	command error_t HasCfpExpired.enable() {return FAIL;}
	command error_t HasCfpExpired.disable() {return FAIL;}
	default event void HasCfpExpired.notify( bool val ) {return;}

#endif
}
