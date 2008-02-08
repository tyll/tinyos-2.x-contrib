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
 * Readings - A TinyOS application that shows the concept of sending 
 *            a radio message.            
 * 
 * Behavior: 'Counts' program starts a timer at an interval of 1s.
 *           Each time the timer is triggered, this program sends 
 *           a radio message that contains its node ID and counter 
 *           variable. The counter variable is incremented each time 
 *           the timer is triggered.
 *
 *           'Readings' extends this program by sampling the node 
 *           voltage as well. 
 *         
 *           In order to see the debugging message, a base station 
 *           node needs be prepared. A base station node is a node 
 *           that is programmed with 'BaseStationCC2420' program, 
 *           which forwards all its received radio messages to and 
 *           from the serial port.
 *          
 *           Try program multiple nodes with 'Counts' program and 
 *           see the behavior with a base station node and java client 
 *           application. You can see the debugging messages 
 *           from multiple sensor nodes.
 *
 * @author David Culler <dculler@archrock.com>
 * @author Jaein Jeong  <jaein@eecs.berkeley.edu>
 * @version $Revision$ 
 *
 */

#include <UserButton.h>
#include "Timer.h"
#include "PrintCounterReading.h"

module ReadingsC {
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

  uint8_t flag = 0;
  uint16_t counter = 0;
  uint16_t voltage_reading = 0;

  event void Boot.booted() {
    call Control.start();
    call Notify.enable();
    call MilliTimer.startPeriodic(1024);
  }

  void serial_print() {
    if (locked) {
      return;
    }
    else {
      print_counter_reading_msg_t* rcm = 
        (print_counter_reading_msg_t*) call Packet.getPayload(&packet, NULL);

      rcm->flag = flag;

      rcm->nodeid = TOS_NODE_ID;

      if (flag & FLAG_COUNTER) {
        rcm->counter = counter;
      }

      if (flag & FLAG_VOLTAGE_READING) {
        rcm->voltage_reading = voltage_reading;
      }

      flag = 0;

      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, 
          sizeof(print_counter_reading_msg_t)) == SUCCESS) {
	      locked = TRUE;
      }
    }
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      locked = FALSE;
    }
  }

  void report_voltage_reading(uint16_t data) {
    flag |= FLAG_VOLTAGE_READING;
    voltage_reading = data;
    serial_print(); 
  }

  event void ReadVoltage.readDone(error_t result, uint16_t data) {
    if (result == SUCCESS) {
      report_voltage_reading(data);
    }
  }

  event void MilliTimer.fired() {
    call Leds.led1Toggle();
    counter++;
    flag |= FLAG_COUNTER;
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




