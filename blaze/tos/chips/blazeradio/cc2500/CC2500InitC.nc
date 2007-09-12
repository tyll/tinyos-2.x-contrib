
#include "Blaze.h"
#include "BlazeInit.h"
#include "CC2500.h"

/**
 * This configuration is responsible for wiring in the CC2500 pins to the 
 * main BlazeInitC component, and provides default values for the CC2500 
 * registers.
 * 
 * @author Jared Hill
 * @author David Moss
 */

configuration CC2500InitC {
  provides {
    interface BlazePower;
    interface BlazeConfig;
  }
}

implementation {
  
  components MainC,
      CC2500InitP,
      ActiveMessageAddressC,
      HplCC2500PinsC as Pins;
      
  MainC.SoftwareInit -> CC2500InitP;
  
  BlazeConfig = CC2500InitP;
  
  CC2500InitP.Csn -> Pins.Csn;
  CC2500InitP.Power -> Pins.Power;
  CC2500InitP.Gdo0_io -> Pins.Gdo0_io;
  CC2500InitP.Gdo2_io -> Pins.Gdo2_io;
  CC2500InitP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  components BlazeInitC;
  BlazePower = BlazeInitC.BlazePower[ CC2500_RADIO_ID ];
  BlazeInitC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  BlazeInitC.Power[ CC2500_RADIO_ID ] -> Pins.Power;
  BlazeInitC.BlazeRegSettings[ CC2500_RADIO_ID ] -> CC2500InitP;
  BlazeInitC.Gdo0_io[ CC2500_RADIO_ID ] -> Pins.Gdo0_io;
  BlazeInitC.Gdo2_io[ CC2500_RADIO_ID ] -> Pins.Gdo2_io;
  CC2500InitP.BlazeCommit -> BlazeInitC;
  
  components BlazeTransmitC;
  BlazeTransmitC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  
  components BlazeReceiveC;
  BlazeReceiveC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  BlazeReceiveC.BlazeConfig[ CC2500_RADIO_ID ] -> CC2500InitP.BlazeConfig;
  
  components LedsC;
  CC2500InitP.Leds -> LedsC;
  
}

