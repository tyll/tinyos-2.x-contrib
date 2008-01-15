/**
 * @author Roman Lim
 */

#include "SyncMacStress.h"
#include "CC2420.h"

module SyncMacStressP {
  uses {
    // Interfaces for initialization:
    interface Boot;
    interface SplitControl as RadioControl;
    
    // Interfaces for communication
    interface AMSend as Send;
    interface Receive as Receive;
    interface AMPacket;
    interface Packet;
    interface LowPowerListening;

    // Miscalleny:
    interface Leds;
    
    // DSN
    interface DsnSend as DSN;
    interface PacketAcknowledgements;
    
    // Sensor
    interface Read<uint16_t> as ReadExternalTemperature;
    interface Read<uint16_t> as ReadExternalHumidity;
	interface Read<uint16_t> as ReadInternalTemperature;
	interface Read<uint16_t> as ReadInternalHumidity;
  }
}

implementation {
	
	bool sendbusy=FALSE;
	message_t dummy_msg;
	uint32_t pktCnt=0;
	am_addr_t dest;
	
    event void Boot.booted() {
       	call DSN.logInt(call AMPacket.address());
    	call DSN.logInfo("Node %i booted");
		
    	// Beginning our initialization phases:
    	if (call RadioControl.start() != SUCCESS) {
    		call DSN.logError("RadioControl.start() failed");
    	}
	}
	
	event void RadioControl.startDone(error_t error) {
		uint8_t i;
		uint8_t * p;
  		if (error != SUCCESS) {
    		call DSN.logError("RadioControl.startDone() failed");
    	}
  		if (TOS_NODE_ID==0) {
  			dest=1;
  	    	call LowPowerListening.setLocalSleepInterval(LPL_INT);
  	    	call LowPowerListening.setRxSleepInterval(&dummy_msg, LPL_INT + 1);
  		}
  		else {
  			dest=0;
  	    	call LowPowerListening.setLocalSleepInterval(LPL_INT+TOS_NODE_ID);
  	    	call LowPowerListening.setRxSleepInterval(&dummy_msg, LPL_INT);
  		}
    	p = (uint8_t *) call Packet.getPayload(&dummy_msg, MSG_LEN);
    	for (i=0;i<MSG_LEN;i++) {
    		*(p+i)=i;
    	}
    	// start sending
    	if (call Send.send(dest, &dummy_msg, MSG_LEN) == SUCCESS) {
    		pktCnt++;
    		sendbusy = TRUE;
    		call Leds.led1On();
    	}
    	// start sensing
    	call ReadExternalTemperature.read();
	}
	
	event void RadioControl.stopDone(error_t error) {
	}
	
	event message_t * Receive.receive(message_t* msg, void *payload, uint8_t len) {
		uint8_t i;
		call Leds.led0Toggle();
		if (len != MSG_LEN) {
			call DSN.logInt(len);
			call DSN.log("*** Error: Wrong length %i");	
			call DSN.logPacket(msg);
		}
    	for (i=0;i<len;i++) {
    		if (*((uint8_t *)payload+i)!=i) {
    			call DSN.log("*** Error: Corrupt payload");
    			call DSN.logPacket(msg);
    			break;
    		}
    	}
        return msg;
    }
    
  	event void Send.sendDone(message_t* msg, error_t error) {
  		call Leds.led1Off();
  		if (!sendbusy) {
  			call DSN.log("*** Error: SendDone signaled without invoking send");
  		}
  		else {
  			sendbusy = FALSE;
  			call DSN.logInt(pktCnt);
  			call DSN.logInt(error);
  			call DSN.logInt(call PacketAcknowledgements.wasAcked(msg));
  			call DSN.log("msg %i");
		
  			// start sending
  			if (TOS_NODE_ID==0)
  				dest=(dest)%2+1;
  			if (call Send.send(dest, &dummy_msg, MSG_LEN) == SUCCESS) {
  				pktCnt++;
  				sendbusy = TRUE;
  				call Leds.led1On();
  			}
  			else {
  				call DSN.log("send failed");
  			}
  		}
  	}
  	
    // external Sensirion
    event void ReadExternalTemperature.readDone(error_t result, uint16_t data) {
    	call ReadExternalHumidity.read();
    }
    
    event void ReadExternalHumidity.readDone(error_t result, uint16_t data) {
    	call ReadInternalTemperature.read();
    }
    // internal Sensirion
    event void ReadInternalTemperature.readDone(error_t result, uint16_t data) {
    	call DSN.logInt(data);
    	call DSN.log("temp %i");
    	call ReadInternalHumidity.read();
    }
    
    event void ReadInternalHumidity.readDone(error_t result, uint16_t data) {
    	call ReadExternalTemperature.read();
    }
  	
}

