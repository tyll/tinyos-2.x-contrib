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

module CfpTransmitP
{
	provides
	{
		interface Init;

		interface FrameTx as CfpTx;
		interface FrameRx as CfpRx;

		interface Notify<bool> as WasRxEnabled;

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
		interface PinDebug;

	}
}
implementation {

#ifdef TKN154_DEBUG
	enum {
		HEADER_STR_LEN = 27,
		DBG_STR_SIZE = 250,
	};
	norace uint16_t m_dbgNumEntries;
	norace char m_dbgStr[HEADER_STR_LEN + DBG_STR_SIZE] = "updateState() transitions: ";
	void dbg_push_state(uint8_t state) {
		if (m_dbgNumEntries < DBG_STR_SIZE-3)
		m_dbgStr[HEADER_STR_LEN + m_dbgNumEntries++] = '0' + state;
	}
	void dbg_flush_state() {
		m_dbgStr[HEADER_STR_LEN + m_dbgNumEntries++] = '\n';
		m_dbgStr[HEADER_STR_LEN + m_dbgNumEntries++] = 0;
		dbg_serial("CfpTransmit",m_dbgStr);
		m_dbgNumEntries = 0;
	}
#else 
#define dbg_push_state(X)
#define dbg_flush_state()
#endif

	typedef enum {
		SWITCH_OFF,
		WAIT_FOR_RXDONE,
		WAIT_FOR_TXDONE,
		DO_NOTHING,
	}next_state_t;

	typedef enum {
		TX_MODE,
		RX_MODE,
		IDLE_MODE,
	}slot_mode_t;

	next_state_t tryReceive();
	next_state_t tryTransmit();
	next_state_t trySwitchOff();
	void updateState();
	void setCurrentFrame(ieee154_txframe_t *frame);
	task void signalTxDoneTask();
	void stopAllAlarms();
	task void wasRxEnabledTask();
	void hasStartSlot();

	/* ----------------------- Vars to CFP tx ----------------------- */
	norace ieee154_status_t m_txStatus;
	norace uint32_t m_transactionTime;
	norace uint32_t m_slotDuration;
	norace uint16_t m_guardTime;
	norace uint32_t m_capDuration;
	norace uint32_t m_gtsDuration;
	norace uint32_t m_cfpInit;
	norace ieee154_macMaxFrameRetries_t m_macMaxFrameRetries;
	norace ieee154_macMaxFrameTotalWaitTime_t m_macMaxFrameTotalWaitTime;
	norace ieee154_macRxOnWhenIdle_t macRxOnWhenIdle;

	norace bool m_lock;
	norace slot_mode_t slot_mode;
	norace uint8_t m_slotNumber;
	norace uint8_t m_numGtsSlots;
	norace ieee154_txframe_t *m_currentFrame;
	norace ieee154_txframe_t *m_lastFrame;

	/* ----------------------- Vars to expiration GTS ----------------------- */
	norace ieee154_GTSentry_t* currentEntry; //to go through the slots
#ifdef IEEE154_BEACON_TX_DISABLED
	ieee154_GTSentry_t* deviceDb;
#endif
	norace uint16_t m_expiredTimeout;

	/***************************************************************************************
	 * INITIALIZE functions
	 ***************************************************************************************/
	error_t reset(error_t error)
	{
		if (call RadioToken.isOwner()) // internal error! this must not happen!
		return FAIL;
		if (m_currentFrame)
		signal CfpTx.transmitDone(m_currentFrame, error);
		if (m_lastFrame)
		signal CfpTx.transmitDone(m_lastFrame, error);

		m_currentFrame = m_lastFrame = NULL;
		m_macMaxFrameTotalWaitTime = call MLME_GET.macMaxFrameTotalWaitTime();

		stopAllAlarms();
		return SUCCESS;
	}

	command error_t Init.init() {
		return reset(IEEE154_TRANSACTION_OVERFLOW);
	}

	/***************************************************************************************
	 * GTS SEND FUNCTIONS
	 ***************************************************************************************/
	command ieee154_status_t CfpTx.transmit(ieee154_txframe_t *frame)
	{
		// request to send a frame in a GTS slot (triggered by MCPS_DATA.request())
		if (m_currentFrame != NULL) {
			// we've not finished transmitting the current frame yet
			dbg_serial("CfpTransmitP", "Overflow\n");
			return IEEE154_TRANSACTION_OVERFLOW;
		} else {
			setCurrentFrame(frame);
			dbg("CfpTransmitP", "New frame to transmit, DSN: %lu\n", (uint32_t) MHR(frame)[MHR_INDEX_SEQNO]);
			updateState();
			return IEEE154_SUCCESS;
		}
	}

	void setCurrentFrame(ieee154_txframe_t *frame)
	{
		ieee154_macDSN_t dsn = call MLME_GET.macDSN();
		frame->header->mhr[MHR_INDEX_SEQNO] = dsn++;
		call MLME_SET.macDSN(dsn);
		m_macMaxFrameRetries = call MLME_GET.macMaxFrameRetries();

		m_transactionTime = IEEE154_SHR_DURATION +
		(frame->headerLen + frame->payloadLen + 2) * IEEE154_SYMBOLS_PER_OCTET; // extra 2 for CRC
		if (frame->header->mhr[MHR_INDEX_FC1] & FC1_ACK_REQUEST)
		m_transactionTime += (IEEE154_aTurnaroundTime + IEEE154_aUnitBackoffPeriod +
				11 * IEEE154_SYMBOLS_PER_OCTET); // 11 byte for the ACK PPDU
		if (frame->headerLen + frame->payloadLen > IEEE154_aMaxSIFSFrameSize)
		m_transactionTime += call MLME_GET.macMinLIFSPeriod();
		else
		m_transactionTime += call MLME_GET.macMinSIFSPeriod();
		m_macMaxFrameTotalWaitTime = call MLME_GET.macMaxFrameTotalWaitTime();

		m_currentFrame = frame;
	}

	/** 
	 * The updateState() function is called whenever something happened that
	 * might require a state transition; it implements a lock mechanism (m_lock)
	 * to prevent race conditions. Whenever the lock is set a "done"-event (from
	 * the SlottedCsmaCa/RadioRx/RadioOff interface) is pending and will "soon"
	 * unset the lock (and then updateState() will called again).  The
	 * updateState() function decides about the next state by checking a list of
	 * possible current states ordered by priority, e.g. it first always checks
	 * whether the CAP is still active. Calling this function more than necessary
	 * can do no harm.
	 */
	void updateState()
	{
		next_state_t next;

		atomic {
			// long atomics are bad... but in this block, once the/ current state has
			// been determined only one branch will/ be taken (there are no loops)
			if (m_lock || !call RadioToken.isOwner())
			return;
			m_lock = TRUE; // lock

			// Check 1: has the CFP finished?
			if (call TimeCalc.hasExpired(m_cfpInit,
							m_gtsDuration - m_guardTime) || !call CfpEndAlarm.isRunning()) {
				dbg_push_state(1);

				if (call RadioOff.isOff()) {
					stopAllAlarms(); // may still fire, but is locked through isOwner()
					m_lock = FALSE; // unlock
					dbg_flush_state();
					dbg_serial("CfpTransmitP", "Handing over to Inactive Period in %lu.\n", call CfpEndAlarm.getNow() );
					
					call RadioToken.transferTo(RADIO_CLIENT_DEVICE_INACTIVE_PERIOD);

					return;
				} else
				next = SWITCH_OFF;
			}

			// Check 4: is some other operation (like MLME-SCAN or MLME-RESET) pending? 
			else if (call IsRadioTokenRequested.getNow()) {
				dbg_push_state(4);
				if (call RadioOff.isOff()) {
					stopAllAlarms(); // may still fire, but is locked through isOwner()
					// nothing more to do... just release the Token
					m_lock = FALSE; // unlock
					dbg_serial("CfpTransmitP", "Token requested: Handing over to Beacon Transmit/Synchronize.\n");
					
					call RadioToken.release();
					return;
				} else
				next = SWITCH_OFF;
			}

			// Check 6: is there a frame ready to transmit and where are in the correct slot?
			else if (slot_mode == TX_MODE && m_currentFrame != NULL) {
				dbg_push_state(6);
				next = tryTransmit();
				currentEntry->expiration = TRUE;
			}

			// Check 7: should we be in receive mode?
			else if (slot_mode == RX_MODE) {
				dbg_push_state(7);
				currentEntry->expiration = TRUE;
				next = tryReceive();
				if (next == DO_NOTHING) {
					// if there was an active MLME_RX_ENABLE.request then we'll
					// inform the next higher layer that radio is now in Rx mode
					post wasRxEnabledTask();
				}
			}

			// Check 8: just make sure the radio is switched off  
			else {
				dbg_push_state(8);
				next = trySwitchOff();
			}

			// if there is nothing to do, then we must clear the lock
			if (next == DO_NOTHING)
			m_lock = FALSE;
		} // atomic

		// put next state in operation (possibly keeping the lock)
		switch (next)
		{
			case SWITCH_OFF: ASSERT(call RadioOff.off() == SUCCESS); break;
			case WAIT_FOR_RXDONE: break;
			case WAIT_FOR_TXDONE: break;
			case DO_NOTHING: break;
		}
	}

	next_state_t tryTransmit()
	{
		next_state_t next;
		if (!call RadioOff.isOff())
		next = SWITCH_OFF;
		else {
			uint32_t dtMax = m_slotDuration*( currentEntry->length ) - m_transactionTime;
			//printf("tryTransmit\n");

			//to debug: show in the packet payload the slotNumber
			//*(m_currentFrame-> payload) = m_slotNumber;

			if (call SF.battLifeExtDuration() > 0) {
				// battery life extension
				uint16_t bleLen = call SF.battLifeExtDuration();
				if (bleLen < dtMax)
				dtMax = bleLen;
			}
			if (call TimeCalc.hasExpired(m_cfpInit, (m_slotNumber*m_slotDuration) + dtMax )) {
				next = DO_NOTHING; // frame doesn't fit in the remaining CFP slot
			} else {
				error_t res;
				res = call RadioTx.transmit(m_currentFrame, call SF.sfStartTime(), dtMax);
				next = WAIT_FOR_TXDONE; // this will NOT clear the lock
			}
		}
		return next;
	}

	next_state_t tryReceive()
	{
		next_state_t next;

		if (call RadioRx.isReceiving())
		next = DO_NOTHING;
		else if (!call RadioOff.isOff())
		next = SWITCH_OFF;
		else {
			call RadioRx.enableRx(0, 0);
			next = WAIT_FOR_RXDONE;
		}
		return next;
	}

	next_state_t trySwitchOff()
	{
		next_state_t next;
		if (call RadioOff.isOff())
		next = DO_NOTHING;
		else
		next = SWITCH_OFF;
		return next;
	}

	task void signalTxDoneTask()
	{
		ieee154_txframe_t *lastFrame = m_lastFrame;
		ieee154_status_t status = m_txStatus;
		m_lastFrame = NULL; // only now can the next transmission can begin 
		if (lastFrame) {
			dbg("CfpTransmitP", "Transmit done, DSN: %lu, result: 0x%lx\n",
					(uint32_t) MHR(lastFrame)[MHR_INDEX_SEQNO], (uint32_t) status);
			signal CfpTx.transmitDone(lastFrame, status);
		}
		updateState();
	}

	/***************************************************************************************
	 * ALARMS FUNCTIONS {Fired and init}
	 ***************************************************************************************/
	void stopAllAlarms() {
		call CfpEndAlarm.stop();
		call CfpSlotAlarm.stop();
	}

	async event void CfpEndAlarm.fired() {
		updateState();
	}

	async event void CfpSlotAlarm.fired() {

		m_slotNumber += (slot_mode != IDLE_MODE ? currentEntry->length : 1); //for coord always !=

		//increase the slot number
		if (m_slotNumber < IEEE154_aNumSuperframeSlots) {
			//Check in which slot we are?
			hasStartSlot();
			//Fired next slot
			updateState();
		}
	}

#ifndef IEEE154_BEACON_TX_DISABLED

	void hasStartSlot() {
		ieee154_address_t deviceShortAddress;
		bool txSlot;
		call PinDebug.ADC0toggle();

		//dbg_serial("CfpTransmitP", "m_numGtsSlots= %u\n", m_numGtsSlots);

		// to gts slot number = 6 (9) ..  0 (15)
		currentEntry = &((call GetGtsCoordinatorDb.get())->db[--m_numGtsSlots]);
//		printf("%u addrd=%u ; startingSlot=%u ; dir=%u \n", m_numGtsSlots, 
//				currentEntry->shortAddress, 
//				currentEntry->startingSlot,
//				currentEntry->direction );
		
		dbg_serial("CfpTransmitP", "cE->direction: %u cE->length: %u\n", currentEntry->direction, currentEntry->length);

		// the direction is refered to the device
		if (currentEntry->direction == GTS_RX_ONLY_REQUEST) {
			txSlot = (call Frame.getDstAddrTxFrame(m_currentFrame,&deviceShortAddress) == SUCCESS
					? (deviceShortAddress.shortAddress == currentEntry->shortAddress ? TRUE : FALSE)
					: FALSE);
			if (txSlot) {
				slot_mode = TX_MODE;
			} else slot_mode = IDLE_MODE;

		} else if(currentEntry->direction == GTS_TX_ONLY_REQUEST) {
			slot_mode = RX_MODE;
		}
		else {
			slot_mode = IDLE_MODE;
		}

		call CfpSlotAlarm.startAt( m_slotDuration * m_slotNumber + call SF.sfStartTime(), m_slotDuration * currentEntry->length);
	}

#else

	void hasStartSlot() {
		uint8_t length = 0;
		deviceDb = call GetGtsDeviceDb.get();
		call PinDebug.ADC0toggle();

		if (m_slotNumber == deviceDb[GTS_TX_ONLY_REQUEST].startingSlot) {
			slot_mode = TX_MODE;
		} else if(m_slotNumber == deviceDb[GTS_RX_ONLY_REQUEST].startingSlot) {
			dbg_serial("CfpTransmitP", "\t \t \t \t Reception slot\n ");

			slot_mode = RX_MODE;
		} else {
			slot_mode = IDLE_MODE;
		}

		// get slot length
		if (slot_mode != IDLE_MODE) {
			currentEntry = deviceDb + slot_mode;
			length = currentEntry->length;
		} else
		length = 1; //fired every slot to check

		call CfpSlotAlarm.startAt( m_slotDuration * m_slotNumber + call SF.sfStartTime(), m_slotDuration * length);
	}
#endif

	/***************************************************************************************
	 * RADIO FUNCTIONS
	 ***************************************************************************************/

	async event void RadioToken.transferredFrom(uint8_t fromClient)
	{
		m_gtsDuration = (IEEE154_aNumSuperframeSlots - call SF.numCapSlots()) *
		(uint32_t) call SF.sfSlotDuration();
		
		//Warning: the functions call MLME_GET are sync but called from async context
		m_guardTime = ( call MLME_GET.macBeaconOrder() == call MLME_GET.macSuperframeOrder() ? call SF.guardTime() : 0);
//		dbg_serial("CfpTransmitP", "numCapSlots=%u ;m_gtsDuration=%u \n", call SF.numCapSlots(), m_gtsDuration);

		if (m_gtsDuration < m_guardTime || m_gtsDuration == 0) {
			// CFP is too short to do something
			dbg_serial("CfpTransmitP", "CFP too short!\n");

			call RadioToken.transferTo(RADIO_CLIENT_DEVICE_INACTIVE_PERIOD);
			return;
		}
		//printf(".........\n");

		m_capDuration = ((uint32_t) call SF.numCapSlots()) *
		(uint32_t) call SF.sfSlotDuration();

		m_slotDuration = call SF.sfSlotDuration();
		m_cfpInit = call SF.sfStartTime() + m_capDuration;
		m_slotNumber = call SF.numCapSlots();

		m_gtsDuration -= m_guardTime;

#ifndef IEEE154_BEACON_TX_DISABLED
		m_numGtsSlots = (call GetGtsCoordinatorDb.get())->numGtsSlots;
#endif

		dbg_serial("CfpTransmitP", "Starting CFP at %lu\n", m_cfpInit);
		dbg_serial("CfpTransmitP", "CFP time: %lu\n", m_gtsDuration);
		dbg_serial("CfpTransmitP", "Got token, remaining CFP time: %lu\n",
				call SF.sfStartTime() + m_capDuration + m_gtsDuration - call CfpEndAlarm.getNow());

		call CfpEndAlarm.startAt(m_cfpInit, m_gtsDuration);

		slot_mode = IDLE_MODE;
		hasStartSlot();
		updateState();
	}

	async event void RadioTx.transmitDone(ieee154_txframe_t *frame, error_t result) {
		bool done = TRUE;
		dbg("CfpTransmitP", "CfpTransmitP.transmitDone() in %lu -> %lu\n", call CfpEndAlarm.getNow(), (uint32_t) result);

		switch (result)
		{
			case SUCCESS:
			// frame was successfully transmitted, if ACK was requested
			// then a matching ACK was successfully received as well   
			currentEntry->expiration = FALSE;
			m_txStatus = IEEE154_SUCCESS;
			break;
			case FAIL:
			m_txStatus = IEEE154_DISABLE_TRX_FAILURE;
			break;
			case ENOACK:
			m_txStatus = IEEE154_NO_ACK;
			break;
			case EINVAL: // DEBUG!!!
			dbg_serial("CfpTransmitP", "EINVAL returned by transmitDone()!\n");
			// fall through
			default:
			ASSERT(0);
			break;
		}

		if (done) {
			m_lastFrame = m_currentFrame;
			m_currentFrame = NULL;
			post signalTxDoneTask();
		}

		m_lock = FALSE;
		updateState();
	}

	async event void RadioOff.offDone()
	{
		m_lock = FALSE;
		updateState();
	}

	async event void RadioRx.enableRxDone()
	{
		m_lock = FALSE;
		updateState();
	}

	event void RadioToken.granted()
	{
		ASSERT(0); // should never happen, because we never call RadioToken.request()
	}

	event message_t* RadioRx.received(message_t* frame)
	{
		// received a frame -> find out frame type and
		// signal it to responsible client component
		uint8_t *mhr = MHR(frame);
		uint8_t frameType = mhr[MHR_INDEX_FC1] & FC1_FRAMETYPE_MASK;

		if (frameType == FC1_FRAMETYPE_DATA) {
			currentEntry->expiration = FALSE;
			dbg("CfpTransmit", "Received frame, DSN: %lu, type: 0x%lu\n",
					(uint32_t) mhr[MHR_INDEX_SEQNO], (uint32_t) frameType);
			return signal CfpRx.received(frame);
		} else
		return frame;
	}

	default event message_t* CfpRx.received(message_t* data) {return data;}

	/***************************************************************************************
	 * RxEnabled FUNCTIONS
	 ***************************************************************************************/

	task void wasRxEnabledTask()
	{
		signal WasRxEnabled.notify(TRUE);
	}
	command error_t WasRxEnabled.enable() {return FAIL;}
	command error_t WasRxEnabled.disable() {return FAIL;}

	event void RxEnableStateChange.notify(bool whatever) {updateState();}
	event void PIBUpdateMacRxOnWhenIdle.notify( const void* val ) {
		atomic macRxOnWhenIdle = *((ieee154_macRxOnWhenIdle_t*) val);
		updateState();
	}
}
