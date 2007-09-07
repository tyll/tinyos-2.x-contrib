
#include "Blaze.h"
#include "IEEE802154.h"
#include "BlazeControl.h"
#include "CC1100.h"

/**
 * @author Jared Hill
 * @author David Moss
 */
 
configuration CC1100ControlC {

  provides {
    interface SplitControl;
    interface BlazePower;
    interface BlazeRegister as Rssi;
    interface State as RadioState;
  }
  
}

implementation {

  components CC1100InitC;
  BlazePower = CC1100InitC;
    
  components BlazeControlC;
  SplitControl = BlazeControlC.SplitControl[ CC1100_RADIO_ID ];
  Rssi = BlazeControlC.Rssi[ CC1100_RADIO_ID ];

  components HplCC1100PinsC as Pins;
  BlazeControlC.Csn[ CC1100_RADIO_ID ] -> Pins.Csn;
  
  components new StateC();
  BlazeControlC.State[ CC1100_RADIO_ID ] -> StateC;
  RadioState = StateC;
  
}

