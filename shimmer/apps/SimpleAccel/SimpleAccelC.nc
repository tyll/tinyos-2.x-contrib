/*
 * Copyright (c) 2010, Shimmer Research, Ltd.
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
 * @date   October, 2010
 */

/***********************************************************************************

   This app uses Bluetooth to stream 3 Accelerometer channels 

***********************************************************************************/
#include "Mma_Accel.h"

module SimpleAccelC {
   uses {
      interface Boot;
      interface Init as BluetoothInit;
      interface Init as AccelInit;
      interface Leds;
      interface shimmerAnalogSetup;
      interface Timer<TMilli> as ActivityTimer;
      interface Timer<TMilli> as SampleTimer;
      interface Mma_Accel as Accel;
      interface StdControl as BTStdControl;
      interface Bluetooth;
      interface Msp430DmaChannel as DMA0;
   }
} 

implementation {
   uint8_t NBR_ADC_CHANS, dma_blocks;
   norace uint8_t current_buffer;
   uint16_t sbuf0[60], sbuf1[60];
   bool enable_sending, command_mode_complete;

   uint16_t sample_freq = 100; //10.24Hz

   void init() {
      atomic {
         enable_sending = FALSE;
         command_mode_complete = FALSE;
         current_buffer = 0;
         dma_blocks = 0;
      }
      call BluetoothInit.init();

      call AccelInit.init();
      call Accel.setSensitivity(RANGE_6_0G);
    
      TOSH_SET_PWRMUX_SEL_PIN();

      call shimmerAnalogSetup.addAccelInputs();
      call shimmerAnalogSetup.addAnExInput(7);
      call shimmerAnalogSetup.finishADCSetup(sbuf0);
      NBR_ADC_CHANS = call shimmerAnalogSetup.getNumberOfChannels();
   }

   event void Boot.booted() {
      init();
      call BTStdControl.start();
   }

   task void sendSensorData() {
      atomic if(enable_sending) {
         if(current_buffer == 1)
            call Bluetooth.write((uint8_t *)sbuf0, 120);
         else
            call Bluetooth.write((uint8_t *)sbuf1, 120);
         atomic enable_sending = FALSE;
      }
   }

   task void startSensing() {
      call ActivityTimer.startPeriodic(1024);
      call Accel.wake(TRUE);
      call SampleTimer.startPeriodic(sample_freq);
   }

   task void stopSensing() {
      call SampleTimer.stop();
      call ActivityTimer.stop();
      call shimmerAnalogSetup.stopConversion();
      call DMA0.stopTransfer();
      call Accel.wake(FALSE);
      call Leds.led1Off();
   }

   async event void Bluetooth.connectionMade(uint8_t status) { 
      atomic enable_sending = TRUE;
      call Leds.led2On();
      post startSensing();
   }

   async event void Bluetooth.commandModeEnded() { 
      atomic command_mode_complete = TRUE;
   }
    
   async event void Bluetooth.connectionClosed(uint8_t reason){
      atomic enable_sending = FALSE;    
      call Leds.led2Off();
      post stopSensing();
   }

   async event void Bluetooth.dataAvailable(uint8_t data){
   }

   event void Bluetooth.writeDone(){
      atomic enable_sending = TRUE;
   }

   event void ActivityTimer.fired() {
      call Leds.led1Toggle();
   }

   event void SampleTimer.fired() {
      call shimmerAnalogSetup.triggerConversion();
   }

   async event void DMA0.transferDone(error_t success) {
      atomic DMA0DA += 8;
      if(++dma_blocks == 15)
      {
         dma_blocks = 0;
         if(current_buffer == 0){
            call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf1, NBR_ADC_CHANS);
            current_buffer = 1;
         }
         else { 
            call DMA0.repeatTransfer((void*)ADC12MEM0_, (void*)sbuf0, NBR_ADC_CHANS);
            current_buffer = 0;
         }
         post sendSensorData();
      }
   }
}

