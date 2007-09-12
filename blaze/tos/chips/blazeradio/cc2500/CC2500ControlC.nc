
#include "Blaze.h"
#include "IEEE802154.h"
#include "BlazeControl.h"
#include "CC2500.h"

/**
 * @author Jared Hill
 * @author David Moss
 */
 
configuration CC2500ControlC {

  provides {
    interface SplitControl;
    interface BlazePower;
    interface BlazeConfig;
    interface BlazeRegister as Rssi;
    interface State as RadioState;
  }
  
}

implementation {

  components CC2500InitC;
  BlazePower = CC2500InitC;
  BlazeConfig = CC2500InitC;
    
  components BlazeControlC;
  SplitControl = BlazeControlC.SplitControl[ CC2500_RADIO_ID ];
  Rssi = BlazeControlC.Rssi[ CC2500_RADIO_ID ];

  components HplCC2500PinsC as Pins;
  BlazeControlC.Csn[ CC2500_RADIO_ID ] -> Pins.Csn;
  
  components new StateC();
  BlazeControlC.State[ CC2500_RADIO_ID ] -> StateC;
  RadioState = StateC;
  
}

