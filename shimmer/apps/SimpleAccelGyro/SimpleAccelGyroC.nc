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
 * @author Steve Ayer
 * @date   February, 2011
 * accel gyro over 802.15.4 active message transport
 */

#include <Timer.h>
#include <UserButton.h>
#include "Mma_Accel.h"
#include "SimpleAccelGyro.h"

module SimpleAccelGyroC {
  uses {
    interface Boot;

    interface SplitControl as AMRadioControl;
    interface AMSend as AMRadioSend;
    interface Packet;
    interface Receive;

    interface Msp430DmaChannel as DMA0;

    interface shimmerAnalogSetup;

    interface Init as AccelInit;
    interface Mma_Accel as Accel;

    interface Init as GyroInit;
    interface StdControl as GyroStdControl;
    interface GyroBoard;

    interface Notify<button_state_t> as tiltNotify;

    interface Init as sampleTimerInit;
    interface Alarm<TMilli, uint16_t> as sampleTimer;
    interface Timer<TMilli> as motionTimer;
    interface Timer<TMilli> as blinkTimer;

    interface Leds;
    //      interface PacketLink;
  }
}
implementation {

  message_t radioPacket, serialPacket;
  bool happy, sleeping;
  uint16_t counter = 0, sbuf0[49], sbuf1[49], tilt_events;
  uint8_t current_buffer = 0, dma_blocks = 0, sample_period, NUM_ADC_CHANS;
  uint8_t msg_buffer[TOSH_DATA_LENGTH - 2];

  task void Go();
  task void Stop();

  event void Boot.booted(){
    dma_blocks = 0;
    current_buffer = 0;
    sample_period = 50;  // 20hz (?)

    happy = TRUE;  // battery, that is

    call sampleTimerInit.init();

    call shimmerAnalogSetup.addAccelInputs();
    call shimmerAnalogSetup.addGyroInputs();
    call shimmerAnalogSetup.addAnExInput(7);
    call shimmerAnalogSetup.finishADCSetup(sbuf0);

    NUM_ADC_CHANS = call shimmerAnalogSetup.getNumberOfChannels();

    post Go();
    call tiltNotify.enable();
  }

  task void Go() { 
    call blinkTimer.startPeriodic(5000);

    call AccelInit.init();
    call Accel.setSensitivity(RANGE_1_5G);

    TOSH_SET_PWRMUX_SEL_PIN();

    call GyroInit.init();
    call GyroStdControl.start();

    // radio comes up elsewhere after packet data is almost ready...

    sleeping = FALSE;
    tilt_events = 0;

    call motionTimer.startPeriodic(10000);  // default inactivity timeout 10 sec.

    call sampleTimer.start(sample_period);
  }

  task void Stop() {
    call sampleTimer.stop();
    call blinkTimer.stop();

    call Leds.set(0);
    
    sleeping = TRUE;

    TOSH_CLR_PWRMUX_SEL_PIN();
    
    call Accel.wake(0);
    call GyroStdControl.stop();
  }
  
  event void tiltNotify.notify(button_state_t val){
    if(!sleeping)
      tilt_events++;
    else
      post Go();
  }
  
  event void AMRadioControl.startDone(error_t err){
    if(err != SUCCESS)
      call AMRadioControl.start();
    
  }
  
  event void AMRadioControl.stopDone(error_t err){ }

  task void send_data(){
    simple_send_msg_t * rcm;
    float batt;
    uint16_t raw;

    ++counter;

    if(!(rcm = (simple_send_msg_t *)call Packet.getPayload(&radioPacket, sizeof(simple_send_msg_t))))
      return;

    rcm->counter = counter;

    if(current_buffer == 0)
      memcpy(rcm->message, (uint8_t *)sbuf1, 98);
    else
      memcpy(rcm->message, (uint8_t *)sbuf0, 98);

    if (call AMRadioSend.send(BASE_STATION_ADDRESS, &radioPacket, sizeof(simple_send_msg_t)) == SUCCESS) {
      ;//      call Leds.led0Toggle();
    }
    
    // we can check the battery voltage while we're here
    raw = *(rcm->message + 97) + (*(rcm->message + 96) << 8);
    batt = (float)((float)((float)raw * (float)6.0) / (float)4095.0);
    
    /*
     * this measurement will be a couple of percent lower than at the terminals
     * we'll warn at about 3.3v at the terminals
     */
    if(batt < (float)3.2){
      call Leds.led2Off();
      happy = FALSE;
    }
    else{
      call Leds.led0Off();
      happy = TRUE;
    }
  }


  async event void sampleTimer.fired(){
    call shimmerAnalogSetup.triggerConversion();

    call sampleTimer.start(sample_period);
  }

  event void motionTimer.fired(){
    atomic if(!tilt_events){
      call motionTimer.stop();
      post Stop();
    }
    else
      atomic tilt_events = 0;
  }

  event void blinkTimer.fired(){
    if(happy)
      call Leds.led2Toggle();
    else
      call Leds.led0Toggle();
  }

  async event void DMA0.transferDone(error_t success) {
    dma_blocks++;
    atomic DMA0DA += 14;
    
    if(dma_blocks == 6)
      call AMRadioControl.start();
    else if(dma_blocks == 7){
      dma_blocks = 0;

      if(current_buffer == 0){
	call DMA0.repeatTransfer((void *)ADC12MEM0_, (void *)sbuf1, NUM_ADC_CHANS);
	current_buffer = 1;
      }
      else { 
	call DMA0.repeatTransfer((void *)ADC12MEM0_, (void *)sbuf0, NUM_ADC_CHANS);
	current_buffer = 0;
      }
      post send_data();
    }
  }

  event void AMRadioSend.sendDone(message_t * msg, error_t error) {
    call AMRadioControl.stop();
    /*
     if (&radioPacket == msg) {
      radioLocked = FALSE;
      }
    */
  }

  event message_t * Receive.receive(message_t * msg, void * payload, uint8_t len) {
    uint8_t *rMsg = payload;
    /*
      if(*rMsg == 's'){
      if(!timerStarted){
      call motionTimer.startOneShot((TOS_NODE_ID - 1) * sample_period);
      timerStarted = TRUE;
      }
      //post send_task();
      }
      else if(*rMsg == 't'){
      call motionTimer.stop();
      call sampleTimer.stop();
      //      call GyroStdControl.stop();
      timerStarted = FALSE;
      }
      
      //      call Leds.led1Toggle();
      return msg;
    */
  }

  async event void GyroBoard.buttonPressed() {
  }
}
