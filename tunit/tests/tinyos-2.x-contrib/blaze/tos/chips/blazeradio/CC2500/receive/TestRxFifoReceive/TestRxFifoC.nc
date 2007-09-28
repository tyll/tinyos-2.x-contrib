
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
      new TestCaseC() as TestReceiveTooSmallC;
      
  components TestRxFifoP,
      CC2500ControlC,
      BlazePacketC,
      new StateC(),
      LedsC,
      new TimerMilliC(),
      BlazeReceiveC;
      
  TestRxFifoP.SetUp -> TestReceiveHeaderPacketC.SetUp;
      
  TestRxFifoP.TestReceiveHeaderPacket -> TestReceiveHeaderPacketC;
  TestRxFifoP.TestReceiveLargePacket -> TestReceiveLargePacketC;
  TestRxFifoP.TestBadPacket -> TestBadPacketC;
  TestRxFifoP.TestReceiveTwoPackets -> TestReceiveTwoPacketsC;
  TestRxFifoP.TestReceiveTooSmall -> TestReceiveTooSmallC;
  
  TestRxFifoP.Receive -> BlazeReceiveC.Receive;
  TestRxFifoP.BlazePacketBody -> BlazePacketC;
  TestRxFifoP.State -> StateC;
  TestRxFifoP.Leds -> LedsC;
  TestRxFifoP.Timer -> TimerMilliC;
  
}
