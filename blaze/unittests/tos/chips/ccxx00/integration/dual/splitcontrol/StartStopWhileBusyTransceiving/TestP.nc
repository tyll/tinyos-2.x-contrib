
#include "TestCase.h"

/**
 * Node 1 starts up its radio and begins transmitting messages as fast as 
 * possible.  Node 0 flips its radio on and off several times a second while
 * receiving and transmitting messages.
 *
 * If the test times out, then something's wrong underneath.
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
    call State.forceState(S_SETUPONETIME);
    if(call ActiveMessageAddress.amAddress() != 0) {
      call SplitControl.start();
    
    } else {
      call SetUpOneTime.done();
    }
  }
  
  event void TearDownOneTime.run() {
    running = FALSE;
    call State.forceState(S_TEARDOWNONETIME);
    call Timer.stop();
    call SplitControl.stop();
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    on = TRUE;
    times++;
    call Leds.led0On();
    if(call State.getState() == S_SETUPONETIME) {
      call State.toIdle();
      post send();
      call SetUpOneTime.done();
    }
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
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    if(times < 100) {
      if(on) {
        call SplitControl.stop();
      } else {
        call SplitControl.start();
      }
      
    } else {
      assertSuccess();
      call MultiStartStop.done();
    }
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.led1Toggle();
    return msg;
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led2Toggle();
    post send();
  }

  async event void ActiveMessageAddress.changed() {
  }
  
  
  /***************** Tasks ****************/
  task void send() {
    if(running) {
      if(call AMSend.send(0, &myMsg, 0) != SUCCESS) {
        post send();
      }
    }
  }
}


