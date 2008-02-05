

#include "CC1100.h"
#include "Blaze.h"

configuration CcaC {
}

implementation {

  components CcaP,
      MainC,
      LedsC,
      CC1100ControlC,
      BlazeCentralWiringC,
      ActiveMessageC;
      
  CcaP.Boot -> MainC;
  CcaP.Leds -> LedsC;
  CcaP.Cca -> BlazeCentralWiringC.Gdo0_io[CC1100_RADIO_ID];
  CcaP.SplitControl -> ActiveMessageC;
  
   
}
