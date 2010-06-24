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
 * This is a double adapter used to apply standard CC2420 radio stack
 * layers to the TOSSIM radio stack.
 * 1. It translates from Model -> (SubSend, SubReceive)
 * 2. It translates from (Send, Receive) -> SubModel
 * Standard CC2420 layers is applied in ActiveMessageC using the
 * Send and Receive interfaces.
 *
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   February 08 2010
 */

module TossimAdapterC {

	provides {
		interface TossimPacketModel as Model;		
		
		interface Send;
    interface Receive;
	}

	uses {
		interface Send as SubSend;
    interface Receive as SubReceive;

		interface TossimPacketModel as SubModel;		

		interface Packet;
	}

} implementation {

  tossim_header_t* getHeader(message_t* msg) {
    return (tossim_header_t*)msg->header;
  }

  tossim_metadata_t* getMetadata(message_t* msg) {
		return (tossim_metadata_t*)msg->metadata;
  }

	/***** Model to SubSend and SubReceive *****/

  command error_t Model.send(int node, message_t* msg, uint8_t len) {
		return call SubSend.send(msg, len - sizeof(tossim_header_t));
	}

  command error_t Model.cancel(message_t* msg) {
		return call SubSend.cancel(msg);
	}

  event void SubSend.sendDone(message_t* msg, error_t error) {
		signal Model.sendDone(msg, error);
	}

  event message_t* SubReceive.receive(message_t* msg, void* payload, uint8_t len) {
		signal Model.receive(msg);
		return msg;
	}

	/***** Send send Receive to SubModel *****/

	command error_t Send.send(message_t* msg, uint8_t len) {
		return call SubModel.send((int)getHeader(msg)->dest, msg, len + sizeof(tossim_header_t));
	}
			
	command error_t Send.cancel(message_t* msg) {
		return call SubModel.cancel(msg);
	}

  command uint8_t Send.maxPayloadLength() {
		return call Packet.maxPayloadLength();
	}

  command void* Send.getPayload(message_t* msg, uint8_t len) {
		return call Packet.getPayload(msg, len);
	}

  event void SubModel.sendDone(message_t* msg, error_t error) {
		signal Send.sendDone(msg, error);
	}

  event void SubModel.receive(message_t* msg) {
		signal Receive.receive(msg, call Packet.getPayload(msg, call Packet.payloadLength(msg)), call Packet.payloadLength(msg));
	}

  event bool SubModel.shouldAck(message_t* msg) {
		return signal Model.shouldAck(msg);
	}


}
