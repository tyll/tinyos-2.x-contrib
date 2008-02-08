/**
 * Copyright (c) 2007 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * Smooth - A TinyOS application that shows the concept of task.
 * 
 * Behavior: This program samples node voltage whenever timer is fired.
 *           When MAX_READINGS samples are collected, this program 
 *           report the samples over the serial port.
 *
 *           The sampled data can be further processed in a task.
 *           'Smooth' application extends this application as follows:
 *           (1) calculates the statistics:
 *             'Smooth' calculates the minumum, maximum and mean for
 *             sampled data in raw_reading[].
 *           (2) smoothens the sampled data:
 *             'Smooth' calculates the exponential moving average of
 *             raw_reading[] into smooth_reading[].
 *
 *           In order to see the debugging message, plug the mote to
 *           a serial port and run the listen client by typing
 *           'source ./run.sh'. The listen client reads a message from
 *           the serial port and prints it on console.
 * 
 * Concepts Illustrated:
 * 
 *   Schedulers and Tasks         - TEP106
 *                                  Tinyos 2.0 tutorial lesson 2
 *   ADC and split-phase          - TEP101
 *                                  Tinyos 2.0 tutorial lesson 5
 *   Mote-PC serial communication - TEP113
 *                                  Tinyos 2.0 tutorial lesson 4
 *
 * @author David Culler <dculler@archrock.com>
 * @author Jaein Jeong  <jaein@eecs.berkeley.edu>
 * @version $Revision$ 
 *
 */

#include <UserButton.h>
#include "Timer.h"
#include "PrintReadingArr.h"

module SmoothC {
  uses {
    interface SplitControl as Control;
    interface Leds;
    interface Boot;
    interface AMSend;
    interface Timer<TMilli> as MilliTimer;
    interface Packet;
    interface Notify<button_state_t>;
    interface Read<uint16_t> as ReadVoltage;
  }
}
implementation {

  message_t packet;

  bool locked = FALSE;

  uint8_t counter = 0;
  uint16_t min;
  uint16_t max;
  uint16_t mean;
  uint16_t raw_reading[MAX_READINGS];
  uint16_t smooth_reading[MAX_READINGS];

  event void Boot.booted() {
    call Control.start();
    call Notify.enable();
    call MilliTimer.startPeriodic(250);
  }

  void serial_print() {
    if (locked) {
      return;
    }
    else {
      uint8_t i;
      print_reading_arr_msg_t* rcm = 
        (print_reading_arr_msg_t*) call Packet.getPayload(&packet, NULL);

      rcm->nodeid = TOS_NODE_ID;
      rcm->min = min;
      rcm->max = max;
      rcm->mean = mean;

      for (i = 0; i < MAX_READINGS; i++) {
        rcm->raw_reading[i] = raw_reading[i];
        rcm->smooth_reading[i] = smooth_reading[i];
      }

      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, 
          sizeof(print_reading_arr_msg_t)) == SUCCESS) {
	      locked = TRUE;
      }
    }
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      locked = FALSE;
    }
  }

  uint16_t smoothen(uint16_t prev_reading, uint16_t new_reading) {
    return (prev_reading * (DENOMINATOR - SMOOTH_FACTOR) +
             new_reading * SMOOTH_FACTOR) / DENOMINATOR;
  }

  task void process_voltage_reading() {
    int i;
    uint16_t temp_min = raw_reading[0];
    uint16_t temp_max = raw_reading[0];
    uint16_t temp_sum = raw_reading[0];

    smooth_reading[0] = raw_reading[0];
  
    for (i = 1; i < MAX_READINGS; i++) {
      temp_sum += raw_reading[i];
      if (raw_reading[i] < temp_min) {
        temp_min = raw_reading[i];
      }
      if (raw_reading[i] > temp_max) {
        temp_max = raw_reading[i];
      }
      smooth_reading[i] = smoothen(smooth_reading[i-1], raw_reading[i]);
    }

    min = temp_min;
    max = temp_max;
    mean = temp_sum / MAX_READINGS;

    serial_print();
  }

  void store_voltage_reading(uint16_t data) {
    raw_reading[counter++] = data;
    if (counter == MAX_READINGS) {
      post process_voltage_reading();
      counter = 0;
    }
  }

  event void ReadVoltage.readDone(error_t result, uint16_t data) {
    if (result == SUCCESS) {
      store_voltage_reading(data);
    }
  }

  event void MilliTimer.fired() {
    call Leds.led1Toggle();
    call ReadVoltage.read(); 
  }

  // state can be either BUTTON_PRESSED or BUTTON_RELEASED
  event void Notify.notify( button_state_t state ) {
    if (state == BUTTON_PRESSED) {
      call Leds.led0Toggle();
    }
  }

  event void Control.startDone(error_t err) { }
  event void Control.stopDone(error_t err)  { }
  

}




