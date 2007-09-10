
configuration TestC {
}

implementation {
  components new TestCaseC() as TestAmC;
  
  components ActiveMessageC,
      new AMSenderC(0),
      new AMReceiverC(0),
      TestP;
   
  TestP.TestAm -> TestAmC;
  
  TestP.SplitControl -> ActiveMessageC;
  TestP.AMSend -> AMSenderC;
  TestP.Receive -> AMReceiverC;
  
}

