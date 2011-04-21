
/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

#include "Debug.h"
#include "BroadcastDebug.h"

generic module DummyUnifiedBroadcastImplP() {

	provides {
		interface Send[uint8_t client];
		interface Receive[am_id_t id];
		interface UnifiedBroadcast[uint8_t client];
	}

	uses {
		interface Send as SubSend[uint8_t client];
		interface Receive as SubReceive[am_id_t id];

		interface AMPacket;
	}

} implementation {

	command error_t Send.send[uint8_t client](message_t* msg, uint8_t len) {
		if(call AMPacket.destination(msg)==AM_BROADCAST_ADDR) {
			dbg("UB.debug", "sending broadcast %hu\n", call AMPacket.type(msg));
			//mortenprintf("%hhu: sending %hhu\n", TOS_NODE_ID, call AMPacket.type(msg));
			debug_event1(DEBUG_BROADCAST_SEND_SENDING, call AMPacket.type(msg));
		}
		return call SubSend.send[client](msg, len);
	}
	
	command error_t Send.cancel[uint8_t client](message_t* msg) {
		return call SubSend.cancel[client](msg);
	}

	command uint8_t Send.maxPayloadLength[uint8_t client]() {
		return call SubSend.maxPayloadLength[client]();
	}
	
	command void* Send.getPayload[uint8_t client](message_t* m, uint8_t len) {
		return call SubSend.getPayload[client](m, len);
	}
	
  event void SubSend.sendDone[uint8_t client](message_t* msg, error_t err) {
		signal Send.sendDone[client](msg, err);
	}

	message_t* handle_receive(am_id_t id, message_t* msg, void* payload, uint8_t len, bool snooped) {

	}

	event message_t* SubReceive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) {
		if(call AMPacket.destination(msg)==AM_BROADCAST_ADDR) {
			dbg("UB.debug", "receiving broadcast %hu\n", call AMPacket.type(msg));
			debug_event1(DEBUG_BROADCAST_RECEIVE, call AMPacket.type(msg));
			//printf("%hhu: receive len %hhu, type %hhu, from %hu: ", TOS_NODE_ID, len, call AMPacket.type(msg), call AMPacket.source(msg));
			{
				uint8_t j;
				for(j=0; j<len; j++) {
					//printf("%hhu ", *((uint8_t*)payload + j)); 
				}
				//printf("\n");
			}
		}
        return signal Receive.receive[id](msg, payload, len);
	}

	command void UnifiedBroadcast.disableDelay[uint8_t client]() {}

	command void UnifiedBroadcast.enableDelay[uint8_t client]() {}

  default event void Send.sendDone[uint8_t client](message_t* msg, error_t err) {}

  default event message_t* Receive.receive[am_id_t id](message_t* msg, void* payload, uint8_t len) { return msg; }

} 
