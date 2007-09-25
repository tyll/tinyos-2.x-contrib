
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
    interface SplitControl as SubControl[ radio_id_t id ];
  }
  
  uses {
    interface TestControl as SetUp;
    interface TestCase as TestSelectRadio;
    interface TestCase as TestSelectCC1100;
    interface TestCase as TestSelectCC2500;
    interface TestCase as TestSelectInvalid;
    interface TestCase as TestReceiveCC1100;
    interface TestCase as TestReceiveCC2500;
    interface TestCase as TestStopWhileSending;
    interface TestCase as TestSendWhileOff;
    interface TestCase as TestStopWhileIdle;
    interface TestCase as TestWrongRadioOn;
    
    interface Send;
    interface Receive;
    interface SplitControl[ radio_id_t id ];
    interface BlazePacket;
    interface RadioSelect;
    interface State;
  }
}

implementation {

  message_t myMsg;
  
  /** SubControl state down below - either off or on */
  bool state[2];
  
  enum {
    S_SPLITCONTROL_OFF,
    S_SPLITCONTROL_ON,
  };
  
  
  enum {
    S_IDLE,
    S_TESTRADIOSELECT,
    S_TESTSELECTCC1100,
    S_TESTSELECTCC2500,
    S_TESTSELECTINVALID,
    S_TESTRECEIVECC1100,
    S_TESTRECEIVECC2500,
    S_TESTSTOPWHILESENDING,
    S_TESTSENDWHILEOFF,
    S_TESTSTOPWHILEIDLE,
    S_TESTWRONGRADIOON,
  };
  
  /***************** Prototypes *****************/
  task void testStopWhileSending_checkSplitControl();
  
  /***************** Test Control ****************/
  event void SetUp.run() {
    state[0] = S_SPLITCONTROL_OFF;
    state[1] = S_SPLITCONTROL_OFF;
    
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
    
    // Single-phase splitcontrol start, we can send immediately
    assertEquals("SplitControl.start(ERROR)", SUCCESS, call SplitControl.start[CC1100_RADIO_ID]());
    
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
    
    // Single-phase splitcontrol start, we can send immediately
    assertEquals("SplitControl.start(ERROR)", SUCCESS, call SplitControl.start[CC2500_RADIO_ID]());
    
    error = call Send.send(&myMsg, 0);
    if(error) {
      assertEquals("Error on send", SUCCESS, error);
    }
    
    call TestSelectCC2500.done();
  }
  
  event void TestSelectInvalid.run() {
    call State.forceState(S_TESTSELECTINVALID);
    assertEquals("Didn't get EINVAL", EINVAL, call RadioSelect.selectRadio(&myMsg, 3));
    
    // Turn on the radio our packet thinks it's being sent to, which
    // should be 0 because the above command shouldn't have been processed.
    assertEquals("SplitControl.start(ERROR)", SUCCESS, call SplitControl.start[call RadioSelect.getRadio(&myMsg)]());
    
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
  
  /**
   * Turn the radio on and verify we got a startDone event.  Then send a 
   * message.  Finally, turn the radio off and post a task.  When the task
   * gets executed later, verify the radio never turned off.
   */
  event void TestStopWhileSending.run() {
    call State.forceState(S_TESTSTOPWHILESENDING);
    assertEquals("Didn't get SUCCESS", SUCCESS, call RadioSelect.selectRadio(&myMsg, CC2500_RADIO_ID));
    assertEquals("SplitControl.start(ERROR)", SUCCESS, call SplitControl.start[CC2500_RADIO_ID]());
    // Continues at SplitControl.startDone()
  }
  
  /** 
   * First we turn the radio on, then turn it off, then try sending a message.
   * The message send request should return EOFF.
   */
  event void TestSendWhileOff.run() {
    call State.forceState(S_TESTSENDWHILEOFF);
    
    assertEquals("Didn't get SUCCESS", SUCCESS, call RadioSelect.selectRadio(&myMsg, CC2500_RADIO_ID));
    assertEquals("SplitControl.start(ERROR)", SUCCESS, call SplitControl.start[CC2500_RADIO_ID]());
    // Test continues at SplitControl.startDone()
  }
  
  /**
   * Turn the radio on, turn the radio off.  Note we're using a CC1100 here.
   */
  event void TestStopWhileIdle.run() {
    call State.forceState(S_TESTSTOPWHILEIDLE);
    assertEquals("SplitControl.start(ERROR)", SUCCESS, call SplitControl.start[CC1100_RADIO_ID]());
    // Continues at startDone()
  }
  
  /**
   * Turn on the CC2500 radio, then try sending to the CC1100 radio.
   * The send should return EOFF.
   */
  event void TestWrongRadioOn.run() {
    call State.forceState(S_TESTWRONGRADIOON);
    assertEquals("Didn't get SUCCESS", SUCCESS, call RadioSelect.selectRadio(&myMsg, CC1100_RADIO_ID));
    assertEquals("SplitControl.start(ERROR)", SUCCESS, call SplitControl.start[CC2500_RADIO_ID]());
    // Continues at startDone()
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
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone[ radio_id_t id ](error_t error) {
    switch (call State.getState()) {
      case S_TESTSTOPWHILESENDING:
        assertEquals("Wrong startDone radio [id]", CC2500_RADIO_ID, id);
        assertEquals("CC2500 state is not ON", S_SPLITCONTROL_ON, state[CC2500_RADIO_ID]);
        assertEquals("Send wasn't SUCCESS", SUCCESS, call Send.send(&myMsg, 0));
        // Now technically, it should post a task to stop the radio.  We should
        // get back a SUCCESS but SubControl.stop() should not be called
        // until Send.sendDone() is signaled.
        assertEquals("Stop wasn't SUCCESS", SUCCESS, call SplitControl.stop[CC2500_RADIO_ID]());
        post testStopWhileSending_checkSplitControl();
        break;
        
      case S_TESTSENDWHILEOFF:
        assertEquals("Wrong startDone radio [id]", CC2500_RADIO_ID, id);
        assertEquals("SplitControl.stop(ERROR)", SUCCESS, call SplitControl.stop[id]());
        // Test continues at SplitControl.stopDone()
        break;
        
      case S_TESTSTOPWHILEIDLE:
        assertEquals("Wrong startDone radio [id]", CC1100_RADIO_ID, id);
        assertEquals("SplitControl.stop(ERROR)", SUCCESS, call SplitControl.stop[id]());
        // Test continues at SplitControl.stopDone()
        break;
        
      case S_TESTWRONGRADIOON:
        assertEquals("Msg sent to radio that's off", EOFF, call Send.send(&myMsg, 0));
        call TestWrongRadioOn.done();
        break;
        
      default:
        break;
    }
  }
  
  event void SplitControl.stopDone[ radio_id_t id ](error_t error) {
    switch (call State.getState()) {
      case S_TESTSENDWHILEOFF:
        assertEquals("Wrong stopDone radio [id]", CC2500_RADIO_ID, id);
        assertEquals("Radio isn't off", S_SPLITCONTROL_OFF, state[CC2500_RADIO_ID]);
        assertEquals("Sent while off", EOFF, call Send.send(&myMsg, 0));
        call TestSendWhileOff.done();
        break;
      
      case S_TESTSTOPWHILEIDLE:
        assertEquals("Wrong stopDone id", CC1100_RADIO_ID, id);
        call TestStopWhileIdle.done();
        break;
        
      default:
        break;
    }
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
  
  /***************** SubControl Commands ****************/
  command error_t SubControl.start[ radio_id_t id ]() {
    switch (call State.getState()) {
      default:
        state[id] = S_SPLITCONTROL_ON;
        signal SubControl.startDone[id](SUCCESS);
        return SUCCESS;
        break;
    }
  }
  
  command error_t SubControl.stop[ radio_id_t id ]() {
    switch (call State.getState()) {
      default:
        state[id] = S_SPLITCONTROL_OFF;
        signal SubControl.stopDone[id](SUCCESS);
        return SUCCESS;
        break;
    }
  }
  
  
  /***************** Tasks *****************/
  task void testStopWhileSending_checkSplitControl() {
    assertEquals("SubControl.stop() got issued", S_SPLITCONTROL_ON, state[CC2500_RADIO_ID]);
    call TestStopWhileSending.done();
  }
  
  /***************** Defaults ****************/
  default command error_t SplitControl.start[ radio_id_t id ]() {
    assertFail("Test: wrong SplitControl.start[id]");
    return EINVAL;
  }
  
  default command error_t SplitControl.stop[ radio_id_t id ]() {
    assertFail("Test: wrong SplitControl.stop[id]");
    return EINVAL;
  }
}

