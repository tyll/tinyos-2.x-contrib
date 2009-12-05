
module ContinuousTransmitP {
  uses {
    interface Boot;
    interface SplitControl;
    interface AMSend;
    interface Leds;
  }
}

implementation {

  message_t myMsg;
  
  /***************** Prototypes ****************/
  task void send();
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    call SplitControl.start();
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    post send();
  }
  
  event void SplitControl.stopDone(error_t error) {
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led2Toggle();
    post send();
  }

  /***************** Tasks ****************/
  task void send() {
    if(call AMSend.send(0, &myMsg, 20) != SUCCESS) {
      call Leds.led0Toggle();
      post send();
    }
  }
  
}

