
/**
 * @author David Moss
 */

// These next two includes define the order of radio id's 
#include "CC1100.h"
#include "CC2500.h"

#include "Blaze.h"
#include "TestCase.h"

configuration TestRadioSelectC {
}

implementation {
  components new TestCaseC() as TestSelectRadioC,
      new TestCaseC() as TestSelectCC1100C,
      new TestCaseC() as TestSelectCC2500C,
      new TestCaseC() as TestSelectInvalidC,
      new TestCaseC() as TestReceiveCC1100C,
      new TestCaseC() as TestReceiveCC2500C,
      new TestCaseC() as TestStopWhileSendingC,
      new TestCaseC() as TestSendWhileOffC,
      new TestCaseC() as TestStopWhileIdleC,
      new TestCaseC() as TestWrongRadioOnC;
      
  components TestRadioSelectP,
      RadioSelectC,
      BlazePacketC,
      new StateC();
      
  RadioSelectC.SubSend -> TestRadioSelectP.SubSend;
  RadioSelectC.SubReceive -> TestRadioSelectP.SubReceive;
  RadioSelectC.SubControl -> TestRadioSelectP.SubControl;
  
  TestRadioSelectP.RadioSelect -> RadioSelectC;
  TestRadioSelectP.Send -> RadioSelectC.Send;
  TestRadioSelectP.Receive -> RadioSelectC.Receive;
  TestRadioSelectP.SplitControl -> RadioSelectC;
  TestRadioSelectP.BlazePacket -> BlazePacketC;
  TestRadioSelectP.State -> StateC;

  TestRadioSelectP.SetUp -> TestSelectRadioC.SetUp;
  TestRadioSelectP.TestSelectRadio -> TestSelectRadioC;
  TestRadioSelectP.TestSelectCC1100 -> TestSelectCC1100C;
  TestRadioSelectP.TestSelectCC2500 -> TestSelectCC2500C;
  TestRadioSelectP.TestSelectInvalid -> TestSelectInvalidC;
  TestRadioSelectP.TestReceiveCC1100 -> TestReceiveCC1100C;
  TestRadioSelectP.TestReceiveCC2500 -> TestReceiveCC2500C;
  TestRadioSelectP.TestStopWhileSending -> TestStopWhileSendingC;
  TestRadioSelectP.TestSendWhileOff -> TestSendWhileOffC;
  TestRadioSelectP.TestStopWhileIdle -> TestStopWhileIdleC;
  TestRadioSelectP.TestWrongRadioOn -> TestWrongRadioOnC;
  

}

