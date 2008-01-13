/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 *  This code funded by TX State San Marcos University. BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * Takes readings for two banks of sensorboard a2d12ch. Bank switching is 
 * handled with the  HplMsp430GeneralIO in  ReadMoistureSensorsP.nc
 * since the IO functions are used as is, no mods.  
 * There is no IO code in a2d12ch modules, only multichannel-a2d and resource.
 * Two temp data buffers are returned with the multichannel.getData 
 * interface as one shorter buffer with the samplesperbank buffer entries
 * all averaged together.

 * by John Griessen <john@ecosensory.com>
 * Rev 1.0 14 Dec 2007
 */
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
  components new TimerMilliC() as Timer1;
  components new TimerMilliC() as Timer2;
  components new TimerMilliC() as Timer3;
  components ReadMoistureSensorsP;
  ReadMoistureSensorsP.Boot -> MainC;
  ReadMoistureSensorsP.Leds -> LedsC;
  ReadMoistureSensorsP.timer0 -> Timer0;
  ReadMoistureSensorsP.timer1 -> Timer1;
  ReadMoistureSensorsP.timer2 -> Timer2;
  ReadMoistureSensorsP.timer3 -> Timer3;
  ReadMoistureSensorsP.AMSend -> AMSenderC;
  ReadMoistureSensorsP.AMRadioOn -> ActiveMessageC;

  components a2d12chP, a2d12chC;  
  ReadMoistureSensorsP.a2d12ch -> a2d12chP.a2d12ch; //Msp430Adc12MultiChannel
  ReadMoistureSensorsP.AdcConfigure -> a2d12chP.AdcConfigure; //Msp430Adc12MultiChannel
  ReadMoistureSensorsP.Resource -> a2d12chP.Resource; //ResourceRVG (first thing to do)

  components HplMsp430GeneralIOC;
  ReadMoistureSensorsP.a2dmuxdisable -> HplMsp430GeneralIOC.Port21;
  ReadMoistureSensorsP.a2dbankselect -> HplMsp430GeneralIOC.Port23;
  ReadMoistureSensorsP.a2dsenvdd1drv -> HplMsp430GeneralIOC.ADC7;
  ReadMoistureSensorsP.a2dsenvdd2drv -> HplMsp430GeneralIOC.ADC6;
  ReadMoistureSensorsP.a2dterm2drv -> HplMsp430GeneralIOC.Port17;

}
