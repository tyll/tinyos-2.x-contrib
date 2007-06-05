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
 * Forwards messages from the computer to the lava lamp controlling node
 * 
 * @author David Moss
 */

#include "PowerOutlet.h"

module BaseP {
  provides {
    interface PowerOutletFeedback;
  }
  
  uses {
    interface Boot;
    interface SplitControl as RadioSplitControl;
    interface SplitControl as SerialSplitControl;
    interface AMSend;
    interface PacketLink;
    interface Leds;
  }
}

implementation {

  /** Message to send */
  message_t myMsg;
  
  uint8_t manualRetries;
  
  /***************** Prototypes ****************/
  task void send();
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    call RadioSplitControl.start();
    call SerialSplitControl.start();
  }
  
  /***************** SplitControl Events ****************/
  event void RadioSplitControl.startDone(error_t error) {
  }
  
  event void RadioSplitControl.stopDone(error_t error) {
  }
  
  event void SerialSplitControl.startDone(error_t error) {
  }
  
  event void SerialSplitControl.stopDone(error_t error) {
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    manualRetries++;
    if(manualRetries < 10) {
      post send();
    }
  }
  
  /***************** PowerOutletFeedback Commands ****************/
  command void PowerOutletFeedback.setPower(bool outlet1, bool outlet2) {
    PowerOutletFeedbackMsg *feedbackMsg = (PowerOutletFeedbackMsg *) call AMSend.getPayload(&myMsg);
    feedbackMsg->bool0 = outlet1;
    feedbackMsg->bool1 = outlet2;
    manualRetries = 0;
    post send();
    
    if(outlet1) {
      call Leds.led1On();
    } else {
      call Leds.led1Off();
    }
    
    if(outlet2) {
      call Leds.led0On();
    } else {
      call Leds.led0Off();
    }
    
  }
  
  
  /***************** Tasks ****************/
  task void send() {
    call PacketLink.setRetries(&myMsg, 10);
    call PacketLink.setRetryDelay(&myMsg, 10);
    if(call AMSend.send(OUTLET_ADDRESS, &myMsg, sizeof(PowerOutletFeedbackMsg)) != SUCCESS) {
      post send();
    }
  }
}

