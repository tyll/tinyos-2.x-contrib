

module TestPacketCrcP {
  uses {
    interface TestControl as SetUp;
    
    interface TestCase as TestAppendCrc;
    interface TestCase as TestVerifyCrc;
    interface TestCase as TestVerifyBadCrc;
    
    interface PacketCrc;
    interface BlazePacketBody;
    interface Crc;
  }
}

implementation {

  message_t myMsg;
  
  enum {
    MY_PAYLOAD_LENGTH = 0,

    // Not including the length byte:
    MY_PACKET_LENGTH = MAC_HEADER_SIZE + MY_PAYLOAD_LENGTH,
  };
  
  /***************** SetUp ****************/
  event void SetUp.run() {
    memset(&myMsg, 0x0, sizeof(message_t));
    (call BlazePacketBody.getHeader(&myMsg))->length = MY_PACKET_LENGTH;
    call SetUp.done();
  }
  
  /***************** Tests ****************/
  event void TestAppendCrc.run() {
    uint16_t packetCrc;
    uint8_t *message = (uint8_t *) &myMsg;
    uint16_t myCalculatedCrc;
    
    call PacketCrc.appendCrc((uint8_t *) &myMsg);
    
    // Add 1 because the length byte isn't included in MY_PACKET_LENGTH
    myCalculatedCrc = call Crc.crc16(&myMsg, MY_PACKET_LENGTH + 1);
    
    assertEquals("Length wasn't increased", MY_PACKET_LENGTH + 2, (call BlazePacketBody.getHeader(&myMsg))->length);
    
    packetCrc = *(message + MY_PACKET_LENGTH + 1) << 8;
    packetCrc |= *(message + MY_PACKET_LENGTH + 2);
    
    assertEquals("Wrong CRC", myCalculatedCrc, packetCrc);
    
    call TestAppendCrc.done();
  }
  
  event void TestVerifyCrc.run() {
    call PacketCrc.appendCrc((uint8_t *) &myMsg);
    assertEquals("Length wasn't increased", MY_PACKET_LENGTH + 2, (call BlazePacketBody.getHeader(&myMsg))->length);
    assertTrue("Verification failed", call PacketCrc.verifyCrc((uint8_t *) &myMsg));
    assertEquals("Length wasn't decreased", MY_PACKET_LENGTH, (call BlazePacketBody.getHeader(&myMsg))->length);
    call TestVerifyCrc.done();
  }
  
  event void TestVerifyBadCrc.run() {
    uint8_t *message = (uint8_t *) &myMsg;
    call PacketCrc.appendCrc((uint8_t *) &myMsg);
    // A bit flipped!
    message[2] = 0x4;
    
    assertEquals("Length wasn't increased", MY_PACKET_LENGTH + 2, (call BlazePacketBody.getHeader(&myMsg))->length);
        
    assertFalse("Bad verification passed", call PacketCrc.verifyCrc((uint8_t *) &myMsg));
    assertEquals("Length wasn't decreased", MY_PACKET_LENGTH, (call BlazePacketBody.getHeader(&myMsg))->length);
    
    call TestVerifyBadCrc.done();
  }
}

