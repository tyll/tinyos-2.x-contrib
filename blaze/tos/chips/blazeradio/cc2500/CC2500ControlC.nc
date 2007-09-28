
#include "Blaze.h"
#include "BlazeInit.h"
#include "CC2500.h"

/**
 * This configuration is responsible for wiring in the CC2500 pins to the 
 * main BlazeInitC component, and provides register values for the CC2500.
 * 
 * @author Jared Hill
 * @author David Moss
 */

configuration CC2500ControlC {
  provides {
    interface SplitControl;
    interface BlazePower;
    interface BlazeConfig;
  }
}

implementation {
  
  components MainC,
      CC2500ControlP,
      ActiveMessageAddressC,
      HplCC2500PinsC as Pins;
      
  MainC.SoftwareInit -> CC2500ControlP;
  
  BlazeConfig = CC2500ControlP;
  
  CC2500ControlP.Csn -> Pins.Csn;
  CC2500ControlP.Power -> Pins.Power;
  CC2500ControlP.Gdo0_io -> Pins.Gdo0_io;
  CC2500ControlP.Gdo2_io -> Pins.Gdo2_io;
  CC2500ControlP.ActiveMessageAddress -> ActiveMessageAddressC;
  
  components BlazeInitC;
  SplitControl = BlazeInitC.SplitControl[ CC2500_RADIO_ID ];
  BlazePower = BlazeInitC.BlazePower[ CC2500_RADIO_ID ];
  BlazeInitC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  BlazeInitC.Power[ CC2500_RADIO_ID ] -> Pins.Power;
  BlazeInitC.BlazeRegSettings[ CC2500_RADIO_ID ] -> CC2500ControlP;
  BlazeInitC.Gdo0_io[ CC2500_RADIO_ID ] -> Pins.Gdo0_io;
  BlazeInitC.Gdo2_io[ CC2500_RADIO_ID ] -> Pins.Gdo2_io;
  BlazeInitC.Gdo0_int[ CC2500_RADIO_ID ] -> Pins.Gdo0_int;
  BlazeInitC.Gdo2_int[ CC2500_RADIO_ID ] -> Pins.Gdo2_int;
  CC2500ControlP.BlazeCommit -> BlazeInitC.BlazeCommit[ CC2500_RADIO_ID ];
  
  components BlazeTransmitC;
  BlazeTransmitC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  BlazeTransmitC.TxInterrupt[ CC2500_RADIO_ID ] -> Pins.Gdo2_int;
  
  components BlazeReceiveC;
  BlazeReceiveC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  BlazeReceiveC.RxInterrupt [ CC2500_RADIO_ID ] -> Pins.Gdo2_int;
  BlazeReceiveC.BlazeConfig[ CC2500_RADIO_ID ] -> CC2500ControlP.BlazeConfig;
  
  components LedsC;
  CC2500ControlP.Leds -> LedsC;
  
}

