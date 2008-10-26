
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
 * CC2430 Specific ADC control interface. It mimic the ChipCon control
 * library
 * 
 * @author Marcus Chang
 *
 */

interface AdcControl {

  /**
   * Enables the ADC for the chosen channel with the specified settings.
   * Also, enables interrupts and disables any current sampling.
   * 
   * @param reference - Reference voltage. Possible choices:
   *    ADC_REF_1_25_V      0x00 // Internal 1.25V reference
   *    ADC_REF_P0_7        0x40 // External reference on AIN7 pin
   *    ADC_REF_AVDD        0x80 // AVDD_SOC pin
   *    ADC_REF_P0_6_P0_7   0xC0 // External reference on AIN6-AIN7 differential input
   *
   * @param resolution - ADC conversion resoltion. Possible values:
   *    ADC_8_BIT           0x00     //  64 decimation rate
   *    ADC_10_BIT          0x10     // 128 decimation rate
   *    ADC_12_BIT          0x20     // 256 decimation rate
   *    ADC_14_BIT          0x30     // 512 decimation rate
   * @param input - ADC input channel. Possible values:
   *    ADC_AIN0            0x00     // single ended P0_0
   *    ...
   *    ADC_AIN7            0x07     // single ended P0_7
   *    ADC_GND             0x0C     // Ground
   *    ADC_TEMP_SENS       0x0E     // on-chip temperature sensor
   *    ADC_VDD_3           0x0F     // (vdd/3)
   */
  command void enable(uint8_t reference, uint8_t resolution, uint8_t input);
  command void disable();
}
