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
    interface AMSend as FrameSend;
    interface Receive;
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

  task void processFrame()
  {
    bigmsg_frame_part_t *msgData =
      (bigmsg_frame_part_t *)call Packet.getPayload(&tx_msg, sizeof(bigmsg_frame_part_t));
    uint32_t buf_offset;
    uint8_t len;

    buf_offset = req.part_id<<BIGMSG_DATA_SHIFT;

    if (buf_offset >= total_size)
    {
      buffer = 0;
      signal SendBigMsg.sendDone(FAIL);
      return;
    }

    len = (total_size - buf_offset < BIGMSG_DATA_LENGTH) ? total_size - buf_offset : BIGMSG_DATA_LENGTH;

    msgData->part_id = req.part_id;
    memcpy(msgData->buf,&(buffer[buf_offset]),len);

    if (call FrameSend.send(AM_BROADCAST_ADDR, &tx_msg, len+BIGMSG_HEADER_LENGTH) == FAIL)
      post processFrame();
  }


  command error_t SendBigMsg.send(uint8_t *start_buf, uint32_t size)
  {
    if (size==0 )//|| busy==1)
    {
      signal SendBigMsg.sendDone(SUCCESS);
      return FAIL;
    }

    buffer = start_buf;
    req.part_id = 0;
    req.send_next_n_parts = size>>BIGMSG_DATA_SHIFT;
    total_size = size;
    post processFrame();
    return SUCCESS;
  }

  command error_t SendBigMsg.resend(uint8_t *start_buf, uint16_t from, uint16_t numFrames)
  {
//    if (buffer!=0)
//      return FAIL;

    buffer = start_buf;
    req.part_id = from;
    req.send_next_n_parts = numFrames;
    total_size = numFrames<<BIGMSG_DATA_SHIFT;
    post processFrame();
    return SUCCESS;
  }
  
	event message_t *Receive.receive(message_t *msg, void *payload, uint8_t len) {
		bigmsg_frame_request_t *reqMsg = (bigmsg_frame_request_t *)payload;

    if (buffer!=0)
  		call SendBigMsg.resend(buffer, reqMsg->part_id, reqMsg->send_next_n_parts);
		return msg;
	}

  event void FrameSend.sendDone(message_t* bufPtr, error_t error)
  {
    if (error==FAIL)
    {
      post processFrame();
      return;
    }
    if (req.send_next_n_parts)
    {
      req.part_id++;
      req.send_next_n_parts--;
      post processFrame();
    }
    else
      signal SendBigMsg.sendDone(SUCCESS);
  }

  default event void SendBigMsg.sendDone(error_t success)
  {
  }
}

