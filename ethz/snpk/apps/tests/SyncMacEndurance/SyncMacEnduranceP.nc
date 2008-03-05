/**
 * This application periodically sends a message between two nodes
 * The neighbour-sync-stack should only fill its mesurement-hostory and stop adding
 * more measurement points.
 * This app is intended to find out, how long a synchronization can last 
 */
#include "syncmac.h"
#include "AM.h"
#include "CC2420.h"
module SyncMacEnduranceP {
	uses {
		interface Boot;
		interface Timer<TMilli> as UnicastTimer;
		interface Timer<TMilli> as StartTimer;
		
		interface SplitControl as RadioControl;

		interface AMPacket;
		interface Packet;
	    interface Leds;
		
	    interface DsnSend;
	    
	    interface LowPowerListening;
	    interface CC2420Config;
	    interface PacketAcknowledgements;

	    interface Receive;
	    interface AMSend;

	    interface Random;
	    
	    interface LinkPacketMetadata;
	    interface NeighbourSyncRequest;
	} 
}
implementation {
	
	message_t m;
	bool radiobusy=FALSE;
	am_addr_t unicastReceiverId;
	
	enum {
		SLEEPTIME = 3000,
		UNICAST_INTERVAL = 7000UL,		
	};
	
	event void Boot.booted(){
		call DsnSend.logInt(TOS_NODE_ID);
		call DsnSend.log("node %i booted");
		call StartTimer.startOneShot(call Random.rand16() >> 6);
		switch (TOS_NODE_ID) {
		case 1:unicastReceiverId=46;break;
		case 46:unicastReceiverId=1;break;
		case 44:unicastReceiverId=133;break;
		case 133:unicastReceiverId=44;break;
		}				
	}
	
	event void StartTimer.fired() {
		call RadioControl.start();
	}
	
	
	event void RadioControl.startDone(error_t error) {
		call UnicastTimer.startPeriodic(UNICAST_INTERVAL);
		call LowPowerListening.setLocalSleepInterval(SLEEPTIME);

		call DsnSend.logInt(call CC2420Config.getChannel());
		call DsnSend.logInt(call CC2420Config.getShortAddr());
		call DsnSend.logInt(call CC2420Config.getPanAddr());
		call DsnSend.logInt(call CC2420Config.isAddressRecognitionEnabled());
		call DsnSend.logInt(call CC2420Config.isHwAutoAckDefault());
		call DsnSend.logInt(call CC2420Config.isAutoAckEnabled());
		call DsnSend.log("CC2420 configuration: ch %i, addr %i, pan %i, addrrec %i, hwAck %i, autoAck %i");
	}
	
	event void RadioControl.stopDone(error_t error) {	}
	
	event void UnicastTimer.fired() {
		unicast_msg_t * u_msg;
		if (!radiobusy) {
			u_msg = call Packet.getPayload(&m, sizeof(unicast_msg_t));
			u_msg->id=TOS_NODE_ID;
			call LowPowerListening.setRxSleepInterval(&m, SLEEPTIME);
			call PacketAcknowledgements.requestAck(&m);
			if (call AMSend.send(unicastReceiverId, &m, sizeof(unicast_msg_t))==SUCCESS) {
				radiobusy=TRUE;
			}
		}
	}
	
	event void AMSend.sendDone(message_t* msg, error_t error) {
		radiobusy=FALSE;
	}
	
	event message_t * Receive.receive(message_t* msg, void* payload, uint8_t len) {
		return msg;
	}
	
	event void CC2420Config.syncDone( error_t error ) {}

	event void NeighbourSyncRequest.updateRequest(am_addr_t address, uint16_t lplPeriod) {
		call DsnSend.logInt(address);
		call DsnSend.log("got sync request from %i");
	}
}
