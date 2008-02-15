/* 
 * Copyright (c) 2006, Technische Universitaet Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitaet Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

module AttributeEyesIFXTemperatureP
{
  provides {
    interface Attribute;
    interface AdcConfigure<const msp430adc12_channel_config_t*>;
  }
  uses {
    interface Resource;
    interface Msp430Adc12SingleChannel as AdcData;
  }
}
implementation
{
  const msp430adc12_channel_config_t config = {
    /* TEMP_SENSOR_LOW_FREQ */
        INPUT_CHANNEL_A0, REFERENCE_VREFplus_AVss, REFVOLT_LEVEL_1_5,
        SHT_SOURCE_ACLK, SHT_CLOCK_DIV_1, SAMPLE_HOLD_4_CYCLES,
        SAMPCON_SOURCE_ACLK, SAMPCON_CLOCK_DIV_1
    };
  
  typedef nx_uint16_t sensor_data_t; 
  
  enum {
    // as defined in attributes.xml
    PS_OPR_EQUALS = 0,
    PS_OPR_SMALLER = 1,
    PS_OPR_SMALLER_EQUAL = 2,
    PS_OPR_GREATER = 3,
    PS_OPR_GREATER_EQUAL = 4,
    PS_OPR_ANY = 5,
  };
  
  norace avpair_t *avpair;
  
  async command const msp430adc12_channel_config_t* AdcConfigure.getConfiguration()
  {
    return &config;
  }
  
  command error_t Attribute.getAttribute(avpair_t *_avpair)
  {
    error_t result = FAIL;
    if (!_avpair)
      result = EINVAL;
    if (avpair)
      result = EBUSY;
    else {
      result = call Resource.request();
      if (result == SUCCESS){
        avpair = _avpair;
      }
    }
    return result;
  }

  event void Resource.granted()
  {
    error_t result = call AdcData.configureSingle(&config);
    if (result == SUCCESS)
      result = call AdcData.getData();
    if (result != SUCCESS){
      call Resource.release();
      signal Attribute.attributeReady(result, avpair);
      avpair = 0;
    }
  }

  command error_t Attribute.getValueSize(uint8_t* valueSize)
  {
    *valueSize = sizeof(sensor_data_t);
    return SUCCESS;
  }
  
  command error_t Attribute.isMatching(const avpair_t *_avpair, const constraint_t *constraint)
  {
    uint16_t value1 = *((sensor_data_t*) _avpair->value);
    uint16_t value2 = *((sensor_data_t*) constraint->value);
    bool matching = FALSE;
    switch (constraint->operationID)
    {
      case PS_OPR_EQUALS: matching = (value1 == value2); break;
      case PS_OPR_SMALLER: matching = (value1 < value2); break;
      case PS_OPR_SMALLER_EQUAL: matching = (value1 <= value2); break;
      case PS_OPR_GREATER: matching = (value1 > value2); break;
      case PS_OPR_GREATER_EQUAL: matching = (value1 >= value2); break;
      case PS_OPR_ANY: matching = TRUE; break;
    }
    if (matching)
      return SUCCESS;
    return FAIL;
  }

  task void signalData()
  {
    signal Attribute.attributeReady(SUCCESS, avpair);
    avpair = 0;
  }

  async event error_t AdcData.singleDataReady(uint16_t data){
    call Resource.release();
    *((sensor_data_t*) avpair->value) = data;
    post signalData();
    return SUCCESS;
  }
  async event uint16_t* AdcData.multipleDataReady(uint16_t *buffer, uint16_t
      numSamples){
    return SUCCESS;
  }
}




