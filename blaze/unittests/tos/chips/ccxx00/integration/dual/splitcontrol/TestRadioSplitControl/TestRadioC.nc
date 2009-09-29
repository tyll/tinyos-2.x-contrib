
#include "TestCase.h"
#include "CC1100.h"

/**
 * Make sure SplitControl works and we're compliant with the virtualized
 * power devices TEP
 * 
 * @author David Moss
 */
configuration TestRadioC {
}

implementation {
  components
      new TestCaseC() as TestRadioPowerCycleC,
      new TestCaseC() as TestAlreadyOnC,
      new TestCaseC() as TestAlreadyOffC,
      new TestCaseC() as TestAlreadyTurningOnC,
      new TestCaseC() as TestAlreadyTurningOffC;
      
  components TestRadioP,
      CC1100ControlC,
      BlazeC,
      new TimerMilliC(),
      new StateC(),
      LedsC;

  TestRadioP.SetUp -> TestRadioPowerCycleC.SetUp;
  
  TestRadioP.TestRadioPowerCycle -> TestRadioPowerCycleC;
  TestRadioP.TestAlreadyOn -> TestAlreadyOnC;
  TestRadioP.TestAlreadyOff -> TestAlreadyOffC;
  TestRadioP.TestAlreadyTurningOn -> TestAlreadyTurningOnC;
  TestRadioP.TestAlreadyTurningOff -> TestAlreadyTurningOffC;
  
  TestRadioP.SplitControl -> BlazeC;
  TestRadioP.AMSend -> BlazeC.AMSend[4];
  TestRadioP.Receive -> BlazeC.Receive[4];
  TestRadioP.Timer -> TimerMilliC;
  TestRadioP.State -> StateC;
  TestRadioP.Leds -> LedsC;

}
