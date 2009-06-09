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
 * This component handles time synchronization
 *
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */
 
enum { 
	SIMPLE_TDMA_SYNC = 123,
};

	
#define PACKET_TIME_32HZ 		37


module BeaconSlotP {
	provides interface Init;
	provides interface AsyncSend as Send;
	provides interface AsyncReceive as Receive; 
	
	uses interface AsyncSend as SubSend;
	uses interface AsyncReceive as SubReceive;
	uses interface AMPacket;
	uses interface SlotterControl;
	uses interface Alarm<T32khz, uint32_t> as SyncAlarm;
	uses interface CcaControl as SubCcaControl;
} implementation {
	message_t syncPkt;
	uint8_t syncPktLen;
	
	void alarm() {
	}
	
 	void write_timestamp(uint8_t *payload, uint32_t timestamp)
	{
		nx_uint32_t *ptr = (nx_uint32_t *) payload;
		*ptr = timestamp;
	}
	
	uint32_t read_timestamp(uint8_t *payload) {
		nx_uint32_t *ptr = (nx_uint32_t *) payload;
		
		return *ptr;
	}
	
	command error_t Init.init() {
  		call AMPacket.setDestination(&syncPkt, AM_BROADCAST_ADDR);
		call AMPacket.setType(&syncPkt, SIMPLE_TDMA_SYNC);
		call AMPacket.setSource(&syncPkt, TOS_NODE_ID);
		syncPktLen = call AMPacket.headerSize() + sizeof(nx_uint32_t);
		return SUCCESS;
  	}
  	

	async command error_t Send.send(message_t *msg, uint8_t len) {
		uint8_t *payload;
		error_t status;
		uint32_t remaining;
		
		payload = call SubSend.getPayload(&syncPkt, len);
 		
 		remaining = call SlotterControl.getRemaining();
 		write_timestamp(payload, remaining);
 		
 		status = call SubSend.send(&syncPkt, syncPktLen);
		return status;
  	}
  	
  	
	async event void SubSend.sendDone(message_t * msg, error_t error) {
		if (msg != &syncPkt) signal Send.sendDone(msg,error);
	}
	
 	async command error_t Send.cancel(message_t *msg) { 
 		return FAIL;
 	}
 	
 	async command void *Send.getPayload(message_t *msg, uint8_t len) { 
		return call SubSend.getPayload(msg, len); 
	}
	
	async command uint8_t Send.maxPayloadLength() {
		return call SubSend.maxPayloadLength();
	}
	
	
	/**
	 * Receive
	 */
	async event void SubReceive.receive(message_t *msg, void *payload, uint8_t len) {
		uint32_t alarmTime;
		
		if (call AMPacket.type(msg) == SIMPLE_TDMA_SYNC) {
			call SlotterControl.stop();
			
			alarmTime = read_timestamp(payload);
			if (alarmTime > PACKET_TIME_32HZ) {
				alarmTime = alarmTime - PACKET_TIME_32HZ;
				call SyncAlarm.start(alarmTime);
				//call Leds.led1Toggle();
			} else {
				//call Leds.led0Toggle();
				//alarm = 0;
				call SlotterControl.synchronize(1);
			}
			//signal Receive.receive(msg, payload, len);
			call SubReceive.updateBuffer(msg);
		} else {
			signal Receive.receive(msg, payload, len);
		}
	}

	async event void SyncAlarm.fired() {
		call SlotterControl.synchronize(1);
	}
	
	command void Receive.updateBuffer(message_t * msg) { return call SubReceive.updateBuffer(msg); }
	
	
	async event uint16_t SubCcaControl.getInitialBackoff(message_t * msg, uint16_t defaultbackoff) {
		return 0;
	}
	
	async event uint16_t SubCcaControl.getCongestionBackoff(message_t * msg, uint16_t defaultBackoff) {
		return 0;
	}
        
	async event bool SubCcaControl.getCca(message_t * msg, bool defaultCca) {
		return FALSE;
	}
}
