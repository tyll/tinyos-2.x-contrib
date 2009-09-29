
/**
 * Test that we can toggle split control on and off while receiving packets
 */
configuration TestC {
}

implementation {
  components new TestCaseC() as TestStartStopWhileReceivingC;
  
  components ActiveMessageC,
      BlazeC,      
      new AMSenderC(0),
      new AMReceiverC(0),
      LedsC,
      new TimerMilliC(),
      new StateC(),
      ActiveMessageAddressC,
      TestP;
   
  TestP.MultiStartStop -> TestStartStopWhileReceivingC;
  TestP.SetUpOneTime -> TestStartStopWhileReceivingC.SetUpOneTime;
  TestP.TearDownOneTime -> TestStartStopWhileReceivingC.TearDownOneTime;
  
  TestP.Timer -> TimerMilliC;
  TestP.SplitControl -> ActiveMessageC;
  TestP.AMSend -> AMSenderC;
  TestP.Receive -> AMReceiverC;
  TestP.State -> StateC;
  TestP.ActiveMessageAddress -> ActiveMessageAddressC;
  TestP.Leds -> LedsC;
  
}

