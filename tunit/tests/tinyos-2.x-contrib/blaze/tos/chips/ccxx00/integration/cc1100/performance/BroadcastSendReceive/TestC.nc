
configuration TestC {
}

implementation {
  components new TestCaseC() as TestAmC;
  
  components BlazeC,
      new AMSenderC(4),
      new AMReceiverC(4),
      LedsC,
      TestP;
   
  TestP.SetUpOneTime -> TestAmC.SetUpOneTime;
  TestP.TearDownOneTime -> TestAmC.TearDownOneTime;
  TestP.TestAm -> TestAmC;
  
  TestP.SplitControl -> BlazeC;
  TestP.AMSend -> AMSenderC;
  TestP.PacketAcknowledgements -> BlazeC;
  TestP.Receive -> AMReceiverC;
  TestP.Leds -> LedsC;
  
}

