/*
 * Copyright (c) 2012, Shimmer Research, Ltd.
 * All rights reserved
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:

 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of Shimmer Research, Ltd. nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.

 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * @author Mike Healy, Steve Ayer
 * @date   February, 2011
 */

#include "Timer.h"
#include "SyncedRadio.h"

module SyncedRadioTxC {
  uses {
    interface Boot;

    interface SplitControl as AMRadioControl;
    interface AMSend as AMRadioSend;
    interface Packet;

    interface Receive;

    interface Init as txTimerInit;
    interface Alarm<TMilli, uint16_t> as txTimer;
    interface Timer<TMilli> as startTimer;

    interface Leds;
  }
}

implementation {
  message_t radioPacket;
  bool timerStarted = FALSE, rxStateChange = FALSE;
  uint16_t counter = 0, send_period;
  uint8_t msg_buffer[TOSH_DATA_LENGTH-2];

  event void Boot.booted()
  {
    register uint8_t i;

    send_period = 102;  // 10hz

    call txTimerInit.init();

    msg_buffer[0] = TOSH_DATA_LENGTH + 14;
    msg_buffer[1] = CC2420_DEF_CHANNEL;
    for(i = 2; i < TOSH_DATA_LENGTH - 2; i++)
      msg_buffer[i] = TOS_NODE_ID;

    call AMRadioControl.start();
  }

  event void AMRadioControl.startDone(error_t err)
  {
    if (err != SUCCESS)
      call AMRadioControl.start();
  }

  event void AMRadioControl.stopDone(error_t err) {  }

  task void send_task(){
    simple_send_msg_t * rcm;

    ++counter;
    if(!(rcm = (simple_send_msg_t*)call Packet.getPayload(&radioPacket, sizeof(simple_send_msg_t))))
      return;

    rcm->counter = counter;
    memcpy(rcm->message, msg_buffer, (TOSH_DATA_LENGTH - 2));
     
    if (call AMRadioSend.send(BASE_STATION_ADDRESS, &radioPacket, sizeof(simple_send_msg_t)) == SUCCESS) {
      call Leds.led2Toggle();
    }
  }

  async event void txTimer.fired()
  {
    post send_task();
    call txTimer.start(send_period);
  }

  task void beginTx() {
    call txTimer.start(send_period);
  }

  event void startTimer.fired()
  {
    post beginTx();
  }

  event void AMRadioSend.sendDone(message_t* msg, error_t error)
  {
    call Leds.led2Toggle();
  }

  /*
   * the idea here is to divide the space between transmissions -- 
   * in this case 100ms -- into equal windows for each node on the channel.
   * then we space the start times from the basestation's initial go signal 
   * by increments of 100ms / number of nodes.  arbitrarily, we use four nodes
   * here, placing each node's transmission 25ms apart.
   */
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    uint8_t *rMsg = payload;
     
    if(*rMsg == 's') {
      if(!timerStarted){
	call startTimer.startOneShot((TOS_NODE_ID - 1) * 25);  
	timerStarted = TRUE;
      }
    }
    else if(*rMsg == 't') {
      call startTimer.stop();
      call txTimer.stop();
      call Leds.set(0);
      timerStarted = FALSE;
    }
     
    return msg;
  }
}
