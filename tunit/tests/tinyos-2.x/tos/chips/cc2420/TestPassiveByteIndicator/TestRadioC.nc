
configuration TestRadioC {
}

implementation {
  components new TestCaseC() as TestIndicatorC;
  
  components TestRadioP,
      ActiveMessageC,
      new AMSenderC(4),
      new AMReceiverC(4),
      new TimerMilliC(),
      ActiveMessageAddressC,
      CC2420TransmitC,
      LedsC;
  
  TestRadioP.SetUpOneTime -> TestIndicatorC.SetUpOneTime;
  TestRadioP.TestIndicator -> TestIndicatorC;
  TestRadioP.TearDownOneTime -> TestIndicatorC.TearDownOneTime;
  
  TestRadioP.SplitControl -> ActiveMessageC;
  TestRadioP.AMSend -> AMSenderC;
  TestRadioP.Receive -> AMReceiverC;
  TestRadioP.ByteIndicator -> CC2420TransmitC.ByteIndicator;
  TestRadioP.ActiveMessageAddress -> ActiveMessageAddressC;
  TestRadioP.Timer -> TimerMilliC;
  TestRadioP.Leds -> LedsC;
  
}
