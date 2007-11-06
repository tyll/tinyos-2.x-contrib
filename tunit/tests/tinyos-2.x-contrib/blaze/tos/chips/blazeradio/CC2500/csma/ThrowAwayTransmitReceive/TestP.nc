
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
    
    interface Boot;
    
    interface Timer<TMilli>;
    interface Send;
    interface SplitControl;
    interface BlazePacketBody;
    interface Receive;
    interface ActiveMessageAddress;
    interface Leds;
  }
}

implementation {


  message_t myMsg;

  norace uint32_t timesSent;
  
  bool receivedPacket;
  
  my_payload_t *myPayload;
  
  
  enum {
    // Not including the length byte:
    MY_PACKET_LENGTH = MAC_HEADER_SIZE + sizeof(my_payload_t),
    
    MY_PAYLOAD_LENGTH = sizeof(my_payload_t),
  };
  
  /***************** Functions ****************/
  task void send() {
    error_t error;
        
    if(call Send.send(&myMsg, MY_PACKET_LENGTH) != SUCCESS) {
      call Leds.led0Toggle();
      call Leds.led1Off();
      post send();
    }
  }
  
  
  /***************** TestControl ****************/
  event void SetUpOneTime.run() {
    call SetUpOneTime.done();
  }
  
  event void Boot.booted() {
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
    (call BlazePacketBody.getHeader(&myMsg))->dest = 1;
    (call BlazePacketBody.getHeader(&myMsg))->fcf = IEEE154_TYPE_DATA;
    (call BlazePacketBody.getHeader(&myMsg))->dsn = 0x55;
    (call BlazePacketBody.getHeader(&myMsg))->destpan = 0xCC;    
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
    call TearDownOneTime.done();
  }
  
    
  /***************** SplitControl Events ****************/
  event void SplitControl.startDone(error_t error) {
    // call SetUpOneTime.done(); 
    
    if(call ActiveMessageAddress.amAddress() == 0) {
      post send();
      //call Timer.startPeriodic(512);
    }
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
    // the receiver quits after 900 receives, which it better do.
    
  }
  
  event void Timer.fired() {
    post send();
  }
 
  /***************** Send Events ****************/
  event void Send.sendDone(message_t* msg, error_t error) {
    timesSent++;
    call Leds.led1Toggle();
    call Leds.led0Off();
    post send();  
  }
  
  
  /***************** Receive Events ****************/
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
    timesSent++;
    return msg;
  }
  
  async event void ActiveMessageAddress.changed() {
  }
 
}

