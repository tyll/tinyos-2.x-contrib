/*
 * "Copyright (c) 2007 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */
 
/**
 *
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */

module PureTDMASchedulerP {
	provides {
		interface Init;
		interface SplitControl;
		interface AsyncSend as Send;
		interface AsyncReceive as Receive;
		interface CcaControl[am_id_t amId];
		interface FrameConfiguration as Frame;
	}	
	uses{			
		interface AsyncStdControl as GenericSlotter;
		interface RadioPowerControl;
		interface Slotter;
		interface SlotterControl;
		interface FrameConfiguration;
		interface AsyncSend as SubSend;
		interface AsyncSend as BeaconSend;
		interface AsyncReceive as SubReceive;
		
		interface AMPacket;
		interface Resend;
		interface PacketAcknowledgements;
		
		interface Boot;
		interface Leds;
		
		//interface HplMsp430GeneralIO as Pin;
	}
}
implementation {
	enum { 
		SIMPLE_TDMA_SYNC = 123,
	};
	
	bool init;
	uint32_t slotSize;
	uint8_t bi, sd, cap;
	uint8_t coordinatorId;
	message_t *toSend;
	uint8_t toSendLen;
	uint8_t currentSlot;
	bool sync;
	bool requestStop;
	bool finishedSlot;
	uint32_t *alarmTime;

	event void Boot.booted()
	{
	}
	
	command error_t Init.init() {		
	  //call Pin.makeOutput();
		currentSlot = 0xff;
		slotSize = 10 * 32;     //10ms
		bi = 16; //# of slots
		sd = 11; //last active slot
		cap = 0;
		coordinatorId = 0;
		init = FALSE;
		toSend = NULL;
		toSendLen = 0;
		sync = FALSE;
		requestStop = FALSE;
		finishedSlot = TRUE;
		return SUCCESS;
	}
	
 	command error_t SplitControl.start() {
 		error_t err;
 		if (init == FALSE) {
 			call FrameConfiguration.setSlotLength(slotSize);
 			call FrameConfiguration.setFrameLength(bi+1);
 		}
 		
 		err = call RadioPowerControl.start();
 		return err;
 	}
 	
 	
 	command error_t SplitControl.stop() {
 		requestStop = TRUE;
 		call GenericSlotter.stop();
 		call RadioPowerControl.stop();
 		return SUCCESS;
 	}
 	
 	event void RadioPowerControl.startDone(error_t error) {
 		//call Leds.led2On();
 		if (coordinatorId == TOS_NODE_ID) { 		
 			if (init == FALSE) { 				
 				signal SplitControl.startDone(error);
 				call GenericSlotter.start();
 				call SlotterControl.synchronize(0);
 				init = TRUE;
 			}
 		} else {
 			if (init == FALSE) {
 				signal SplitControl.startDone(error);
 				init = TRUE;
 			}
 		} 		
	}
	
 	event void RadioPowerControl.stopDone(error_t error)  {
		if (requestStop)  {
			requestStop = FALSE;
			signal SplitControl.stopDone(error);
		}
		//call Leds.led2Off();
	}
 	
 	/****************************
 	 *   Implements the schedule
 	 */ 	
 	async event void Slotter.slot(uint8_t slot) {
 		message_t *tmpToSend;
 		uint8_t tmpToSendLen;
 		
 		//printf("slot,%d\n",slot);printfflush();//sha
 		
 		atomic currentSlot = slot;
 	
 		if (slot == 0) {
 			//beacon slot
 			if (coordinatorId == TOS_NODE_ID) {		
 				call BeaconSend.send(NULL, 0);
 			};
 			return;
 		} 
 		
 		if (slot >= sd+1) {
 			//sleep 			
 			if (slot == sd+1) {
 				call RadioPowerControl.stop();
 				//call Pin.clr();
 				call Leds.led0Off();
 			}
 			
 			//wakeup
 			if (slot == bi) {
 				call RadioPowerControl.start();
 				//call Pin.set();
 				call Leds.led0On();
 			} 
 			return;
 		}
 		
 		if (slot < cap) {
 			//signal CSMASlotSend.send(slot); 
 		} else {
 				if(TOS_NODE_ID==0&& slot == 8)
 				{
 					atomic {
 						tmpToSend = toSend;
 						tmpToSendLen = toSendLen;
 					}
 					call SubSend.send(tmpToSend, tmpToSendLen);
 				}
 				
 				if (slot == TOS_NODE_ID)  {
 					//call Pin.set();
 					atomic {
 						tmpToSend = toSend;
 						tmpToSendLen = toSendLen;
 					}
 					call SubSend.send(tmpToSend, tmpToSendLen);
 			}
 		}

 	}
 	
 	async command error_t Send.send(message_t * msg, uint8_t len) {
 		atomic {
 			if (toSend == NULL) {
 				toSend = msg;
 				toSendLen = len;
 				return SUCCESS;
 			}
 		}		
 		
 		return FAIL;
 	}


	async event void BeaconSend.sendDone(message_t * msg, error_t error) {	
	}


	async event void SubSend.sendDone(message_t * msg, error_t error) {	
		if (msg == toSend) {
			if (call AMPacket.type(msg) != SIMPLE_TDMA_SYNC) { 
			//printf("PureIDMASchedulerP,senddone\n");printfflush();
				signal Send.sendDone(msg, error);
			} else {
				//call Slotter.stop();
				//call SyncAlarm.start(32 * slotSize - PACKET_TIME_32HZ);
			}
			atomic toSend = NULL;
		}		
	}
	
 	//provide the send interface
 	async command error_t Send.cancel(message_t *msg) { 
  		atomic {
 			if (toSend == NULL) return SUCCESS;
 			atomic toSend = NULL;
 		}
 		return call SubSend.cancel(msg);
 	}

	/**
	 * Receive
	 */
	async event void SubReceive.receive(message_t *msg, void *payload, uint8_t len) {
		am_addr_t src = call AMPacket.source(msg);

		if (coordinatorId == TOS_NODE_ID) {
			if ((currentSlot != 0xff) && (currentSlot != src)) {
			}	
		}
		signal Receive.receive(msg, payload, len);
	}	
	
	/** 
	 * Frame configuration
	 */
  	command void Frame.setSlotLength(uint32_t slotTimeBms) {
		atomic slotSize = slotTimeBms;
		call FrameConfiguration.setSlotLength(slotSize);
 	}
 	command void Frame.setFrameLength(uint8_t numSlots) {
 		atomic bi = numSlots;
		call FrameConfiguration.setFrameLength(bi+1);
 	}
 	command uint32_t Frame.getSlotLength() {
 		return slotSize;
 	}
 	command uint8_t Frame.getFrameLength() {
 		return bi+1;
 	}

	
	/**
	 * MISC functions
	 */
	async command void *Send.getPayload(message_t * msg, uint8_t len) {
		return call SubSend.getPayload(msg, len); 
	}
	
	async command uint8_t Send.maxPayloadLength() {
		return call SubSend.maxPayloadLength();
	}
	
	//provide the receive interface
	command void Receive.updateBuffer(message_t * msg) { return call SubReceive.updateBuffer(msg); }
	
	default async event uint16_t CcaControl.getInitialBackoff[am_id_t id](message_t * msg, uint16_t defaultbackoff) {
		return 0;
	}
	
	default async event uint16_t CcaControl.getCongestionBackoff[am_id_t id](message_t * msg, uint16_t defaultBackoff) {
		return 0;
	}
        
	default async event bool CcaControl.getCca[am_id_t id](message_t * msg, bool defaultCca) {
		return FALSE;
	}
}
