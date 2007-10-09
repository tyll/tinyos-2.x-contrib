/* 
 * Copyright (c) 2007, Ecosensory
 * -- Use per TOS Alliance license. If not found in your distr. 
 *     see http://tinyos.net/licenses/toslicense.txt --
 * $Revision: 1.0 Testch12AdcP.nc  
 * $Date: 2sep2007
 * @author: John Griessen <john@ecosensory.com>
 * ============================================================
 * Soil Moisture sensorboard prototype code.
 */
#include "Msp430Adc12.h"
#include "ch12Adc.h"
module Testch12AdcP {
  uses  {
    interface Leds;
    interface Resource;
    interface Boot;
    interface Msp430Adc12MultiChannel as ch12Adc;
    interface AdcConfigure<const msp430adc12_channel_config_t*>;

  }
}
implementation
{
#define BUFFER_SIZE 6
//uint8_t samplesperbank = 1;
uint8_t jiffies = 0;
uint16_t  bufferlen = BUFFER_SIZE;
  //  ref volt from generator = 2.50 Volts
#define CONFIG_VREF  REFVOLT_LEVEL_2_5, SHT_SOURCE_ACLK, SHT_CLOCK_DIV_1, SAMPLE_HOLD_4_CYCLES, SAMPCON_SOURCE_SMCLK, SAMPCON_CLOCK_DIV_1

//CHANNEL1 {INPUT_CHANNEL_A0, REFERENCE_VREFplus_AVss}
//CHANNEL2 {INPUT_CHANNEL_A1, REFERENCE_VREFplus_AVss}
//CHANNEL3 {INPUT_CHANNEL_A2, REFERENCE_VREFplus_AVss}
//CHANNEL4 {INPUT_CHANNEL_A3, REFERENCE_VREFplus_AVss}
//CHANNEL5 {INPUT_CHANNEL_A4, REFERENCE_VREFplus_AVss}
//CHANNEL6 {INPUT_CHANNEL_A5, REFERENCE_VREFplus_AVss}

const  msp430adc12_channel_config_t config = {CHANNEL1, CONFIG_VREF};
// adc12memctl_t  struct defined in Msp430Adc12.h
adc12memctl_t memctl[5] = {{CHANNEL2},{CHANNEL3},{CHANNEL4},{CHANNEL5},{CHANNEL6}};
//adc12memctl_t memctl[2] = {{INPUT_CHANNEL_A1, REFERENCE_VREFplus_AVss},{INPUT_CHANNEL_A2, REFERENCE_VREFplus_AVss}};


uint8_t numMemctl = 5; //numMemctl counts channels after the first one.
uint16_t buffer[BUFFER_SIZE];
//  AdcConfigure.getConfiguration() is not called from 
// inside ch12AdcP when a getData is asked for.  We defined data
// above as const config and use it below as &config.
//WE could call ch12AdcP.AdcConfigure to get a default stored there.
// Istead, we use the config assembled above, since it 
// is more general to use with other configs for
//  other than moisture sensors.

  event void Boot.booted() 
  {
    call Resource.request();
  }

  event void Resource.granted()
  {
//Get defaultconfig to satisfy Msp430Adc12MultiChannel.
       const msp430adc12_channel_config_t* defaultconfig = call AdcConfigure.getConfiguration(); 
//configure  with &config, to change ref volts
    if ( call ch12Adc.configure(defaultconfig, memctl, numMemctl, buffer, bufferlen, jiffies) == SUCCESS){
    call Leds.led0On();  //debug aid
    call ch12Adc.getData();
    }
  }

//  async command error_t Resource.request()
//    {
//    }

  async event void ch12Adc.dataReady(uint16_t *buffreturn, uint16_t buffreturnlen) 
    {
    call Leds.led1On();  //debug aid
    if ( buffreturnlen == BUFFER_SIZE )   // put something better jg24aug07
      {
        call Leds.led1On();
      }
    else
      {
        call Leds.led2On();
      }
    }

}

// .getData
//send to serial port, serial forwarder, oscilloscope
//repeat when user button pressed



