/**
 * This application simply generates unicast traffic, following this scheme:
 * periodically send broadcast beacons
 * save neighbour ids
 * periodically send unicast packtes to a randomly selected neighbour 
 * 
 */
#include "syncmac.h"
#include "AM.h"
#include "CC2420.h"
module SyncMacP {
	uses {
		interface Boot;
		interface Timer<TMilli> as BeaconTimer;
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

	    interface Receive as BeaconReceive;
	    interface Receive as UnicastReceive;
	    interface AMSend as BeaconSend;
	    interface AMSend as UnicastSend;

	    interface Random;
	    
	    interface LinkPacketMetadata;
	} 
}
implementation {
	
	am_addr_t neighbour[5];
	uint8_t numNeighbours=0;
	message_t m;
	bool radiobusy=FALSE;
	am_addr_t unicastReceiverId=AM_BROADCAST_ADDR;
	
	enum {
		SLEEPTIME = 7000,
		BEACON_INTERVAL = 120000UL,
		UNICAST_INTERVAL = 14000UL,		
	};
	
	event void Boot.booted(){
		call DsnSend.logInt(TOS_NODE_ID);
		call DsnSend.log("node %i booted");
		call StartTimer.startOneShot(call Random.rand16() >> 10);
	}
	
	event void StartTimer.fired() {
		call RadioControl.start();
	}
	
	
	event void RadioControl.startDone(error_t error) {
		call BeaconTimer.startOneShot(call Random.rand16() & 0x0fff);
		call UnicastTimer.startOneShot(call Random.rand16());
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
	
	event void BeaconTimer.fired() {
		beacon_msg_t * b_msg;
		call BeaconTimer.startOneShot(BEACON_INTERVAL);
		if (!radiobusy) {
			b_msg = call Packet.getPayload(&m, sizeof(beacon_msg_t));
			b_msg->id=TOS_NODE_ID;
			call LowPowerListening.setRxSleepInterval(&m, SLEEPTIME);
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
		if (len == sizeof(beacon_msg_t) && call LinkPacketMetadata.highChannelQuality(msg)) {
			// call Leds.led0Toggle();
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
		if (!call UnicastTimer.isRunning())
			call UnicastTimer.startPeriodic(UNICAST_INTERVAL);
		if (numNeighbours>SYNCMAC_MIN_NEIGHBOURS && !radiobusy) {
			if (unicastReceiverId==AM_BROADCAST_ADDR) {
				/*
				if (TOS_NODE_ID!=44 && TOS_NODE_ID!=133)
					unicastReceiverId=44;
				else if (TOS_NODE_ID==44)
					unicastReceiverId=133;
				*/
				unicastReceiverId=neighbour[call Random.rand16() % numNeighbours];
				
			}
			if (unicastReceiverId!=AM_BROADCAST_ADDR) {
				u_msg = call Packet.getPayload(&m, sizeof(unicast_msg_t));
				u_msg->id=TOS_NODE_ID;
				call LowPowerListening.setRxSleepInterval(&m, SLEEPTIME);
				call PacketAcknowledgements.requestAck(&m);
				if (call UnicastSend.send(unicastReceiverId, &m, sizeof(unicast_msg_t))==SUCCESS) {
					radiobusy=TRUE;
					//call Leds.led2Toggle();
				}
			}
		}
	}
	
	event void UnicastSend.sendDone(message_t* msg, error_t error) {
		radiobusy=FALSE;
	}
	
	event message_t * UnicastReceive.receive(message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(unicast_msg_t)) {
			//call Leds.led1Toggle();
			//call DsnSend.logInt(call AMPacket.source(msg));
			//call DsnSend.log("msg from %i");
		}
		return msg;
	}
	
	event void CC2420Config.syncDone( error_t error ) {}
}
