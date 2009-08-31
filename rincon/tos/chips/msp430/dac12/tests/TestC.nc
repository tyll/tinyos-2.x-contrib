
#include "stdio.h"

configuration TestC {
}

implementation {

  components MainC;
  components TestP;
  TestP.Boot -> MainC;
  
  components Msp430Dac12_0C;
  TestP.StdControl -> Msp430Dac12_0C;
  TestP.Msp430Dac12 -> Msp430Dac12_0C;
  
  components DacConfigurationP;
  Msp430Dac12_0C.Configure -> DacConfigurationP;
  
  components LedsC;
  TestP.Leds -> LedsC;
  
  
  // NEXT STEP:
  // Generate a reference voltage. VeRef+ is grounded on flint3's.
  //components Msp430RefVoltGeneratorP;
  //TestP.
  components UartPrintfC;  
  
  
}
