
#include "TestCase.h"
#include "CC1100.h"
#include "Ccxx00Nbd.h"
#include "CC2500.h"

module TestP {
  uses {
    interface TestControl as SetUpOneTime;
    
    interface TestCase as TestRadioOne;
    interface TestCase as TestRadioTwo;
    interface TestCase as TestRadioThree;
    
    interface AMSend;
    interface Receive;
    interface RadioSelect;
    interface RfResource;
    interface AMPacket;
    interface Leds;
  }
}

implementation {

  /** Current state */
  uint8_t state;
  
  /** Message to send */
  message_t myMsg;
  
  enum {
    S_TESTRADIOONE,
    S_TESTRADIOTWO,
    S_TESTRADIOTHREE,
    S_MAXSTATES,
  };
  
  /***************** Prototypes ****************/
  task void send();
  
  /***************** TestControl Events ****************/
  event void SetUpOneTime.run() {
    if(call AMPacket.address() > 0) {
      post send();
    }
    
    call SetUpOneTime.done();
  }
  
  /***************** Test Cases ****************/
  /**
   * Because we're using RF Resource and that component automatically
   * turns on the radio for us, we shouldn't have to mess with 
   * SplitControl start / stop throughout this test. But we should
   * keep in mind that future tests may conflict with the radios that
   * are still left on from this one.
   */
  event void TestRadioOne.run() {   
    state = S_TESTRADIOONE;
    
    // Default radio should already be the CC1100 radio for all platforms
    call RfResource.setDefaultRadio(CC1100_RADIO_ID);
  }
  
  event void TestRadioTwo.run() {
    state = S_TESTRADIOTWO;
    
    call RfResource.setDefaultRadio(NBD_RADIO_ID);
  }
  
  event void TestRadioThree.run() {
    state = S_TESTRADIOTHREE;
    
    call RfResource.setDefaultRadio(CC2500_RADIO_ID);
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.set(1 << state);
    state++;
    state %= S_MAXSTATES;
    call RadioSelect.selectRadio(&myMsg, state);
    post send();
  }
  
  /**************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.set(1 << state);
    
    switch(state) {
    case S_TESTRADIOONE:
      assertSuccess();
      call TestRadioOne.done();
      break;
    
    case S_TESTRADIOTWO:
      assertSuccess();
      call TestRadioTwo.done();
      break;
      
    case S_TESTRADIOTHREE:
      assertSuccess();
      state++;
      call TestRadioThree.done();
      break;
      
    default:
      break;
    }
    
    return msg;
  }
  
  /***************** RfResource Events ****************/
  event void RfResource.defaultRadioChanged(radio_id_t defaultRadio) {
  }
  
  /***************** Tasks ******************/
  task void send() {
    error_t error;
    if((error = call AMSend.send(1, &myMsg, 0)) != SUCCESS) {
      assertEquals("send(ERROR)", SUCCESS, error);
      post send();
    }
  }
}
