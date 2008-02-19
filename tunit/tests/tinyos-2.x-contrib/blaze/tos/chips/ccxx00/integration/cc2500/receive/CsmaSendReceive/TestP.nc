
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
  
  bool transmitter;
  
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
    transmitter = FALSE;
    timesSent = 0;
    memset(&myMsg, 0, MY_PACKET_LENGTH);
    // Subtract 1 because the length byte isn't counted as part of the packet
    // at Tx or Rx time.  This would be handled in BlazeActiveMessageP
    // as part of the size of the MAC header.
    // In other words, even though MY_PACKET_LENGTH represents the length of
    // the whole packet including the length byte at this level, layers
    // below see things differently.
    
    (call BlazePacketBody.getHeader(&myMsg))->length = MY_PACKET_LENGTH;
    (call BlazePacketBody.getHeader(&myMsg))->dest = 1;
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
    error_t error;

    transmitter = TRUE;
    error = call Send.send(&myMsg, MY_PACKET_LENGTH);
    
    if(error) {
      assertEquals("Error calling Send.send()", SUCCESS, error);
      call TestReceive.done();
    }
  }
 
  /***************** Send Events ****************/
  event void Send.sendDone(message_t* msg, error_t error) {
    assertEquals("sendDone(ERROR)", SUCCESS, error);
    call Leds.led2On();
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    call Leds.led1On();
    
    //if(transmitter) {
    //  assertFail("Tx node rx'd pkt");
    //  return msg;
    //}
    
    if(!receivedPacket) {
      // This is the first packet we received
      receivedPacket = TRUE;
      myPayload = (my_payload_t *) msg->data;

      if(msg->data != payload) {
        assertFail("Wrong payload pointer");
      }
        
      assertEquals("Wrong length", MY_PACKET_LENGTH, len);
      assertEquals("Wrong dest", 1, (call BlazePacketBody.getHeader(msg))->dest);
      assertEquals("Wrong fcf", IEEE154_TYPE_DATA, (call BlazePacketBody.getHeader(msg))->fcf);
      assertEquals("Wrong dsn", 0x55, (call BlazePacketBody.getHeader(msg))->dsn);
      assertEquals("Wrong destpan", TOS_AM_GROUP, (call BlazePacketBody.getHeader(msg))->destpan);
      assertEquals("Wrong src", 0, (call BlazePacketBody.getHeader(msg))->src);
      assertEquals("Wrong type", 0x33, (call BlazePacketBody.getHeader(msg))->type);
      
      assertEquals("Payload byte A", 0xAA, myPayload->a);
      assertEquals("Payload byte B", 0xBB, myPayload->b);
      assertEquals("Payload byte C", 0xCC, myPayload->c);
      assertEquals("Payload byte D", 0xDD, myPayload->d);
      assertEquals("Payload byte E", 0xEE, myPayload->e);
      assertEquals("Payload byte F", 0xFF, myPayload->f);
      assertEquals("Payload byte G", 0xAA, myPayload->g);
      assertEquals("Payload byte H", 0xBB, myPayload->h);
      assertEquals("Payload byte I", 0xCC, myPayload->i);
      
      call TestReceive.done();
   
    } else {
      assertFail("Received 2 pkts!");
    }
    
    return msg;
  }
 
}

