/* 
 * Copyright (c) 2007, Ecosensory
 * -- Use per TOS Alliance license. If not found in your distr. 
 *     see http://tinyos.net/licenses/toslicense.txt --
 * $Revision: 1.0  a2d12chP.nc
 * $Date: 02sep2007
 * @author: John Griessen <john@ecosensory.com>
 * ============================================================
 */
module a2d12chP {
  uses  {
    interface Msp430Adc12MultiChannel as multichannel;
//    interface GeneralIO as bankSelect;
    interface Leds; //debug aid
    interface Resource as ResourceRVG;
  }
  provides {
    interface Msp430Adc12MultiChannel as a2d12ch;
    interface AdcConfigure<const msp430adc12_channel_config_t*>;
    interface Resource;
  }
// same configuration for all 12 channels. ( 6 to start)
// returns different numSamples than start with, since getting
// two 6 channel buffers full, averaging down each, 
// and combining them.
}
implementation
{
#include "a2d12ch.h"
#include "Msp430Adc12.h"
const  msp430adc12_channel_config_t defaultconfig = {INPUT_CHANNEL_A0, REFERENCE_VREFplus_AVss, CONFIG_VREF};
  async command const msp430adc12_channel_config_t* AdcConfigure.getConfiguration()
  {
    return &defaultconfig;
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

 async command error_t a2d12ch.configure(const msp430adc12_channel_config_t *config, adc12memctl_t *memctl, uint8_t numMemctl, uint16_t *buffer, uint16_t numSamples, uint16_t jiffies)
  {
    if (call multichannel.configure(config, memctl, numMemctl, buffer, numSamples, jiffies) == SUCCESS) {
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
    //save the data and change the mux select...
//      call multichannel.getData();    //get another buffer full
//  average the first buffer, put in first group of buffer1
//  average the 2nd buffer put in 2nd group of buffer2
// copy buffer1[0-5] to buffer2[0-5]
// update numSamples to be 12 instead of 12 * X
//  done.
//  call Leds.led2On();  //debug aid
    signal a2d12ch.dataReady(buffer, numSamples);
  }
}

