/* Copyright (c) 2007, Tor Petterson <motor@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
  @author Tor Petterson <motor@diku.dk>
*/

#ifndef _H_Hcs08ADC_h
#define _H_Hcs08ADC_h

/* Adc channels */
enum 
{
  Hcs08_ADC_CH0 = 0,
  Hcs08_ADC_CH1 = 1,
  Hcs08_ADC_CH2 = 2,
  Hcs08_ADC_CH3 = 3,
  Hcs08_ADC_CH4 = 4,
  Hcs08_ADC_CH5 = 5,
  Hcs08_ADC_CH6 = 6,
  Hcs08_ADC_CH7 = 7,
  Hcs08_ADC_VREFH = 0x1E,
  Hcs08_ADC_VREFL = 0x1F
};

/* Prescaler values */
enum
{
  Hcs08_ADC_PRESCALE_2 = 0x0,
  Hcs08_ADC_PRESCALE_4 = 0x1,
  Hcs08_ADC_PRESCALE_6 = 0x2,
  Hcs08_ADC_PRESCALE_8 = 0x3,
  Hcs08_ADC_PRESCALE_10 = 0x4,
  Hcs08_ADC_PRESCALE_12 = 0x5,
  Hcs08_ADC_PRESCALE_14 = 0x6,
  Hcs08_ADC_PRESCALE_16 = 0x7,
  Hcs08_ADC_PRESCALE_18 = 0x8,
  Hcs08_ADC_PRESCALE_20 = 0x9,
  Hcs08_ADC_PRESCALE_22 = 0xA,
  Hcs08_ADC_PRESCALE_24 = 0xB,
  Hcs08_ADC_PRESCALE_26 = 0xC,
  Hcs08_ADC_PRESCALE_28 = 0xD,
  Hcs08_ADC_PRESCALE_30 = 0xE,
  Hcs08_ADC_PRESCALE_32 = 0xF
};

#define UQ_HCS08ADC_RESOURCE "hcs08adc.resource"

#endif //_H_Hcs08ADC_h