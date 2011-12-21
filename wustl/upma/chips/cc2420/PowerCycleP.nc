/*
 * "Copyright (c) 2007-2008 Washington University in St. Louis.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL WASHINGTON UNIVERSITY IN ST. LOUIS BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
 * OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF WASHINGTON
 * UNIVERSITY IN ST. LOUIS HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * WASHINGTON UNIVERSITY IN ST. LOUIS SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND WASHINGTON UNIVERSITY IN ST. LOUIS HAS NO
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS."
 */
 
/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
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
 * Module to duty cycle the radio on and off, performing CCA receive checks.
 * When a carrier is sensed, this will leave the radio on. It is then up
 * to higher layers to turn the radio off again.  Once the radio is turned
 * off, this module will automatically continue duty cycling and looking for
 * a modulated signal.
 *
 * Suggested TODO's:
 *  > TransmitC and ReceiveC provide Energy, Byte, and Packet indicators.
 *    Tap into those to add more detection levels and granularity. Only let
 *    the radio turn off when we're not actively receiving bytes.  Right now
 *    the packet indicator is a little backwards.
 *  > Let one component be in charge of maintaining State information about
 *    the power of the radio, probably lower in the stack.
 *  > Wire SplitControl, Send, and Receive through this component.  Make it
 *    responsible for packet-level detections and being completely responsible
 *    for controlling the power of the radio without the use of upper layers
 *  > Remove unnecessary State components and Timers.
 *
 * @author David Moss
 * @author Greg Hackmann
 */
 
#include "PowerCycle.h"

module PowerCycleP {
  provides {
    interface ChannelMonitor;
    interface LplAccounting;
  }

  uses {
    interface RadioPowerControl;
    interface Leds;
    interface ReceiveIndicator as EnergyIndicator;
    interface ReceiveIndicator as ByteIndicator;
    interface ReceiveIndicator as PacketIndicator;
    
#ifndef OLDCCA
    interface LocalTimeExtended<T32khz, local_time16_t> as Time;
#endif
  }
}

implementation {
  uint32_t detected = 0, free = 0;

  enum {
    DEFAULT_CCA_LENGTH = 8 * 32,
  };
  
  norace uint16_t ccaCheckLength = DEFAULT_CCA_LENGTH;

  /***************** Prototypes ****************/
  task void startRadio();
  task void getCca();
  
  /***************** RadioPowerControl Events ****************/
  
  event void RadioPowerControl.startDone(error_t error) {
    call Leds.led2On();
    post getCca();
  }
  
  event void RadioPowerControl.stopDone(error_t error) {
    call Leds.led2Off();
  }
    
  async command void ChannelMonitor.setCheckLength(uint16_t ms) {
    ccaCheckLength = ms * 32;
  }
  
  async command uint16_t ChannelMonitor.getCheckLength() {
    return ccaCheckLength / 32;
  }

  async command void ChannelMonitor.check() {
    post startRadio();
  }
  
  /***************** Tasks ****************/
  
  task void startRadio() {
    error_t err;
    err = call RadioPowerControl.start();
    if(err == EALREADY) {
      post getCca();
    } else if (err != SUCCESS) {
      post startRadio();
    }
  }

  task void getCca() {
    uint8_t detects = 0;
#ifdef OLDCCA
    uint16_t ccaChecks;
    atomic {
      for(ccaChecks = 0; ccaChecks < MAX_LPL_CCA_CHECKS; ccaChecks++) {
        if(call PacketIndicator.isReceiving()) {
          detected++;
          signal ChannelMonitor.busy();
          return;
        }
          
        if(call EnergyIndicator.isReceiving()) {
          detects++;
          if(detects > MIN_SAMPLES_BEFORE_DETECT) {
            detected++;
            signal ChannelMonitor.busy(); 
            return;
          }
          // Leave the radio on for upper layers to perform some transaction
        }
      }
      free++;
      signal ChannelMonitor.free();
    }
#else
    local_time16_t startAt, endAt, length, now;
    uint16_t count = 0;
		
    length.mticks = 0;
    length.sticks = ccaCheckLength;
    startAt = call Time.getNow();
    endAt = call Time.add(&startAt, &length);

    while(TRUE) {
      count++;
      if(count % 32 == 0) {
        now = call Time.getNow();
        if(!call Time.lessThan(&now, &endAt)) {
          break;
        }
      }
      
      if(call PacketIndicator.isReceiving()) {
        detects = MIN_SAMPLES_BEFORE_DETECT + 1;
        break;
      }
			
       if(call EnergyIndicator.isReceiving()) {
         detects++;
         if(detects > MIN_SAMPLES_BEFORE_DETECT) {
           break;
         }
         // Leave the radio on for upper layers to perform some transaction
       }
    }
    
    if(detects > MIN_SAMPLES_BEFORE_DETECT) {
      detected++;
      signal ChannelMonitor.busy();
    } else {
      free++;
      signal ChannelMonitor.free();
    }
#endif
    
  }
  
  command uint32_t LplAccounting.detected() { return detected; }
  command uint32_t LplAccounting.free() { return free; }
}


