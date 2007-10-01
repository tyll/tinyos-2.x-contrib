
configuration TestC {
}

implementation {
  components new TestCaseC() as TestAmC;
  
  components BlazeC,
      new AMSenderC(0),
      new AMReceiverC(0),
      TestP;
   
  TestP.TestAm -> TestAmC;
  
  TestP.SplitControl -> BlazeC;
  TestP.AMSend -> AMSenderC;
  TestP.Receive -> AMReceiverC;
  
}

