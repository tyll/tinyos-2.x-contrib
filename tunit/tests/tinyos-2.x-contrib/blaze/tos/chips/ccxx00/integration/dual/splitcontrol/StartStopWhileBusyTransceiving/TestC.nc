
/**
 * Test that we can toggle split control on and off all the time
 * while sending and receiving packets
 */
configuration TestC {
}

implementation {
  components new TestCaseC() as TestStartStopWhileTransceivingC;
  
  components ActiveMessageC, 
      BlazeC,
      new AMSenderC(0),
      new AMReceiverC(0),
      LedsC,
      new TimerMilliC(),
      new StateC(),
      ActiveMessageAddressC,
      TestP;
   
  TestP.MultiStartStop -> TestStartStopWhileTransceivingC;
  TestP.SetUpOneTime -> TestStartStopWhileTransceivingC.SetUpOneTime;
  TestP.TearDownOneTime -> TestStartStopWhileTransceivingC.TearDownOneTime;
  
  TestP.Timer -> TimerMilliC;
  TestP.SplitControl -> BlazeC;
  TestP.AMSend -> AMSenderC;
  TestP.Receive -> AMReceiverC;
  TestP.State -> StateC;
  TestP.ActiveMessageAddress -> ActiveMessageAddressC;
  TestP.Leds -> LedsC;
  
}

