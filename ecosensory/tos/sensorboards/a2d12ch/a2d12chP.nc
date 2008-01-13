/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 *  This code funded by TX State San Marcos University. BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * by John Griessen <john@ecosensory.com>
 * Rev 1.0 14 Dec 2007
 */
module a2d12chP {
  uses  {
    interface Msp430Adc12MultiChannel as multichannel;
    interface Leds; //debug aid
    interface Resource as ResourceRVG;
  }
  provides {
    interface Msp430Adc12MultiChannel as a2d12ch;
    interface AdcConfigure<const msp430adc12_channel_config_t*>;
    interface Resource;
  }
// same configuration for all channels. ( 6 per bank)
// will return averaged down numSamples in future...or just
// do the averaging in ReadMoistureSensors app.
}
implementation
{
#include "a2d12ch.h"
#include "Msp430Adc12.h"
const  msp430adc12_channel_config_t config = {CHANNEL1, CONFIG_VREF};  //see a2d12ch.h

  async command const msp430adc12_channel_config_t* AdcConfigure.getConfiguration()
  {
    return &config;
  }

 async command error_t a2d12ch.configure(const msp430adc12_channel_config_t *a2d12chconfig, adc12memctl_t *memctl, uint8_t numMemctl, uint16_t *buffer, uint16_t numSamples, uint16_t jiffies)
  {
    if (call multichannel.configure(a2d12chconfig, memctl, numMemctl, buffer, numSamples, jiffies) == SUCCESS) {
//   call Leds.led0On();  //debug aid
      return SUCCESS;  
    }
    else
      return FAIL; //how do you return all the errs, and does it matter?
  }
  async command error_t a2d12ch.getData()
  //   getData( samplesperbank, jiffies)
//numsamples*6 is buffer size
  {
   if (call multichannel.getData() == SUCCESS) {
// Puts data in buffer.
//  call Leds.led1On();  //debug aid
     return SUCCESS;
       }
     else
     return FAIL; //how do you return all the errs, and does it matter?
//   return call multichannel.getData();
  }

  async event void multichannel.dataReady(uint16_t *buffer, uint16_t numSamples)
 {
//  call Leds.led2On();  //debug aid
    signal a2d12ch.dataReady(buffer, numSamples);
  }

  async command error_t Resource.request()
  {
    return call  ResourceRVG.request();
  }

  async command error_t Resource.release()
  {
    return call  ResourceRVG.release();
  }

async command error_t Resource.immediateRequest()
  {
    return call  ResourceRVG.immediateRequest();
  }
  async command bool  Resource.isOwner()
  {
    return call  ResourceRVG.isOwner();
  }

  event void ResourceRVG.granted()
  {
    signal  Resource.granted();
  }

}

