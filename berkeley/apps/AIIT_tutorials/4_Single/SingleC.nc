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
 * Single - A TinyOS application that shows the concept of sending.
 * 
 * Behavior: On boot, a timer of 1s period is started.
 *           Each time the timer is fired, sampling of the node voltage
 *           is requested. When the node voltage reading is available,
 *           this program sends the voltage reading over serial port.
 *           This program also allows sending an error message and
 *           the temperature reading (to be used at 'Dual' application).
 *         
 *           This program samples only node voltage. 
 *           If you want to extend this program to sample node internal
 *           temperature as well, wire DemoTemperatureSensorC.nc module
 *           to configuration module (SingleAppC.nc). 
 *           
 *           In order to see the debugging message, plug the mote to
 *           a serial port and run the listen client by typing
 *           'source ./run.sh'. The listen client reads a message from
 *           the serial port and prints it on console.
 * 
 * Concepts Illustrated:
 * 
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
#include "PrintReading.h"

module SingleC {
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
  char m_error[13] = "Sample Error\n";
  char m_data[TOSH_DATA_LENGTH - 5];
  uint16_t voltage_reading = 0;
  uint16_t temperature_reading = 0;

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
      uint8_t i;
      print_reading_msg_t* rcm = 
        (print_reading_msg_t*) call Packet.getPayload(&packet, NULL);

      rcm->flag = flag;

      if (flag & FLAG_BUFFER) {
        for (i = 0; i < TOSH_DATA_LENGTH - 5; i++) {
          rcm->buffer[i] = m_data[i]; 
        }
      }
      
      if (flag & FLAG_VOLTAGE_READING) {
        rcm->voltage_reading = voltage_reading;
      }

      if (flag & FLAG_TEMPERATURE_READING) {
        rcm->temperature_reading = temperature_reading;
      }

      flag = 0;

      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, 
          sizeof(print_reading_msg_t)) == SUCCESS) {
	      locked = TRUE;
      }
    }
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      locked = FALSE;
    }
  }

  void report_problem() {
    uint8_t i;
    flag = FLAG_BUFFER;
    for (i = 0; i < sizeof(m_error); i++) {
      m_data[i] = m_error[i];
    }
    m_data[i] = 0;
    serial_print();
  }

  void report_voltage_reading(uint16_t data) {
    flag = FLAG_VOLTAGE_READING;
    voltage_reading = data;
    serial_print(); 
  }

  event void ReadVoltage.readDone(error_t result, uint16_t data) {
    if (result != SUCCESS) {
	    report_problem();
    }
    report_voltage_reading(data);
  }

  event void MilliTimer.fired() {
    call Leds.led1Toggle();
    if (call ReadVoltage.read() != SUCCESS) 
      report_problem();
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




