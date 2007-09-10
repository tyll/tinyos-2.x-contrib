
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
      HplCC2500PinsC,
      CC2500ControlC,
      LedsC;
  
  TestP.SetUpOneTime -> ResetRadioTestC.SetUpOneTime;
  
  TestP.CSN -> HplCC2500PinsC.Csn;
  TestP.SRES -> BlazeSpiC.SRES;
  TestP.Resource -> BlazeSpiC;
  TestP.Leds -> LedsC;
  TestP.BlazePower -> CC2500ControlC;
  
  /***************** Register Connections ****************/
  TestP.IOCFG2 -> BlazeSpiC.IOCFG2;
  
  /***************** Test Connections ***************/
  TestP.ResetRadioTest -> ResetRadioTestC;
  
}

