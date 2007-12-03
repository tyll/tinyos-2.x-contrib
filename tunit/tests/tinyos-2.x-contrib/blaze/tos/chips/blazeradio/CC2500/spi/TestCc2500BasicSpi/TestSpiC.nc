
#include "TestCase.h"

/**
 * @author David Moss
 */
configuration TestSpiC {
}

implementation {

  components new TestCaseC() as SpiTestC;
  
  components TestSpiP,
      new BlazeSpiResourceC(),
      BlazeSpiC,
      HplCC2500PinsC,
      LedsC;
  
  TestSpiP.CSN -> HplCC2500PinsC.Csn;
  TestSpiP.Idle -> BlazeSpiC.SIDLE;
  TestSpiP.PARTNUM -> BlazeSpiC.PARTNUM;
  TestSpiP.SRES -> BlazeSpiC.SRES;
  TestSpiP.SNOP -> BlazeSpiC.SNOP;
  TestSpiP.SpiTest -> SpiTestC;
  TestSpiP.Resource -> BlazeSpiResourceC;
  TestSpiP.Leds -> LedsC;
  
}

