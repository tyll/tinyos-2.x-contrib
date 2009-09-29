
/**
 * @author David Moss
 */
 
#include "TestCase.h"
#include "Blaze.h"

module BroadcastP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestControl as TearDownOneTime;
    
    interface TestCase as TestBroadcast;
    
    interface SplitControl;
    interface AMSend;
    interface Receive;
    interface AMPacket;
    interface PacketAcknowledgements;
    interface BlazePacketBody;
    interface Leds;
  }
}

implementation {

  message_t myMsg;
  
  /***************** TestControl *****************/
  event void SetUpOneTime.run() {
    call SplitControl.start();
  }
  
  event void TearDownOneTime.run() {
    call SplitControl.stop();
  }
 
  event void SplitControl.startDone(error_t error) { 
    call Leds.led3On();
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call Leds.led3Off();
    call TearDownOneTime.done();
  }
  
  /***************** Tests *****************/
  event void TestBroadcast.run() {
    error_t error;
    
    call PacketAcknowledgements.requestAck(&myMsg);
    if((error = call AMSend.send(AM_BROADCAST_ADDR, &myMsg, 0)) != SUCCESS) {
      assertEquals("send error", SUCCESS, error);
      call TestBroadcast.done();
    }
  }
  
  event void AMSend.sendDone(message_t *msg, error_t error) {
    if(call PacketAcknowledgements.wasAcked(&myMsg)) {
      assertFail("Bcast packet was ack'd");
    }
  }
  
  event message_t *Receive.receive(message_t *msg, void *payload, error_t error) {
    assertEquals("Wrong dest addr", AM_BROADCAST_ADDR, (call BlazePacketBody.getHeader(msg))->dest);
    call TestBroadcast.done();
    return msg;
  }
  
}

