

configuration TestPacketCrcC {
}

implementation {

  components new TestCaseC() as TestAppendCrcC,
      new TestCaseC() as TestVerifyCrcC,
      new TestCaseC() as TestVerifyBadCrcC;
      
  components TestPacketCrcP,
      PacketCrcC,
      CrcC,
      BlazePacketC;
  
  TestPacketCrcP.SetUp -> TestAppendCrcC.SetUp;
  
  TestPacketCrcP.TestAppendCrc -> TestAppendCrcC;
  TestPacketCrcP.TestVerifyCrc -> TestVerifyCrcC;
  TestPacketCrcP.TestVerifyBadCrc -> TestVerifyBadCrcC;
      
  TestPacketCrcP.Crc -> CrcC;
  TestPacketCrcP.BlazePacketBody -> BlazePacketC;
  TestPacketCrcP.PacketCrc -> PacketCrcC;
  
  
}

