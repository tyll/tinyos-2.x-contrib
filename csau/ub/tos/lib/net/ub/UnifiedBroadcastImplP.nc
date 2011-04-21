
/**
 *
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

#include "UnifiedBroadcast.h"

generic module UnifiedBroadcastImplP(uint8_t numClients) @safe() {

	provides {
		interface Init;
		interface Send[uint8_t client];
		interface Receive[am_id_t id];
		interface UnifiedBroadcast[uint8_t client];
	}
	
	uses {
		interface SplitControl as RadioControl;

		interface BitVector as PendingVector;
		interface BitVector as SendingVector;
		interface BitVector as UrgentVector;
		interface AMSend as BroadcastSend;
		interface Send as SubSend[uint8_t client];
		interface AMPacket;
		interface Packet;

		interface LocalTime<TMilli>;

		interface Receive as SubReceive[am_id_t id];

#ifndef UB_NO_TIMESTAMP
		interface PacketTimeSyncOffset;
#endif
	}

} implementation {

	enum {
		NO_TIMESTAMP = 0xFFFFFFFF,
	};

	typedef struct {
		uint32_t last_time;
		uint32_t current_time;
		message_t* ONE_NOK msg;
		uint8_t len;
	} queue_entry_t;
  
	queue_entry_t queue[numClients];
	uint8_t nextClient;
	
	message_t broadcast_msg;
	uint8_t offset;
#ifndef UB_NO_TIMESTAMP
	timesync_radio_t timestamp;
#endif
	bool sending;
	bool running;

	message_t r_msg;
	message_t* ONE receive_msg = &r_msg;

	task void prepareBroadcast();
	task void sendBroadcast();
	task void flushBroadcast();
	uint8_t free_space();
	bool add_client(uint8_t client);
	void signal_done(uint8_t client, error_t err);
	void clear_send();

	/********** Init **********/

	command error_t Init.init() {
		uint8_t i;
		for(i=0; i<numClients; i++) {
			queue[i].last_time = 0xFFFFFFFF;
		}
		nextClient = 0;
		offset = 0;
#ifndef UB_NO_TIMESTAMP
		timestamp = NO_TIMESTAMP;
#endif
		sending = FALSE;
		running = FALSE;
		return SUCCESS;
	}

	/***************** RadioControl ****************/

	event void RadioControl.startDone(error_t error) {
		running = TRUE;
	}

	event void RadioControl.stopDone(error_t error) {
		running = FALSE;
		post flushBroadcast();
	}


	/********** Send **********/

	command error_t Send.send[uint8_t client](message_t* msg, uint8_t len) {

		//if(TOS_NODE_ID==0) dbg("FTSP", "length is %hhu\n", len);

		if(call PendingVector.get(client)) {
			dbgerror("UB.error", "BUSY client %hhu with %hhu\n", client, call AMPacket.type(msg));			
			return EBUSY;
		} else if(running && call AMPacket.destination(msg)==AM_BROADCAST_ADDR && call AMPacket.type(msg)!=AM_UNIFIEDBROADCAST_MSG) {
			call PendingVector.set(client);
			queue[client].current_time = call LocalTime.get();
			queue[client].msg = msg;
			queue[client].len = len;

#ifdef TOSSIM
			dbg("UB.debug", "prepare client %hhu with %hu of len %hhu: ", client, call AMPacket.type(msg), len);
			{
						uint8_t j;
						uint8_t* buf = (uint8_t*) call Packet.getPayload(msg,len);
						for(j=0; j<len; j++) {
							dbg_clear("UB.debug", "%hhu ", buf[j]); 
						}
						dbg_clear("UB.debug", "\n");
			}
#endif
			//if(TOS_NODE_ID==0) dbg("FTSP", "adding client %hhu, pending: %hhu, sending: %hhu\n", client, call PendingVector.get(client), call SendingVector.get(client));
			post prepareBroadcast();
			return SUCCESS;
		} else {
			return call SubSend.send[client](msg, len);
		}
	}

	command error_t Send.cancel[uint8_t client](message_t* msg) {
		if(call PendingVector.get(client)) {
			// TODO: implement cancel mask so that signal done can be signalled
			// after return of SUCCESS
			return FAIL;//signal_done(client, ECANCEL);
		} else if (call SendingVector.get(client)) {
			return FAIL;
		} else {
			return call SubSend.cancel[client](msg);
		}
	}

	command uint8_t Send.maxPayloadLength[uint8_t client]() {
		return call SubSend.maxPayloadLength[client]();
	}
	
	command void* Send.getPayload[uint8_t client](message_t* m, uint8_t len) {
		return call SubSend.getPayload[client](m, len);
	}

  event void SubSend.sendDone[uint8_t client](message_t* msg, error_t err) {
		if(sending && nextClient==client) {
			sending = FALSE;
			post prepareBroadcast();
			nextClient = (nextClient + 1) % numClients;

			if(err==SUCCESS) {
				//dbg("UB.debug", "single, senddone\n");
			} else {
				dbgerror("UB.error", "single senddone fail\n");
			}
			
			signal_done(client, err);
		} else {
			signal Send.sendDone[client](msg, err);
		}
	}

	/********** BroadcastSend **********/

	task void prepareBroadcast() {
		uint8_t no_use;

		if(sending) return;

		if(TOS_NODE_ID==0) {
		dbg("UB.trace", "vectors: ");
		{
			uint8_t j;
			for(j=0; j<numClients; j++) {
				dbg_clear("UB.trace", "%hhu-%hhu, ", call PendingVector.get(j), call SendingVector.get(j));
			}
		}
		dbg_clear("UB.trace", "\n");
		}
		// TODO: make run through round-robin so that one client cannot be starved
		// by another
		
		for(no_use=0; no_use<numClients; no_use++) {

			if(call PendingVector.get(nextClient)) {
				//dbg("UB.trace", "len %hhu vs %hhu for client %hhu\n", queue[nextClient].len+2, len-offset, nextClient);
				
				// if already sending from client, send buffered message
				if(call SendingVector.get(nextClient)) {
					dbg("UB.debug", "already sending client, so send\n");
					post sendBroadcast();
					break;
				}

				// if we need to send single packet (2*2=4 headers need to be send,
				// else we might as well send single packet)
				if(queue[nextClient].len>TOSH_DATA_LENGTH-4) {

					/*
					// if pending messages in buffer, send them first
					if(offset>0) {
						dbg("UB.debug", "single, clear buffer\n");
						// TODO: add other clients that might fit in buffer now that we are sending anyways
						post sendBroadcast();
						break;
						
					// else send single message
					} else {*/

					error_t error = call SubSend.send[nextClient](queue[nextClient].msg, queue[nextClient].len);

					if(error==SUCCESS) {
                      dbg("UB.debug", "single, send client %hhu\n", nextClient);
						sending = TRUE;
						//offset = TOSH_DATA_LENGTH;
						break;
					} else {
						dbgerror("UB.error", "could not send client %hhu \n", nextClient);
						signal_done(nextClient, error);
					}
					
					//}

				} else {
					//am_id_t type = call AMPacket.type(queue[nextClient].msg);

					// if message fit in buffered message, buffer it
					if(add_client(nextClient)) {

						if(call UrgentVector.get(nextClient)) {
							dbg("UB.debug", "urgent added, so send\n");
							post sendBroadcast();
							break;
						}

					// else send buffer to clear space
					} else {

						dbg("UB.debug", "buffer is full, so send\n");
						post sendBroadcast();
						break;
						
					}
					
				}

			}

			// look at next client
			nextClient = (nextClient + 1) % numClients;
			
		}

		//post sendBroadcast();

	}

	task void sendBroadcast() {
		error_t error;
		uint8_t no_use, c;

		if(sending || offset==0) return;

		// fill up buffer with clients that might fit 
		c = nextClient;
		for(no_use=0; no_use<numClients; no_use++) {
			if(call PendingVector.get(c) && !call SendingVector.get(c)) {			
				if(add_client(c)) {
					dbg("UB.debug", "fill up with client %hhu\n", c);
				}
			}
			c = (c + 1) % numClients;
		}
		
#ifndef UB_NO_TIMESTAMP
		if(timestamp!=NO_TIMESTAMP) {
			// copy timestamp into 
			memcpy(((uint8_t*)call Packet.getPayload(&broadcast_msg, offset + sizeof(timesync_radio_t)))+offset, &timestamp, sizeof(timesync_radio_t));
			// enable packet timestamping on transmit
			call PacketTimeSyncOffset.set(&broadcast_msg);
			error = call BroadcastSend.send(AM_BROADCAST_ADDR, &broadcast_msg, offset + sizeof(timesync_radio_t));			
		} else {
			call PacketTimeSyncOffset.cancel(&broadcast_msg);
			error = call BroadcastSend.send(AM_BROADCAST_ADDR, &broadcast_msg, offset);
		}
#else
		error = call BroadcastSend.send(AM_BROADCAST_ADDR, &broadcast_msg, offset);
#endif

		if(error==SUCCESS) {
			dbg("UB.trace", "sending\n");
			sending = TRUE;
		} else {
			dbgerror("UB.error", "cannot send\n");

			clear_send();
			post prepareBroadcast();
		}
		
	}

	task void flushBroadcast() {
		uint8_t i;

		dbg("Test", "flushing broadcasts\n");

		if(!sending) {
			clear_send();
		}
		
		for(i=0; i<numClients; i++) {
			if(call PendingVector.get(i)) {		
				signal_done(i, EOFF);
			}
		}
	}

  event void BroadcastSend.sendDone(message_t* msg, error_t err) {

		if(err!=SUCCESS) {
			dbgerror("UB.error", "senddone fail\n");
		}
		
		clear_send();
		dbg("UB.trace", "done, so prepare\n");
		post prepareBroadcast();

	}

	/********** Receive **********/
			 
	event message_t* SubReceive.receive[am_id_t id](message_t* msg, void* payload, uint8_t length) {
		if(id==AM_UNIFIEDBROADCAST_MSG) {
			uint8_t* buf = (uint8_t*) payload;
			uint8_t len = length;
			uint8_t r_offset = 0;
            
			while(r_offset<len) {
				uint8_t l = buf[r_offset];
				if(l>0 && (r_offset+l+1)<=len){
					am_id_t type = buf[r_offset+1];
			
                    call Packet.clear(receive_msg);
                    memset(receive_msg->data, 0, TOSH_DATA_LENGTH);
					// Copy header, metadata, and packet content
					memcpy(receive_msg->header, msg->header, sizeof(message_header_t));
					memcpy(receive_msg->metadata, msg->metadata, sizeof(message_metadata_t));
					memcpy(call Packet.getPayload(receive_msg, l-1), &buf[r_offset+2], l-1);
					call Packet.setPayloadLength(receive_msg, l-1);
					// Set type
					call AMPacket.setType(receive_msg, type);

#ifndef UB_NO_TIMESTAMP
					if(type==AM_TIMESYNCMSG) {
                      uint8_t* p = (uint8_t*)call Packet.getPayload(receive_msg, call Packet.payloadLength(receive_msg)+sizeof(timesync_radio_t));
						// Set timestamp
						memcpy(p+call Packet.payloadLength(receive_msg), &buf[length-sizeof(timesync_radio_t)], sizeof(timesync_radio_t));
						// Adjust payload length
						call Packet.setPayloadLength(receive_msg, l-1+sizeof(timesync_radio_t));
						// Make sure that timestamp is not processed as packet content.
						len = length - sizeof(timesync_radio_t);
                        {
                          timesync_radio_t ts;
                          memcpy(&ts, (uint8_t*)call Packet.getPayload(receive_msg, call Packet.payloadLength(receive_msg)+sizeof(timesync_radio_t))+call Packet.payloadLength(receive_msg), sizeof(timesync_radio_t));
                        }
					}
#endif

                    receive_msg = signal Receive.receive[type](receive_msg, call Packet.getPayload(receive_msg, call Packet.payloadLength(receive_msg)), call Packet.payloadLength(receive_msg));
					

					r_offset += l+1;
				} else {
					dbgerror("UB.error", "no length\n");
					break;
				}
			}
			return msg;
		} else {
            return signal Receive.receive[id](msg, payload, length);
		}
	}

	/********** UnifiedBroadcast **********/

	command void UnifiedBroadcast.disableDelay[uint8_t client]() {
		call UrgentVector.set(client);
	}

	command void UnifiedBroadcast.enableDelay[uint8_t client]() {
		call UrgentVector.clear(client);
	}

	/********** Functions **********/

	uint8_t free_space() {
#ifndef UB_NO_TIMESTAMP
		return call Packet.maxPayloadLength() - offset - (timestamp!=NO_TIMESTAMP?sizeof(timesync_radio_t):0);
#else
		return call Packet.maxPayloadLength() - offset;
#endif
	}

	bool add_client(uint8_t client) {
		uint8_t len = call Packet.maxPayloadLength();
		uint8_t* buf = (uint8_t*) call Packet.getPayload(&broadcast_msg, len);

		if(queue[client].len+2 <= free_space()) {
			uint8_t* payload = (uint8_t*) call Packet.getPayload(queue[client].msg, queue[client].len);
			buf[offset+1] = call AMPacket.type(queue[client].msg);
#ifndef UB_NO_TIMESTAMP
			if(call AMPacket.type(queue[client].msg)==AM_TIMESYNCMSG) {
				// set length minus timestamp
				buf[offset] = queue[client].len + 1 - sizeof(timesync_radio_t);
				// copy data to buf without timestamp
				memcpy(&buf[offset+2], payload, queue[client].len-sizeof(timesync_radio_t));
				// save timestamp
				memcpy(&timestamp, payload + queue[client].len - sizeof(timesync_radio_t), sizeof(timesync_radio_t));
				// set used offset
				offset += queue[client].len+2-sizeof(timesync_radio_t);
			} else 
#endif
			{
				// set length
				buf[offset] = queue[client].len + 1;
				// copy data to bugf
				memcpy(&buf[offset+2], payload, queue[client].len);
				// set used offset
				offset += queue[client].len+2;
			}

			call PendingVector.clear(client);
			call SendingVector.set(client);
			dbg("UB.debug", "adding client %hhu with %hhu\n", client, call AMPacket.type(queue[client].msg));
			signal_done(client, SUCCESS);

			if(free_space()<3) {
				dbg("UB.debug", "buffer is almost full, so send\n");
				post sendBroadcast();
			}

			return TRUE;
		} else {
			return FALSE;
		}
	}
			 
	void signal_done(uint8_t client, error_t err) {
		message_t* temp_msg = queue[client].msg;

		// Set payload length as CC2420TimeSyncMessageP relies on this
		call Packet.setPayloadLength(queue[client].msg, queue[client].len); 

		queue[client].last_time = queue[client].current_time;
		queue[client].current_time = 0xFFFFFFFF;
		queue[client].msg = NULL;
		queue[client].len = 0;

		call PendingVector.clear(client);
					 
		signal Send.sendDone[client](temp_msg, err);
	}

	void clear_send() {
		call SendingVector.clearAll();
		offset = 0;
#ifndef UB_NO_TIMESTAMP
		timestamp = NO_TIMESTAMP;
#endif
		sending = FALSE;
	}

  default event void Send.sendDone[uint8_t client](message_t* msg, error_t err) {}

  default event message_t* Receive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) { return msg; }

}
