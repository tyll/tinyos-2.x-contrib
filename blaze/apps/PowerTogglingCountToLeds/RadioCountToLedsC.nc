
#include "Timer.h"
#include "RadioCountToLeds.h"
 

/**
 * Post send() in a task while toggling the radio on and off periodically
 * @author David Moss
 */
 
module RadioCountToLedsC {
  uses {
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli>;
    interface SplitControl;
    interface Packet;
  }
}
implementation {

  message_t packet;

  bool on;
  
  /***************** Prototypes *****************/
 
  task void send();
  
  /***************** Boot Events *****************/
  event void Boot.booted() {
    on = FALSE;
    call Timer.startPeriodic(256);
    post send();
  }

  /***************** SplitControl Events *****************/
  event void SplitControl.startDone(error_t err) {
    on = TRUE;
    call Leds.led2On();
  }

  event void SplitControl.stopDone(error_t err) {
    on = FALSE;
    call Leds.set(0);
  }
  
  
  /***************** Timer Events *****************/
  event void Timer.fired() {
    if(on) {
      call SplitControl.stop();
      
    } else {
      call SplitControl.start();
    }
  }


  /***************** Receive Events *****************/
  event message_t* Receive.receive(message_t* msg, 
                                   void* payload, uint8_t len) {
    if(on) {
      call Leds.led1Toggle();
    }
    return msg;
  }

  /***************** AMSend Events *****************/
  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    call Leds.led0Toggle();
    post send();
  }
  
  /***************** Tasks *****************/
  task void send() {
    if (call AMSend.send(AM_BROADCAST_ADDR, &packet, sizeof(radio_count_msg_t)) != SUCCESS) {
      post send();
    }
  }


}




