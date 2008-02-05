
#include "CC1100.h"

/**
 * @author David Moss
 */
 
configuration TestC {
}

implementation {

  components MainC;
  
  components TestP,
      CC1100ControlC,
      BlazeTransmitC,
      new BlazeSpiResourceC();
  
  TestP.Boot -> MainC;

  TestP.Resource -> BlazeSpiResourceC;
  TestP.SplitControl -> CC1100ControlC;
  TestP.AsyncSend -> BlazeTransmitC.AsyncSend[ CC1100_RADIO_ID ];
  
  components LedsC;
  TestP.Leds -> LedsC;
  
}

