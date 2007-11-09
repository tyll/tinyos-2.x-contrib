
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
    
    interface Send;
    interface SplitControl;
    interface PacketAcknowledgements;
    interface BlazePacketBody;
    interface Receive;
    interface Leds;
  }
}

implementation {


  message_t myMsg;

  norace uint8_t timesSent;
  
  bool receivedPacket;
  
  my_payload_t *myPayload;
  
  uint8_t totalErrors;
  
  bool sending;
  
  enum {
    // Not including the length byte:
    MY_PACKET_LENGTH = MAC_HEADER_SIZE + sizeof(my_payload_t),
    
    MY_PAYLOAD_LENGTH = sizeof(my_payload_t),
    
    TOO_MANY_ERRORS = 1000,
  };
  
  /***************** Prototypes ****************/
  task void send();
  
  /***************** TestControl ****************/
  event void SetUpOneTime.run() {
    myPayload = (my_payload_t *) (&myMsg.data);
    
    sending = FALSE;
    receivedPacket = FALSE;
    timesSent = 0;
    totalErrors = 0;
    memset(&myMsg, 0, MY_PACKET_LENGTH);
    // Subtract 1 because the length byte isn't counted as part of the packet
    // at Tx or Rx time.  This would be handled in BlazeActiveMessageP
    // as part of the size of the MAC header.
    // In other words, even though MY_PACKET_LENGTH represents the length of
    // the whole packet including the length byte at this level, layers
    // below see things differently.
    
    (call BlazePacketBody.getHeader(&myMsg))->length = MY_PACKET_LENGTH;
    (call BlazePacketBody.getHeader(&myMsg))->dest = AM_BROADCAST_ADDR;
    (call BlazePacketBody.getHeader(&myMsg))->dsn = 0x55;
    (call BlazePacketBody.getHeader(&myMsg))->destpan = 0xCC;
    (call BlazePacketBody.getHeader(&myMsg))->src = 0;
    (call BlazePacketBody.getHeader(&myMsg))->type = 0x33;
  
    call PacketAcknowledgements.requestAck(&myMsg);
    
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
  
    
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    call SetUpOneTime.done(); 
  }
  
  event void SplitControl.stopDone(error_t error) {
    call TearDownOneTime.done();
  }
  
  
  /***************** TestReceive Events ****************/
  /**
   * Only node 0 gets this command.  So we don't need to check addresses on 
   * anything for this test.
   */
  event void TestReceive.run() {
    post send();
  }
 
  /***************** Send Events ****************/
  event void Send.sendDone(message_t* msg, error_t error) {
    sending = FALSE;
    if(!call PacketAcknowledgements.wasAcked(msg)) {
      totalErrors++;
      if(totalErrors > TOO_MANY_ERRORS) {
        assertFail("No ack: too many errors");
        call TestReceive.done();
      
      } else {
        post send(); 
      }
      
    } else {
      timesSent++;
    }
    call Leds.led2Toggle();
  }
  
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.led1Toggle();
    if(timesSent < 2) {
      post send();
    
    } else {
      assertSuccess();
      call TestReceive.done();
    }
    
    return msg;
  }
  
  /***************** Tasks ****************/
  task void send() {
    error_t error;
    if((!sending) && (error = call Send.send(&myMsg, MY_PACKET_LENGTH)) != SUCCESS) {
      totalErrors++;
      if(totalErrors > TOO_MANY_ERRORS) {
        assertFail("Send: Too many errors");
        call TestReceive.done();
      
      } else {
        assertEquals("send(ERROR)", SUCCESS, error);
        post send();
      }
      
    } else {
      sending = TRUE;
    }
  }
}

