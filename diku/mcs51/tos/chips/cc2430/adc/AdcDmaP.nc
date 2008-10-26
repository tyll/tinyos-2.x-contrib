
/*
 * Copyright (c) 2007 University of Copenhagen
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * 
 * @author Marcus Chang
 *
 */

module AdcDmaP {

  provides interface Init;
  provides interface AdcControl[uint8_t id];
  provides interface Read<int16_t>[uint8_t id];
  uses interface Dma;

}

implementation
{

#include "Adc.h"
#include "dma.h"

  uint8_t references[uniqueCount("UNIQUE_ADC_PORT")];
  uint8_t resolutions[uniqueCount("UNIQUE_ADC_PORT")];
  uint8_t inputs[uniqueCount("UNIQUE_ADC_PORT")];
  bool inUse[uniqueCount("UNIQUE_ADC_PORT")];

  uint8_t counter;
  uint8_t lastId = uniqueCount("UNIQUE_ADC_PORT");

  int16_t value;
  dma_config_t * dmaConfig;
  
  command error_t Init.init() {
    uint8_t i; 
 
    for (i = 0; i < uniqueCount("UNIQUE_ADC_PORT"); i++) {
      inUse[i] = FALSE;
    }

    counter = 0;  

    /* setup DMA for ADC values */
    dmaConfig = call Dma.getConfig();

    dmaConfig->SRCADDR   = (uint16_t) 0xDFBA;          // address of source 
    dmaConfig->DESTADDR  = (uint16_t) &value;    // address of destination       
    dmaConfig->LEN       = 1;
    dmaConfig->VLEN      = VLEN_USE_LEN;  // Using LEN to determine how many bytes to transfer
    dmaConfig->IRQMASK   = TRUE;          // Issue an IRQ upon completion.
    dmaConfig->DESTINC   = DESTINC_0;     // The destination address is to be incremented by 1 after each transfer
    dmaConfig->SRCINC    = SRCINC_0;      // The source address inremented by 1 byte after each transfer
    dmaConfig->TRIG      = DMATRIG_ADC_CHALL;  // The DMA channel will be started manually
    dmaConfig->WORDSIZE  = WORDSIZE_WORD; // One byte is transferred each time.
    dmaConfig->TMODE     = TMODE_SINGLE_REPEATED;   // The number of bytes specified by LEN is transferred
    
    return SUCCESS;
  }


  command void AdcControl.enable[uint8_t id](uint8_t reference, uint8_t resolution, uint8_t input) {

    /* enable interrupt when a channel is enabled (and stop any sampling in progress */
    if (counter == 0) {
      ADC_STOP();
      
      call Dma.armChannel();
    }

    /* enable channel if not already enabled */
    if (!inUse[id]) {
        inUse[id] = TRUE;
        counter++;
    }

    /* save parameters */
    references[id] = reference;
    resolutions[id] = resolution;
    inputs[id] = input;

  }

  command void AdcControl.disable[uint8_t id]() {

    /* disable channel if it has been enabled */
    if (inUse[id]) {
      inUse[id] = FALSE;
      counter--;

      /* disable interrupts if no more channels are used by ADC */
      if (counter == 0) {
        call Dma.stopTransfer();
      }
    }  
  }

  /**
   * Initiates a read of the value.
   * 
   * @return SUCCESS if a readDone() event will eventually come back.
   */
  command error_t Read.read[uint8_t id]() {

    /* check if ADC is in use */
    if (lastId < uniqueCount("UNIQUE_ADC_PORT")) {
        return FAIL;
    } else {
        uint8_t temp;

        /* remember caller */
        lastId = id;

        /* set channel as input */
        ADC_ENABLE_CHANNEL(inputs[id]);  

        /* configure ports */
        ADC_SEQUENCE_SETUP(references[id] | resolutions[id] | inputs[id]);

        /* start conversion */
        ADC_SAMPLE_SINGLE();

        return SUCCESS;
    }
  }

  task void signalReadDone();
  
  async event void Dma.transferDone() {
    post signalReadDone();  
  }

  task void signalReadDone() {
    uint8_t tmp;
    
    tmp = lastId;

    /* mark ADC as not in use */
    lastId = uniqueCount("UNIQUE_ADC_PORT");
  
    /* map out value according to resolution */
    value >>= (8 - (resolutions[tmp] >> 3));

    /* disable ADC channel */    
    ADC_DISABLE_CHANNEL(inputs[tmp]);    

    signal Read.readDone[tmp](SUCCESS, value);    
  }

  default event void Read.readDone[uint8_t id](error_t result, int16_t val) {

  }
  
}
