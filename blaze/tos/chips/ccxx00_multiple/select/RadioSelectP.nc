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
 * Select which radio to use for a given message, and parameterize
 * the Send and Receive interfaces below this point by radio id
 * 
 * @author David Moss
 */
 
module RadioSelectP {
  provides {
    interface SplitControl[radio_id_t radioId];
    interface RadioSelect;
    interface Send;
    interface Receive;
  }
  
  uses {
    interface CentralWiring;
    interface SplitControl as SubControl;
    interface Send as SubSend;
    interface Receive as SubReceive;
    interface BlazePacketBody;
    interface Leds;
  }
}

implementation {
  
  enum {
    NO_RADIO = 0xFF,
  };
  
  uint8_t currentRadio = NO_RADIO;
  
  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start[radio_id_t radioId]() {
    error_t error;
    if(currentRadio != NO_RADIO) {
      return EALREADY;
    }
    
    currentRadio = radioId;
    
    call CentralWiring.switchTo(radioId);
    
    if((error = call SubControl.start()) != SUCCESS) {
      currentRadio = NO_RADIO;
    }
    
    return error;
  }
  
  command error_t SplitControl.stop[radio_id_t radioId]() {
    if(currentRadio != radioId) {
      return EALREADY;
    }
    
    return call SubControl.stop();
  }
  
  /***************** SubControl Events ****************/
  event void SubControl.startDone(error_t error) {
    uint8_t radio = currentRadio;
    
    if(error) {
      currentRadio = NO_RADIO;
    }
    
    signal SplitControl.startDone[radio](error);
  }
  
  event void SubControl.stopDone(error_t error) {
    uint8_t radio = currentRadio;
    currentRadio = NO_RADIO;
    signal SplitControl.stopDone[radio](error);
  }
  
  
  /***************** RadioSelect Commands ****************/
  /**
   * Select the radio to be used to send this message
   * We don't prevent invalid radios from being selected here; instead,
   * invalid radios are filtered out when they are attempted to be used.
   * 
   * @param msg The message to configure that will be sent in the future
   * @param radioId The radio ID to use when sending this message.
   *    See CC1100.h or CC2500.h for definitions, the ID is either
   *    CC1100_RADIO_ID or CC2500_RADIO_ID.
   * @return SUCCESS if the radio ID was set. EINVAL if you have selected
   *    an invalid radio
   */
  command error_t RadioSelect.selectRadio(message_t *msg, radio_id_t radioId) {
    (call BlazePacketBody.getMetadata(msg))->radio = radioId;
    
    return SUCCESS;
  }

  /**
   * Get the radio ID this message will use to transmit when it is sent
   * @param msg The message to extract the radio ID from
   * @return The ID of the radio selected for this message
   */
  command radio_id_t RadioSelect.getRadio(message_t *msg) {
    return (call BlazePacketBody.getMetadata(msg))->radio;
  }
  
  
  /***************** Send Commands ****************/
  /**
   * By this point, the length should already be set in the message itself.
   *
   * The RadioSelect.selectRadio() command sets the radio id in the message,
   * and that command filters out invalid radio id's.
   * 
   * @param msg the message to send
   * @param len IGNORED
   * @return SUCCESS if we're going to try to send the message.
   *     FAIL if you need to reevaluate your code
   */
  command error_t Send.send(message_t* msg, uint8_t len) {
    if((call RadioSelect.getRadio(msg) >= uniqueCount(UQ_BLAZE_RADIO))
        || call RadioSelect.getRadio(msg) != currentRadio) {
      return EOFF;
    }
    
    return call SubSend.send(msg, len);
  }

  command error_t Send.cancel(message_t* msg) {
    return FAIL;
  }

  command uint8_t Send.maxPayloadLength() { 
    return call SubSend.maxPayloadLength();
  }

  command void *Send.getPayload(message_t* msg, uint8_t len) {
    return call SubSend.getPayload(msg, len);
  }

  /***************** SubSend Events ****************/
  event void SubSend.sendDone(message_t *msg, error_t error) {
    signal Send.sendDone(msg, error);
  }
  
  /***************** SubReceive Events ****************/
  event message_t *SubReceive.receive(message_t *msg, void *payload, uint8_t len) {
    (call BlazePacketBody.getMetadata(msg))->radio = currentRadio;
    return signal Receive.receive(msg, payload, len);
  }

  /***************** Defaults ****************/
  default event void SplitControl.startDone[radio_id_t radioId](error_t error) {}
  default event void SplitControl.stopDone[radio_id_t radioId](error_t error) {}
  
}

