
#include "Blaze.h"
#include "TestCase.h"
#include "IEEE802154.h"

/**
 * Checks:
 * > RSSI and LQI set correctly
 * > Large packets have no issues
 * > Ack's get sent correctly
 * > Bad packets are filtered out
 * > Two packets get received if they're received simultaneously
 * > Packets that are only a few bytes long get filtered out
 * 
 * @author David Moss
 */
 
module TestRxFifoP {
  provides {
    interface GpioInterrupt as RxInterrupt[radio_id_t id];
    interface GeneralIO as RxIo[ radio_id_t id ];    
    interface BlazeFifo as RXFIFO;
    interface AsyncSend as AckSend[radio_id_t id];
    interface BlazeRegister as RXREG;
  }
  
  uses {
    interface Receive[radio_id_t id];
    interface AckReceive;
    interface BlazePacketBody;
    interface ActiveMessageAddress;
    interface State;
    interface GpioInterrupt as TheRealRxInterruptThatWeIgnore[radio_id_t id];
    interface GeneralIO as TheRealRxIoThatWeIgnore[ radio_id_t id ];    
    interface Leds;
    interface Timer<TMilli>;
        
    interface TestControl as SetUp;
    
    interface TestCase as TestReceiveHeaderPacket;
    interface TestCase as TestReceiveLargePacket;
    interface TestCase as TestBadPacket;
    interface TestCase as TestReceiveTwoPackets;
    interface TestCase as TestReceiveTooSmall;
    interface TestCase as TestReceiveAck;
  }
  
}

