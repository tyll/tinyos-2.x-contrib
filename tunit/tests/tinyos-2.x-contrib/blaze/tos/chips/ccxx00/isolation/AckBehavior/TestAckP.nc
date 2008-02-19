
#include "TestCase.h"
#include "IEEE802154.h"


/**
 * @author David Moss
 */

module TestAckP {
  provides {
    interface Send as SubSend[ radio_id_t radioId ];
    interface ChipSpiResource;
    interface AckReceive;
  }
  
  uses {
    interface Send[radio_id_t radioId];
    
    interface PacketAcknowledgements;
    
    interface State;
    interface BlazePacketBody;
    
    interface TestControl as SetUp;
    
    interface TestCase as TestPacketAcknowledgements;
    interface TestCase as TestNoAck;
    interface TestCase as TestAckWithResponse;
    interface TestCase as TestAckNoResponse;
    interface TestCase as TestAckWrongDsn;
    interface TestCase as TestAckWrongSource;
    interface TestCase as TestAckWrongDest;
    interface TestCase as TestAckBroadcastDest;
    interface Leds;
  }
    
}

implementation {

  /**
   * Test States
   */
  enum {
    S_IDLE,
    S_TESTPACKETACKNOWLEDGEMENTS,
    S_TESTNOACK,
    S_TESTACKWITHRESPONSE,
    S_TESTACKNORESPONSE,
    S_TESTACKWRONGDSN,
    S_TESTACKWRONGSOURCE,
    S_TESTACKWRONGDEST,
    S_TESTACKBROADCASTDEST,
  };

  enum {
    MY_RADIO_ID = 15,
    MY_SOURCE = 100,
    MY_DEST = 200,
    MY_DSN = 0x55,
  };
  
  /***************** Local Test Variables ****************/ 
  norace message_t myMsg;
  
  /***************** Send Variables ****************/
  norace uint8_t sendRadioId;
  norace message_t *sendMsg;
  norace uint8_t sendLen;
  
  /***************** AckReceive Variables ****************/
  norace uint16_t ackSrc;
  norace uint16_t ackDest;
  norace uint8_t ackDsn;
  
  /***************** ChipSpiResource Variables ****************/
  norace bool spiResourceHeld;
  norace uint8_t chipSpiResourceAborts;
  norace uint8_t chipSpiResourceReleases;
  
  /***************** Prototypes ****************/
  task void pretendSend();
  task void receiveAck();
  
  /***************** SetUp Events ****************/
  event void SetUp.run() {
    call Leds.set(0);
    
    spiResourceHeld = FALSE;
    chipSpiResourceAborts = 0;
    chipSpiResourceReleases = 0;
    
    ackSrc = 0;
    ackDest = 0;
    ackDsn = 0;
    
    sendRadioId = 0;
    sendMsg = NULL;
    sendLen = 0;
    
    (call BlazePacketBody.getHeader(&myMsg))->type = 0xAA;
    (call BlazePacketBody.getHeader(&myMsg))->src = MY_SOURCE;
    (call BlazePacketBody.getHeader(&myMsg))->dest = MY_DEST;
    (call BlazePacketBody.getHeader(&myMsg))->dsn = MY_DSN;
    
    (call BlazePacketBody.getMetadata(&myMsg))->ack = FALSE;
    
    call PacketAcknowledgements.noAck(&myMsg);
    
    call State.toIdle();
    call SetUp.done();
  }




  /***************** TestCases ****************/
  /**
   * Make sure the PacketAcknowledgements interface is accessing, clearing,
   * setting the right bits and bytes in the packet
   */
  event void TestPacketAcknowledgements.run() {
    call State.forceState(S_TESTPACKETACKNOWLEDGEMENTS);
    
    call PacketAcknowledgements.requestAck(&myMsg);
    assertEquals("Didn't set ack bit", 1, ((call BlazePacketBody.getHeader(&myMsg))->fcf >> IEEE154_FCF_ACK_REQ) & 0x1);
    
    call PacketAcknowledgements.noAck(&myMsg);
    assertEquals("Didn't clr ack bit", 0, ((call BlazePacketBody.getHeader(&myMsg))->fcf >> IEEE154_FCF_ACK_REQ) & 0x1);
    
    assertFalse("Says acked when it wasn't", call PacketAcknowledgements.wasAcked(&myMsg));
    
    (call BlazePacketBody.getMetadata(&myMsg))->ack = TRUE;
    assertTrue("Says wasn't acked when it was", call PacketAcknowledgements.wasAcked(&myMsg));

    call TestPacketAcknowledgements.done();
  }
  
  
  /**
   * Send a packet requesting NO acknowledgements, but had an acknowledgement
   * last time the packet was sent.  We shouldn't abort the SPI bus release, 
   * so the SPI bus should be released.  After send is successful, we verify
   * things in sendDone, making sure we didn't get an ack this time.
   */
  event void TestNoAck.run() {
    call State.forceState(S_TESTNOACK);
    call PacketAcknowledgements.noAck(&myMsg);
    
    // Pretend like we got an ack on the last send:
    (call BlazePacketBody.getMetadata(&myMsg))->ack = TRUE;
    
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
 
  /**
   * Request acknowledgements on the packet. Send it.  We should get an
   * abort.  After the SPI abort and after signaling CSMA's sendDone, we 
   * magically get an AckReceive with the right values.  
   * Verify the results in the local sendDone event.
   */
  event void TestAckWithResponse.run() {
    call State.forceState(S_TESTACKWITHRESPONSE);
    call PacketAcknowledgements.requestAck(&myMsg);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
 
  event void TestAckNoResponse.run() {
    call State.forceState(S_TESTACKNORESPONSE);
    call PacketAcknowledgements.requestAck(&myMsg);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
 
  event void TestAckWrongDsn.run() {
    call State.forceState(S_TESTACKWRONGDSN);
    call PacketAcknowledgements.requestAck(&myMsg);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
 
  event void TestAckWrongSource.run() {
    call State.forceState(S_TESTACKWRONGSOURCE);
    call PacketAcknowledgements.requestAck(&myMsg);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
 
  event void TestAckWrongDest.run() {
    call State.forceState(S_TESTACKWRONGDEST);
    call PacketAcknowledgements.requestAck(&myMsg);
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
  
  event void TestAckBroadcastDest.run() {
    call State.forceState(S_TESTACKBROADCASTDEST);
    call PacketAcknowledgements.requestAck(&myMsg);
    (call BlazePacketBody.getHeader(&myMsg))->dest = AM_BROADCAST_ADDR;
    assertEquals("Send.send() failed", SUCCESS, call Send.send[MY_RADIO_ID](&myMsg, 20));
  }
  
 
  /***************** Send Events ****************/
  event void Send.sendDone[radio_id_t id](message_t *msg, error_t error) {
    if(msg != &myMsg) {
      assertFail("sendDone: msg!=&myMsg");
    }
    
    if(error != SUCCESS) {
      assertEquals("sendDone(ERROR)", SUCCESS, error);
    }
    
    if(id != MY_RADIO_ID) {
      assertEquals("sendDone[WRONG ID]", MY_RADIO_ID, id);
    }
    
    if((((call BlazePacketBody.getHeader(&myMsg))->fcf >> IEEE154_FCF_FRAME_TYPE) & 0x7)
        != IEEE154_TYPE_DATA) {
      assertFail("Didn't set FCF data frame type");
    }
    
    switch(call State.getState()) {
      case S_TESTNOACK:
        assertEquals("Incorrect SPI aborts", 0, chipSpiResourceAborts);
        assertEquals("Incorrect SPI releases", 0, chipSpiResourceReleases);
        assertFalse("Shouldn't have gotten ack'd", call PacketAcknowledgements.wasAcked(&myMsg));
        call TestNoAck.done();
        break;
        
      case S_TESTACKWITHRESPONSE:
        assertEquals("Incorrect SPI aborts", 1, chipSpiResourceAborts);
        assertEquals("Incorrect SPI releases", 1, chipSpiResourceReleases);
        assertTrue("Should have gotten ack'd", call PacketAcknowledgements.wasAcked(&myMsg));
        call TestAckWithResponse.done();
        break;
        
      case S_TESTACKNORESPONSE:
        assertEquals("Incorrect SPI aborts", 1, chipSpiResourceAborts);
        assertEquals("Incorrect SPI releases", 1, chipSpiResourceReleases);
        assertFalse("Shouldn't have gotten ack'd", call PacketAcknowledgements.wasAcked(&myMsg));
        call TestAckNoResponse.done();
        break;
        
      case S_TESTACKWRONGDSN:
        assertEquals("Incorrect SPI aborts", 1, chipSpiResourceAborts);
        assertEquals("Incorrect SPI releases", 1, chipSpiResourceReleases);
        assertFalse("Shouldn't have gotten ack'd", call PacketAcknowledgements.wasAcked(&myMsg));
        call TestAckWrongDsn.done();
        break;
        
      case S_TESTACKWRONGSOURCE:
        assertEquals("Incorrect SPI aborts", 1, chipSpiResourceAborts);
        assertEquals("Incorrect SPI releases", 1, chipSpiResourceReleases);
        assertFalse("Shouldn't have gotten ack'd", call PacketAcknowledgements.wasAcked(&myMsg));
        call TestAckWrongSource.done();
        break;
        
      case S_TESTACKWRONGDEST:
        assertEquals("Incorrect SPI aborts", 1, chipSpiResourceAborts);
        assertEquals("Incorrect SPI releases", 1, chipSpiResourceReleases);
        assertFalse("Shouldn't have gotten ack'd", call PacketAcknowledgements.wasAcked(&myMsg));
        call TestAckWrongDest.done();
        break;
        
      case S_TESTACKBROADCASTDEST:
        assertEquals("Incorrect SPI aborts", 1, chipSpiResourceAborts);
        assertEquals("Incorrect SPI releases", 1, chipSpiResourceReleases);
        assertTrue("Should have gotten ack'd", call PacketAcknowledgements.wasAcked(&myMsg));
        call TestAckBroadcastDest.done();
        break;      
      
      default:
        assertFail("Test Error: sendDone.default called");
        break;
      
    }
  }
  
  
  
  /***************** SubSend Interface Implementation ****************/
  command error_t SubSend.send[radio_id_t id](message_t* msg, uint8_t len) {
    spiResourceHeld = TRUE;
    // Pretend we're sending the packet here.
    sendRadioId = id;
    sendMsg = msg;
    sendLen = len;
    
    if(msg != &myMsg) {
      assertFail("SubSend.send(WRONG MSG)");
    }
    
    if(id != MY_RADIO_ID) {
      assertFail("SubSend.send[WRONG RADIO ID]");
    }
    
    post pretendSend();
    return SUCCESS;
  }

  command error_t SubSend.cancel[radio_id_t id](message_t* msg) {
    return FAIL;
  }

  command uint8_t SubSend.maxPayloadLength[radio_id_t id]() {
    return 0;
  }

  command void* SubSend.getPayload[radio_id_t id](message_t* msg, uint8_t len) {
    return NULL;
  }
  
  
  /***************** ChipSpiResource Interface Implementation ****************/
  async command void ChipSpiResource.abortRelease() {
    chipSpiResourceAborts++;
  }

  async command error_t ChipSpiResource.attemptRelease() {
    chipSpiResourceReleases++;
    spiResourceHeld = FALSE;
    return SUCCESS;
  }
  
  
  /***************** Tasks *****************/
  task void pretendSend() {
    // Ok, we sent the packet.  Now send is done and CSMA will release its
    // SPI bus.  This causes BlazeSpi to signal out a ChipSpiResource request
    signal ChipSpiResource.releasing();
    
    if(!call State.isState(S_TESTNOACK)) {
      // Every test except for TestNoAck should abort the release.
      if(chipSpiResourceAborts < 1) {
        assertFail("Should have aborted SPI release");
      }
    
    } else {
      if(chipSpiResourceAborts > 0) {
        assertFail("NoAck shouldn't abort SPI release");
      }
    }
    
    if(chipSpiResourceAborts == 0) {
      spiResourceHeld = FALSE;
    }
    
    switch(call State.getState()) {
      case S_TESTACKWITHRESPONSE:
        signal SubSend.sendDone[sendRadioId](sendMsg, SUCCESS);
        ackSrc = MY_DEST;
        ackDest = MY_SOURCE;
        ackDsn = MY_DSN;
        post receiveAck();
        break;
    
      case S_TESTACKWRONGDSN:
        signal SubSend.sendDone[sendRadioId](sendMsg, SUCCESS);
        ackSrc = MY_DEST;
        ackDest = MY_SOURCE;
        ackDsn = MY_DSN - 1;
        post receiveAck();
        break;
        
     case S_TESTACKWRONGSOURCE:
        signal SubSend.sendDone[sendRadioId](sendMsg, SUCCESS);
        ackSrc = MY_DEST - 1;
        ackDest = MY_SOURCE;
        ackDsn = MY_DSN;
        post receiveAck();
        break;
        
     case S_TESTACKWRONGDEST:
        signal SubSend.sendDone[sendRadioId](sendMsg, SUCCESS);
        ackSrc = MY_DEST;
        ackDest = MY_SOURCE - 1;
        ackDsn = MY_DSN;
        post receiveAck();
        break;
        
      case S_TESTACKBROADCASTDEST:
        signal SubSend.sendDone[sendRadioId](sendMsg, SUCCESS);
        ackSrc = MY_DEST;
        ackDest = MY_SOURCE;
        ackDsn = MY_DSN;
        post receiveAck();
        break;
        
      default:
        signal SubSend.sendDone[sendRadioId](sendMsg, SUCCESS);
        break;
    }
    
  }
  
  /**
   * Preconfigure the ackSrc, ackDest, and ackDsn depending on the type of test
   */
  task void receiveAck() {
    signal AckReceive.receive(ackSrc, ackDest, ackDsn);
  }
  
}

