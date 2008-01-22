
#include "TestCase.h"
#include "Blaze.h"
#include "SplitControlManager.h"

module TestManagerP {
  provides {
    interface SplitControl as SubControl[radio_id_t radioId];
    interface Send as SubSend[radio_id_t radioId];
  }
  
  uses {
    interface TestCase as TestAlreadyOn;
    interface TestCase as TestAlreadyOff;
    interface TestCase as TestAlreadyTurningOn;
    interface TestCase as TestAlreadyTurningOff;
    interface TestCase as TestOtherRadioFocused;
    interface TestCase as TestSendToDisabledRadio;
    interface TestCase as TestOnOff;
    
    interface TestControl as SetUp;
    interface TestControl as TearDown;
    
    interface Leds;
    interface State;
    
    interface SplitControlManager[radio_id_t radioId];
    interface SplitControl[radio_id_t radioId];
    interface Send[radio_id_t radioId];
  }
}

implementation {
  
  enum {
    RADIO0 = unique(UQ_BLAZE_RADIO),
    RADIO1 = unique(UQ_BLAZE_RADIO),
  };
  
  enum {
    S_IDLE,
    S_TESTALREADYON,
    S_TESTALREADYOFF,
    S_TESTALREADYTURNINGON,
    S_TESTALREADYTURNINGOFF,
    S_TESTOTHERRADIOFOCUSED,
    S_TESTSENDTODISABLEDRADIO,
    S_TESTONOFF,
    S_TEARDOWN,
  };

  uint8_t on;
  uint8_t focusedRadio;
  message_t myMsg;
  uint8_t subControlRadio;
  
  
  /****************** Prototypes ****************/
  task void startRadio();
  task void stopRadio();
  
  /****************** TestControl Events ****************/
  event void SetUp.run() {
    focusedRadio = RADIO0;
    on = 0;
    call SetUp.done();
  }
  
  event void TearDown.run() {
    call State.forceState(S_TEARDOWN);
    if(call SplitControl.stop[focusedRadio]() != SUCCESS) {
      call State.toIdle();
      call TearDown.done();
    }
  }
  
  /****************** Tests ****************/
  event void TestAlreadyOn.run() {
    call State.forceState(S_TESTALREADYON);
    assertFalse("Radio already on", call SplitControlManager.isOn[focusedRadio]());
    assertEquals("Wrong number of test radios", 2, uniqueCount(UQ_BLAZE_RADIO));
    
    if(call SplitControl.start[focusedRadio]() != SUCCESS) {
      assertFail("start() failed");
      call TestAlreadyOn.done();
    }
    
    assertEquals("Trying to turn off while starting", EBUSY, call SplitControl.stop[focusedRadio]());
    
  }
  
  event void TestAlreadyOff.run() {
    call State.forceState(S_TESTALREADYOFF);
    assertFalse("Radio already on", call SplitControlManager.isOn[focusedRadio]());
    
    assertEquals("stop() didn't return EALREADY", EALREADY, call SplitControl.stop[focusedRadio]());
    call TestAlreadyOff.done();
  }
  
  event void TestAlreadyTurningOn.run() {
    error_t error;
    call State.forceState(S_TESTALREADYTURNINGON);
    assertFalse("Radio already on", call SplitControlManager.isOn[focusedRadio]());
    

    if((error = call SplitControl.start[focusedRadio]()) != SUCCESS) {
      assertEquals("1st start", SUCCESS, error);
      call TestAlreadyTurningOn.done();
    }
    
    if((error = call SplitControl.start[focusedRadio]()) != SUCCESS) {
      assertEquals("2nd start", SUCCESS, error);
      call TestAlreadyTurningOn.done();
    }
    
  }
  
  event void TestAlreadyTurningOff.run() {
    call State.forceState(S_TESTALREADYTURNINGOFF);
    assertFalse("Radio already on", call SplitControlManager.isOn[focusedRadio]());
    
    if(call SplitControl.start[focusedRadio]() != SUCCESS) {
      assertFail("start() failed");
      call TestAlreadyTurningOff.done();
    }
  }
  
  
  event void TestOtherRadioFocused.run() {
    call State.forceState(S_TESTOTHERRADIOFOCUSED);
    assertFalse("Radio already on", call SplitControlManager.isOn[focusedRadio]());
    
    if(call SplitControl.start[focusedRadio]() != SUCCESS) {
      assertFail("start() failed");
      call TestOtherRadioFocused.done();
    }
  }
  
  event void TestSendToDisabledRadio.run() {
    call State.forceState(S_TESTSENDTODISABLEDRADIO);
    assertFalse("Radio already on", call SplitControlManager.isOn[focusedRadio]());
    
    assertEquals("Send to off radio", EOFF, call Send.send[focusedRadio](&myMsg, 0));
    if(call SplitControl.start[focusedRadio]() != SUCCESS) {
      assertFail("start() failed");
      call TestSendToDisabledRadio.done();
    }

  }
  
  event void TestOnOff.run() {
    call State.forceState(S_TESTONOFF);
    assertEquals("start() failed", SUCCESS, call SplitControl.start[RADIO0]());
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone[radio_id_t radioId](error_t error) {
    error_t myError;
    call Leds.led2On();
    on++;
    
    
    switch(call State.getState()) {
     
    case S_TESTALREADYON:
      assertEquals("startDone([error])", SUCCESS, error);      
      assertEquals("restart() wasn't EALREADY", EALREADY, call SplitControl.start[focusedRadio]());
      assertTrue("isOn() error", call SplitControlManager.isOn[RADIO0]());
      assertFalse("RADIO1 is on", call SplitControlManager.isOn[RADIO1]());
      call TestAlreadyOn.done();
      break;
    
    case S_TESTALREADYTURNINGON:
      assertEquals("Turned on more than once", 1, on);
      call TestAlreadyTurningOn.done();
      break;
    
    case S_TESTALREADYTURNINGOFF:
      if((myError = call SplitControl.stop[focusedRadio]()) != SUCCESS) {
        assertEquals("1st off", SUCCESS, myError);
        call TestAlreadyTurningOff.done();
      }
      
      if((myError = call SplitControl.stop[focusedRadio]()) != SUCCESS) {
        assertEquals("2nd off", SUCCESS, myError);
      }
      
      assertEquals("Trying to turn on while stopping", EBUSY, call SplitControl.start[focusedRadio]());
      break;
      
    case S_TESTOTHERRADIOFOCUSED:
      assertEquals("Other radio start", FAIL, call SplitControl.start[RADIO1]());
      assertEquals("Other radio stop", EALREADY, call SplitControl.stop[RADIO1]());
      call TestOtherRadioFocused.done();
      break;
      
    case S_TESTSENDTODISABLEDRADIO:
      assertEquals("Sending to active radio", SUCCESS, call Send.send[focusedRadio](&myMsg, 0));
      call TestSendToDisabledRadio.done();
      break;
      
    case S_TESTONOFF:
      assertEquals("stop() error", SUCCESS, call SplitControl.stop[focusedRadio]());
      break;
      
    default:
    }
  }
  
  event void SplitControl.stopDone[radio_id_t radioId](error_t error) {
    call Leds.led2Off();
    on--;
    
    switch(call State.getState()) {
    case S_TEARDOWN:
      call State.toIdle();
      call TearDown.done();
      break;
    
    case S_TESTALREADYTURNINGOFF:
      assertEquals("ON != 0", 0, on);
      call TestAlreadyTurningOff.done();
      break;
      
    case S_TESTONOFF:
      assertSuccess();
      call TestOnOff.done();
      break;
      
    default:
    }
  }
  
  /***************** Send Events ***************/
  event void Send.sendDone[radio_id_t radioId](message_t *msg, error_t error) {
  }
  
  /***************** SplitControlManager Events ****************/
  event void SplitControlManager.stateChange[radio_id_t radioId]() {
  }
  
  /***************** SubControl Commands ****************/
  command error_t SubControl.start[radio_id_t radioId]() {
    subControlRadio = radioId;
    post startRadio();
    return SUCCESS;
  }
  
  command error_t SubControl.stop[radio_id_t radioId]() {
    subControlRadio = radioId;
    post stopRadio();
    return SUCCESS;
  }
  
  /***************** SubSend Commands ***************/
  command error_t SubSend.send[radio_id_t radioId](message_t* msg, uint8_t len) {
    signal SubSend.sendDone[radioId](msg, SUCCESS);
    return SUCCESS;
  }

  command error_t SubSend.cancel[radio_id_t radioId](message_t* msg) {
    signal SubSend.sendDone[radioId](msg, ECANCEL);
    return SUCCESS;
  }

  command uint8_t SubSend.maxPayloadLength[radio_id_t radioId]() {
    return 0;
  }

  command void* SubSend.getPayload[radio_id_t radioId](message_t* msg, uint8_t len) {
    return NULL;
  }
  
  
  /***************** Tasks ****************/
  task void startRadio() {
    signal SubControl.startDone[subControlRadio](SUCCESS);
  }
  
  task void stopRadio() {
    signal SubControl.stopDone[subControlRadio](SUCCESS);
  }
  
  
  /***************** Defaults ***************/
 
}

