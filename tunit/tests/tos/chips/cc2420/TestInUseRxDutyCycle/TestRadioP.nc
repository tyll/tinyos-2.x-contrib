
#include "TestCase.h"

/**
 * @author David Moss
 */
module TestRadioP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestControl as SetUp;
    interface TestControl as TearDownOneTime;
    
    interface TestCase as TestInUseDutyCycle;
    
    interface SplitControl;
    interface AMSend;
    interface Receive;
    interface PacketAcknowledgements;
    interface Timer<TMilli>;
    interface State;
    interface Leds;
  }
}

implementation {

  uint16_t successfulReceiveCycles;
  
  bool justStarted;
  
  message_t myMsg;
  
  /** TRUE if the radio is on */
  bool on;
  
  enum {
    S_IDLE,
    S_SETUPONETIME,
    S_TESTINUSEDUTYCYCLE,
    S_TEARDOWNONETIME,
  };
  
    
  enum {
    RADIO_POWER_CYCLES = 100,
  };

  /***************** Prototypes ****************/
  task void sendMsg();
  
  /***************** SetUp Events ****************/
  event void SetUpOneTime.run() {
    justStarted = FALSE;
    call State.forceState(S_SETUPONETIME);
    call PacketAcknowledgements.requestAck(&myMsg);
    if(call SplitControl.start() != SUCCESS) {
      call State.toIdle();
      call SetUpOneTime.done();
    }
  }
  
  event void SetUp.run() {
    call SetUp.done();
  }
  
  event void TearDownOneTime.run() {
    call State.forceState(S_TEARDOWNONETIME);
    if(call SplitControl.stop() != SUCCESS) {
      call TearDownOneTime.done();
    }
  }
  
  /***************** Tests ****************/
  /**
   * Make sure the receiver doesn't lock up if we continuously send messages
   * and duty cycle it at the same time.  The test really begins when the 
   * receiver gets the first message.  The transmitter gets the run event
   * to start transmitting.
   */
  event void TestInUseDutyCycle.run() {
    post sendMsg();
  }
  
    
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    if(call State.getState() == S_SETUPONETIME) {
      call State.toIdle();
      call SetUpOneTime.done();
    }
    
    call Leds.led2On();
    justStarted = TRUE;
    on = TRUE;
  }
  
  event void SplitControl.stopDone(error_t error) {
    if(call State.isState(S_TEARDOWNONETIME)) {
      call TearDownOneTime.done();
    }
    
    call Leds.led1Off();
    call Leds.led2Off();
    on = FALSE;
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led1Toggle();
    post sendMsg();
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    if(call State.requestState(S_TESTINUSEDUTYCYCLE) == SUCCESS) {
      // Test just started, enable our duty cycling timer
      call Timer.startPeriodic(128);
    }
    
    call Leds.led1Toggle();
    if(justStarted) {
      justStarted = FALSE;
      successfulReceiveCycles++;
    }
    
    if(successfulReceiveCycles > RADIO_POWER_CYCLES) {
      call Timer.stop();
      call SplitControl.stop();
      assertSuccess();
      call TestInUseDutyCycle.done();
    }     
    
    return msg;
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    if(on) {
      call SplitControl.stop();
      
    } else {
      call SplitControl.start();
      
    }    
  }
  
  /***************** Tasks ****************/
  task void sendMsg() {
    if(call AMSend.send(1, &myMsg, TOSH_DATA_LENGTH) != SUCCESS) {
      post sendMsg();
    }
  }
  
  
}
