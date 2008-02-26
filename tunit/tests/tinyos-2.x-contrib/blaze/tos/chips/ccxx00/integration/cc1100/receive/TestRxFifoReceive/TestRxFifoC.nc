
/**
 * Make sure the RXFIFO.readDone() part of receive works correctly since it's
 * the most complex part of the receive branch
 * @author David Moss
 */
 
configuration TestRxFifoC {
}

implementation {
  components new TestCaseC() as TestReceiveHeaderPacketC,
      new TestCaseC() as TestReceiveLargePacketC,
      new TestCaseC() as TestBadPacketC,
      new TestCaseC() as TestReceiveTwoPacketsC,
      new TestCaseC() as TestReceiveTooSmallC,
      new TestCaseC() as TestReceiveAckC;
      
  components TestRxFifoP,
      CC1100ControlC,
      BlazePacketC,
      new StateC(),
      LedsC,
      new TimerMilliC(),
      ActiveMessageAddressC,
      BlazeReceiveC;
      
  TestRxFifoP.SetUp -> TestReceiveHeaderPacketC.SetUp;
      
  TestRxFifoP.TestReceiveHeaderPacket -> TestReceiveHeaderPacketC;
  TestRxFifoP.TestReceiveLargePacket -> TestReceiveLargePacketC;
  TestRxFifoP.TestBadPacket -> TestBadPacketC;
  TestRxFifoP.TestReceiveTwoPackets -> TestReceiveTwoPacketsC;
  TestRxFifoP.TestReceiveTooSmall -> TestReceiveTooSmallC;
  TestRxFifoP.TestReceiveAck -> TestReceiveAckC;
  TestRxFifoP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  TestRxFifoP.Receive -> BlazeReceiveC.Receive;
  TestRxFifoP.AckReceive -> BlazeReceiveC;
  TestRxFifoP.BlazePacketBody -> BlazePacketC;
  TestRxFifoP.State -> StateC;
  TestRxFifoP.Leds -> LedsC;
  TestRxFifoP.Timer -> TimerMilliC;
  
}
