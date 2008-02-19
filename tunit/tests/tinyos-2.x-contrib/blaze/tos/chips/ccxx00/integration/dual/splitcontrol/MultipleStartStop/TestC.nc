
configuration TestC {
}

implementation {
  components new TestCaseC() as TestSplitControlStartStopC;
  
  components ActiveMessageC,
      BlazeC,
      new AMSenderC(0),
      new AMReceiverC(0),
      LedsC,
      TestP;
   
  TestP.MultiStartStop -> TestSplitControlStartStopC;
  
  TestP.SplitControl -> BlazeC;
  TestP.AMSend -> AMSenderC;
  TestP.Receive -> AMReceiverC;
  TestP.Leds -> LedsC;
  
}

