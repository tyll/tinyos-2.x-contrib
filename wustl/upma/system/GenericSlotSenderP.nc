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
 * The generic slot sender implements a generic slot as follows:
 * 
 *      start
 *       |
 *       |           offset     initial backoff     send done      
 *       |             |              |              |               
 *       v             v              V              V               
 *       |********************************************************|
 *       |---START-----|---OFFSET-----|----SENT------|            | END 
 *  
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */
 
generic module GenericSlotSenderP(uint16_t offset, uint16_t backoff, bool cca)  {
	provides interface Init;
	provides interface AsyncSend as Send;
		
	uses interface AsyncSend as SubSend;
	uses interface AMPacket;
	uses interface Alarm<T32khz, uint16_t>;
	uses interface CcaControl as SubCcaControl;
	uses interface Leds;
	
	uses interface Boot;
		
} implementation {
	enum {
		S_START = 0,
		S_OFFSET = 1,
		S_SENT = 2,
		S_END = 3,
	};
	
	message_t *toSend;
	uint8_t toSendLen;
	uint8_t state;

	event void Boot.booted()
	{
	}
	
		
	void alarm(uint8_t at) { 
	}
	
	command error_t Init.init() {
		toSend = NULL;
		toSendLen = 0;
		state = S_END;
		return SUCCESS;
  	}
  	  		
	async command error_t Send.send(message_t *msg, uint8_t len) {
  		error_t err;
  		uint8_t state_;
  		
  		if (msg == NULL) return FAIL;	
  		
  		atomic {
  			state_ = state;
  			
			toSend = msg;
			toSendLen = len;
			
			if (offset == 0) {
				state = S_OFFSET;
			} else {
				state = S_START;
			}
		}
		
		if (state_ != S_END) {
			alarm(0);
			return FAIL;
		}
		
	
		if (state == S_OFFSET) {
			err = call SubSend.send(toSend, toSendLen);			
			if (err != SUCCESS) {
				atomic state = S_END;
			}
		} else {
			call Alarm.start(offset);
			err = SUCCESS;
		}
		
		//call Pin.set();
		
		return err;
		
  	}
  	
  	async event void Alarm.fired() {
  		uint8_t oldState;
  		
  		atomic oldState = state;
  		if (oldState != S_START) {
  			alarm(2);
  		}
  		
  		atomic state = S_OFFSET;  		
  		if (call SubSend.send(toSend, toSendLen) != SUCCESS) {
			atomic state = S_END;
		}
  	}
  	
  	
	async event void SubSend.sendDone(message_t * msg, error_t error) {
		if (toSend == msg) {
			atomic state = S_END;
			atomic toSend = NULL;
			signal Send.sendDone(msg,error);
		}
	}
	
 	async command error_t Send.cancel(message_t *msg) { 
 		return FAIL;
 	}
 	
	async command void *Send.getPayload(message_t * msg, uint8_t len) {
		return call SubSend.getPayload(msg, len); 
	}
	
	async command uint8_t Send.maxPayloadLength() {
		return call SubSend.maxPayloadLength();
	}
 	
	async event uint16_t SubCcaControl.getInitialBackoff(message_t * msg, uint16_t defaultbackoff) {
		return backoff;
	}
	
	async event uint16_t SubCcaControl.getCongestionBackoff(message_t * msg, uint16_t defaultBackoff) {
		return 0;
	}
        
	async event bool SubCcaControl.getCca(message_t * msg, bool defaultCca) {
		return cca;
	}
}
