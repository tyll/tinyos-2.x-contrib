
/**
 * @author David Moss
 */
 
#include "CC1100.h"
#include "CC2500.h"

#include "Blaze.h"
#include "TestCase.h"

module TestRadioSelectP {
  provides {
    interface Send as SubSend[radio_id_t id];
    interface Receive as SubReceive[radio_id_t id];
  }
  
  uses {
    interface TestControl as SetUp;
    interface TestCase as TestSelectRadio;
    interface TestCase as TestSelectCC1100;
    interface TestCase as TestSelectCC2500;
    interface TestCase as TestSelectInvalid;
    interface TestCase as TestReceiveCC1100;
    interface TestCase as TestReceiveCC2500;
    
    interface Send;
    interface Receive;
    interface BlazePacket;
    interface RadioSelect;
    interface State;
  }
}

implementation {

  message_t myMsg;
  
  enum {
    S_IDLE,
    S_TESTRADIOSELECT,
    S_TESTSELECTCC1100,
    S_TESTSELECTCC2500,
    S_TESTSELECTINVALID,
    S_TESTRECEIVECC1100,
    S_TESTRECEIVECC2500,
  };
  
  /***************** Test Control ****************/
  event void SetUp.run() {
    call State.toIdle();
    call SetUp.done();
  }
  
  /***************** Test Cases ****************/
  event void TestSelectRadio.run() {
    call RadioSelect.selectRadio(&myMsg, CC2500_RADIO_ID);
    assertEquals("CC2500 not selected", CC2500_RADIO_ID, call RadioSelect.getRadio(&myMsg));
    
    call RadioSelect.selectRadio(&myMsg, CC1100_RADIO_ID);
    assertEquals("CC1100 not selected", CC1100_RADIO_ID, call RadioSelect.getRadio(&myMsg));
    
    assertEquals("Didn't get EINVAL", EINVAL, call RadioSelect.selectRadio(&myMsg, 2));
    
    call TestSelectRadio.done();
  }
  
  event void TestSelectCC1100.run() {
    error_t error;
    call State.forceState(S_TESTSELECTCC1100);
    
    call RadioSelect.selectRadio(&myMsg, CC1100_RADIO_ID);
    assertEquals("CC1100 not selected", CC1100_RADIO_ID, call RadioSelect.getRadio(&myMsg));
    
    error = call Send.send(&myMsg, 0);
    if(error) {
      assertEquals("Error on send", SUCCESS, error);
    }
    
    call TestSelectCC1100.done();
  }
  
  event void TestSelectCC2500.run() {
    error_t error;
    call State.forceState(S_TESTSELECTCC2500);
    
    call RadioSelect.selectRadio(&myMsg, CC2500_RADIO_ID);
    assertEquals("CC2500 not selected", CC2500_RADIO_ID, call RadioSelect.getRadio(&myMsg));
    
    error = call Send.send(&myMsg, 0);
    if(error) {
      assertEquals("Error on send", SUCCESS, error);
    }
    
    call TestSelectCC2500.done();
  }
  
  event void TestSelectInvalid.run() {
    call State.forceState(S_TESTSELECTINVALID);
    assertEquals("Didn't get EINVAL", EINVAL, call RadioSelect.selectRadio(&myMsg, 3));
    
    // We get success because the selectRadio call above didn't go through.
    assertEquals("Didn't get SUCCESS", SUCCESS, call Send.send(&myMsg, 0));
    call TestSelectInvalid.done();
  }
  
  event void TestReceiveCC1100.run() {
    message_t *msg;
    call State.forceState(S_TESTRECEIVECC1100);
    msg = signal SubReceive.receive[CC1100_RADIO_ID](&myMsg, NULL, 0);
    if(msg != &myMsg) {
      assertFail("Wrong msg returned");
    }
    
    call TestReceiveCC1100.done();
  }
  
  event void TestReceiveCC2500.run() {
    message_t *msg;
    call State.forceState(S_TESTRECEIVECC2500);
    msg = signal SubReceive.receive[CC2500_RADIO_ID](&myMsg, NULL, 0);
    if(msg != &myMsg) {
      assertFail("Wrong msg returned");
    }
    
    call TestReceiveCC2500.done();
  }
  
  
  /***************** Send Events ****************/
  event void Send.sendDone(message_t *msg, uint8_t len) {
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, error_t error) {
    if(msg != &myMsg) {
      assertFail("Rx msg!=&myMsg");
    }

    switch (call State.getState()) {
    case S_TESTRECEIVECC1100:
      assertEquals("CC1100 not selected", CC1100_RADIO_ID, call RadioSelect.getRadio(&myMsg));
      break;
      
    case S_TESTRECEIVECC2500:
      assertEquals("CC2500 not selected", CC2500_RADIO_ID, call RadioSelect.getRadio(&myMsg));
      break;
      
    default:
      break;
    }
    
    return msg;
  }
  
  
  
  /***************** SubSend Commands ****************/
  /**
   * By this point, the length should already be set in the message itself.
   * @param msg the message to send
   * @param len IGNORED
   * @return SUCCESS if we're going to try to send the message.
   *     FAIL if you need to reevaluate your code
   */
  command error_t SubSend.send[radio_id_t id](message_t* msg, uint8_t len) {
    if(msg != &myMsg) {
      assertFail("Tx msg!=&myMsg");
    }

    switch (call State.getState()) {
    case S_TESTSELECTCC1100:
      assertEquals("Wrong radio", CC1100_RADIO_ID, id);
      break;
      
    case S_TESTSELECTCC2500:
      assertEquals("Wrong radio", CC2500_RADIO_ID, id);
      break;
      
    default:
      break;
    }
    

    return SUCCESS;
  }

  command error_t SubSend.cancel[radio_id_t id](message_t* msg) {
    return FAIL;
  }

  command uint8_t SubSend.maxPayloadLength[radio_id_t id]() { 
    return 0;
  }

  command void *SubSend.getPayload[radio_id_t id](message_t* msg, uint8_t len) {
    return NULL;
  }
  
  
  
}

