
#include "TestCase.h"

/**
 * @author David Moss
 */
module TestRadioP {
  uses {
    interface TestControl as SetUp;
    
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

  uint16_t myIndex;
  
  message_t myMsg;
  
  /** TRUE if the radio is on */
  bool on;
  
  enum {
    S_IDLE,
    S_TESTINUSEDUTYCYCLE,
  };
  
    
  enum {
    RADIO_POWER_CYCLES = 100,
  };

  /***************** Prototypes ****************/
  task void sendMsg();
  
  /***************** SetUp Events ****************/
  event void SetUp.run() {
    call PacketAcknowledgements.requestAck(&myMsg);
    call SetUp.done();
  }
  
  
  /***************** Tests ****************/
  /**
   * Make sure the radio doesn't lock up if we continuously send messages
   * and duty cycle it at the same time
   */
  event void TestInUseDutyCycle.run() {
    call State.forceState(S_TESTINUSEDUTYCYCLE);
    call Timer.startPeriodic(128);
    post sendMsg();
  }
  
    
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    call Leds.led2On();
    on = TRUE;
  }
  
  event void SplitControl.stopDone(error_t error) {
    call Leds.led2Off();
    on = FALSE;
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led1Toggle();
    call Leds.led0Off();
    if(call State.isState(S_TESTINUSEDUTYCYCLE)) {
      post sendMsg();
    }
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    return msg;
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    if(on) {
      call SplitControl.stop();
      
    } else {
    
      if(call State.isState(S_TESTINUSEDUTYCYCLE)) {
        myIndex++;
        if(myIndex > RADIO_POWER_CYCLES) {
          call Timer.stop();
          call State.toIdle();
          assertSuccess();
          call TestInUseDutyCycle.done();
        }
      }
      
      call SplitControl.start();
    }    
  }
  
  /***************** Tasks ****************/
  task void sendMsg() {
    // Send to a node that probably isn't in our network to increase the 
    // amount of time spent in transmit. Request acks too.
    
    if(call AMSend.send(100, &myMsg, TOSH_DATA_LENGTH) != SUCCESS) {
      call Leds.led1Off();
      call Leds.led0Toggle();
      post sendMsg();
    }
  }
  
  
}
