
#include "RadioCountToLeds.h"

configuration RadioCountToLedsC {
}

implementation {
  components MainC, 
      RadioCountToLedsP, 
      LedsC;
      
  components new AMSenderC(AM_RADIO_COUNT_MSG);
  components new AMReceiverC(AM_RADIO_COUNT_MSG);
  components new TimerMilliC();
  components ActiveMessageC;
  
  RadioCountToLedsP.Boot -> MainC.Boot;
  
  RadioCountToLedsP.Receive -> AMReceiverC;
  RadioCountToLedsP.AMSend -> AMSenderC;
  RadioCountToLedsP.SplitControl -> ActiveMessageC;
  RadioCountToLedsP.PacketAcknowledgements -> ActiveMessageC;
  RadioCountToLedsP.Leds -> LedsC;
  RadioCountToLedsP.Timer -> TimerMilliC;
  RadioCountToLedsP.Packet -> AMSenderC;
  
}


