/*
 * Copyright (c) 2010 Aarhus University
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
 * - Neither the name of Aarhus University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL AARHUS
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 19 2010
 */

#include "Ieee154.h"
//#include "printf.h"

generic module Ieee154SenderP() {
	
	provides {
		interface Init;
		interface Ieee154Send as Send;
	} 
	
	uses {
		interface Resource as SendResource;
		interface Ieee154Send as SubSend;
	} 

} implementation {

	ieee154_saddr_t address;
	message_t* message;
	uint8_t length;

	
	/********** Init **********/
	
	command error_t Init.init() {
		address = IEEE154_BROADCAST_ADDR;
		message = NULL;
		length = 0;
		return SUCCESS;
	}

	/********** Send **********/
	
	command error_t Send.send(ieee154_saddr_t addr, message_t* msg, uint8_t len) {
		if(message!=NULL) {
			//printf("%hhu: busy\n", TOS_NODE_ID);
			//printfflush();
			return EBUSY;
		} else {
			address = addr;
			message = msg;
			length = len;
			//printf("%hhu: request\n", TOS_NODE_ID);
			call SendResource.request();
			return SUCCESS;
		}
	}
	
	event void SendResource.granted() {
		error_t error = call SubSend.send(address, message, length);
		if(error!=SUCCESS) {
			message_t* temp = message;
			call SendResource.release();
			message = NULL;
			//printf("%hhu: sent failed\n", TOS_NODE_ID);
			signal Send.sendDone(temp, error); 
		} else {
			//printf("%hhu: sending\n", TOS_NODE_ID);
		}
	}

	command error_t Send.cancel(message_t* msg) {
		if(message==msg) {
			return call SubSend.cancel(msg);
		} else {
			return FAIL;
		}
	}
	
  command uint8_t Send.maxPayloadLength() {
		return call SubSend.maxPayloadLength();
	}
	
  command void* Send.getPayload(message_t* msg, uint8_t len) {
		return call SubSend.getPayload(msg, len);
	}

	/********** SubSend **********/

  event void SubSend.sendDone(message_t* msg, error_t error) {
		message = NULL;
		call SendResource.release();
		//printf("%hhu: sendDone\n", TOS_NODE_ID);
		signal Send.sendDone(msg, error);
	}

	/********** Defaults **********/

  default event void Send.sendDone(message_t* msg, error_t error) {}

}
