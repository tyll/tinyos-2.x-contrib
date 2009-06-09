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
 *       |****************************************************************|
 *       |---START-----|---OFFSET-----|----SENT------|                    | END 
 *                                              
 *
 * @author Octav Chipara
 * @version $Revision$
 * @date $Date$
 */
 
generic module CsmaSlotSenderP(uint16_t offset, uint16_t backoff, uint16_t checkLength)  {
	provides interface Init;
	provides interface AsyncSend as Send;
		
	uses interface AsyncSend as SubSend;
	uses interface AMPacket;
	uses interface CcaControl as SubCcaControl;
	uses interface Leds;
	
	uses interface ChannelMonitor;
	uses interface Alarm<T32khz, uint32_t>;
	uses interface Random;
} implementation {
	enum {
		S_START = 0,
		S_CCA = 1,
		S_BACKOFF = 2,
		S_CCA2 = 3,
		S_SEND = 4,
		S_END = 5,
	};
	
	message_t *toSend;
	uint8_t toSendLen;
	uint8_t state;
	
	void alarm(uint8_t at) { 
	}
	
	command error_t Init.init() {
		toSend = NULL;
		toSendLen = 0;
		state = S_END;
		
		return SUCCESS;
  	}
  	  		
	async command error_t Send.send(message_t *msg, uint8_t len) {
  		uint8_t state_;
		if (msg == NULL) return FAIL;	
		
		atomic state_ = state;
		if ((state_ != S_END) && (state_ != S_START)) {
			alarm(0);
			return FAIL;
		} else {
			atomic {
				state = S_START;  		
				toSend = msg;
				toSendLen = len;
			}

			call ChannelMonitor.setCheckLength(checkLength);
			call ChannelMonitor.check();
		}
	
		return SUCCESS;
  	}
  	
  	 async event void ChannelMonitor.free() {
  	 	uint8_t state_;
  	 	uint16_t initialBackoff;
  	 	
  	 	atomic state_ = state;
  	 	
  	 	if (state_ == S_START) {
  	 		atomic state = S_BACKOFF;
  	 		initialBackoff = 1 + (call Random.rand16() % backoff);
  	 		call Alarm.start(initialBackoff);
  	 	} else {
  	 		if (state_ == S_CCA2) {
  	 			if (call SubSend.send(toSend, toSendLen) == SUCCESS) {
  	 				atomic state = S_SEND;
  	 			}
  	 		} //else alarm(3);
  	 	}  	 	
  	 }
  	 
  	 async event void Alarm.fired() {
  	 	uint8_t state_;
  	 	
  	 	atomic state_ = state;
  	 	if (state_ == S_BACKOFF) {
  	 		atomic state  = S_CCA2;
  	 		call ChannelMonitor.setCheckLength(checkLength);
  	 		call ChannelMonitor.check();
  	 	} else {
  	 		alarm(4);
  	 	}
  	 }

  	
  	async event void ChannelMonitor.busy() {
  		atomic state = S_END;
  		if (toSend != NULL) signal Send.sendDone(toSend, FAIL);
  	}
  	
  	async event void ChannelMonitor.error() {
  		atomic state = S_END;
  		if (toSend != NULL) signal Send.sendDone(toSend, FAIL);
  	}
  	
  	
	async event void SubSend.sendDone(message_t * msg, error_t error) {
		if (toSend == msg) {
			atomic state = S_END;
			atomic toSend = NULL;
			signal Send.sendDone(msg,error);
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
 	
 	async command void *Send.getPayload(message_t *msg, uint8_t len) { 
		return call SubSend.getPayload(msg, len); 
	}
	
	async command uint8_t Send.maxPayloadLength() {
		return call SubSend.maxPayloadLength();
	}
 	
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
