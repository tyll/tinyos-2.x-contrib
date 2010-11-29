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
 * @author Steve Ayer
 * @date   July 2010
 * test of both components on gps board
 */

#include "Timer.h"
#include "RovingNetworks.h"

module TestGPSC {
  uses {
    interface Boot;
    interface Init as BluetoothInit;
    interface Init as GpsInit;
    interface Init as PSInit;
    interface Gps;
    interface PressureSensor;
    interface StdControl as PSStdControl;
    interface Leds;
    interface Timer<TMilli>;
    interface StdControl as BTStdControl;
    interface Bluetooth;
  }
} 

implementation {
  extern int sprintf(char *str, const char *format, ...) __attribute__ ((C));

  uint8_t gpsbuff[96];
  uint16_t sbuf0[128], sample_period;
  uint8_t enable_shipping = 0, bytesToSend, sample_count;

  int32_t pressure;
  int16_t temperature;

  event void Boot.booted() {
    sample_period = 100;

    call GpsInit.init();

    call BluetoothInit.init();
    
    call BTStdControl.start();
  }

  task void sendit() {
    if(enable_shipping){
      call Leds.led2Toggle();
      call Bluetooth.write(gpsbuff, 96);
    }
  }

  task void runGPS(){
    sample_count = 0;
    call Timer.stop();

    call PressureSensor.disableBus();

    call Gps.enableBus();
  }    

  event void Timer.fired() {
    call PressureSensor.readTemperature();
  }

  event void PressureSensor.tempAvailable(int16_t * data){
    call PressureSensor.readPressure();
    temperature = *data;
  }

  event void PressureSensor.pressAvailable(int32_t * data){
    pressure = *data;
    
    memset(gpsbuff, 0, 96);
    *gpsbuff = 6;
    memcpy(gpsbuff + 2, &temperature, 2);
    memcpy(gpsbuff + 4, &pressure, 4);

    //    bytesToSend = 6;
    
    post sendit();
    
    post runGPS();
  }

  task void runPressure() {
    sample_count = 0;

    call Gps.disableBus();
    
    call PressureSensor.enableBus();
    
    call Timer.startPeriodic(sample_period);
  }

  async event void Gps.NMEADataAvailable(char * data) {
    if(!strncmp("$GPGGA", data, 6)){
      *gpsbuff = strlen(data);
      strcpy(gpsbuff + 2, data);
      
      post sendit();
      
      post runPressure();
    }
  }

  task void fireitup() {
    call PSInit.init();
    call PSStdControl.start();

    call Timer.startPeriodic(sample_period);
  }

  task void cutitout() { 
    call Timer.stop();
    
  }

  async event void Bluetooth.connectionMade(uint8_t status) { 
    call Leds.led0On();
    enable_shipping = 1;
    
    post fireitup();
  }

  async event void Bluetooth.commandModeEnded() { 
  }
    
  async event void Bluetooth.connectionClosed(uint8_t reason){
    call Leds.led0Off();
    enable_shipping = 0;

    post cutitout();
  }

  async event void Bluetooth.dataAvailable(uint8_t data){
  }

  event void Bluetooth.writeDone(){
  }

}

