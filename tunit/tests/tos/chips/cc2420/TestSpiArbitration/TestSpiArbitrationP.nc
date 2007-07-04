
#include "TestCase.h"

module TestSpiArbitrationP {
  provides {
    interface Resource as PlatformSpiResource;
  }
  
  uses {
    interface TestControl as SetUp;
    interface TestCase as TestSingleAcquire;
    interface TestCase as TestMultiAcquire;
    interface TestCase as TestReleaseAndHold;
    interface TestCase as TestImmediateRequest;
    interface TestCase as TestReleaseAbortAcquire;
    interface TestCase as TestAbortImmediateRequest;
    
    interface Resource as Resource1;
    interface Resource as Resource2;
    interface Resource as Resource3;
    interface Resource as Resource4;
    interface ChipSpiResource;
    
    interface State;
    interface Leds;
  }
    
}

implementation {
  
  norace bool inUse;
  uint8_t platformRequests;
  bool resource4Granted;
  
  enum {
    S_IDLE,
    S_TESTSINGLEACQUIRE,
    S_TESTMULTIACQUIRE,
    S_TESTRELEASEANDHOLD,
    S_TESTIMMEDIATEREQUEST,
    S_TESTRELEASEABORTACQUIRE,
    S_TESTABORTIMMEDIATEREQUEST,
  };
  
  
  /***************** Prototypes ****************/
  task void immediateRequest_finish();
  
  task void releaseAndHold_attemptRelease();
  task void releaseAndHold_finish();
  
  task void releaseAbortAcquire_attemptRelease();
  task void releaseAbortAcquire_finish();
  
  task void abortImmediateRequest_immediateRequest();
  task void abortImmediateRequest_finish();
  
  /***************** SetUp Events ****************/
  event void SetUp.run() {
    call Resource1.release();
    call Resource2.release();
    call Resource3.release();
    call Resource4.release();
    inUse = FALSE;
    resource4Granted = FALSE;
    platformRequests = 0;
    call Leds.set(0);
    call SetUp.done();
  }
  
  /***************** TestSingleAcquire Events ****************/
  /**
   * Acquire the SPI bus, verify we got it.  Try to release the chip.
   * Verify the chip won't release.  Release the resource, verify the
   * chip was released from the platform
   */
  event void TestSingleAcquire.run() {
    call Leds.led0On();
    call State.forceState(S_TESTSINGLEACQUIRE);
    if(call Resource1.request() != SUCCESS) {
      assertFail("Request Failed");
      call State.toIdle();
      call TestSingleAcquire.done();
    }
  }
  
  /**
   * Acquire the SPI bus. Try to acquire a different one immediately, verify
   * that fails.  Try to request a different one, verify it succeeds.
   * Release the first SPI bus and verify the second one gets granted.
   * Verify the PlatformSpiResource only hands out one SPI bus request to the
   * chip.
   */
  event void TestMultiAcquire.run() {
    call State.forceState(S_TESTMULTIACQUIRE);
    if(call Resource1.request() != SUCCESS) {
      assertFail("Request 1 Failed");
      call State.toIdle();
      call TestMultiAcquire.done();
    }
  }
  
  /**
   * Acquire the SPI bus, release it and abort the chip's release.
   * Verify the chip holds onto the SPI bus.  Attempt to release the chip's 
   * SPI bus. Verify it got released.
   */
  event void TestReleaseAndHold.run() {
    call State.forceState(S_TESTRELEASEANDHOLD);
    if(call Resource1.request() != SUCCESS) {
      assertFail("Request 1 Failed");
      call State.toIdle();
      call TestReleaseAndHold.done();
    }
  }
  
  /**
   * Immediately request resource 4.  Verify we got it. Imm.Request another
   * resource, verify we didn't get it.  Post a task to verify 
   * Resource4.granted() was never signaled.
   */
  event void TestImmediateRequest.run() {
    call State.forceState(S_TESTIMMEDIATEREQUEST);
    resource4Granted = FALSE;
    assertEquals("Imm.Req.(3) failed", SUCCESS, call Resource4.immediateRequest());
    assertTrue("Platform SPI not in use", inUse);
    assertNotEquals("Imm.Req.(2) was granted", SUCCESS, call Resource2.immediateRequest());
    post immediateRequest_finish();
  }
  
  /**
   * Acquire the SPI with resource 1.  Release it, abort the chip release.
   * Acquire the SPI with resource 3. Verify we acquired it correctly and
   * that the chip only made one request to the platform SPI.
   */
  event void TestReleaseAbortAcquire.run() {
    call State.forceState(S_TESTRELEASEABORTACQUIRE);
    if(call Resource1.request() != SUCCESS) {
      assertFail("Request 1 Failed");
      call State.toIdle();
      call TestReleaseAbortAcquire.done();
    }
  }
  
  /**
   * Acquire, Release & Abort, immediately request.  No granted() should be
   * signaled for the immediate request at any time.
   */
  event void TestAbortImmediateRequest.run() {
    call State.forceState(S_TESTABORTIMMEDIATEREQUEST);
    resource4Granted = FALSE;
    if(call Resource1.request() != SUCCESS) {
      assertFail("Request 1 Failed");
      call State.toIdle();
      call TestAbortImmediateRequest.done();
    }
  }
  
  
  /***************** ChipSpiResource Events ****************/
  async event void ChipSpiResource.releasing() {
    if(call State.getState() == S_TESTRELEASEANDHOLD) {
      call ChipSpiResource.abortRelease();
      post releaseAndHold_attemptRelease();
    
    } else if(call State.getState() == S_TESTRELEASEABORTACQUIRE) {
      call ChipSpiResource.abortRelease();
      post releaseAbortAcquire_attemptRelease();
    
    } else if(call State.getState() == S_TESTABORTIMMEDIATEREQUEST) {
      call ChipSpiResource.abortRelease();
      post abortImmediateRequest_immediateRequest();
    }
  }
  
  /***************** Resource1 Events ****************/
  event void Resource1.granted() {
    if(call State.getState() == S_TESTSINGLEACQUIRE) {
      call Leds.led2On();
      // attempt release should not release the SPI bus because we have it.
      assertEquals("Wrong # platform rqsts", 1, platformRequests);
      assertNotEquals("Chip shouldn't release bus", SUCCESS, call ChipSpiResource.attemptRelease());
      if(call Resource1.release() != SUCCESS) {
        assertFail("Release failed");
      }
      
      assertFalse("Platform SPI was not released", inUse);
      call State.toIdle();
      call TestSingleAcquire.done();
      
    } else if(call State.getState() == S_TESTMULTIACQUIRE) {
      if(call Resource2.immediateRequest() == SUCCESS) {
        assertFail("ImmReq should have failed");
        call State.toIdle();
        call TestMultiAcquire.done();
        return;
      }
      
      if(call Resource2.request() != SUCCESS) {
        assertFail("Request 2 Failed");
        call State.toIdle();
        call TestMultiAcquire.done();
        return;
      }
      
      if(call Resource1.release() != SUCCESS) {
        assertFail("Resource1 release failed");
        call State.toIdle();
        call TestMultiAcquire.done();
      }
      // Test should continue when Resource2 is granted
      
    } else if(call State.getState() == S_TESTRELEASEANDHOLD) {
       if(call Resource1.release() != SUCCESS) {
         assertFail("Resource1 release failed");
         call State.toIdle();
         call TestReleaseAndHold.done();
       }
       // ChipSpiResource.releasing() is signaled, test continues there.
       
    } else if(call State.getState() == S_TESTRELEASEABORTACQUIRE) {
      if(call Resource1.release() != SUCCESS) {
        assertFail("Resource1 release failed");
        call State.toIdle();
        call TestReleaseAbortAcquire.done();
      }
      // ChipSpiResource.releasing() is signaled, test continues there.
    
    } else if(call State.getState() == S_TESTABORTIMMEDIATEREQUEST) {
      if(call Resource1.release() != SUCCESS) {
        assertFail("Resource1 release failed");
        call State.toIdle();
        call TestAbortImmediateRequest.done();
      }
      // ChipSpiResource.releasing() continues
      
    }
  }
  
  event void Resource2.granted() {
    if(call State.getState() == S_TESTMULTIACQUIRE) {
      assertResultIsBelow("Too many platform requests", 2, platformRequests);
      assertTrue("Platform SPI was released", inUse);
      
      if(call Resource1.isOwner()) {
        assertFail("Resource 2 is owner, not 1");
      }
      
      if(!call Resource2.isOwner()) {
        assertFail("Resource 2 should own, but doesn't");
      }
      
      call Resource2.release();
      call State.toIdle();
      call TestMultiAcquire.done();
    }
  }
  
  event void Resource3.granted() {
    call ChipSpiResource.attemptRelease(); // shouldn't release
    assertTrue("Platform SPI isn't in use", inUse);
    assertResultIsBelow("Too many platform requests", 2, platformRequests);
    call Resource3.release();
    post releaseAbortAcquire_finish();
  }
  
  event void Resource4.granted() {
    resource4Granted = TRUE;
  }
  
  /***************** Tasks ****************/  
  task void immediateRequest_finish() {
    assertFalse("Resource 4 was granted on an imm.req!", resource4Granted);
    call TestImmediateRequest.done();
  }
  
  task void releaseAndHold_attemptRelease() {
    assertTrue("Platform SPI was released", inUse);
    assertResultIsBelow("Too many platform requests", 2, platformRequests);
    call State.toIdle(); // Don't hang on this time..
    call ChipSpiResource.attemptRelease();
    post releaseAndHold_finish();
  }
  
  task void releaseAndHold_finish() {
    assertFalse("Platform SPI wasn't released", inUse);
    assertResultIsBelow("Too many platform requests", 2, platformRequests);
    call State.toIdle();
    call TestReleaseAndHold.done();
  }
  
  
  task void releaseAbortAcquire_attemptRelease() {
    assertTrue("Platform SPI was released", inUse);
    call State.toIdle(); // Don't hang on
    if(call Resource3.request() != SUCCESS) {
      assertFail("Could not request resource 3");
      call TestReleaseAbortAcquire.done();
    } 
  }
  
  task void releaseAbortAcquire_finish() {
    assertFalse("Platform SPI wasn't released", inUse);
    assertResultIsBelow("Too many platform requests", 2, platformRequests);
    call State.toIdle();
    call TestReleaseAbortAcquire.done();
  }
  
  
  task void abortImmediateRequest_immediateRequest() {
    if(call Resource4.immediateRequest() != SUCCESS) {
      assertFail("Imm.Req to 4 failed");
      call TestAbortImmediateRequest.done();
    }
    
    post abortImmediateRequest_finish();
  }
  
  task void abortImmediateRequest_finish() {
    assertFalse("Resource 4 was granted on an imm.req", resource4Granted);
    call TestAbortImmediateRequest.done();
  }
  
  
  /***************** PlatformSpiResource Commands ****************/  
  async command error_t PlatformSpiResource.request() {
    platformRequests++;
    if(inUse) {
      assertFail("REQ: Resource already in use");
      return FAIL;
    }
    
    call Leds.led1On();
    inUse = TRUE;
    signal PlatformSpiResource.granted();
    return SUCCESS;
  }

  async command error_t PlatformSpiResource.immediateRequest() {
    platformRequests++;
    if(inUse) {
      assertFail("IMREQ: Resource already in use");
      return FAIL;
    }
    
    inUse = TRUE;
    return SUCCESS;
  }
   
  async command error_t PlatformSpiResource.release() {
    inUse = FALSE;
    return SUCCESS;
  }

  async command bool PlatformSpiResource.isOwner() {
    if(inUse) {
      return TRUE;
    } else {
      return FALSE;
    }
  }
}

