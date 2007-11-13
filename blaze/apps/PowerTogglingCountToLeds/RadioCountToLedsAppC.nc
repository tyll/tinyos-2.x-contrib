
#include "RadioCountToLeds.h"

/**
 * Post send() in a task while toggling the radio on and off periodically
 * @author David Moss
 */
 
configuration RadioCountToLedsAppC {}
implementation {
  components MainC, 
      RadioCountToLedsC as App, 
      LedsC;
      
  components new AMSenderC(AM_RADIO_COUNT_MSG);
  components new AMReceiverC(AM_RADIO_COUNT_MSG);
  components new TimerMilliC();
  components ActiveMessageC;
  
  App.Boot -> MainC.Boot;
  
  App.Receive -> AMReceiverC;
  App.AMSend -> AMSenderC;
  App.SplitControl -> ActiveMessageC;
  App.Leds -> LedsC;
  App.Timer -> TimerMilliC;
  App.Packet -> AMSenderC;
}


