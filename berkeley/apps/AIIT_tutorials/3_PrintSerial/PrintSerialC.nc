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
 * PrintSerial - A TinyOS application that shows the concept of 
 *               network debugging.
 * 
 * Behavior: When the user button is pressed, a counter variable is
 *           set to (counter + 1) mod 10. 
 *           After that, a debugging  message "Hello <counter>\n"
 *           is sent over the serial port (UART).
 *           
 *           In order to see the debugging message, plug the mote to
 *           a serial port and run the listen client by typing
 *           'source ./run.sh'. The listen client reads a message from
 *           the serial port and prints it on console.
 * 
 * Concepts Illustrated:
 * 
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
#include "PrintSerial.h"

module PrintSerialC {
  uses {
    interface SplitControl as Control;
    interface Leds;
    interface Boot;
    interface AMSend;
    interface Timer<TMilli> as MilliTimer;
    interface Packet;

    interface Notify<button_state_t>;
  }
}
implementation {

  message_t packet;

  bool locked = FALSE;

  char m_data[TOSH_DATA_LENGTH] = "Hello 0\n";
  uint8_t c = 0;
  
  event void Boot.booted() {
    call Control.start();
    call Notify.enable();
    call MilliTimer.startPeriodic(1024);
  }
  
  event void MilliTimer.fired() {
    call Leds.led1Toggle();
  }

  void serial_print(char *str, uint8_t len) {
    if (locked) {
      return;
    }
    else {
      uint8_t i;
      print_serial_msg_t* rcm = 
        (print_serial_msg_t*) call Packet.getPayload(&packet, NULL);

      if (call Packet.maxPayloadLength() < len) {
	      return;
      }

      for (i = 0; i < len; i++) {
        rcm->buffer[i] = m_data[i]; 
      }

      if (call AMSend.send(AM_BROADCAST_ADDR, &packet, 
          sizeof(print_serial_msg_t)) == SUCCESS) {
	      locked = TRUE;
      }
    }
  }

  event void AMSend.sendDone(message_t* bufPtr, error_t error) {
    if (&packet == bufPtr) {
      locked = FALSE;
    }
  }

  // state can be either BUTTON_PRESSED or BUTTON_RELEASED
  event void Notify.notify( button_state_t state ) {
    if (state == BUTTON_PRESSED) {
      call Leds.led0Toggle();
      c = (c==9) ? 0 : c+1;
      m_data[6] = '0' + c;
      serial_print(m_data, sizeof(m_data));
    }
  }

  event void Control.startDone(error_t err) { }
  event void Control.stopDone(error_t err)  { }
  

}




