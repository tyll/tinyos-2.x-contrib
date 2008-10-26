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
 * This modules groups the 3 axises of an accellerometer to one
 * ThreeAxisAccel inteface
 *
 * @author Marcus Chang
 *
 */

#include "Timer.h"
#include "CC2430_CSP.h"
#include "ioCC2430.h"

#include "Adc.h"
#define BUTTON_PUSH         0x01
#define ADC_INPUT_JOYSTICK_PUSH    0x05
#define ADC_INPUT_JOYSTICK    0x06
#define ADC_INPUT_POT   0x07

#define ACCELEROMETER_X_AXIS 0x02
#define ACCELEROMETER_Y_AXIS 0x03
#define ACCELEROMETER_Z_AXIS 0x04

#define ADC_INPUT_GND   0x0C
#define ADC_INPUT_REF   0x0D
#define ADC_INPUT_TMP   0x0E
#define ADC_INPUT_VDD3  0x0F


#define SAMPLE_INTERVAL 0x0800

module AccelerometerM {

  provides interface StdControl;
  provides interface ThreeAxisAccel;

  uses interface AdcControl as xControl;
  uses interface Read<int16_t> as x;
  uses interface AdcControl as yControl;
  uses interface Read<int16_t> as y;
  uses interface AdcControl as zControl;
  uses interface Read<int16_t> as z;
  uses interface AdcControl as referenceControl;
  uses interface Read<int16_t> as reference;
}
implementation
{

  /****************************************************************************
  ** StdControl
  ****************************************************************************/
  command error_t StdControl.start() {

//    call xControl.enable(ADC_REF_AVDD, ADC_14_BIT, ADC_INPUT_POT);

    call xControl.enable(ADC_REF_AVDD, ADC_14_BIT, 0x01); // pin 3

//    call xControl.enable(ADC_REF_AVDD, ADC_14_BIT, 0x03); // pin 4

    call yControl.enable(ADC_REF_AVDD, ADC_14_BIT, 0x04); // pin 6
    call zControl.enable(ADC_REF_AVDD, ADC_14_BIT, 0x07); // pin 9


//    call yControl.enable(ADC_REF_AVDD, ADC_14_BIT, ACCELEROMETER_Y_AXIS);
//    call zControl.enable(ADC_REF_AVDD, ADC_14_BIT, ACCELEROMETER_Z_AXIS);

    call referenceControl.enable(ADC_REF_1_25_V, ADC_14_BIT, ADC_INPUT_GND);

    /* set sleep pin high on accelerometer to wakeup device*/
//    P0_DIR |= 0x02;
//    P0_1 = 1;

    /* LEDS */
    P0_DIR |= 0x60;
    P0_5 = 0;
    P0_6 = 0;

    return SUCCESS;
  }

  command error_t StdControl.stop() {

    call xControl.disable();
    call yControl.disable();
    call zControl.disable();
    call referenceControl.disable();

    /* set sleep pin low on accelerometer to make device sleep */
//    P0_DIR |= 0x02;
//    P0_1 = 0;
  
    return SUCCESS;
  }


  /****************************************************************************
  ** ThreeAxisAccel
  ****************************************************************************/
  command error_t ThreeAxisAccel.setRange(uint8_t range) { 

    /* set range on accelerometer by manipulating pins */  
//    P0_DIR |= 0x81;    

/*
    switch(range) {
        case ACCEL_RANGE_2x5G:
            P0_0 = 0;
            P0_7 = 0;
            break;
        case ACCEL_RANGE_6x7G:
            P0_0 = 1;
            P0_7 = 0;
            break;
        case ACCEL_RANGE_3x3G:
            P0_0 = 0;
            P0_7 = 1;
            break;
        case ACCEL_RANGE_10x0G:
            P0_0 = 1;
            P0_7 = 1;
            break;
        default:
            P0_0 = 0;
            P0_7 = 0;
    }
*/

    return SUCCESS; 
  }
    

  int16_t xval, yval, zval;
  
  command error_t ThreeAxisAccel.getData() {

    call x.read();

    return SUCCESS;
  }

  event void x.readDone( error_t result, int16_t val ) {

    call y.read();
    
    xval = val;
  }

  event void y.readDone( error_t result, int16_t val ) {
  
    call z.read();
    
    yval = val;
  }

  event void z.readDone( error_t result, int16_t val ) {

    call reference.read();
    
    zval = val;
  }

  event void reference.readDone( error_t result, int16_t val ) {

    /* blink */
//    P0_6 = P0_6 ? 0 : 1;

    signal ThreeAxisAccel.dataReady(xval, yval, zval, (uint8_t) val);
  }


}