implementation {

  enum {
    S_IDLE,
    S_TESTRECEIVEHEADERPACKET,
    S_TESTRECEIVELARGEPACKET,
    S_TESTBADPACKET,
    S_TESTRECEIVETWOPACKETS,
    S_TESTRECEIVETOOSMALL,
    S_TESTRECEIVEACK,
  };
  
  /** Message to load into the RX FIFO */
  norace message_t myMsg;

  /** Ack to load into the RX FIFO */
  norace blaze_ack_t myAck;
  
  /** Header of our message */
  norace blaze_header_t *myHeader;
  
  
    
  /** Our radio RX FIFO */
  norace uint8_t rxFifo[64];
  
  /** Where we're reading from in the RX FIFO */
  norace uint8_t *rxFifoReadPointer;
  
  /** Where our test is writing to in the RX FIFO */
  norace uint8_t *rxFifoWritePointer;
  
  norace bool ackSent;
  
  norace uint8_t totalPacketsReceived;
  
  norace bool packetReceived;
  
  /** Used for the RXFIFO.readDone task only */
  norace uint8_t *rxFifoData;
  
  /** Used for the RXFIFO.readDone task only */
  norace uint8_t rxFifoLength;
  
  /** Used when we receive two packets */
  norace bool rxIo;
  
  
  struct statusBytes {
    uint8_t rssi;
    uint8_t lqi;
  } statusBytes;
  
  /***************** Prototypes ****************/
  void read(uint8_t *data, uint8_t length);
  void append(void *data, uint8_t length);
  task void readDone();
  
  
  /***************** TestControl ****************/
  /**
   * Clear out and reset the FIFO and states before each test
   */
  event void SetUp.run() {
    memset(&rxFifo, 0x0, 64);
    memset(&myMsg, 0x0, sizeof(message_t));
    rxFifoReadPointer = rxFifo;
    rxFifoWritePointer = rxFifo;
    myHeader = call BlazePacketBody.getHeader(&myMsg);
    call State.toIdle();
    
    rxIo = FALSE;
    packetReceived = FALSE;
    ackSent = FALSE;
    totalPacketsReceived = 0;
    
    statusBytes.rssi = 0xAA;
    statusBytes.lqi = 0xBB;
    
    call SetUp.done();
  }
  
  
  /***************** Test Cases ****************/
  /**
   * Create a header for a packet in our message.  Tack on the CRC. Write
   * it into the RX FIFO.  Write the status bytes into the RX FIFO.  Verify
   * we receive the packet correctly in the receive event and an ack
   * was generated. Check the RSSI and LQI, which we were never able to test 
   * before this (and it turned out the test proved it was broken!).
   */
  event void TestReceiveHeaderPacket.run() {
    uint8_t bytesAvailable;
    call State.forceState(S_TESTRECEIVEHEADERPACKET);
    
    // Subtract 1 because the length byte isn't counted
    myHeader->length = sizeof(blaze_header_t) - 1;
    myHeader->dest = 0;
    myHeader->fcf = (IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (1 << IEEE154_FCF_ACK_REQ);
    myHeader->dsn = 1;
    myHeader->destpan = call ActiveMessageAddress.amGroup();
    myHeader->src = 3;
    myHeader->type = 4;
    
    append(&myMsg, myHeader->length + 1);
    append(&statusBytes, 2);
    
    // Check this internal function one time for the whole test suite so we
    // know our test works...
    call RXREG.read(&bytesAvailable);
    // Add two for the status bytes
    assertEquals("RXREG test setup error", sizeof(blaze_header_t) + 2, bytesAvailable);
    
    
    signal RxInterrupt.fired[0]();
    // Ack should be sent
    // Continue at Received...
  }
  
  /**
   * The largest packet should be received with no problems and also
   * send an ack.  We're transmitting to the broadcast address, make
   * sure the ack works for broadcasts.
   */
  event void TestReceiveLargePacket.run() {
    call State.forceState(S_TESTRECEIVELARGEPACKET);
    // Subtract 1 because the length byte isn't counted
    myHeader->length = sizeof(blaze_header_t) + TOSH_DATA_LENGTH - 1;
    myHeader->dest = AM_BROADCAST_ADDR;
    myHeader->fcf = (IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (1 << IEEE154_FCF_ACK_REQ);
    myHeader->dsn = 1;
    myHeader->destpan = call ActiveMessageAddress.amGroup();
    myHeader->src = 3;
    myHeader->type = 4;
    
    append(&myMsg, myHeader->length + 1);
    append(&statusBytes, 2);
    signal RxInterrupt.fired[0]();
    // Ack should be sent
    // Continue at Received...
  }
  
  /**
   * Receive a large corrupted packet, one randomly chosen bit incorrect.
   */
  event void TestBadPacket.run() {
    call State.forceState(S_TESTBADPACKET);
    
    myHeader->length = sizeof(blaze_header_t) + TOSH_DATA_LENGTH - 1;
    myHeader->dest = 0;
    myHeader->fcf = (IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (1 << IEEE154_FCF_ACK_REQ);
    myHeader->dsn = 1;
    myHeader->destpan = call ActiveMessageAddress.amGroup();
    myHeader->src = 3;
    myHeader->type = 4;
    statusBytes.lqi = 0x0;
    
    append(&myMsg, myHeader->length + 1);
    append(&statusBytes, 2);
    
    signal RxInterrupt.fired[0]();
    call Timer.startOneShot(256);
    // Since we won't receive this packet, continue at Timer.fired and make
    // sure !packetReceived
  }
  
  event void TestReceiveTwoPackets.run() {
    call State.forceState(S_TESTRECEIVETWOPACKETS);
    
    myHeader->length = sizeof(blaze_header_t) - 1;
    myHeader->dest = 0;
    myHeader->fcf = (IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (1 << IEEE154_FCF_ACK_REQ);
    myHeader->dsn = 1;
    myHeader->destpan = call ActiveMessageAddress.amGroup();
    myHeader->src = 3;
    myHeader->type = 4;
    
    // Received a packet once...
    append(&myMsg, myHeader->length + 1);
    append(&statusBytes, 2);
    
    // Received a packet twice...
    append(&myMsg, myHeader->length + 1);
    append(&statusBytes, 2);

    rxIo = TRUE;
    
    // We magically received two packets instantaneously
    signal RxInterrupt.fired[0]();
  }
  
  event void TestReceiveTooSmall.run() {
    call State.forceState(S_TESTRECEIVETOOSMALL);
    
    myHeader->length = sizeof(blaze_header_t) - 2;  // this length is too small but the ack is ok
    myHeader->dest = 0;
    myHeader->fcf = (IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (1 << IEEE154_FCF_ACK_REQ);
    myHeader->dsn = 1;
    myHeader->destpan = call ActiveMessageAddress.amGroup();
    myHeader->src = 3;
    myHeader->type = 4;
    
    // Received a packet once...
    append(&myMsg, myHeader->length + 1);
    append(&statusBytes, 2);
    
    signal RxInterrupt.fired[0]();
    call Timer.startOneShot(256);
    // should continue at Timer.fired() because we don't receive a packet
  }
  
  event void TestReceiveAck.run() {
    call State.forceState(S_TESTRECEIVEACK);
    
    myAck.length = ACK_FRAME_LENGTH;
    myAck.dest = 0;
    myAck.fcf = (IEEE154_TYPE_ACK << IEEE154_FCF_FRAME_TYPE);
    myAck.dsn = TOS_AM_GROUP;
    myAck.src = 100;
    
    append(&myAck, sizeof(blaze_ack_t));
    append(&statusBytes, 2);
    
    assertSuccess();
    signal RxInterrupt.fired[0]();
    // Continues at AckReceive...
  }
  

  async event void ActiveMessageAddress.changed() {
  }
  
  /***************** RXFIFO commands ****************/
  async command blaze_status_t RXFIFO.beginRead( uint8_t* data, uint8_t length ) {
    read(data, length);
    return 0;
  }

  async command error_t RXFIFO.continueRead( uint8_t* data, uint8_t length ) {
    read(data, length);
    return SUCCESS;
  }

  async command blaze_status_t RXFIFO.write( uint8_t* data, uint8_t length ) {
    return 0;
  }
  
  /***************** AckSend Commands ****************/
  async command error_t AckSend.send[radio_id_t id](void *msg, bool force, uint16_t preambleDurationMs) {
    ackSent = TRUE;
    signal AckSend.sendDone[id](SUCCESS);
    return SUCCESS;
  }
    
  default async event void AckSend.sendDone[radio_id_t id](error_t error) {
    assertEquals("Bad sendDone connection []", 0, id);
  }
  
  
  /***************** RxInterrupt Commands ****************/
  async command error_t RxInterrupt.enableRisingEdge[radio_id_t id]() {
    return SUCCESS;
  }
  
  async command error_t RxInterrupt.enableFallingEdge[radio_id_t id]() {
    return SUCCESS;
  }
  
  async command error_t RxInterrupt.disable[radio_id_t id]() {
    return SUCCESS;
  }
  
  default async event void RxInterrupt.fired[radio_id_t id]() {
    assertEquals("Bad rx fired connection []", 0, id);
  }
 
  /***************** RxIo Commands ****************/
  async command void RxIo.set[ radio_id_t id ]() {}
  async command void RxIo.clr[ radio_id_t id ]() {}
  async command void RxIo.toggle[ radio_id_t id ]() {}
  async command bool RxIo.get[ radio_id_t id ]() {
    // Only trigger this once if rxIo is TRUE - which would only be the case
    // for the TESTRECEIVETWOPACKETS test.
    if(rxIo) {
      rxIo = FALSE;
      return TRUE;
    }
    
    return rxIo;
  }
  
  async command void RxIo.makeInput[ radio_id_t id ]() {}
  async command bool RxIo.isInput[ radio_id_t id ]() {
    return TRUE;
  }
  
  async command void RxIo.makeOutput[ radio_id_t id ]() {}
  async command bool RxIo.isOutput[ radio_id_t id ]() {
    return FALSE;
  }
   
  /***************** TheRealRxInterruptThatWeIgnore Events ****************/
  async event void TheRealRxInterruptThatWeIgnore.fired[radio_id_t id]() {
    // Ignored!
  }
  
  /***************** Receive Events ****************/
  event message_t *Receive.receive[radio_id_t id](message_t *msg, void *payload, uint8_t len) {
    packetReceived = TRUE;
    totalPacketsReceived++;
    
    switch (call State.getState()) {
    case S_TESTRECEIVEHEADERPACKET:
      assertEquals("Wrong length", sizeof(blaze_header_t) - 1, len);
      assertEquals("Wrong dest", 0, (call BlazePacketBody.getHeader(msg))->dest);
      assertEquals("Wrong fcf", (IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (1 << IEEE154_FCF_ACK_REQ), (call BlazePacketBody.getHeader(msg))->fcf);
      assertEquals("Wrong dsn", 1, (call BlazePacketBody.getHeader(msg))->dsn);
      assertEquals("Wrong destpan", call ActiveMessageAddress.amGroup(), (call BlazePacketBody.getHeader(msg))->destpan);
      assertEquals("Wrong src", 3, (call BlazePacketBody.getHeader(msg))->src);
      assertEquals("Wrong type", 4, (call BlazePacketBody.getHeader(msg))->type);
      assertEquals("Wrong RSSI", 0xAA, (call BlazePacketBody.getMetadata(msg))->rssi);
      assertEquals("Wrong LQI", 0x3B, (call BlazePacketBody.getMetadata(msg))->lqi);
      assertTrue("No ack issued", ackSent);
      call TestReceiveHeaderPacket.done();
      break;
    
    case S_TESTRECEIVELARGEPACKET:
      assertEquals("Wrong length", sizeof(blaze_header_t) + TOSH_DATA_LENGTH - 1, len);
      assertEquals("Wrong dest", AM_BROADCAST_ADDR, (call BlazePacketBody.getHeader(msg))->dest);
      assertEquals("Wrong fcf", (IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (1 << IEEE154_FCF_ACK_REQ), (call BlazePacketBody.getHeader(msg))->fcf);
      assertEquals("Wrong dsn", 1, (call BlazePacketBody.getHeader(msg))->dsn);
      assertEquals("Wrong destpan", call ActiveMessageAddress.amGroup(), (call BlazePacketBody.getHeader(msg))->destpan);
      assertEquals("Wrong src", 3, (call BlazePacketBody.getHeader(msg))->src);
      assertEquals("Wrong type", 4, (call BlazePacketBody.getHeader(msg))->type);
      assertEquals("Wrong RSSI", 0xAA, (call BlazePacketBody.getMetadata(msg))->rssi);
      assertEquals("Wrong LQI", 0x3B, (call BlazePacketBody.getMetadata(msg))->lqi);
      assertTrue("No ack issued", ackSent);
      call TestReceiveLargePacket.done();
      break;
      
    case S_TESTRECEIVETWOPACKETS:
      assertEquals("Wrong length", sizeof(blaze_header_t) - 1, len);
      assertEquals("Wrong dest", 0, (call BlazePacketBody.getHeader(msg))->dest);
      assertEquals("Wrong fcf", (IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (1 << IEEE154_FCF_ACK_REQ), (call BlazePacketBody.getHeader(msg))->fcf);
      assertEquals("Wrong dsn", 1, (call BlazePacketBody.getHeader(msg))->dsn);
      assertEquals("Wrong destpan", call ActiveMessageAddress.amGroup(), (call BlazePacketBody.getHeader(msg))->destpan);
      assertEquals("Wrong src", 3, (call BlazePacketBody.getHeader(msg))->src);
      assertEquals("Wrong type", 4, (call BlazePacketBody.getHeader(msg))->type);
      assertEquals("Wrong RSSI", 0xAA, (call BlazePacketBody.getMetadata(msg))->rssi);
      assertEquals("Wrong LQI", 0x3B, (call BlazePacketBody.getMetadata(msg))->lqi);
      assertTrue("No ack issued", ackSent);
      if(totalPacketsReceived == 2) {
        call TestReceiveTwoPackets.done();
      }
      break;
      
      
    default:
      break;
    }
    
    return msg;
  } 
  
  async event void AckReceive.receive( am_addr_t source, am_addr_t destination, uint8_t dsn ) {
    assertSuccess();
    if(call State.isState(S_TESTRECEIVEACK)) {
      assertEquals("Wrong ack src", 100, source);
      assertEquals("Wrong ack dest", 0, destination);
      assertEquals("Wrong ack dsn", TOS_AM_GROUP, dsn);
      call TestReceiveAck.done();
    }
  }
  
  /***************** RXREG Commands ***************/
  async command blaze_status_t RXREG.read(uint8_t* data) {
    if(call State.isState(S_TESTBADPACKET)) {
      // The RX FIFO was flushed due to CRC_AUTOFLUSH in this test case
      *data = 0;
      
    } else {
      *data = rxFifoWritePointer - rxFifoReadPointer;
    }
    
    return BLAZE_S_RX;
  }

  async command blaze_status_t RXREG.write(uint8_t data) {
    return BLAZE_S_RX;
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    switch (call State.getState()) {
      case S_TESTBADPACKET:
        call Leds.set(4);
        assertFalse("Bad packet ack sent", ackSent);
        assertFalse("Bad packet received", packetReceived);
        call TestBadPacket.done();
        break;
        
      case S_TESTRECEIVETOOSMALL:
        assertFalse("Ack sent incorrectly", ackSent);
        assertFalse("Small packet received", packetReceived);
        call TestReceiveTooSmall.done();
        break;
        
      default:
    }
  }
  
  /***************** Functions ****************/
  
  void read(uint8_t *data, uint8_t length) {
    memcpy(data, rxFifoReadPointer, length);
    rxFifoReadPointer += length;
    
    if(rxFifoReadPointer > rxFifoWritePointer) {
      // You read more bytes than were available for reading
      assertFail("RXFIFO Underflow!");
    }
    
    rxFifoData = data;
    rxFifoLength = length;
    post readDone();
    
  }
  
  void append(void *data, uint8_t length) {
    memcpy(rxFifoWritePointer, data, length);
    rxFifoWritePointer += length;
  }
  
  task void readDone() {
    signal RXFIFO.readDone(rxFifoData, rxFifoLength, SUCCESS);
  }
}


