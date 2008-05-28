/*
 * Copyright (c) 2008 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * This will receive data from the gps and forward it over the radio.  The
 * NMEA code is not completed yet--not all information is accurate.  A
 * mote running a basestation app can forward the radio information to a
 * computer but no application has been made to interpret the information
 * yet.
 * 
 * @author Danny Park
 */

#include "Nmea.h"
#include "NmeaGga.h"

module TestNmeaParseP {
  uses {
    interface Boot;
    interface NmeaRawReceive;
    interface SplitControl as GPSControl;
    interface Leds;
    interface Packet;
    interface SplitControl as RadioControl;
    interface AMSend;
    interface NmeaPacket<nmea_gga_msg_t> as GGAPacket;
  }
}
implementation {
  message_t myMsg;
  nmea_gga_msg_t* gpsInfo;
  
  event void Boot.booted() {
    gpsInfo = (nmea_gga_msg_t*)call Packet.getPayload(&myMsg,
        sizeof(nmea_gga_msg_t));
    call GPSControl.start();
  }
  
  event void GPSControl.startDone(error_t error) {
    call Leds.led1On();
  }
  
  event void GPSControl.stopDone(error_t error) {
    call Leds.led1Off();
    call RadioControl.start();
  }
  
  event void RadioControl.startDone(error_t error) {
    if(error == SUCCESS) {
      call AMSend.send(AM_BROADCAST_ADDR, &myMsg, sizeof(nmea_gga_msg_t));
    }
    else {//error
      //call Leds.led0On();
    }
  }
  
  event void RadioControl.stopDone(error_t error) {
    call GPSControl.start();
  }
  
  event void NmeaRawReceive.received(nmea_raw_t* packet, bool complete) {
    if(complete) {
      if(gpsInfo != NULL) {
        if(call GGAPacket.process(packet, gpsInfo) == SUCCESS) {
          if(gpsInfo->fixQuality != FIX_INVALID) {
            call Leds.led2Toggle();
            call GPSControl.stop();
          }
        }
        else {//error
          call Leds.led0Toggle();
        }
      }
    }
    else {
      //call Leds.led0On();
    }
  }
  
  event void AMSend.sendDone(message_t* msg, error_t error) {
    if(error == SUCCESS && msg == &myMsg) {
      //call Leds.led2Off();
      call RadioControl.stop();
    }
    else {//error
      //call Leds.led0On();
    }
  }
}
