
#include "Blaze.h"
#include "BlazeInit.h"
#include "CC1100.h"

/**
 * This configuration is responsible for wiring in the CC1100 pins to the 
 * main BlazeInitC component, and provides register values for the CC1100.
 * 
 * @author Jared Hill
 * @author David Moss
 */

configuration CC1100ControlC {
  provides {
    interface SplitControl;
    interface BlazePower;
    interface BlazeConfig;
  }
}

implementation {
  
  components MainC,
      CC1100ControlP,
      ActiveMessageAddressC,
      HplCC1100PinsC as Pins;
      
  MainC.SoftwareInit -> CC1100ControlP;
  
  BlazeConfig = CC1100ControlP;
  
  CC1100ControlP.Csn -> Pins.Csn;
  CC1100ControlP.Power -> Pins.Power;
  CC1100ControlP.Gdo0_io -> Pins.Gdo0_io;
  CC1100ControlP.Gdo2_io -> Pins.Gdo2_io;
  CC1100ControlP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  components BlazeInitC;
  SplitControl = BlazeInitC.SplitControl[ CC1100_RADIO_ID ];
  BlazePower = BlazeInitC.BlazePower[ CC1100_RADIO_ID ];
  BlazeInitC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  BlazeInitC.Power[ CC1100_RADIO_ID ] -> Pins.Power;
  BlazeInitC.BlazeRegSettings[ CC1100_RADIO_ID ] -> CC1100ControlP;
  BlazeInitC.Gdo0_io[ CC1100_RADIO_ID ] -> Pins.Gdo0_io;
  BlazeInitC.Gdo2_io[ CC1100_RADIO_ID ] -> Pins.Gdo2_io;
  CC1100ControlP.BlazeCommit -> BlazeInitC.BlazeCommit[ CC1100_RADIO_ID ];
  
  components BlazeTransmitC;
  BlazeTransmitC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  
  components BlazeReceiveC;
  BlazeReceiveC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  BlazeReceiveC.TxInterrupt [ CC1100_RADIO_ID ] -> Pins.Gdo2_int;
  BlazeReceiveC.BlazeConfig[ CC1100_RADIO_ID ] -> CC1100ControlP.BlazeConfig;
  
  components LedsC;
  CC1100ControlP.Leds -> LedsC;
  
}

