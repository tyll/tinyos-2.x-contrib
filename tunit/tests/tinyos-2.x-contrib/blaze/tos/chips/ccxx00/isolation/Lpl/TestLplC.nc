
/**
 * @author David Moss
 */

#include "Blaze.h"

configuration TestLplC {
}

implementation {

  enum {
    MY_RADIO = unique(UQ_BLAZE_RADIO),
  };
  
  components 
      new TestCaseC() as ToggleLplBeforeStartC,
      new TestCaseC() as ToggleLplAfterStartC,
      new TestCaseC() as NoLplSplitControlC;

  components 
      LplP,
      WireLplC,
      TestLplP,
      new StateC(),
      LedsC;
      
  TestLplP.SetUp -> ToggleLplAfterStartC.SetUp;
  TestLplP.ToggleLplBeforeStart -> ToggleLplBeforeStartC;
  TestLplP.ToggleLplAfterStart -> ToggleLplAfterStartC;
  TestLplP.NoLplSplitControl -> NoLplSplitControlC;
  
  
  TestLplP.LowPowerListening -> LplP;
  TestLplP.SplitControl -> LplP;
  TestLplP.Send -> LplP;
  TestLplP.Leds -> LedsC;
  TestLplP.State -> StateC;
  
  LplP.SubSend -> TestLplP.SubSend;
  LplP.SplitControlManager -> TestLplP;
  LplP.RxNotify -> TestLplP;
  LplP.Wor -> TestLplP;  
  
}
