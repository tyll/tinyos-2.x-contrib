
#include "TestCase.h"
#include "AM.h"
#include "message.h"

/**
 * Test one basic case of cancel.  This doesn't cover all the cases, but 
 * does cover Mischa Weise's bug discovery.
 * @author David Moss
 */
 
module TestCancelP {
  provides {
    interface GeneralIO as CcaProvider;
  }
  
  uses {
    interface TestControl as SetUpOneTime;
    interface TestControl as TearDownOneTime;
    
    interface TestCase as TestCancelAtCongestionBackoff;
    
    interface LowPowerListening;
    interface SplitControl;
    interface AMSend;
    interface CC2420PacketBody;
    interface RadioBackoff;
  }
}

implementation {

  message_t myMsg;
  
  /***************** Test Control ****************/
  event void SetUpOneTime.run() {
    call SplitControl.start();
  }
  
  event void TearDownOneTime.run() {
    call SplitControl.stop();
  }
  
  event void SplitControl.startDone(error_t error) {
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TearDownOneTime.done();
  }
  
  /***************** Tests ****************/
  event void TestCancelAtCongestionBackoff.run() {
    call LowPowerListening.setRxSleepInterval(&myMsg, 10240);
    call AMSend.send(0, &myMsg, 20);
    // Execution continues at requestCongestionBackoff
  }
  
  
  /***************** RadioBackoff Events ****************/
  async event void RadioBackoff.requestInitialBackoff(message_t *msg) {
  }

  /** 
   * Do this to make the call synchronous like it asks
   */
  task void cancel() {
    assertEquals("Cancel ERROR", SUCCESS, call AMSend.cancel(&myMsg));
  }
  
  async event void RadioBackoff.requestCongestionBackoff(message_t *msg) {
    post cancel();
    call RadioBackoff.setCongestionBackoff(1024);
    // Execution continues at sendDone
  }

  async event void RadioBackoff.requestCca(message_t *msg) {
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone( message_t* p_msg, error_t error ) {
    assertEquals("sendDone wasn't ECANCEL", ECANCEL, error);
    if(p_msg != &myMsg) {
      assertFail("sendDone(*msg) != &myMsg");
    }
    
    call TestCancelAtCongestionBackoff.done();
  }
  
  
  /***************** CcaProvider Commands ****************/
  /**
   * Our line is always low, i.e. there's always a transmitter nearby
   */
  async command void CcaProvider.set() {
  }
  
  async command void CcaProvider.clr() {
  }
  
  async command void CcaProvider.toggle() {
  }
  
  async command bool CcaProvider.get() {
    return FALSE;
  }
  
  async command void CcaProvider.makeInput() {
  }
  
  async command bool CcaProvider.isInput() {
    return TRUE;
  }
  
  async command void CcaProvider.makeOutput() {
  }
  
  async command bool CcaProvider.isOutput() {
    return FALSE;
  }
}

