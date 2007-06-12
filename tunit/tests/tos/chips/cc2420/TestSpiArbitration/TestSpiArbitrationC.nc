
/**
 * @author David Moss
 */
 
configuration TestSpiArbitrationC {
}

implementation {
  components 
      new TestCaseC() as TestSingleAcquireC,
      new TestCaseC() as TestMultiAcquireC,
      new TestCaseC() as TestReleaseAndHoldC,
      new TestCaseC() as TestImmediateRequestC,
      new TestCaseC() as TestReleaseAbortAcquireC;
      
  components TestSpiArbitrationP,
      new CC2420SpiC() as Resource1C,
      new CC2420SpiC() as Resource2C,
      new CC2420SpiC() as Resource3C,
      new StateC(),
      LedsC;
      
  TestSpiArbitrationP.SetUp -> TestSingleAcquireC.SetUp;
  
  TestSpiArbitrationP.TestSingleAcquire -> TestSingleAcquireC;
  TestSpiArbitrationP.TestMultiAcquire -> TestMultiAcquireC;
  TestSpiArbitrationP.TestReleaseAndHold -> TestReleaseAndHoldC;
  TestSpiArbitrationP.TestImmediateRequest -> TestImmediateRequestC;
  TestSpiArbitrationP.TestReleaseAbortAcquire -> TestReleaseAbortAcquireC;
  
  TestSpiArbitrationP.ChipSpiResource -> Resource1C;
  TestSpiArbitrationP.Resource1 -> Resource1C;
  TestSpiArbitrationP.Resource2 -> Resource2C;
  TestSpiArbitrationP.Resource3 -> Resource3C;
  TestSpiArbitrationP.State -> StateC;
  TestSpiArbitrationP.Leds -> LedsC;

}

