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

module SSTdmaSchedulerP {
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
		interface AsyncSend as SubSend_TDMA;
		interface AsyncSend as SubSend_CSMA;
		interface AsyncSend as SubSend_Beacon;
		interface AsyncReceive as SubReceive;
		
		interface AMPacket;
		interface Resend;
		interface PacketAcknowledgements;
		
		interface Leds;
	}
}
implementation {
	enum { 
		SIMPLE_TDMA_SYNC = 123,
	};
	
	#define PACKET_TIME_32HZ 		37

	bool init;
	uint32_t slotSize;
	uint8_t bi, sd, cap;
	uint8_t coordinatorId;
	message_t *toSend;
	uint8_t toSendLen;
	uint8_t currentSlot;
	bool sync;
	uint32_t *alarmTime;
	
#ifdef FRAME_STATS
	#define FRAMECOUNT 9
	norace uint8_t frameAttemptSend;
	norace uint8_t frameSentOk;
	norace uint8_t frameActiveSlots;
	norace uint8_t frameCount;
	norace uint8_t frameFailedSendDone;
	norace uint8_t frameFailedSend;
#endif

	command error_t Init.init() {
		currentSlot = 0xff;
		slotSize = 10 * 32;
		bi = 16; //# of slots
		sd = 11; //last active slot
		cap = 0;
		coordinatorId = 0;
		init = FALSE;
		toSend = NULL;
		toSendLen = 0;
		sync = FALSE;
		
		#ifdef FRAME_STATS
		frameSentOk = 0;
		frameAttemptSend = 0;
		frameActiveSlots = 0;
		frameFailedSend = 0;
		frameFailedSendDone = 0;
		frameCount = FRAMECOUNT;
		#endif
		
		return SUCCESS;
	}
	
 	command error_t SplitControl.start() {
 		error_t err;
 		if (init == FALSE) {
 			call FrameConfiguration.setSlotLength(slotSize);
 			call FrameConfiguration.setFrameLength(bi);
 		}
 		
 		err = call RadioPowerControl.start();
 		return err;
 	}
 	
 	
 	command error_t SplitControl.stop() {
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
		signal SplitControl.stopDone(error);
		//call Leds.led2Off();
	}
	
 	/****************************
 	 *   Implements the schedule
 	 */ 	
 	async event void Slotter.slot(uint8_t slot) {
 		message_t *tmpToSend;
 		uint8_t tmpToSendLen;
 		error_t err;
 		
 	
 		atomic {
 				tmpToSend = toSend;
 				tmpToSendLen = toSendLen;
 				currentSlot = slot;
 		}

 		if (slot == 0) {
 			//beacon slot
 			if (coordinatorId == TOS_NODE_ID) {
 				call SubSend_Beacon.send(NULL, 0);
 			}; 			 			
 			return;
 		} 

		#ifdef FRAME_STATS 		
 		if (slot == 1) {
 			if (frameCount == 0) {
 				atomic {
 					frameAttemptSend = 0;
 					frameActiveSlots = 0; 		
 					frameSentOk = 0;
 					frameFailedSendDone = 0;
 					frameFailedSend = 0;
 					frameCount = FRAMECOUNT;  					
 				}
 			} else {
 				atomic frameCount--;
 			}
 		}
 		#endif
 		
 		if (slot >= sd) {
 			if (slot == sd) {
 				call RadioPowerControl.stop();
 			}
 			
 			//wakeup
 			if (slot == bi - 1) {
 				call RadioPowerControl.start();
 			} 
 			return;
 		}
 		
 		if (slot < cap) {
 			//signal CSMASlotSend.send(slot); 
 		} else {
 			#ifdef FRAME_STATS 			
 			atomic frameActiveSlots++;
 			#endif
 			
 			if (coordinatorId == TOS_NODE_ID) {
 				//the coordinator will do the receiving
 			} else {
 				if (slot == TOS_NODE_ID) {
 					err = call SubSend_TDMA.send(tmpToSend, tmpToSendLen);
 				} else {
 					err = call SubSend_CSMA.send(tmpToSend, tmpToSendLen);
 				}
 				
 				#ifdef FRAME_STATS
 				atomic {
 					frameAttemptSend++; 				
 					if (err != SUCCESS) {
 						frameFailedSend++;
 					}
 				}
 				#endif
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


	void sendDone(message_t *msg, error_t error) {
		if (msg == toSend) {			
			if (call AMPacket.type(msg) != SIMPLE_TDMA_SYNC) { 
				if (error == SUCCESS) {
					#ifdef FRAME_STATS
					atomic frameSentOk++;
					#endif
					signal Send.sendDone(msg, error);
					atomic toSend = NULL;
				} else {
					#ifdef FRAME_STATS
					atomic frameFailedSendDone++;
					#endif
				}
			} 
		}		
	}
	
	async event void SubSend_CSMA.sendDone(message_t *msg, error_t error) {
		sendDone(msg, error);
	}
	
	async event void SubSend_TDMA.sendDone(message_t * msg, error_t error) {	
		sendDone(msg, error);
	}

	async event void SubSend_Beacon.sendDone(message_t * msg, error_t error) {	
		sendDone(msg, error);
	}
	
 	//provide the send interfac
 	async command error_t Send.cancel(message_t *msg) { 
 		return FAIL;
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
		call FrameConfiguration.setFrameLength(bi);
 	}
 	command uint32_t Frame.getSlotLength() {
 		return slotSize;
 	}
 	command uint8_t Frame.getFrameLength() {
 		return bi;
 	}

	/**
	 * Receive
	 */
	async event void SubReceive.receive(message_t *msg, void *payload, uint8_t len) {
		signal Receive.receive(msg, payload, len);		
	}
	
	/**
	 * MISC functions
	 */
	async command void *Send.getPayload(message_t *msg, uint8_t len) { 
		return call SubSend_TDMA.getPayload(msg, len); 
	}
	
	async command uint8_t Send.maxPayloadLength() {
		return call SubSend_TDMA.maxPayloadLength();
	}
	
	//provide the receive interface	
	command void Receive.updateBuffer(message_t * msg) { return call SubReceive.updateBuffer(msg); }
	
	default async event uint16_t CcaControl.getInitialBackoff[am_id_t id](message_t * msg, uint16_t defaultbackoff) {
		return 8;
	}
	
	default async event uint16_t CcaControl.getCongestionBackoff[am_id_t id](message_t * msg, uint16_t defaultBackoff) {
		return 8;
	}
        
	default async event bool CcaControl.getCca[am_id_t id](message_t * msg, bool defaultCca) {
		return TRUE;
	}

}
