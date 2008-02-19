
#include "TestCase.h"

/**
 * Test all bounds of an isolated CsmaC component
 * @author David Moss
 */
configuration TestCsmaC {
}

implementation {

  components new TestCaseC() as TestCcaRequestC,
      new TestCaseC() as TestNoCcaNoCongestionC,
      new TestCaseC() as TestNoCcaWithCongestionC,
      new TestCaseC() as TestInitialRequestC,
      new TestCaseC() as TestSingleCongestionC,
      new TestCaseC() as TestMultipleCongestionC,
      new TestCaseC() as TestCancelC;
      
  components TestCsmaP,
      CsmaP,
      BlazePacketC,
      new StateC();
  
  TestCsmaP.Send -> CsmaP;
  TestCsmaP.Csma -> CsmaP;
  
  TestCsmaP.State -> StateC;
  TestCsmaP.BlazePacketBody -> BlazePacketC;
  
  TestCsmaP.SetUp -> TestCcaRequestC.SetUp;
  TestCsmaP.TestCcaRequest -> TestCcaRequestC;
  TestCsmaP.TestNoCcaNoCongestion -> TestNoCcaNoCongestionC;
  TestCsmaP.TestNoCcaWithCongestion -> TestNoCcaWithCongestionC;
  TestCsmaP.TestInitialRequest -> TestInitialRequestC;
  TestCsmaP.TestSingleCongestion -> TestSingleCongestionC;
  TestCsmaP.TestMultipleCongestion -> TestMultipleCongestionC;
  TestCsmaP.TestCancel -> TestCancelC;
  
  
  /***************** CsmaP Wrapper Configuration *****************/
   
  // Edited to connect to our test
  CsmaP.AsyncSend -> TestCsmaP;
  CsmaP.Resource -> TestCsmaP;
  
  components AlarmMultiplexC;
  CsmaP.BackoffTimer -> AlarmMultiplexC;
  
  CsmaP.BlazePacket -> BlazePacketC;
  CsmaP.BlazePacketBody -> BlazePacketC;
  
  components new StateC() as CsmaStateC;
  CsmaP.State -> CsmaStateC;
  
  components BlazeSpiC;
  CsmaP.PaReg -> BlazeSpiC.PA;
  
  components RandomC;
  CsmaP.Random -> RandomC;
  
}
