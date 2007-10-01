
#include "TestCase.h"

/** 
 * TWO REGISTERS DO NOT MATCH WITH THE DATASHEET:
 *  MDMCFG0: Default value is 0x0 (datasheet says 0xF8)
 *  FREND1: Default value is 0x56 (datasheet says 0xA6)
 *
 * @author David Moss
 */
configuration TestC {
}

implementation {

  components 
    new TestCaseC() as ResetRadioTestC;


  components TestP,
      BlazeSpiC,
      new BlazeSpiResourceC(),
      new BlazeSpiResourceC() as BlazeSpiResource2C,
      HplCC1100PinsC,
      CC1100ControlC,
      LedsC;
  
  TestP.SetUpOneTime -> ResetRadioTestC.SetUpOneTime;
  
  TestP.CSN -> HplCC1100PinsC.Csn;
  TestP.Resource -> BlazeSpiResourceC;
  TestP.Resource2 -> BlazeSpiResource2C;
  TestP.Leds -> LedsC;
  TestP.BlazePower -> CC1100ControlC;
  
  /***************** Register Connections ****************/
  TestP.IOCFG2 -> BlazeSpiC.IOCFG2;
  
  /***************** Test Connections ***************/
  TestP.ResetRadioTest -> ResetRadioTestC;
  
}

