
#include "TestCase.h"

/**
 * @author David Moss
 */

module TestCsmaP {
  provides {
    interface AsyncSend[ radio_id_t id ];
    interface Resource;
  }
  
  uses {
    interface Send[radio_id_t radioId];
    interface Csma[am_id_t amId];
    
    interface State;
    interface BlazePacketBody;
    
    interface TestControl as SetUp;
    
    interface TestCase as TestCcaRequest;
    interface TestCase as TestNoCcaNoCongestion;
    interface TestCase as TestNoCcaWithCongestion;
    interface TestCase as TestInitialRequest;
    interface TestCase as TestSingleCongestion;
    interface TestCase as TestMultipleCongestion;
    interface TestCase as TestCancel;
  }
    
}

implementation {

  /**
   * Test States
   */
  enum {
    S_IDLE,
    S_TESTCCAREQUEST,
    S_TESTNOCCANOCONGESTION,
    S_TESTNOCCAWITHCONGESTION,
    S_TESTINITIALREQUEST,
    S_TESTSINGLECONGESTION,
    S_TESTMULTIPLECONGESTION,
    S_TESTCANCEL,
  };

  enum {
    MY_RADIO_ID = 5,
  };

  /***************** Local Test Variables ****************/ 
  norace message_t myMsg;
  
  /***************** AsyncSend Interface Variables ****************/
  norace uint8_t asyncSendAttempts;
  norace uint8_t asyncSendRadioId;
  norace void *asyncSendMsg;
  norace bool asyncSendLoaded;
  
  /***************** CSMA Interface Variables ****************/ 
  norace uint8_t csmaInitialBackoffRequests;
  norace uint8_t csmaCongestionBackoffRequests;
  norace uint8_t csmaCcaRequests;
  
  /***************** Resource Interface Variables ****************/
  norace bool resourceOwned = FALSE;
  
  
  
  /***************** SetUp Events ****************/
  event void SetUp.run() {
    resourceOwned = FALSE;
    asyncSendLoaded = FALSE;
    asyncSendMsg = NULL;
    asyncSendAttempts = 0;
    asyncSendRadioId = 0;
    
    csmaInitialBackoffRequests = 0;
    csmaCongestionBackoffRequests = 0;
    csmaCcaRequests = 0;
    
    (call BlazePacketBody.getHeader(&myMsg))->type = 0xAA;
    
    call State.toIdle();
    call SetUp.done();
  }




  /***************** TestCases ****************/
  /**
   * Send a message, verify the requestCca event gets executed.
   * Wait for the sendDone event, the test passes after requests are checked
   */
  event void TestCcaRequest.run() {
    call State.forceState(S_TESTCCAREQUEST);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
  
  /**
   * Send a message.  On the CCA request, call back with a FALSE to tell
   * CSMA to send this message without using CCA.  Let the message
   * send ok, and on sendDone the test passes after request #'s are checked
   */
  event void TestNoCcaNoCongestion.run() { 
    call State.forceState(S_TESTNOCCANOCONGESTION);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
  
  /**
   * Send a message. On the CCA request, call back FALSE so we don't use
   * CCA. Hardware CCA is still enabled, so show the Tx couldn't succeed
   * because the channel is busy.  CSMA should never do initial or congestion
   * backoffs, and we should get a sendDone event as soon as AsyncSend 
   * succeeds.
   */
  event void TestNoCcaWithCongestion.run() {
    call State.forceState(S_TESTNOCCAWITHCONGESTION);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
  
  /**
   * Send a message, don't handle the requestCca event.  In the 
   * requestInitialBackoff event, call back with a 0 initial backoff. We should
   * tap into Alarm to make sure the value passed in is not 0, but it's a lot
   * to add into this test right now.  Maybe we can access the variable inside
   * CSMA directly to make sure it isn't 0.
   * 
   * Send the message the first time, verify requests at the end of sendDone
   */
  event void TestInitialRequest.run() {
    call State.forceState(S_TESTINITIALREQUEST);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
  
  event void TestSingleCongestion.run() {
    call State.forceState(S_TESTSINGLECONGESTION);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
  
  event void TestMultipleCongestion.run() {
    call State.forceState(S_TESTMULTIPLECONGESTION);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
  
  /**
   * Load and attempt to send the packet. The packet will never be sent,
   * always returning EBUSY. On the congestion backoff request, cancel
   * the send.  Assert that we get a sendDone(ECANCEL) event.
   */
  event void TestCancel.run() {
    call State.forceState(S_TESTCANCEL);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
  
  /***************** Send Events ****************/
  event void Send.sendDone[radio_id_t id](message_t *msg, error_t error) {
    atomic asyncSendLoaded = FALSE;
    
    if(id != MY_RADIO_ID) {
      assertEquals("Incorrect sendDone[ID]", MY_RADIO_ID, id);
    }
    
    if(msg != &myMsg) {
      assertFail("sendDone msg!=&myMsg");
    }
    
        
    switch(call State.getState()) {
      case S_TESTCCAREQUEST:
        assertEquals("Incorrect CCA requests", 1, csmaCcaRequests);
        assertEquals("Incorrect initial backoffs", 1, csmaInitialBackoffRequests);
        assertEquals("Incorrect congestion backoffs", 0, csmaCongestionBackoffRequests);
        assertEquals("sendDone(ERROR)", SUCCESS, error);
        call TestCcaRequest.done();
        break;
        
      case S_TESTNOCCANOCONGESTION:
        assertEquals("Incorrect CCA requests", 1, csmaCcaRequests);
        assertEquals("Incorrect initial backoffs", 0, csmaInitialBackoffRequests);
        assertEquals("Incorrect congestion backoffs", 0, csmaCongestionBackoffRequests);
        assertEquals("sendDone(ERROR)", SUCCESS, error);
        call TestNoCcaNoCongestion.done();
        break;
        
      case S_TESTNOCCAWITHCONGESTION:
        assertEquals("Incorrect CCA requests", 1, csmaCcaRequests);
        assertEquals("Incorrect initial backoffs", 0, csmaInitialBackoffRequests);
        assertEquals("Incorrect congestion backoffs", 0, csmaCongestionBackoffRequests);
        assertEquals("sendDone(ERROR)", SUCCESS, error);        
        call TestNoCcaWithCongestion.done();
        break;
        
      case S_TESTINITIALREQUEST:
        // TODO can we access the global variable inside of CsmaP here
        // to verify its value?
        //assertEquals("CsmaP incorrect initial backoff", 1, CsmaP$myInitialBackoff);
        assertEquals("Incorrect CCA requests", 1, csmaCcaRequests);
        assertEquals("Incorrect initial backoffs", 1, csmaInitialBackoffRequests);
        assertEquals("Incorrect congestion backoffs", 0, csmaCongestionBackoffRequests);
        assertEquals("sendDone(ERROR)", SUCCESS, error);        
        call TestInitialRequest.done();
        break;
        
      case S_TESTSINGLECONGESTION:
        assertEquals("Incorrect CCA requests", 1, csmaCcaRequests);
        assertEquals("Incorrect initial backoffs", 1, csmaInitialBackoffRequests);
        assertEquals("Incorrect congestion backoffs", 1, csmaCongestionBackoffRequests);
        assertEquals("sendDone(ERROR)", SUCCESS, error);
        call TestSingleCongestion.done();
        break;
        
      case S_TESTMULTIPLECONGESTION:
        assertEquals("Incorrect CCA requests", 1, csmaCcaRequests);
        assertEquals("Incorrect initial backoffs", 1, csmaInitialBackoffRequests);
        assertEquals("Incorrect congestion backoffs", 99, csmaCongestionBackoffRequests);
        assertEquals("sendDone(ERROR)", SUCCESS, error);        
        call TestMultipleCongestion.done();
        break;
        
      case S_TESTCANCEL:
        assertEquals("Incorrect CCA requests", 1, csmaCcaRequests);
        assertEquals("Incorrect initial backoffs", 1, csmaInitialBackoffRequests);
        assertEquals("Incorrect congestion backoffs", 1, csmaCongestionBackoffRequests);
        assertEquals("sendDone(NOT ECANCEL)", ECANCEL, error);
        call TestCancel.done();
        break;
        
        
      default:
        assertFail("Test error: sendDone default");
        break;
    }
  }
  
  
  /***************** Csma Events ****************/
  async event void Csma.requestInitialBackoff[am_id_t amId](message_t *msg) {
    csmaInitialBackoffRequests++;
  
    if(amId != 0xAA) {
      assertEquals("AM type wrong", 0xAA, amId);
    }
    
    if(msg != &myMsg) {
      assertFail("requestCca: Wrong msg ptr");
    }
    
    switch(call State.getState()) {
      case S_TESTNOCCANOCONGESTION:
        assertFail("Shouldn't call initial backoff");
        call TestNoCcaNoCongestion.done();
        break;
        
      case S_TESTNOCCAWITHCONGESTION:
        assertFail("Shouldn't call initial backoff");
        call TestNoCcaNoCongestion.done();
        break;
        
      case S_TESTINITIALREQUEST:
        call Csma.setInitialBackoff[amId](0);
        break;
        
      default:
        break;
    }
  }
  
  async event void Csma.requestCongestionBackoff[am_id_t amId](message_t *msg) {
    csmaCongestionBackoffRequests++;
    
    if(amId != 0xAA) {
      assertEquals("AM type wrong", 0xAA, amId);
    }
    
    if(msg != &myMsg) {
      assertFail("requestCca: Wrong msg ptr");
    }
    
    
    switch(call State.getState()) {
      case S_TESTNOCCANOCONGESTION:
        assertFail("Shouldn't call congestion backoff");
        call TestNoCcaNoCongestion.done();
        break;
        
      case S_TESTNOCCAWITHCONGESTION:
        assertFail("Shouldn't call congestion backoff");
        call TestNoCcaNoCongestion.done();
        break;
        
        
      case S_TESTSINGLECONGESTION:
        call Csma.setCongestionBackoff[amId](0);
        break;
        
      case S_TESTCANCEL:
        assertEquals("cancel(ERROR)", SUCCESS, call Send.cancel[amId](msg));
        // Should continue at sendDone()
        break;
        
      default:
        break;
    }
  }
  
  async event void Csma.requestCca[am_id_t amId](message_t *msg) {
    csmaCcaRequests++;
    
    if(amId != 0xAA) {
      assertEquals("AM type wrong", 0xAA, amId);
    }
    
    if(msg != &myMsg) {
      assertFail("requestCca: Wrong msg ptr");
    }
      
      
    switch(call State.getState()) {
      case S_TESTCCAREQUEST:
        call Csma.setCca[amId](TRUE);
        break;
      
      
      case S_TESTNOCCANOCONGESTION:
        call Csma.setCca[amId](FALSE);
        break;
      
      case S_TESTNOCCAWITHCONGESTION:
        call Csma.setCca[amId](FALSE);
        break;
        
      default:
        break;
    }
  }
  
  /***************** Dummy AsyncSend Implementation ****************/
  async command error_t AsyncSend.send[ radio_id_t id ](void *msg, bool force, uint16_t preambleDurationMs) {
    asyncSendAttempts++;
    
    if(!resourceOwned) {
      assertFail("send failed: resource not owned");
    }
    
    if(id != MY_RADIO_ID) {
      assertEquals("Incorrect send[ID]", MY_RADIO_ID, id);
    }
    
    switch(call State.getState()) {
      case S_TESTNOCCAWITHCONGESTION:
        if(asyncSendAttempts < 100) {
          return EBUSY;
       
        } else {
          signal AsyncSend.sendDone[id](SUCCESS);
          return SUCCESS;
        }
        break;
        
      case S_TESTSINGLECONGESTION:
        if(asyncSendAttempts < 2) {
          return EBUSY;
          
        } else {
          signal AsyncSend.sendDone[id](SUCCESS);
          return SUCCESS;
        }
        break;
        
      case S_TESTMULTIPLECONGESTION:
        if(asyncSendAttempts < 100) {
          return EBUSY;
          
        } else {
          signal AsyncSend.sendDone[id](SUCCESS);
          return SUCCESS;
        }
        break;
        
      case S_TESTCANCEL:
        return EBUSY;
        break;
        
      default:
        signal AsyncSend.sendDone[id](SUCCESS);
        return SUCCESS;
    }
    
    
  }
    
  default async event void AsyncSend.sendDone[radio_id_t id](error_t error) {
    assertFail("Default AsyncSend.sendDone event executed");
  }
  
  
  /***************** Dummy Resource Implementation ****************/

  async command error_t Resource.request() {
    if(resourceOwned) {
      assertFail("Resource.request() called multiple times");
      return FAIL;
    
    } else {
      resourceOwned = TRUE;
      signal Resource.granted();
      return SUCCESS;
    }
    
  }

  async command error_t Resource.immediateRequest() {
    if(resourceOwned) {
      assertFail("Resource.immediateRequest called multiple times");
      return FAIL;
    
    } else {
      resourceOwned = TRUE;
      return SUCCESS;
    }
  }

  async command error_t Resource.release() {
    if(resourceOwned) {
      resourceOwned = FALSE;
      return SUCCESS;
    
    } else {
      return FAIL;
    }
  }

  async command bool Resource.isOwner() {
    return resourceOwned;
  }
  
  /***************** Alarm Interface Implementation ****************
  async command void Alarm.start(uint32_t dt) {
    if(dt == 0) {
      assertFail("Alarm.start(0)");
    }
  }

  async command void Alarm.stop() {
  }

  async event void Alarm.fired() {
  }

  async command bool Alarm.isRunning() {
  }

  async command void Alarm.startAt(uint32_t t0, uint32_t dt) {
  }

  async command size_type Alarm.getNow() {
  }

  async command size_type Alarm.getAlarm() {
  }
  */
}

