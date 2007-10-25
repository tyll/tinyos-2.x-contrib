/**
 * This application simply generates unicast traffic, following this scheme:
 * periodically send broadcast beacons
 * save neighbour ids
 * periodically send unicast packtes to a randomly selected neighbour 
 * 
 */
#include "syncmac.h"
#include "AM.h"
module SyncMacP {
	uses {
		interface Boot;
		interface Timer<TMilli> as BeaconTimer;
		interface Timer<TMilli> as UnicastTimer;
		
		interface SplitControl as RadioControl;

		interface AMPacket;
		interface Packet;
	    interface Leds;
		
	    interface DsnSend;
	    
	    interface LowPowerListening;
	    interface CC2420Config;
	    interface PacketAcknowledgements;

	    interface Receive as BeaconReceive;
	    interface Receive as UnicastReceive;
	    interface AMSend as BeaconSend;
	    interface AMSend as UnicastSend;

	    interface Random;
	} 
}
implementation {
	
	am_addr_t neighbour[5];
	uint8_t numNeighbours=0;
	message_t m;
	bool radiobusy=FALSE;
	am_addr_t unicastReceiverId=AM_BROADCAST_ADDR;
	
	event void Boot.booted(){
		call DsnSend.logInt(TOS_NODE_ID);
		call DsnSend.log("node %i booted");
		call RadioControl.start();
	}
	
	event void RadioControl.startDone(error_t error) {
		call BeaconTimer.startOneShot(2000);
		call UnicastTimer.startPeriodic(4000);
		call LowPowerListening.setLocalSleepInterval(200);

		call DsnSend.logInt(call CC2420Config.getChannel());
		call DsnSend.logInt(call CC2420Config.getShortAddr());
		call DsnSend.logInt(call CC2420Config.getPanAddr());
		call DsnSend.logInt(call CC2420Config.isAddressRecognitionEnabled());
		call DsnSend.logInt(call CC2420Config.isHwAutoAckDefault());
		call DsnSend.logInt(call CC2420Config.isAutoAckEnabled());
		call DsnSend.log("CC2420 configuration: ch %i, addr %i, pan %i, addrrec %i, hwAck %i, autoAck %i");
	}
	
	event void RadioControl.stopDone(error_t error) {	}
	
	event void BeaconTimer.fired() {
		beacon_msg_t * b_msg;
		call BeaconTimer.startOneShot(60000U);
		if (!radiobusy) {
			b_msg = call Packet.getPayload(&m, sizeof(beacon_msg_t));
			b_msg->id=TOS_NODE_ID;
			call LowPowerListening.setRxSleepInterval(&m, 200);
			if (call BeaconSend.send(AM_BROADCAST_ADDR, &m, sizeof(beacon_msg_t))==SUCCESS)
				radiobusy=TRUE;
		}
	}
	
	event void BeaconSend.sendDone(message_t* msg, error_t error) {
		radiobusy=FALSE;
	}
	
	event message_t * BeaconReceive.receive(message_t* msg, void* payload, uint8_t len) {
		uint8_t i;
		bool known=FALSE;
		am_addr_t id;
		if (len == sizeof(beacon_msg_t) && ((beacon_msg_t*)payload)->id!=TOS_NODE_ID) {
			call Leds.led0Toggle();
			id = ((beacon_msg_t*)payload)->id;
			if (numNeighbours<5) {
				for (i=0;i<numNeighbours;i++)
					if (neighbour[i]==id)
						known=TRUE;
				if (!known) {
					neighbour[numNeighbours++]=id;
					call DsnSend.logInt(id);
					call DsnSend.log("added %i");
				}
			}
		}
		return msg;
	}
	
	event void UnicastTimer.fired() {
		unicast_msg_t * u_msg;
		if (numNeighbours>1 && !radiobusy) {
			if (unicastReceiverId==AM_BROADCAST_ADDR) {
				unicastReceiverId=neighbour[call Random.rand16() % numNeighbours];
			}
			u_msg = call Packet.getPayload(&m, sizeof(unicast_msg_t));
			u_msg->id=TOS_NODE_ID;
			call LowPowerListening.setRxSleepInterval(&m, 200);
			call PacketAcknowledgements.requestAck(&m);
			if (call UnicastSend.send(unicastReceiverId, &m, sizeof(unicast_msg_t))==SUCCESS) {
				radiobusy=TRUE;
				//call Leds.led2Toggle();
			}
		}
	}
	
	event void UnicastSend.sendDone(message_t* msg, error_t error) {
		radiobusy=FALSE;
		//call DsnSend.logInt(unicastReceiverId);
		call DsnSend.log("senddone");
	}
	
	event message_t * UnicastReceive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(unicast_msg_t)) {
			call Leds.led1Toggle();
			//call DsnSend.logInt(call AMPacket.source(msg));
			//call DsnSend.log("msg from %i");
		}
		return msg;
	}
	
	event void CC2420Config.syncDone( error_t error ) {}
}
