
#include "TestCase.h"

/**
 * @author David Moss
 */
module TestRadioP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestControl as TearDownOneTime;
    
    interface TestCase as TestChangeFrequency;
    interface SplitControl;
    interface BlazeConfig;
    interface PacketAcknowledgements;
    interface AMSend;
    interface Receive;
    interface Timer<TMilli>;
    interface State;
    interface Leds;
  }
}

implementation {

  message_t myMsg;

  uint16_t misses;
  
  enum {
    S_IDLE,
    S_SETUPONETIME,
    S_TESTCHANGEFREQUENCY,
  };
  
  enum {
    MIN_CHANNEL = 0,
    MAX_CHANNEL = 255,
    MAX_MISSES = 100,
  };
  

  /***************** Prototypes ****************/
  task void changeChannel();
  task void send();
  
  /***************** SetUp Events ****************/
  event void SetUpOneTime.run() {
    call PacketAcknowledgements.requestAck(&myMsg);
    call State.forceState(S_SETUPONETIME);
    call SplitControl.start();
  }
  
  event void TearDownOneTime.run() {
    call SplitControl.stop();
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    call BlazeConfig.setChannel(MIN_CHANNEL);
    call BlazeConfig.commit();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TearDownOneTime.done();
  }
  
  event void BlazeConfig.commitDone() {
    call Leds.led1Toggle();
    
    if(call State.isState(S_SETUPONETIME)) {
      call State.toIdle();
      call SetUpOneTime.done();
    }
    
    if(call State.isState(S_TESTCHANGEFREQUENCY)) {
      post send();
    }
  }
  
  
  /***************** Tests ****************/
  event void TestChangeFrequency.run() {
    call State.forceState(S_TESTCHANGEFREQUENCY);
    post send();
  }
    
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led2Toggle();
    if(!call PacketAcknowledgements.wasAcked(msg)) {
      misses++;
      if(misses > MAX_MISSES) {
        assertFail("Didn't get a response");
        call TestChangeFrequency.done();
        return;
      
      } else {
        post send();
      }
      
    } else {
      if(call BlazeConfig.getChannel() < MAX_CHANNEL) {
        post changeChannel();
      } else {
        assertSuccess();
        call TestChangeFrequency.done();
      }
    }
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    if(call BlazeConfig.getChannel() < MAX_CHANNEL) {
      post changeChannel(); 
    }
    
    return msg;
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
  }
  
  /***************** Tasks ****************/
  task void send() {
    if(call AMSend.send(1, &myMsg, TOSH_DATA_LENGTH) != SUCCESS) {
      post send();
    }
  }
  
  task void changeChannel() {
    misses = 0;
    call BlazeConfig.setChannel(call BlazeConfig.getChannel() + 1);
    call BlazeConfig.commit();
  }
}
