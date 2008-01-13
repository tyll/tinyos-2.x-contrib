/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 *  This code funded by TX State San Marcos University. BSD license full text at: 
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
  uses interface Timer<TMilli>  as timer1;
  uses interface Timer<TMilli>  as timer2;
  uses interface Timer<TMilli>  as timer3;
  uses interface Boot;
  uses interface Leds;
  uses interface Resource;
  uses interface Msp430Adc12MultiChannel as a2d12ch;
  uses interface HplMsp430GeneralIO as   a2dbankselect;
  uses interface HplMsp430GeneralIO as   a2dmuxdisable;
  uses interface HplMsp430GeneralIO as   a2dsenvdd1drv;
  uses interface HplMsp430GeneralIO as   a2dsenvdd2drv;
  uses interface HplMsp430GeneralIO as   a2dterm2drv;
  uses interface AdcConfigure<const msp430adc12_channel_config_t*>;
}
implementation {
  bool busy = FALSE;  //Used by AMSend
  bool bank1 = FALSE;  //Used by  a2d12ch.dataReady
  message_t pkt;   //Used by AMSend
//  message_t rmspkt; //old way 
  MoistureSensorsMsg* rmspkt; //jg08jan08  needs testing.
  uint8_t pktlen; //Used by AMSend
//  uint16_t timerend = 0;   //del a.
  uint16_t timestamp = 0;
  uint16_t TOS_NODEID;

//uint8_t samplesperbank = 1;
uint8_t jiffies = JIFFIES;
uint16_t buffer[BUFFER_SIZE];   //see a2d12ch.h
uint16_t  bufferlen = BUFFER_SIZE;
//  ref volt from generator = 2.50 Volts
//CHANNEL1 {INPUT_CHANNEL_A0, REFERENCE_VREFplus_AVss}  see a2d12ch.h
//CHANNEL2 {INPUT_CHANNEL_A1, REFERENCE_VREFplus_AVss}
//CHANNEL3 {INPUT_CHANNEL_A2, REFERENCE_VREFplus_AVss}
//CHANNEL4 {INPUT_CHANNEL_A3, REFERENCE_VREFplus_AVss}
//CHANNEL5 {INPUT_CHANNEL_A4, REFERENCE_VREFplus_AVss}
//CHANNEL6 {INPUT_CHANNEL_A5, REFERENCE_VREFplus_AVss}
// adc12memctl_t  struct defined in Msp430Adc12.h
adc12memctl_t memctl[5] = {{CHANNEL2},{CHANNEL3},{CHANNEL4},{CHANNEL5},{CHANNEL6}};
//adc12memctl_t memctl[2] = {{INPUT_CHANNEL_A1, REFERENCE_VREFplus_AVss},{INPUT_CHANNEL_A2, REFERENCE_VREFplus_AVss}};
uint8_t numMemctl = 5; //numMemctl counts channels after the first one.


//  AdcConfigure.getConfiguration() is called from  here
// inside a2d12chP when a getData event happens.  
//  We defined data
// above as const config and use it below as &config.
//We use the call a2d12chP.AdcConfigure to get config data in a2d12chP.
//  memctl and buffer lengt do not need to be defined in the a2d12chP module.
//  They are about how much data, not the config.
  task void MoistureSensorsMsgSend();
  task void MoistureSensorsMsgBank1();
  task void MoistureSensorsMsgBank2();
  
  event void Boot.booted() {
    call AMRadioOn.start();  //AMRadio renames SplitControl, Start comes from it. 
                   //this is simplistic.  NOT low power since radio on indefinitely.
    call a2dbankselect.selectIOFunc();
    call a2dbankselect.makeOutput();
    call a2dbankselect.clr();  //first state is LO to choose SENSIG1 muxed.
    call a2dmuxdisable.selectIOFunc();
    call a2dmuxdisable.makeOutput();
    call a2dmuxdisable.set();  //first state is HI to choose mux disabled.
    call a2dsenvdd1drv.selectIOFunc();
    call a2dsenvdd1drv.makeOutput();
    call a2dsenvdd1drv.clr();  //first state is  LO to choose senvdd1 off.
    call a2dsenvdd2drv.selectIOFunc();
    call a2dsenvdd2drv.makeOutput();
    call a2dsenvdd2drv.clr();  //first state is LO to choose senvdd2 off.
    call a2dterm2drv.selectIOFunc();
    call a2dterm2drv.makeOutput();
    call a2dterm2drv.set();  //first state is HI to choose term2 cutoff.

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
//    timerend = call  timer0.getNow();  // time senvdd1 was turned on.  del a.
//    call timer3.startOneShotAt(timerend, ALWAYS_SHUTOFF_MILLI);    del a.
    call timer1.startOneShot(ECH2O_WARMUP_MILLI);
    call timer3.startOneShot(ALWAYS_SHUTOFF_MILLI);
    atomic  { bank1 = TRUE;  // next data ready goes in bank1 data slots.
    }
    call a2dmuxdisable.clr();  //timer1 -->  LO to choose mux enabled.
    call a2dbankselect.clr();  //timer0 -->   LO to choose SENSIG1 muxed.
    call a2dsenvdd1drv.set();  //timer0 -->  set HI a2dsenvdd1drv.
    atomic {
      timestamp++;   //a simplistic timestamp value to put in data slot for now.
      }
    //   to let the ECH2O sensors get setup time done.
  }

  event void timer1.fired() {   //timer1 dt = ECH2O_WARMUP_MILLI
//    timerend = call  timer1.getNow();  // time senvdd2 was turned on.  del a.
    call timer2.startOneShot(ECH2O_WARMUP_MILLI);
    call a2dsenvdd2drv.set();  //timer1 -->  set HI a2dsenvdd2drv.
    atomic  {
      if (!busy) {       //AMSend not in progress 
        call Resource.request();  // Resource --> adc12multichannel
    // 08jan08JG  get the outgoing packet payload pointer, (and default len).
    //09dec07jg    //cast result of .getPayload to pointer rmspkt.
    rmspkt = (MoistureSensorsMsg*) (call AMSend.getPayload(&pkt, pktlen));
    rmspkt->nodeid = TOS_NODEID;  //  outgoing packet struct empty of a2d data.
      }
    }
  }

  event void timer2.fired() {   //timer2 dt = ECH2O_WARMUP_MILLI
    call a2dmuxdisable.clr();  //timer2 -->  LO to choose mux enabled.
    call a2dbankselect.set();  //timer1 -->   HI to choose SENSIG2 muxed.
    atomic  {
    bank1 = FALSE;  // next data ready goes in bank2 data slots.
      if (!busy) {       //AMSend not in progress 
        call Resource.request();  // Resource --> adc12multichannel
    // use the same outgoing packet payload pointer, (and default len).
      }
    }
  }

  event void timer3.fired() {   //action when AMSend was busy
    call a2dmuxdisable.set();  //HI to choose mux disabled.
    call a2dsenvdd1drv.clr();  //LO to choose senvdd1 off.
    call a2dsenvdd2drv.clr();  //LO to choose senvdd2 off.
  }

  async event void a2d12ch.dataReady(uint16_t *readybuf, uint16_t readybuflen) 
  {
    atomic {
    bufferlen = readybuflen;  //probably can just not use *readybuf
    }
    //sort adc read values into nx_struct MoistureSensorsMsg.
    if (bank1 == TRUE) {       // async handling of banks. 
      rmspkt->timestamp = timestamp;  // 2nd bank will have delta from stamp.
      post MoistureSensorsMsgBank1();
    }
    else {
      post MoistureSensorsMsgBank2();
// do something to send message now
    post MoistureSensorsMsgSend();
    }
  }

  event void Resource.granted()  //resource meaning is "just the a2d channel"
  {
    const msp430adc12_channel_config_t* a2d12chconfig = call AdcConfigure.getConfiguration();  //to get setup from a2d12ch.
        // start the adc read, ( use a2d12chconfig from above).
    atomic {
    if ( call a2d12ch.configure(a2d12chconfig, memctl, numMemctl, buffer, bufferlen, jiffies) == SUCCESS){
      call Leds.led0On();  //debug aid
      call a2d12ch.getData();  // returns buffer[], bufferlen integer
    }
   }
  }

  event void AMSend.sendDone(message_t* msg, error_t sendresult) {
    call Leds.led0Off();  //debug aid
    call Leds.led1Off();  //debug aid
    call Leds.led2Off();  //debug aid
    if (&pkt == msg) {  // req'd when others could be sending "which msg?"
        // if (sendresult ==  SUCCESS)  lighter test than (&pkt == msg)
      atomic {
        busy = FALSE;
      }
    }
  }

  task void MoistureSensorsMsgBank1()
  { 
    //assign buffer[] elements to rmspkt  nx_struct elements.
    atomic 
    {
      rmspkt->adc00 = buffer[0];
      rmspkt->adc01 = buffer[1];
      rmspkt->adc02 = buffer[2];
      rmspkt->adc03 = buffer[3];
      rmspkt->adc04 = buffer[4];
      rmspkt->adc05 = buffer[5];
    }
    //rmspkt struct is now filled with new bank1 data.
      //  shut off bank1 related.
      call Resource.release();
      call a2dsenvdd1drv.clr();  //dataReady -->  a2dsenvdd1drv = LO.
  }

  task void MoistureSensorsMsgBank2()
  { 
    atomic 
    {
      rmspkt->adc10 = buffer[0];
      rmspkt->adc11 = buffer[1];
      rmspkt->adc12 = buffer[2];
      rmspkt->adc13 = buffer[3];
      rmspkt->adc14 = buffer[4];
      rmspkt->adc15 = buffer[5];
    }
      //  shut off bank2 related.
      call a2dmuxdisable.set();  //data stored -->  HI disables mux.
      call a2dsenvdd2drv.clr();  //data stored -->  a2dsenvdd2drv = LO.
      call Resource.release();
  }

  task void MoistureSensorsMsgSend()
  {

    call Leds.led1On();  //debug aid
    if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(MoistureSensorsMsg)) == SUCCESS) {
      call Leds.led2On();  //debug aid
      busy = TRUE;  //the data is queued to go out.
    }
  }
}
  
