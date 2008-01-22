

configuration TestManagerC {
}

implementation {

  components new TestCaseC() as TestAlreadyOnC,
      new TestCaseC() as TestAlreadyOffC,
      new TestCaseC() as TestAlreadyTurningOnC,
      new TestCaseC() as TestAlreadyTurningOffC,
      new TestCaseC() as TestOtherRadioFocusedC,
      new TestCaseC() as TestSendToDisabledRadioC,
      new TestCaseC() as TestOnOffC;
      
  components TestManagerP;
  TestManagerP.TestAlreadyOn -> TestAlreadyOnC;
  TestManagerP.TestAlreadyOff -> TestAlreadyOffC;
  TestManagerP.TestAlreadyTurningOn -> TestAlreadyTurningOnC;
  TestManagerP.TestAlreadyTurningOff -> TestAlreadyTurningOffC;
  TestManagerP.TestOtherRadioFocused -> TestOtherRadioFocusedC;
  TestManagerP.TestSendToDisabledRadio -> TestSendToDisabledRadioC;
  TestManagerP.TestOnOff -> TestOnOffC;
  
  TestManagerP.SetUp -> TestAlreadyOnC.SetUp;
  TestManagerP.TearDown -> TestAlreadyOnC.TearDown;
  
  
  components LedsC;
  TestManagerP.Leds -> LedsC;
  
  components new StateC();
  TestManagerP.State -> StateC;
  
  components SplitControlManagerC;
  TestManagerP.SplitControl -> SplitControlManagerC;
  TestManagerP.Send -> SplitControlManagerC;
  TestManagerP.SplitControlManager -> SplitControlManagerC;
  
  SplitControlManagerC.SubSend -> TestManagerP;
  SplitControlManagerC.SubControl -> TestManagerP; 
  
  
}
