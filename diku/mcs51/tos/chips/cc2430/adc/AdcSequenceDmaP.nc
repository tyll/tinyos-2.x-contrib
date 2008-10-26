
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
/*
 * 
 * @author Marcus Chang
 *
 */

module AdcSequenceDmaP {

  provides interface Init;
  provides interface AdcControl;
  provides interface StdControl as PortControl[uint8_t id];
  provides interface Read<int16_t>[uint8_t id];
  uses interface Dma as Dma1;
  uses interface Dma as Dma2;
  uses interface StdOut;

}

implementation
{

#include "Adc.h"
#include "dma.h"

  uint8_t reference;
  uint8_t resolution;
  uint8_t input;

  uint8_t counter = 0;

  dma_config_t * dmaConfigValue, * dmaConfigRegister;
  
  int16_t adc_value[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
  uint8_t adc_port[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
  bool inUse[] = { FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE };
    
  command error_t Init.init() {
    
    dmaConfigValue = call Dma1.getConfig();
    dmaConfigRegister = call Dma2.getConfig();

    /* setup DMA for ADC values */
    dmaConfigValue->SRCADDR = (uint16_t) 0xDFBA;          // address of source 
    dmaConfigValue->DESTADDR = (uint16_t) &adc_value[0];    // address of destination       
    dmaConfigValue->VLEN      = VLEN_USE_LEN;  // Using LEN to determine how many bytes to transfer
    dmaConfigValue->IRQMASK   = TRUE;          // Issue an IRQ upon completion.
    dmaConfigValue->DESTINC   = DESTINC_1;     // The destination address is to be incremented by 1 after each transfer
    dmaConfigValue->SRCINC    = SRCINC_0;      // The source address inremented by 1 byte after each transfer
    dmaConfigValue->TRIG      = DMATRIG_ADC_CHALL;  // The DMA channel will be started manually
    dmaConfigValue->WORDSIZE  = WORDSIZE_WORD; // One byte is transferred each time.
    dmaConfigValue->TMODE     = TMODE_SINGLE_REPEATED;   // The number of bytes specified by LEN is transferred

    /* setup DMA for port reading */
    dmaConfigRegister->SRCADDR = (uint16_t) 0xDFB5;          // address of source 
    dmaConfigRegister->DESTADDR = (uint16_t) &adc_port[0];    // address of destination       
    dmaConfigRegister->VLEN      = VLEN_USE_LEN;  // Using LEN to determine how many bytes to transfer
    dmaConfigRegister->IRQMASK   = TRUE;          // Issue an IRQ upon completion.
    dmaConfigRegister->DESTINC   = DESTINC_1;     // The destination address is to be incremented by 1 after each transfer
    dmaConfigRegister->SRCINC    = SRCINC_0;      // The source address inremented by 1 byte after each transfer
    dmaConfigRegister->TRIG      = DMATRIG_ADC_CHALL;  // The DMA channel will be started manually
    dmaConfigRegister->WORDSIZE  = WORDSIZE_BYTE; // One byte is transferred each time.
    dmaConfigRegister->TMODE     = TMODE_SINGLE_REPEATED;   // The number of bytes specified by LEN is transferred

    
    return SUCCESS;
  }

  command void AdcControl.enable(uint8_t ref, uint8_t res, uint8_t in) {

    /* enable ADC interrupt */
    ADCIE = 1;
    ADC_STOP();
 
    /* save parameters */
    reference = ref;
    resolution = res;
    input = in;

    /* setup sequence */
    ADC_SEQUENCE_SETUP(reference | resolution | ADC_AIN7);

  }

  command void AdcControl.disable() {

    /* disable ADC interrupt */
    ADCIE = 0; 
  }


  /****************************************************************************
  **
  ****************************************************************************/
  command error_t PortControl.start[uint8_t id]() {
  
    /* enable channel if not already enabled */
    if (!inUse[id]) {
        inUse[id] = TRUE;
        ADC_ENABLE_CHANNEL(id);  

        /* number of ADC values to be transfered by DMA */
        counter++;
        dmaConfigValue->LEN = counter;
        dmaConfigRegister->LEN = counter;

        if (counter == 1) {
            call Dma1.armChannel();
            call Dma2.armChannel();
        }
    }
 
  
    return SUCCESS;
  }
 
  command error_t PortControl.stop[uint8_t id]() {
  
    /* disable channel if not already disabled */
    if (inUse[id]) {
        inUse[id] = FALSE;
        ADC_DISABLE_CHANNEL(id);  

        /* number of ADC values to be transfered by DMA */
        counter--;
        dmaConfigValue->LEN = counter;
        dmaConfigRegister->LEN = counter;

        if (counter == 0) {
            call Dma1.stopTransfer();
            call Dma2.stopTransfer();
        }
    }
 
    return SUCCESS;
  }


  /****************************************************************************
  **
  ****************************************************************************/
  command error_t Read.read[uint8_t id]() {

    /* start conversion sequence */        
    ADC_SAMPLE_SINGLE();
//    ADC_SAMPLE_CONTINUOUS();

    /* setup extra conversion of the reference voltage */
    ADC_SINGLE_CONVERSION(ADC_REF_AVDD | ADC_14_BIT | ADC_PVR);
    
    return SUCCESS;  
  }
   

  task void signalReadDone();
  int16_t value;

  async event void Dma1.transferDone() {
//    call StdOut.print("DMA val\n\r");              
  }

  async event void Dma2.transferDone() {
//    call StdOut.print("DMA reg\n\r");          
  }

  /* Interrupt handler */
  MCS51_INTERRUPT(SIG_ADC) {

    /* read reference value from register */        
    value = (( (uint16_t) ADCH) << 8);
    value |= ADCL;

    /* extra conversion done - process readings */
    post signalReadDone();
  }

  task void signalReadDone() {
    uint8_t i, id, res;
    error_t result;
      
    /* map out reference value according to resolution */
    value >>= 2;
        
    /* if reference value is correct, assume conversion is correct */
    if (value == 0x01FF)
        result = SUCCESS;
    else
        result = FAIL;
        
    /* setup resolution shifting */        
    res = (8 - (resolution >> 3));

    /* traverse adc readings */
    for (i = 0; i < counter; i++) {

        /* read port id from register */    
        id = ((adc_port[i] & 0x0F) - 1);
        
        /* buggy cc2430 */
        id = (id == 0x0C) ? 0x07 : id;

        /* signal value */        
        signal Read.readDone[id](result, adc_value[i] >> res);    

//        call StdOut.print("ID: ");
//        call StdOut.printHex(id);
//        call StdOut.print(": ");
//        call StdOut.printHexword(adc_value[i]);
//        call StdOut.print("\n\r");                
    }

//    call StdOut.print("\n\r");        

  }

  default event void Read.readDone[uint8_t id](error_t result, int16_t val) { }

  async event void StdOut.get(uint8_t c) {
  }
}
