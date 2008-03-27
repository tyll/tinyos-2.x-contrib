/*
* Copyright (c) 2008 New University of Lisbon - Faculty of Sciences and
* Technology.
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
* - Neither the name of New University of Lisbon - Faculty of Sciences and
*   Technology nor the names of its contributors may be used to endorse or 
*   promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
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
 * @author Miguel Silva (migueltsilva@gmail.com)
 * @version $Revision$
 * @date $Date$
 */

#include <Timer.h>
#include "RSSI.h"
#include "AM.h"
#include "Serial.h"
#include "UserButton.h"

module RSSIC {
	uses interface Boot;
	uses interface Timer<TMilli> as Timer;
	uses interface Leds;
	uses interface SplitControl as AMControl;
	uses interface AMSend as RadioSend;
	uses interface Receive as RadioReceive;
	uses interface Packet as RadioPacket;
	uses interface AMPacket as RadioAMPacket;
	uses interface PacketAcknowledgements as PacketAck;
	uses interface CC2420Packet;
	uses interface SplitControl as PrintfControl;
	uses interface PrintfFlush;
	uses interface Get<button_state_t>;
	uses interface Notify<button_state_t>;
}
implementation {
	message_t pkt;
	uint32_t count;
	bool send_msg;

	/***************** Prototypes ****************/
	task void sendMsg();
	void  signallights(uint8_t value);


	/***************** Boot Events ****************/
	event void Boot.booted() {
		call AMControl.start();
		call Notify.enable();
		call PrintfControl.start();
		send_msg = FALSE;
		count = 0;
	}


	/***************** Timer Events ***************/
	event void Timer.fired() {
		if(send_msg == TRUE){
			post sendMsg();
		}
	}

	/***************** AMSend Events ****************/
	event void RadioSend.sendDone(message_t* msg, error_t error) {
		signallights(0);
		call Leds.led0Off();
		call Timer.startOneShot(SAMPLE_SEND);
	}


	/***************** RadioReceive Events ****************/
	event message_t* RadioReceive.receive(message_t* msg, void* payload,uint8_t len) {
		am_addr_t source = call RadioAMPacket.source(msg);
		//RssiMsg* Rssi = (RssiMsg*) (call RadioPacket.getPayload(&pkt,sizeof(RssiMsg)));
		if (source != TOS_NODE_ID) {
			int16_t value_rssi = call CC2420Packet.getRssi(msg);
			//uint8_t value_lqi = call CC2420Packet.getLqi(msg);
			count++;
			signallights(2);
			if (value_rssi > 0x80)
				//printf("time	%d	Raw RSSI	%d	LQI	%d	RSSI	%d\n",count,value_rssi,value_lqi,value_rssi - 256 - 45);
				printf("time	%ld	source	%d	RSSI	%d\n",count,source,value_rssi - 256 - 45);
			else
				//printf("time	%d	Raw RSSI	%d	LQI	%d	RSSI	%d\n",count,value_rssi,value_lqi,value_rssi - 45);
				printf("time	%ld	source	%d	RSSI	%d\n",count,source,value_rssi - 45);
			call PrintfFlush.flush();
		}
		return msg;
	}


	/*
	 * User Button function
	 * click and start sending messages after one second
	 * click again and stop sending 
	 */
	event void Notify.notify( button_state_t state ) {
		if ( state == BUTTON_RELEASED ) {
			if(send_msg == FALSE){
				call Timer.startOneShot(1024);
				send_msg = TRUE;
			}
			else{
				send_msg = FALSE;
			}
 		}
	}


	/***************** RadioSplitControl Events ****************/
	event void AMControl.startDone(error_t error) {
		if (error != SUCCESS)
			call AMControl.start();
	}

	event void AMControl.stopDone(error_t error) {
		if (error != SUCCESS)
			call AMControl.stop();
	}


	/***************** PrintfSplitControl Events ****************/
	event void PrintfControl.startDone(error_t error) {
		printf("This is a test\n");
		call PrintfFlush.flush();
	}

	event void PrintfControl.stopDone(error_t error) {

	}

	event void PrintfFlush.flushDone(error_t error) {

	}


	/****************** Tasks ****************/

	task void sendMsg() {
		RssiMsg* Rssi = (RssiMsg*) (call RadioPacket.getPayload(&pkt,sizeof(RssiMsg)));
		Rssi->value = TOS_NODE_ID;
		signallights(1);
		if(call RadioSend.send(AM_BROADCAST_ADDR, &pkt,sizeof(RssiMsg)) != SUCCESS) {
			post sendMsg();
		}
	}

	void  signallights(uint8_t value){
		if(value == 0){ call Leds.led0Off(); call Leds.led1Off(); call Leds.led2Off();
		} if(value == 1){ call Leds.led0On(); call Leds.led1Off(); call Leds.led2Off();
		} if(value == 2){ call Leds.led0Off(); call Leds.led1On(); call Leds.led2Off();
		} if(value == 3){ call Leds.led0On(); call Leds.led1On(); call Leds.led2Off();
		} if(value == 4){ call Leds.led0Off(); call Leds.led1Off(); call Leds.led2On();
		} if(value == 5){ call Leds.led0On(); call Leds.led1Off(); call Leds.led2On();
		} if(value == 6){ call Leds.led0Off(); call Leds.led1On(); call Leds.led2On();
		} if(value == 7){ call Leds.led0On(); call Leds.led1On(); call Leds.led2On();
		}
	}

}

