/*
 * Copyright (c) 2009, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Janos Sallai
 */

module TestBroadcastPolicyC {
  uses {
    interface Boot;
    interface SplitControl as AMControl;
    interface StdControl as DfrfControl;
    interface DfrfSend<counter_packet_t>;
    interface DfrfReceive<counter_packet_t>;
    interface Timer<TMilli>;
#if defined(DFRF_MICRO)    
    interface LocalTime<TMicro>;
#elif defined(DFRF_32KHZ)    
    interface LocalTime<T32khz>;
#else
    interface LocalTime<TMilli>;
#endif
    interface AMPacket;
    interface Leds;
  }
} implementation {

  uint8_t cnt = 0;

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t error_code) {
    if(call DfrfControl.start() == SUCCESS) {
      if(call AMPacket.address() == 1) {
        dbg("TestBroadcastPolicy","Starting send timer\n");
        call Timer.startPeriodic(768);
      }
    } else {
        call Leds.led0On();
        dbg("TestBroadcastPolicy","Error starting Dfrf\n");
    }
  }

  event void AMControl.stopDone(error_t error_code) {}

  task void sendPacket() {
    counter_packet_t packet;
    uint32_t timeStamp = call LocalTime.get();

    packet.cnt = cnt;
    packet.src = call AMPacket.address() & 0xff;
    call DfrfSend.send(&packet, timeStamp);
    dbg("TestBroadcastPolicy","Sent packet %d @ %d\n", cnt, timeStamp);

    cnt++;
    if((cnt % 4) != 0)
      post sendPacket();
  }

  event void Timer.fired() {
    post sendPacket();
  }

  event bool DfrfReceive.receive(counter_packet_t* packet, uint32_t timeStamp) {

    dbg("TestBroadcastPolicy","Received packet %d @ %d\n", packet->cnt, timeStamp);
    call Leds.set(packet->cnt);
  
    return TRUE;
  }

}
