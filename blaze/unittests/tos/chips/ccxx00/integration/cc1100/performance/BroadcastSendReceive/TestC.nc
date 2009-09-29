
configuration TestC {
}

implementation {
  components new TestCaseC() as TestAmC;
  
  components ActiveMessageC,
      new AMSenderC(4),
      new AMReceiverC(4),
      LedsC,
      TestP;
   
  TestP.SetUpOneTime -> TestAmC.SetUpOneTime;
  TestP.TearDownOneTime -> TestAmC.TearDownOneTime;
  TestP.TestAm -> TestAmC;
  
  TestP.SplitControl -> ActiveMessageC;
  TestP.AMSend -> AMSenderC;
  TestP.PacketAcknowledgements -> ActiveMessageC;
  TestP.Receive -> AMReceiverC;
  TestP.Leds -> LedsC;
  
}

