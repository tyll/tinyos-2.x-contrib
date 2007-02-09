
/**
 * Quick hack to prove that the micaz receiver keeps rebooting when
 * receiving many packets from a transmitter
 * @author David Moss
 */
 
#include "message.h"
 
module ReliabilityP  {
  uses {
    interface Boot;
    interface AMSend;
    interface Receive;
    interface Leds;
    interface AMPacket;
    interface SplitControl;
    interface AMSend as SerialAMSend;
    interface SplitControl as SerialSplitControl;
  }
}

implementation {
  
  message_t myMsg;
  
  /***************** Prototypes ****************/
  task void send();
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    call SerialSplitControl.start();
    call SplitControl.start();
  }
  
  
  /***************** Radio SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    if(call AMPacket.address() == 0) {
      // I am the transmitter
      post send();
    }
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  
  /***************** SerialSplitControl Events ****************/
  event void SerialSplitControl.startDone(error_t error) {
    // Send a dummy packet to the serial port so we get a notification
    // that this mote just booted up.
    call SerialAMSend.send(0, &myMsg, 0);
  }
  
  event void SerialSplitControl.stopDone(error_t error) {
  }
  
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led1Toggle();
    post send();
  }
  
  event void SerialAMSend.sendDone(message_t *msg, error_t error) {
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, error_t error) {
    call Leds.led2Toggle();
    return msg;
  }
  
  /***************** Tasks ****************/
  task void send() {
    if(call AMSend.send(AM_BROADCAST_ADDR, &myMsg, TOSH_DATA_LENGTH) != SUCCESS) {
      post send();
    }
  }
  
}

