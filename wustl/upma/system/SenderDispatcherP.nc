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

module SenderDispatcherP {		
	uses interface CcaControl as SubCcaControl[am_id_t];
	uses interface AsyncSend as SubSend;
	
	#if TRACE_SEND == 1
	uses interface HplMsp430GeneralIO as Pin;	
	#endif
	
	provides interface Init;
	provides interface AsyncSend as Send[uint8_t type];
	provides interface CcaControl as SlotsCcaControl[uint8_t type];
} implementation {
	message_t *toSend;
	uint8_t toSendLen;
	uint8_t last_id;
	
	command error_t Init.init() {
		toSend = NULL;
		toSendLen = 0;
		last_id = NO_SLOT;
		
		
		#if TRACE_SEND == 1
			call Pin.makeOutput();
		#endif
			
		return SUCCESS;
  	}
	
	async command error_t Send.send[uint8_t slotType](message_t * msg, uint8_t len) {
 		error_t err;
 		message_t *prev_toSend;
 		uint8_t prev_toSendLen, prev_id;
 		
 		atomic {
 			prev_toSend = toSend;
 			prev_toSendLen = toSendLen;
 			prev_id = last_id;
 		}
 		
 		if (prev_id != NO_SLOT) {
 			return FAIL;
 		}
 		
		atomic {
			toSend = msg;
			toSendLen = len;
			last_id = slotType;
		}
 		err = call SubSend.send(msg, len);
 		if (err != SUCCESS) {
			atomic {
				toSend = prev_toSend;
				toSendLen = prev_toSendLen;
				last_id = prev_id;
			}
 		}
 		return err;
 	}
	
 	async command error_t Send.cancel[uint8_t slotType](message_t *msg) { 
 		return FAIL;
 	}
 	
 	async command void *Send.getPayload[uint8_t slotType](message_t *msg, uint8_t len) { 
		return call SubSend.getPayload(msg, len); 
	}
	
	async command uint8_t Send.maxPayloadLength[uint8_t slotType]() {
		return call SubSend.maxPayloadLength();
	}
	
	async event void SubSend.sendDone(message_t * msg, error_t error) {
		uint8_t prev_last_id;
		atomic prev_last_id = last_id;
	
		atomic {
			if (msg == toSend) {
				toSend = NULL;
			}
		}
	
		atomic last_id = NO_SLOT;	
		
		#if TRACE_SEND == 1
		call Pin.clr();
		#endif
		
		signal Send.sendDone[prev_last_id](msg,error);
	}
	
	default async event void Send.sendDone[uint8_t type](message_t * msg, error_t error) {
	}
	
	default async event uint16_t SlotsCcaControl.getInitialBackoff[am_id_t id](message_t * msg, uint16_t defaultbackoff) {
		return defaultbackoff;
	}
	
	default async event uint16_t SlotsCcaControl.getCongestionBackoff[am_id_t id](message_t * msg, uint16_t defaultBackoff) {
		return defaultBackoff;
	}
        
	default async event bool SlotsCcaControl.getCca[am_id_t id](message_t * msg, bool defaultCca) {
		return defaultCca;
	}
	
	async event uint16_t SubCcaControl.getInitialBackoff[am_id_t id](message_t * msg, uint16_t defaultbackoff) {
		uint16_t backoff;
		backoff = signal SlotsCcaControl.getInitialBackoff[last_id](msg, defaultbackoff);
		return backoff;
	}
	
	async event uint16_t SubCcaControl.getCongestionBackoff[am_id_t id](message_t * msg, uint16_t defaultBackoff) {
		return signal SlotsCcaControl.getCongestionBackoff[last_id](msg, defaultBackoff);
	}
        
	async event bool SubCcaControl.getCca[am_id_t id](message_t * msg, bool defaultCca) {
		bool cca;
		uint8_t last_id_;
		
		atomic last_id_ = last_id;
		cca = signal SlotsCcaControl.getCca[last_id_](msg, defaultCca);
		
		return cca;
	}
}
