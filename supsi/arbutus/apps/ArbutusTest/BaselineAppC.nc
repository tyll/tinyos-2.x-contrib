


#include <data.h>

configuration BaselineAppC { }
implementation {
  components MainC, BaselineC, LedsC, new TimerMilliC(),
    RandomC;
 components CC2420ActiveMessageC as CC2420;



  BaselineC.CC2420Packet -> CC2420;

  BaselineC.Boot -> MainC;
  BaselineC.Timer -> TimerMilliC;
  
  BaselineC.Leds -> LedsC;
  BaselineC.Random -> RandomC;
  
  components CollectionC as Collector,  // Collection layer
    ActiveMessageC,                         // AM layer
    new CollectionSenderC(AM_DATA_MSG), // Sends multihop RF
    SerialActiveMessageC,                   // Serial messaging
    new SerialAMSenderC(AM_DATA_MSG);   // Sends to the serial port

  components ArbutusP as Arbutus;
  
  BaselineC.RadioControl -> ActiveMessageC;
  BaselineC.SerialControl -> SerialActiveMessageC;
  BaselineC.RoutingControl -> Collector;

  BaselineC.Send -> CollectionSenderC;
  BaselineC.SerialSend -> SerialAMSenderC.AMSend;
  BaselineC.Receive -> Collector.Receive[AM_DATA_MSG];
  BaselineC.RootControl -> Collector;



  BaselineC.ArbutusInfo -> Arbutus;
  BaselineC.Packet -> Arbutus;
 

  

}
