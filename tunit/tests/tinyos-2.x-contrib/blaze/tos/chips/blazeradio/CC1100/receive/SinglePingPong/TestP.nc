
#include "TestCase.h"
#include "Blaze.h"
#include "message.h"
#include "IEEE802154.h"

#include "Test.h"



/**
 * @author David Moss
 */
module TestP {
  uses {
    interface TestControl as SetUpOneTime;
    interface TestControl as TearDownOneTime;
    
    interface TestCase as TestReceive;
    
    interface Resource;
    interface SplitControl;
    interface BlazePacketBody;
    interface AsyncSend;
    interface Receive;
    interface ReceiveController;
    interface ActiveMessageAddress;
    interface Leds;
  }
}

implementation {


  message_t myMsg;

  norace uint8_t timesSent;
  
  bool receivedPacket;
  
  my_payload_t *myPayload;
  
  
  enum {
    // Not including the length byte:
    MY_PACKET_LENGTH = MAC_HEADER_SIZE + sizeof(my_payload_t),
    
    MY_PAYLOAD_LENGTH = sizeof(my_payload_t),
  };
  
  /***************** Functions ****************/

  /***************** TestControl ****************/
  event void SetUpOneTime.run() {
    myPayload = (my_payload_t *) (&myMsg.data);
  
    receivedPacket = FALSE;
    timesSent = 0;
    memset(&myMsg, 0, MY_PACKET_LENGTH);
    // Subtract 1 because the length byte isn't counted as part of the packet
    // at Tx or Rx time.  This would be handled in BlazeActiveMessageP
    // as part of the size of the MAC header.
    // In other words, even though MY_PACKET_LENGTH represents the length of
    // the whole packet including the length byte at this level, layers
    // below see things differently.
    
    (call BlazePacketBody.getHeader(&myMsg))->length = MY_PACKET_LENGTH;
    
    (call BlazePacketBody.getHeader(&myMsg))->dest = AM_BROADCAST_ADDR;
    
    (call BlazePacketBody.getHeader(&myMsg))->fcf = IEEE154_TYPE_DATA;
    (call BlazePacketBody.getHeader(&myMsg))->dsn = 0x55;
    (call BlazePacketBody.getHeader(&myMsg))->destpan = TOS_AM_GROUP;    
    (call BlazePacketBody.getHeader(&myMsg))->src = 0;
    (call BlazePacketBody.getHeader(&myMsg))->type = 0x33;
    
    myPayload->a = 0xAA;
    myPayload->b = 0xBB;
    myPayload->c = 0xCC;
    myPayload->d = 0xDD;
    myPayload->e = 0xEE;
    myPayload->f = 0xFF;
    myPayload->g = 0xAA;
    myPayload->h = 0xBB;
    myPayload->i = 0xCC;
    
    call SplitControl.start();
  }
  
  event void TearDownOneTime.run() {
    call SplitControl.stop();
  }
  
  
  /***************** Resource Events ****************/
  event void Resource.granted() {
  }
  
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    call SetUpOneTime.done();
  }
  
  event void SplitControl.stopDone(error_t error) {
    call Resource.release();
    call TearDownOneTime.done();
  }
  
  
  /***************** TestReceive Events ****************/
  /**
   * Only node 0 gets this command.  So we don't need to check addresses on 
   * anything for this test.
   */
  event void TestReceive.run() {
    error_t error;

    call Resource.immediateRequest();
    
    error = call AsyncSend.load(&myMsg, 0);
    
    assertEquals("AsyncSend.load() error", SUCCESS, error);
    
    if(error) {  
      call TestReceive.done();
    }
  }
 
  /***************** AsyncSend Events ****************/
  async event void AsyncSend.loadDone(error_t error) {
    assertEquals("send(ERROR)", SUCCESS, call AsyncSend.send());
  }
  
  async event void AsyncSend.sendDone(error_t error) {
    //call Leds.led2On();
    call Resource.release();
    // The receiver must stop the test by receiving one of those or we timeout
  }
  
  
  /***************** Receive Events ****************

  /***************** ReceiveController Events ****************/
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    error_t error;
    //call Leds.led1Toggle();
    
    if(call ActiveMessageAddress.amAddress() == 1) {
    
      call Resource.immediateRequest();
    
      error = call AsyncSend.load(&myMsg, 0);
      assertEquals("node 1 load error", SUCCESS, error);
      
    } else {
      assertSuccess();
      call TestReceive.done();
    }
    return msg;
  }
  
  async event void ActiveMessageAddress.changed() {
  }
 
}

