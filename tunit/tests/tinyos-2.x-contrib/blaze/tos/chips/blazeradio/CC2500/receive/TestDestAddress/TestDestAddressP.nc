
/**
 * Receive a message with the low byte = 1, and the high byte incorrect.
 * This will pass the hardware address check but should fail the software
 * address check.
 * 
 * @author David Moss
 */
 
module TestDestAddressP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestCase as TestWrongAddress;
    interface TestControl as TearDownOneTime;
    
    interface SplitControl;
    interface AMPacket;
    interface AMSend;
    interface Receive;
    interface Receive as Snoop;
    interface Leds;
  }
}

implementation {

  message_t myMsg;
  
  /***************** TestControl ****************/
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
  event void TestWrongAddress.run() {
    error_t error;
    if((error = call AMSend.send(0xFF01, &myMsg, 0)) != SUCCESS) {
      assertEquals("Send error", SUCCESS, error);
      call TestWrongAddress.done();
    }
  }
  
  event void AMSend.sendDone(message_t *msg, error_t error) {
    call Leds.led1On();
    // Test completes at the secondary node in the test in the receive event.
  }
  
  /***************** Receive events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.led0On();
    assertEquals("Wrong destination", 0xFF01, call AMPacket.destination(msg));
    assertEquals("Wrong source", 0x0, call AMPacket.source(msg));
    assertFail("Receive interface: SW address check failed");
    call TestWrongAddress.done();
    return msg;
  }
  
  event message_t *Snoop.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.led1On();
    assertEquals("Wrong destination", 0xFF01, call AMPacket.destination(msg));
    assertEquals("Wrong source", 0x0, call AMPacket.source(msg));
    call TestWrongAddress.done(); 
    return msg;
  }
  
  
}

