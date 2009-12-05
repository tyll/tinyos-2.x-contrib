
#include "RadioCountToLeds.h"

module RadioCountToLedsP {
  uses {
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli>;
    interface SplitControl;
    interface Packet;
    interface PacketAcknowledgements;
  }
}
implementation {

  message_t packet;
  
  uint16_t counter;
  
  bool radioOn;
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    radioOn = FALSE;
    counter = 0;
    call PacketAcknowledgements.requestAck(&packet);
    call SplitControl.start();
  }

  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t err) {
    call Timer.startPeriodic(1024);
  }

  event void SplitControl.stopDone(error_t err) {
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
		if(TOS_NODE_ID == 0){
			radio_count_msg_t* rcm = (radio_count_msg_t*) call Packet.getPayload(&packet, sizeof(radio_count_msg_t)); 
			counter++;
			rcm->counter = counter;
			call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t));
		}
	}

	/***************** Receive Events ****************/
  event message_t* Receive.receive(message_t* bufPtr, 
                                   void* payload, uint8_t len) {
		radio_count_msg_t* msg = payload ;
    //call Leds.led1Toggle();
		call Leds.set(msg->counter);
    return bufPtr;
  }
  
  /***************** AMSend Events ***************/
  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    call Leds.led2Toggle();
  }
}
