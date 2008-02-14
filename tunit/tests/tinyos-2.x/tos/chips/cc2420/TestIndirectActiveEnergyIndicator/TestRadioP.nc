
#include "TestCase.h"

module TestRadioP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestControl as TearDownOneTime;
    
    interface TestCase as TestIndicator;
    interface Statistics;
    
    interface SplitControl;
    interface AMSend;
    interface Receive;
    interface ActiveMessageAddress;
    interface ReceiveIndicator as EnergyIndicator;
    interface Timer<TMilli>;
    interface Leds;
  }
}

implementation {

  uint32_t detects;
  uint32_t misses;
  bool sending;
  bool detecting;
  bool transmitter;
  message_t myMsg;
  
  /***************** Prototypes ****************/
  task void send();
  task void detect();
  
  /***************** SetUpOneTime ****************/
  event void SetUpOneTime.run() {
    detects = 0;
    misses = 0;
    detecting = FALSE;
    transmitter = call ActiveMessageAddress.amAddress() == 1;
    call SplitControl.start();
  }
  
  /***************** TearDownOneTime ***************/
  event void TearDownOneTime.run() {
    sending = FALSE;
    call SplitControl.stop();
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    if(transmitter) {
      sending = TRUE;
      post send();
    }
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TearDownOneTime.done();
  }
  
  /***************** Tests *****************/
  event void TestIndicator.run() {
    detecting = TRUE;
    call Timer.startOneShot(10240);
    post detect();
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    if(transmitter) {
      post send();
      
    } else {
      detecting = FALSE;
      call Leds.led1Off();
      assertResultIsAbove("Too few energy detects", 1300, detects);
      assertResultIsAbove("Too few energy gaps", 10000, misses);
      call Statistics.log("[Energy Detects]", detects);
      call TestIndicator.done();
    }
  }
  
  
  /***************** Send/Receive ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led0Off();
    call Timer.startOneShot(128);
  }
  
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    return msg;
  }
  
  /***************** ActiveMessageAddress Events ****************/
  async event void ActiveMessageAddress.changed() {
  }
  
  /***************** Tasks ****************/
  task void send() {
    if(sending) {
      call Leds.led0On();
      if(call AMSend.send(1000, &myMsg, TOSH_DATA_LENGTH) != SUCCESS) {
        post send();
      }
    }
  }
  
  task void detect() {
    if(call EnergyIndicator.isReceiving()) {
      detects++;
      call Leds.led1On();
    } else {
      misses++;
      call Leds.led1Off();
    }
    
    if(detecting) {
      post detect(); 
    }
  }
  
}
