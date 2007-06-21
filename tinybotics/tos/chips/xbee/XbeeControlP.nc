/*
 * Copyright (c) 2005-2006 Arch Rock Corporation
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
 *
 * Copyright (c) 2007 University of Padova
 * Copyright (c) 2007 Orebro University
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
 * - Neither the name of the the copyright holders nor the names of
 *   their contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
 * HOLDERS OR THEIR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * simple control file to init the xbee module with the correct params
 * @author Jonathan Hui <jhui@archrock.com>
 * @author Urs Hunkeler
 * @author Mirko Bordignon <mirko.bordignon@ieee.org>
 */


// due to assumptions behind this simple implementation, it is currently unsafe
// to use XbeeConfig commands outside the autowired self-configuration process
// started by the top-level AM.SplitControl.start()

// improvements to come...

#include "Xbee.h"

module XbeeControlP {

  provides {
    interface SplitControl;
    interface XbeeConfig;
  }
  uses {
    interface Send;
    interface Receive;
    interface Leds;
    command am_addr_t amAddress();
  }
}

implementation {

  message_t* configMsg;
  uint8_t configLen;
  xbee_service_header_t* configHeader;

  uint8_t m_channel = XBEE_DEF_CHANNEL;
  uint8_t m_tx_power = XBEE_DEF_RFPOWER;
  uint16_t m_pan = TOS_AM_GROUP;
  uint16_t m_short_addr;

  bool channel_set;
  bool tx_power_set;
  bool pan_set;
  bool short_addr_set;
  bool sync_done;

  task void send();

  xbee_service_header_t* getHeader(message_t* msg) {
    return (xbee_service_header_t*)(msg->data - sizeof(xbee_service_header_t));
  }

  /***************** SplitControl Commands ****************/
  command error_t SplitControl.start() {
    channel_set = FALSE;
    tx_power_set = FALSE;
    pan_set = FALSE;
    short_addr_set = FALSE;
    sync_done = FALSE;

    configHeader = getHeader(configMsg);
    m_short_addr = call amAddress();
    // start the config sequence
    call XbeeConfig.setChannel(m_channel);
    return SUCCESS;
  }

  command error_t SplitControl.stop() {
    return SUCCESS;
  }
  
  /***************** XbeeConfig Commands ****************/

  // all the Set commmands simply queue a parameter to be set (API id 0x09)
  // hence they must be followed by a Sync call to be actually applied
  command uint8_t XbeeConfig.getChannel() {
    return m_channel;
  }

  command void XbeeConfig.setChannel( uint8_t channel ) {
    configHeader->api = XBEE_API_AT_COMMAND_QUEUE;
    configMsg->data[0] = 0; // no response frame
    configMsg->data[1] = ASCII_C;
    configMsg->data[2] = ASCII_H;
    configMsg->data[3] = channel;
    configLen = 4;
    channel_set = TRUE;
    post send();
    return;
  }

  command uint8_t XbeeConfig.getTxPower() {
    return m_tx_power;
  }

  command void XbeeConfig.setTxPower( uint8_t power ) {
    configHeader->api = XBEE_API_AT_COMMAND_QUEUE;
    configMsg->data[0] = 0; // no response frame
    configMsg->data[1] = ASCII_P;
    configMsg->data[2] = ASCII_L;
    configMsg->data[3] = power;
    configLen = 4;
    tx_power_set = TRUE;
    post send();
    return;
  }

  command uint16_t XbeeConfig.getShortAddr() {
    return m_short_addr;
  }

  command void XbeeConfig.setShortAddr( uint16_t addr ) {
    configHeader->api = XBEE_API_AT_COMMAND_QUEUE;
    configMsg->data[0] = 0; // no response frame
    configMsg->data[1] = ASCII_M;
    configMsg->data[2] = ASCII_Y;
    configMsg->data[3] = (addr >> 8) & 0xFF;  //MSB of the addr
    configMsg->data[4] = addr & 0xFF;         //LSB of the addr
    configLen = 5;
    short_addr_set = TRUE;
    post send();
    return;
  }

  command uint16_t XbeeConfig.getPanAddr() {
    return m_pan;
  }

  command void XbeeConfig.setPanAddr( uint16_t pan ) {
    configHeader->api = XBEE_API_AT_COMMAND_QUEUE;
    configMsg->data[0] = 0; // no response frame
    configMsg->data[1] = ASCII_I;
    configMsg->data[2] = ASCII_D;
    configMsg->data[3] = (pan >> 8) & 0xFF;  //MSB of the pan id
    configMsg->data[4] = pan & 0xFF;         //LSB of the pan id
    configLen = 5;
    pan_set = TRUE;
    post send();
    return;
  }

  // issuing an AC command applies all queued changes
  command void XbeeConfig.sync() {
    configHeader->api = XBEE_API_AT_COMMAND_QUEUE;
    configMsg->data[0] = 1; // response frame ID = 1
    configMsg->data[1] = ASCII_A;
    configMsg->data[2] = ASCII_C;
    configLen = 3;
    sync_done = TRUE;
    post send();
    return;
  }

  /* send and receive event */

  event void Send.sendDone(message_t* msg, error_t result) {
    //check that everything is configured:
    if ( channel_set != TRUE ) {
      call XbeeConfig.setChannel(m_channel);
      return;
    }
    if ( tx_power_set != TRUE) {
      call XbeeConfig.setTxPower(m_tx_power);
      return;
    }
    if ( pan_set != TRUE ) {
      call XbeeConfig.setPanAddr(m_pan);
      return;
    }
    if ( short_addr_set != TRUE) {
      call XbeeConfig.setShortAddr(m_short_addr);
      return;
    }
    //check that mods have been applied:
    if ( sync_done != TRUE) {
      call XbeeConfig.sync();
      return;
    }
    //configuration ok
    return;
  }

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    if ( ( msg->data[0] == 5 ) && ( msg->data[3] == 0 ) ) { // changes were successfully applied
      sync_done = TRUE;
      signal SplitControl.startDone( SUCCESS );
    }
    else {
      signal SplitControl.startDone( FAIL );
    }
    return msg;
  }

// the send task will repost itself until it succeeds
// hence we set the relative flag to TRUE when we post it
  task void send() { 
    if(call Send.send(configMsg, configLen) != SUCCESS) {
      post send();
    }
  }

}
