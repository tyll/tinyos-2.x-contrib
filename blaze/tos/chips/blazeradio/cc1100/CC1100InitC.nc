
#include "Blaze.h"
#include "BlazeInit.h"
#include "CC1100.h"

/**
 * This configuration is responsible for wiring in the CC1100 pins to the 
 * main BlazeInitC component, and provides default values for the CC1100 
 * registers.
 * 
 * @author Jared Hill
 * @author David Moss
 */

configuration CC1100InitC {
  provides {
    interface BlazePower;
  }
}

implementation {
  
  components MainC,
      CC1100InitP,
      HplCC1100PinsC as Pins;
      
  MainC.SoftwareInit -> CC1100InitP;
  
  CC1100InitP.Csn -> Pins.Csn;
  CC1100InitP.Power -> Pins.Power;
  CC1100InitP.Gdo0_io -> Pins.Gdo0_io;
  CC1100InitP.Gdo2_io -> Pins.Gdo2_io;
 
  components BlazeInitC;
  BlazePower = BlazeInitC.BlazePower[ CC1100_RADIO_ID ];
  BlazeInitC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  BlazeInitC.Power[ CC1100_RADIO_ID ] -> Pins.Power;
  BlazeInitC.BlazeRegSettings[ CC1100_RADIO_ID ] -> CC1100InitP;
  BlazeInitC.Gdo0_io[ CC1100_RADIO_ID ] -> Pins.Gdo0_io;
  BlazeInitC.Gdo2_io[ CC1100_RADIO_ID ] -> Pins.Gdo2_io;
  
  components BlazeTransmitC;
  BlazeTransmitC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  
  components BlazeReceiveC;
  BlazeReceiveC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  
  components LedsC;
  CC1100InitP.Leds -> LedsC;
  
}

