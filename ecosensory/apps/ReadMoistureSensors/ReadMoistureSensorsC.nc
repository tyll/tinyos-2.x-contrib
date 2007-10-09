#include <Timer.h>
#include "ReadMoistureSensors.h"
#include "Msp430Adc12.h"

configuration ReadMoistureSensorsC {
}
implementation {
  components MainC, LedsC;
  components ActiveMessageC;
  components new AMSenderC(AM_MOISTURESENSORSMSG);
  components new TimerMilliC() as Timer0;
  components ReadMoistureSensorsP;
  ReadMoistureSensorsP.Boot -> MainC;
  ReadMoistureSensorsP.Leds -> LedsC;
  ReadMoistureSensorsP.timer0 -> Timer0;
  ReadMoistureSensorsP.AMSend -> AMSenderC;
  ReadMoistureSensorsP.AMRadioOn -> ActiveMessageC;

  components a2d12chP, a2d12chC;  
  ReadMoistureSensorsP.a2d12ch -> a2d12chP.a2d12ch; //Msp430Adc12MultiChannel
  ReadMoistureSensorsP.AdcConfigure -> a2d12chP.AdcConfigure; //Msp430Adc12MultiChannel
  ReadMoistureSensorsP.Resource -> a2d12chP.Resource; //ResourceRVG (first thing to do)

}
