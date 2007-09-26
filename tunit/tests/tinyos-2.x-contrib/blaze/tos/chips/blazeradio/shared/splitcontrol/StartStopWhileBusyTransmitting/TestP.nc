
#include "TestCase.h"

/**
 * Node 0 transmits its send() stuff in a continuous task loop while
 * toggling its radio on and off.  If the test times out, something's wrong
 * underneath in the radio stack. Obviously.
 * @author David Moss
 */
module TestP {
  uses {    
    interface TestCase as MultiStartStop;
    interface TestControl as SetUpOneTime;
    interface TestControl as TearDownOneTime;
    
    interface AMSend;
    interface Receive;
    interface SplitControl;
    interface Timer<TMilli>;
    interface State;
    interface ActiveMessageAddress;
    interface Leds;
  }
}

implementation {

  message_t myMsg;
  
  uint32_t times;
  
  bool on;
  
  bool running;
  
  enum {
    S_IDLE,
    S_SETUPONETIME,
    S_TEARDOWNONETIME,
  };
  
  /***************** Prototypes Events ****************/
  task void send();
  
  
  /***************** Test Control Events ****************/
  event void SetUpOneTime.run() {
    running = TRUE;
    times = 0;
    call SetUpOneTime.done();
  }
  
  event void TearDownOneTime.run() {
    running = FALSE;
    call State.forceState(S_TEARDOWNONETIME);
    call Timer.stop();
    call SplitControl.stop();
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    call Leds.led0On();
    on = TRUE;
    times++;
  }
  
  event void SplitControl.stopDone(error_t error) {
    on = FALSE;
    times++;
    call Leds.set(0);
    if(call State.getState() == S_TEARDOWNONETIME) {
      call TearDownOneTime.done();
    }
  }
  
  
  /***************** Tests ****************/
  event void MultiStartStop.run() {
    times = 0;
    call Timer.startPeriodic(128);
    post send();
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    if(times < 800) {
      if(on) {
        call Leds.led0Off();
        call SplitControl.stop();
      } else {
        call Leds.led0On();
        call SplitControl.start();
      }
      
    } else {
      assertSuccess();
      call MultiStartStop.done();
    }
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    return msg;
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led2Toggle();
    if(running) {
      post send();
    }
  }

  async event void ActiveMessageAddress.changed() {
  }
  
  
  /***************** Tasks ****************/
  task void send() {
    if(call AMSend.send(0, &myMsg, 0) != SUCCESS) {
      post send();
    }
  }
}


