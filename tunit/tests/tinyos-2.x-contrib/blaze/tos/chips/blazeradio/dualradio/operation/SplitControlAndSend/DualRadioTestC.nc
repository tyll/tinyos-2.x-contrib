
/**
 * Isolate the entire blaze radio stack from the radio, and check to see
 * if SplitControl and AMSend work by using the default interfaces
 * as well as selecting specific radio's.
 * 
 * @author David Moss
 */

#include "TestCase.h"

configuration DualRadioTestC {
}

implementation {
  components new TestCaseC() as TurnOnDefaultRadioC,
      new TestCaseC() as TurnOnSecondaryRadioC,
      new TestCaseC() as SendDefaultMsgC;
  
  components ActiveMessageC,
    DualRadioTestP,
    new StateC();
  
  DualRadioTestP.SetUp -> TurnOnDefaultRadioC.SetUp;
  DualRadioTestP.TurnOnDefaultRadio -> TurnOnDefaultRadioC;
  DualRadioTestP.TurnOnSecondaryRadio -> TurnOnSecondaryRadioC;
  DualRadioTestP.SendDefaultMsg -> SendDefaultMsgC;
    
  DualRadioTestP.State -> StateC;
  DualRadioTestP.SplitControl -> ActiveMessageC;
  DualRadioTestP.BlazeSplitControl -> ActiveMessageC;
  DualRadioTestP.AMSend -> ActiveMessageC.AMSend[0];
    
}

