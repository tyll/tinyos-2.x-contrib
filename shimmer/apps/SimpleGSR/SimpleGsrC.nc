/*
 * Copyright (c) 2011, Shimmer Research, Ltd.
 * All rights reserved
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:

 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of Shimmer Research, Ltd. nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Mike Healy
 * @date   April, 2011
 */

/***********************************************************************************

   This app uses Bluetooth to stream the (smoothed) GSR resistance 

***********************************************************************************/
#include "Gsr.h"

module SimpleGsrC {
   uses {
      interface Boot;
      interface Init as BluetoothInit;
      interface Leds;
      interface shimmerAnalogSetup;
      interface Timer<TMilli> as ActivityTimer;
      interface Timer<TMilli> as SampleTimer;
      interface StdControl as BTStdControl;
      interface Bluetooth;
      interface Msp430DmaChannel as DMA0;
      interface Init as GsrInit;
      interface Gsr;
   }
} 

implementation {
   uint8_t active_resistor, iteration;
   norace uint8_t NBR_ADC_CHANS, current_buffer, current_res_buf;
   uint16_t sbuf0, sbuf1;
   norace bool enable_sending;
   uint32_t resistance_buf0[30], resistance_buf1[30];

   uint16_t sample_freq = 32; //32Hz

   void init() {
      enable_sending = FALSE;
      active_resistor = HW_RES_40K; //as set in GsrInit.init();
      current_buffer = 0;
      current_res_buf = 0;
      iteration = 0;
      call BluetoothInit.init();

      call shimmerAnalogSetup.addGSRInput();
      call shimmerAnalogSetup.finishADCSetup(&sbuf0);
      NBR_ADC_CHANS = call shimmerAnalogSetup.getNumberOfChannels();

      call GsrInit.init();
   }

   event void Boot.booted() {
      init();
      call BTStdControl.start();
   }

   task void sendSensorData() {
      if(enable_sending) {
         if(current_res_buf == 1)
            call Bluetooth.write((uint8_t *)resistance_buf0, 120);
         else
            call Bluetooth.write((uint8_t *)resistance_buf1, 120);
         enable_sending = FALSE;
      }
   }

   task void collectResults() {
      uint16_t ADCsample;
      uint32_t res;

      if(current_buffer == 1)
         ADCsample = sbuf0;
      else
         ADCsample = sbuf1;

      res = call Gsr.calcResistance(ADCsample, active_resistor);
      res = call Gsr.smoothSample(res, active_resistor);

      active_resistor = call Gsr.controlRange(ADCsample, active_resistor);

      if(current_res_buf == 0)
         *(resistance_buf0 + iteration) = res;
      else
         *(resistance_buf1 + iteration) = res;

      if(++iteration == 30) {
         iteration = 0;
         if(current_res_buf == 0)
            current_res_buf = 1;
         else
            current_res_buf = 0;
         post sendSensorData();
      }
   }

   task void startSensing() {
      call Gsr.initSmoothing(active_resistor);
      call ActivityTimer.startPeriodic(1024);
      call SampleTimer.startPeriodic(sample_freq);
   }

   task void stopSensing() {
      call SampleTimer.stop();
      call ActivityTimer.stop();
      call shimmerAnalogSetup.stopConversion();
      call DMA0.stopTransfer();
      call Leds.led1Off();
   }

   async event void Bluetooth.connectionMade(uint8_t status) { 
      enable_sending = TRUE;
      call Leds.led2On();
	   post startSensing();
   }

   async event void Bluetooth.commandModeEnded() { 
   }
    
   async event void Bluetooth.connectionClosed(uint8_t reason){
      enable_sending = FALSE;    
      call Leds.led2Off();
      post stopSensing();
   }

   async event void Bluetooth.dataAvailable(uint8_t data){
   }

   event void Bluetooth.writeDone(){
      enable_sending = TRUE;
   }

   event void ActivityTimer.fired() {
      call Leds.led1Toggle();
   }

   event void SampleTimer.fired() {
      call shimmerAnalogSetup.triggerConversion();
   }

   async event void DMA0.transferDone(error_t success) {
      if(current_buffer == 0){
         call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)&sbuf1, NBR_ADC_CHANS);
         current_buffer = 1;
      }
      else { 
         call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)&sbuf0, NBR_ADC_CHANS);
         current_buffer = 0;
      }
      post collectResults();
   }
}

