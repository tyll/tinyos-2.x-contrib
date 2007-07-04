
configuration TestRadioC {
}

implementation {
  components new TestCaseC() as TestIndicatorC,
      new StatisticsC() as IndicatorStatsC;
  
  components TestRadioP,
      ActiveMessageC,
      new AMSenderC(4),
      new AMReceiverC(4),
      new TimerMilliC(),
      ActiveMessageAddressC,
      CC2420ReceiveC,
      LedsC;
  
  TestRadioP.SetUpOneTime -> TestIndicatorC.SetUpOneTime;
  TestRadioP.TestIndicator -> TestIndicatorC;
  TestRadioP.Statistics -> IndicatorStatsC;
  TestRadioP.TearDownOneTime -> TestIndicatorC.TearDownOneTime;
  
  TestRadioP.SplitControl -> ActiveMessageC;
  TestRadioP.AMSend -> AMSenderC;
  TestRadioP.Receive -> AMReceiverC;
  TestRadioP.PacketIndicator -> CC2420ReceiveC.PacketIndicator;
  TestRadioP.ActiveMessageAddress -> ActiveMessageAddressC;
  TestRadioP.Timer -> TimerMilliC;
  TestRadioP.Leds -> LedsC;
  
}
