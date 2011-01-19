// $Id$
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
 */

#include <UserButton.h>

module TestBluetoothC {
  uses {
    interface Boot;
    interface Leds;
    interface Init as BluetoothInit;
    interface StdControl as BTStdControl;
    interface Bluetooth;
    interface Timer<TMilli> as activityTimer;
  }
}

implementation {
  char msgbuf[128];

  event void Boot.booted(){
    strcpy(msgbuf, "hello, bluetooth is awake!");

    call BluetoothInit.init();
    call Bluetooth.resetDefaults();
    call Bluetooth.setRadioMode(SLAVE_MODE);
    call Bluetooth.setName("testUnit");
    call BTStdControl.start();
  }

  task void sendStuff() {
    call Bluetooth.write(msgbuf, strlen(msgbuf));
  }

  event void activityTimer.fired() { 
    post sendStuff();
  }

  async event void Bluetooth.connectionMade(uint8_t status) { 
    call Leds.led2On();

    call activityTimer.startPeriodic(1000);
  }  

  async event void Bluetooth.connectionClosed(uint8_t reason){
    call Leds.led2Off();
    call activityTimer.stop();
  }

  async event void Bluetooth.dataAvailable(uint8_t data){
    //    call Leds.led1Toggle();
  }

  event void Bluetooth.writeDone(){
  }

  async event void Bluetooth.commandModeEnded() { 
    call Leds.led0On();
  }
}
