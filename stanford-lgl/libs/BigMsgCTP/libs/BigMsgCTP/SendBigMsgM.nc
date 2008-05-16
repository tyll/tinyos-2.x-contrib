/*
* Copyright (c) 2006 Stanford University.
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
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */

#include "BigMsg.h"

module SendBigMsgM
{
  provides
  {
    interface SendBigMsg;
  }

  uses
  {
    interface Boot;
    interface Packet;
    interface Packet as AMPacket;
    interface Send as FrameSend;
    interface Leds;
#if BIGMSG_TIMER > 0
    interface Timer<TMilli> as Timer0;
#endif
  }
}

implementation
{
  uint8_t *buffer;
  bigmsg_frame_request_t req;
  uint32_t total_size;

  message_t tx_msg;

  event void Boot.booted()
  {
    buffer = 0;
  }

  task void processFrame();

#if BIGMSG_TIMER > 0
  event void Timer0.fired()
  {
      if (req.send_next_n_parts)
      {
        post processFrame();
        call Timer0.startOneShot(BIGMSG_TIMER);
      }
  }
#endif

  void nextFrame()
  {
#if BIGMSG_TIMER > 0
      ;
#else
      post processFrame();
#endif
  }
  
  void startFrame()
  {
      post processFrame();

#if BIGMSG_TIMER > 0
      call Timer0.startOneShot(BIGMSG_TIMER);
#endif
  }

  task void processFrame()
  {
    bigmsg_frame_part_t *msgData =
      (bigmsg_frame_part_t *)call FrameSend.getPayload(&tx_msg, sizeof(bigmsg_frame_part_t));
    uint32_t buf_offset;
    uint8_t len;

    buf_offset = req.part_id<<BIGMSG_DATA_SHIFT;

    if (buf_offset >= total_size)
    {
      buffer = 0;
      signal SendBigMsg.sendDone(FAIL);
      call Leds.led1Toggle();
      return;
    }

    len = (total_size - buf_offset < BIGMSG_DATA_LENGTH) ? total_size - buf_offset : BIGMSG_DATA_LENGTH;

    msgData->part_id = req.part_id;
    msgData->node_id = TOS_NODE_ID;
    memcpy(msgData->buf,&(buffer[buf_offset]),len);
    if (len < BIGMSG_DATA_LENGTH)
      memset(&(msgData->buf[len]),0,BIGMSG_DATA_LENGTH-len);

    //if (call FrameSend.send(&tx_msg, len+BIGMSG_HEADER_LENGTH) == FAIL)
    //tos java doesn't support variable length messages, so we just send a full length msg
    if (call FrameSend.send(&tx_msg, BIGMSG_DATA_LENGTH+BIGMSG_HEADER_LENGTH) == FAIL)
  		nextFrame();
  }


  event void FrameSend.sendDone(message_t* bufPtr, error_t error)
  {

    if (error==FAIL)
    {
      nextFrame();
      return;
    }

    if (req.send_next_n_parts)
    {
      req.part_id++;
      req.send_next_n_parts--;
      nextFrame();
      call Leds.led2Toggle();
    }
    else
      signal SendBigMsg.sendDone(SUCCESS);
  }

  command error_t SendBigMsg.send(uint8_t *start_buf, uint32_t size)
  {
    if (size==0 )//|| busy==1)
      return FAIL;

    buffer = start_buf;
    req.part_id = 0;
    req.send_next_n_parts = size>>BIGMSG_DATA_SHIFT;
    total_size = size;
    startFrame();
    return SUCCESS;
  }

  command error_t SendBigMsg.resend(uint8_t *start_buf, uint16_t from, uint16_t numFrames)
  {
//    if (buffer!=0)
//      return FAIL;

    buffer = start_buf;
    req.part_id = from;
    req.send_next_n_parts = numFrames;
    //total_size = numFrames<<BIGMSG_DATA_SHIFT;
    startFrame();

    return SUCCESS;
  }

  default event void SendBigMsg.sendDone(error_t success)
  {}
}

