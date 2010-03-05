/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
 

/**
 * @author David Moss */

#include "Lpl.h"
#include "Wor.h"
#include <UserButton.h>
#define PREAMBLE_INTERVAL 30
#define WAIT_TIME 400

module LplP {
  provides {
    interface SplitControl[radio_id_t radioId];
    interface LowPowerListening[radio_id_t radioId];
    interface Send[radio_id_t radioId];
    
  }
  
  uses {
    interface Send as SubSend[radio_id_t radioId];
    interface Wor[radio_id_t radioId];
    interface State;
    interface SplitControlManager[radio_id_t radioId];
    interface BlazePacketBody;
    interface RxNotify[radio_id_t radioId];
    interface State as ReceiveState;
    interface Leds;

		//add by Gang Sep 17
		interface SplitControl as SubControl[radio_id_t radioId];
		interface Timer<TMilli> as PreambleTimer;
		interface Timer<TMilli> as WaitTimer;
  }
}

implementation {
  
  /** TRUE if WoR is enabled on a system level, regardless of radio power */
  bool worSystemEnabled[uniqueCount(UQ_BLAZE_RADIO)];
  
  /** Current radio we're dealing with */
  radio_id_t focusedRadio;

	//added by Gang
	radio_id_t tempRadioID;
  
  /** Message just sent */
  message_t *focusedMsg;
	message_t ackMsg;
  
  /** Temporary variable used for length and error code on send and sendDone */
  uint8_t temp;
	uint8_t sender = 0;
	uint8_t preambling = 0;
  
  /**
   * States
   */
  enum {
    S_IDLE,
    S_SPLITCONTROL_STOP,
    S_SPLITCONTROL_START,
    S_SENDING,
    S_SENDDONE,
    S_RXDONE,
		S_SUBSEND,
    S_CONFIGURING,
  };
  
  enum {
    /** The amount of extra time to send a wake-up transmission, in bms */
    EXTRA_TRANSMIT_TIME = 3,
  };
  
    
  /***************** Prototypes ****************/
  uint16_t convertMsToBms(uint16_t ms);
  uint16_t convertBmsToMs(uint16_t bms);
  
	void init(radio_id_t radioId){
		call State.forceState(S_SPLITCONTROL_START);
    if(worSystemEnabled[radioId]) {
      call Wor.enableWor[radioId](TRUE);
      // continues at Wor.stateChanged()...
    } else {
      call State.toIdle();
      signal SplitControl.startDone[radioId](SUCCESS);
    }

	}
  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start[radio_id_t radioId]() {
    call SubControl.start[radioId]();  
    return SUCCESS;
  }
	event void SubControl.startDone[radio_id_t radioId](error_t error){
    worSystemEnabled[radioId] = TRUE;
		
		init(radioId);
//      signal SplitControl.startDone[radioId](SUCCESS);
	}
  
  command error_t SplitControl.stop[radio_id_t radioId]() {
    call State.forceState(S_SPLITCONTROL_STOP);
    
    if(worSystemEnabled[radioId]) {
      call Wor.enableWor[radioId](FALSE);
      return SUCCESS;
      // continues at Wor.stateChanged()...
      
    } else {
      call State.toIdle();
      signal SplitControl.stopDone[radioId](SUCCESS);
    }
    
    return SUCCESS;
  }
  

	event void SubControl.stopDone[radio_id_t radioId](error_t error){
	}
  

  
  /***************** LowPowerListening Commands ****************/
  /** 
   * Use true milliseconds!
   */
  command void LowPowerListening.setLocalSleepInterval[radio_id_t radioId](uint16_t sleepIntervalMs) {  
    call Wor.calculateAndSetEvent0[radioId](sleepIntervalMs);
    if(sleepIntervalMs == 0) {
      // Disable WoR if it is currently active.
      worSystemEnabled[radioId] = FALSE;
      
      if(call Wor.isEnabled[radioId]()) {
        if(call State.requestState(S_CONFIGURING) != SUCCESS) {
          return;
        }
        
        call Wor.enableWor[radioId](FALSE);
      }
     
    } else {
      worSystemEnabled[radioId] = TRUE;
      if(call SplitControlManager.isOn[radioId]()) {
        if(call State.requestState(S_CONFIGURING) != SUCCESS) {
          return;
        }
        
        call Wor.synchronizeSettings[radioId]();
      }
    }
  }
  
  command uint16_t LowPowerListening.getLocalSleepInterval[radio_id_t radioId]() {
    return call Wor.getEvent0Ms[radioId]();
  }
  
  /**
   * Use true milliseconds!
   */
  command void LowPowerListening.setRxSleepInterval[radio_id_t radioId](message_t *msg, uint16_t sleepIntervalMs) {
    (call BlazePacketBody.getMetadata(msg))->rxInterval = 
        convertMsToBms(sleepIntervalMs) + EXTRA_TRANSMIT_TIME;
  }
  
  
  /**
   * @return true milliseconds
   */
  command uint16_t LowPowerListening.getRxSleepInterval[radio_id_t radioId](message_t *msg) {
    return convertMsToBms((call BlazePacketBody.getMetadata(msg))->rxInterval);
  }
  
  
  
  command void LowPowerListening.setLocalDutyCycle[radio_id_t radioId](uint16_t dutyCycle) {
    // Not supported!
  }
  
  command uint16_t LowPowerListening.getLocalDutyCycle[radio_id_t radioId]() {
    // Not supported!
    return 10000;
  }
  
  command void LowPowerListening.setRxDutyCycle[radio_id_t radioId](message_t *msg, uint16_t dutyCycle) {
    // Not supported!
  }
  
  command uint16_t LowPowerListening.getRxDutyCycle[radio_id_t radioId](message_t *msg) {
    // Not supported!
    return 10000;
  }
  
  command uint16_t LowPowerListening.dutyCycleToSleepInterval[radio_id_t radioId](uint16_t dutyCycle) {
    // Not supported!
    return 10000;
  }
  
  command uint16_t LowPowerListening.sleepIntervalToDutyCycle[radio_id_t radioId](uint16_t sleepInterval) {
    // Not supported!
    return 10000;
  }
  
  /***************** RxNotify Events ****************/
  event void RxNotify.doneReceiving[radio_id_t radioId]() {
    if(call SplitControlManager.isOn[radioId]() 
       && worSystemEnabled[radioId]
         && call State.isIdle()) {
      call State.forceState(S_RXDONE);
      call Wor.enableWor[radioId](TRUE);
      // Continues at stateChange()..
    }
  }

	/*
		 typedef nx_struct blaze_header_t {
		 nxle_uint8_t length;
		 nxle_uint16_t dest;
		 nxle_uint8_t fcf;
		 nxle_uint8_t dsn;
		 nxle_uint16_t src;
		 nxle_uint8_t destpan;
		 nxle_uint8_t type;
		 } blaze_header_t;

		 typedef nx_struct blaze_footer_t {
#if BLAZE_ENABLE_CRC_32
			nx_uint32_t crc;
#endif
			} blaze_footer_t;

			typedef nx_struct blaze_metadata_t {
			nx_uint8_t rssi;
			nx_uint8_t lqi;
			nx_uint8_t radio;
			nx_uint8_t txPower;
			nx_uint16_t rxInterval;
			nx_uint16_t maxRetries;
			nx_uint16_t retryDelay;
			} blaze_metadata_t;
	*/

	/***************** Send Commands ****************/
	command error_t Send.send[radio_id_t radioId](message_t* msg, uint8_t len) {
		blaze_header_t *header;
		header = call BlazePacketBody.getHeader( (message_t *) msg );

		/*
		if(header->length == 28)
			call Leds.led1Toggle();
		PXDBG(printfUART("length=%d\n", header->length));
		PXDBG(printfUART("dest=%d\n", header->dest));
		PXDBG(printfUART("fcf=%d\n", header->fcf));
		PXDBG(printfUART("dsn=%d\n", header->dsn));
		PXDBG(printfUART("src=%d\n", header->src));
		PXDBG(printfUART("destpan=%d\n", header->destpan));
		PXDBG(printfUART("type=%d\n\n", header->type));
		*/

		if(call State.requestState(S_SENDING) != SUCCESS) {
			return EBUSY;
		}

		if(worSystemEnabled[radioId] 
				&& call Wor.isEnabled[radioId]()
				&& call ReceiveState.isIdle()) {
			focusedMsg = msg;
			temp = len;
			call Wor.enableWor[radioId](FALSE);
			return SUCCESS;
			// continues at stateChange()...

		} else {
			return call SubSend.send[radioId](msg, len);
		}
	}

	command error_t Send.cancel[radio_id_t radioId](message_t* msg) {
		return call SubSend.cancel[radioId](msg);
	}

	command uint8_t Send.maxPayloadLength[radio_id_t radioId]() {
		return call SubSend.maxPayloadLength[radioId]();
	}

	command void* Send.getPayload[radio_id_t radioId](message_t* msg, uint8_t len) { 
		return call SubSend.getPayload[radioId](msg, len);
	}

	/***************** SubSend Events ****************/
	event void SubSend.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
		//PXDBG(printfUART("SubSendDone receive_state=%d, is wor=%d \n", call ReceiveState.isIdle(), call Wor.isEnabled[radioId]())); 

		if(call SplitControlManager.isOn[radioId]() 
				/* && worSystemEnabled[radioId]*/
				&& call ReceiveState.isIdle()) {

			call State.forceState(S_SENDDONE);
			focusedMsg = msg;
			temp = error;

			//changed by Gang
			if(sender == 1)
				call Wor.enableWor[radioId](FALSE);
			else
				call Wor.enableWor[radioId](TRUE);
			// Continues at stateChange()...

		} else {
			call State.toIdle();
			signal Send.sendDone[radioId](msg, error);
		}
	}

	error_t subsend(radio_id_t radioId){
		if(worSystemEnabled[radioId] 
				/*&& call Wor.isEnabled[radioId]()*/
				&& call State.isIdle()) 
		{
			call State.forceState(S_SUBSEND);
			call Wor.enableWor[radioId](FALSE);
			return SUCCESS;
			// continues at stateChange()...
		}
		else{
			return FAIL;
		}

	}

	/***************** Wor Events ****************/
	event void Wor.stateChange[radio_id_t radioId](bool enabled) {
		uint8_t lastState = call State.getState();
		blaze_header_t *ackHeader;

		call State.toIdle();

		switch(lastState) {
			case S_SPLITCONTROL_STOP:
				signal SplitControl.stopDone[radioId](SUCCESS);
				break;

			case S_SPLITCONTROL_START:
				signal SplitControl.startDone[radioId](SUCCESS);
				break;

			case S_SENDING:
				//PXDBG(printfUART("Sending\n")); 
				sender = 1;
				focusedRadio = radioId;
				call PreambleTimer.startPeriodic(PREAMBLE_INTERVAL);
				//call WaitTimer.startOneShot(WAIT_TIME);
				break;

			case S_SENDDONE:
				//PXDBG(printfUART("SendDone receive_state=%d,is wor=%d\n",call ReceiveState.isIdle(),call Wor.isEnabled[radioId]())); 
				if(sender == 0){
						signal Send.sendDone[radioId](focusedMsg, temp);
				}
				break;

			case S_SUBSEND:
				//PXDBG(printfUART("SubSend\n")); 
				//PXDBG(printfUART("length=%d\n", MAC_HEADER_SIZE + MAC_FOOTER_SIZE)); 
				ackHeader = call BlazePacketBody.getHeader((message_t *)&ackMsg);
				//ackHeader->length = 28 + MAC_HEADER_SIZE + MAC_FOOTER_SIZE;
				ackHeader->length = 14; 
				ackHeader->dest = -1;
				ackHeader->fcf = 0;
				ackHeader->dsn = 0;
				ackHeader->src = TOS_NODE_ID;
				ackHeader->destpan = 34;
				ackHeader->type = 6;
				call SubSend.send[radioId](&ackMsg, temp);
				break;

			case S_RXDONE:
				//PXDBG(printfUART("RxDone sender=%d\n", sender)); 
				if(sender == 1){
					//PXDBG(printfUART("RxDone try to stop preamble timer\n")); 
					call PreambleTimer.stop();
					sender = 0;
					
					call State.forceState(S_SENDDONE);
					call WaitTimer.stop();
					call Wor.enableWor[radioId](TRUE);
				}
				else{
					subsend(focusedRadio);
				}
				break;

			default:
				break;
		}
	}

	event void PreambleTimer.fired(){
		call Leds.led0Toggle();
		call SubSend.send[focusedRadio](focusedMsg, temp);
	}
	
	event void WaitTimer.fired(){
		call PreambleTimer.stop();
		signal Send.sendDone[focusedRadio](focusedMsg, temp);
	}

	/***************** SplitControlManager Events ****************/
	event void SplitControlManager.stateChange[radio_id_t radioId]() {
	}

	/***************** Tasks and Functions ****************/
	uint16_t convertMsToBms(uint16_t ms) {
		return (((uint32_t) ms) * ((uint32_t) 1024)) / 1000;
	}

	uint16_t convertBmsToMs(uint16_t bms) {
		return (((uint32_t) bms) * ((uint32_t) 1000)) / 1024;
	}

	/***************** Defaults ****************/
	default event void SplitControl.startDone[radio_id_t radioId](error_t error) {
	}

	default event void SplitControl.stopDone[radio_id_t radioId](error_t error) {
	}

	default event void Send.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
	}

}

