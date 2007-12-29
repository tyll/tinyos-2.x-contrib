/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * by John Griessen <john@ecosensory.com>
 * Rev 1.0 14 Dec 2007
 */
#include <Timer.h>
#include "ReadMoistureSensors.h"
#include "Msp430Adc12.h"
#include "a2d12ch.h"

module ReadMoistureSensorsP {
  // uses interface Packet;
  uses interface AMSend;
  uses interface SplitControl as AMRadioOn;
  uses interface Timer<TMilli>  as timer0;
  uses interface Boot;
  uses interface Leds;
  uses interface Resource;
  uses interface Msp430Adc12MultiChannel as a2d12ch;
  uses interface AdcConfigure<const msp430adc12_channel_config_t*>;
}
implementation {
  bool busy = FALSE;  //Used by AMSend
  message_t pkt;   //Used by AMSend
  uint8_t pktlen; //Used by AMSend
  uint16_t timestamp = 0;
  uint16_t TOS_NODEID;

//uint8_t samplesperbank = 1;
uint8_t jiffies = JIFFIES;
uint16_t buffer[BUFFER_SIZE];   //see a2d12ch.h
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
//  AdcConfigure.getConfiguration() is not called from 
// inside a2d12chP when a getData is asked for.  We defined data
// above as const config and use it below as &config.
//WE could call a2d12chP.AdcConfigure to get a default stored there.
// Istead, we use the config assembled above, since it 
// is more general to use with other configs for
//  other than moisture sensors.

  task void MoistureSensorsMsgSend();
  
  event void Boot.booted() {
    call AMRadioOn.start();  //AMRadio renames SplitControl, Start comes from it. 
                   //this is simplistic.  NOT low power since radio on indefinitely.


  }
  event void AMRadioOn.startDone(error_t starterr) {
    if (starterr == SUCCESS) {
       call timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMRadioOn.start();
    }
  }
  event void AMRadioOn.stopDone(error_t starterr) { 
  }     // stopDone required by SplitControl do nothing.
    
  event void timer0.fired() {   //From Timer<TMilli>
    atomic {
      timestamp++;   //a simplistic timestamp value to put in data slot for now.
      }
//    call Leds.set(timestamp);  //skip LEDs after debugged
    atomic  {
      if (!busy) {       //AMSend not in progress 
        call Resource.request();
      }
    }
  }

  event void Resource.granted()
  {
          //to satisfy Msp430Adc12MultiChannel.
    const msp430adc12_channel_config_t* defaultconfig = 
    call AdcConfigure.getConfiguration();  //to satisfy Msp430Adc12MultiChannel.

        // start the adc read, (can also use defaultconfig from above).
    if ( call a2d12ch.configure(&config, memctl, numMemctl, buffer, bufferlen, jiffies) == SUCCESS){
      call Leds.led0On();  //debug aid
      call a2d12ch.getData();  // returns data in buffer, (a pointer), numSamples integer
    }
  }


  event void AMSend.sendDone(message_t* msg, error_t sendresult) {
    call Leds.led0Off();  //debug aid
    call Leds.led1Off();  //debug aid
    call Leds.led2Off();  //debug aid
        if (&pkt == msg) {  // req'd when others could be sending "which msg?" ....
        // if (sendresult ==  SUCCESS) {   much lighter test than (&pkt == msg) ....
      atomic {
        busy = FALSE;
      }
    }
  }
//  also when timer fired... {
      //sort adc read values into nx_struct MoistureSensorsMsg here.

  async event void a2d12ch.dataReady(uint16_t *buffer, uint16_t bufferlen) 
  {
    post MoistureSensorsMsgSend();
  }

  task void MoistureSensorsMsgSend()  
  {
    MoistureSensorsMsg* rmspkt = (MoistureSensorsMsg*) (call AMSend.getPayload(&pkt, pktlen));  //09dec07jg
    //cast result of .getPayload to pointer of nx_struct MoistureSensorsMsg*
    rmspkt->nodeid = TOS_NODEID;
    rmspkt->timestamp = timestamp;
    call Leds.led1On();  //debug aid
    if ( bufferlen == 12 )   // 12 Adc values in a vector, len == 12
    {
      rmspkt->adc00 = buffer[0];
      rmspkt->adc01 = buffer[1];
      rmspkt->adc02 = buffer[2];
      rmspkt->adc03 = buffer[3];
      rmspkt->adc04 = buffer[4];
      rmspkt->adc05 = buffer[5];
      rmspkt->adc10 = buffer[6];
      rmspkt->adc11 = buffer[7];
      rmspkt->adc12 = buffer[8];
      rmspkt->adc13 = buffer[9];
      rmspkt->adc14 = buffer[10];
      rmspkt->adc15 = buffer[11];
      //rmspkt struct is now filled with new data.
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(MoistureSensorsMsg)) == SUCCESS) 
      {
        call Leds.led2On();  //debug aid
        busy = TRUE;  //the data is queued to go out.
      }
    }
    else
    {
      rmspkt->adc00 = 0xff;  //error value
      rmspkt->adc01 = 0xff;
      rmspkt->adc02 = 0xff;
      rmspkt->adc03 = 0xff;
      rmspkt->adc04 = 0xff;
      rmspkt->adc05 = 0xff;
      rmspkt->adc10 = 0xff;
      rmspkt->adc11 = 0xff;
      rmspkt->adc12 = 0xff;
      rmspkt->adc13 = 0xff;
      rmspkt->adc14 = 0xff;
      rmspkt->adc15 = 0xff;
      //rmspkt struct is now filled with error flags.
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(MoistureSensorsMsg)) == SUCCESS) 
      {
        call Leds.led2On();  //debug aid
        busy = TRUE;  //the data is queued to go out.
      }
    }
      call Resource.release();
  }

}
  
