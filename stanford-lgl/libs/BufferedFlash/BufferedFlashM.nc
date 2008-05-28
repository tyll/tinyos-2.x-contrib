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
#include "BufferedFlash.h"

module BufferedFlashM
{
  provides interface BufferedFlash;
  uses interface Boot;
  uses interface BlockRead;
  uses interface BlockWrite;
}

implementation
{
  uint8_t *wbuf;
  uint16_t wbuf_idx=0;
  uint8_t buf1[BUF_SIZE];
  uint8_t buf2[BUF_SIZE];
  uint32_t total_data_size=0;

  uint8_t  rdata[BUF_SIZE];
  uint16_t rdata_idx=0;
  uint32_t raddr_offset=0;

  flash_header_t header;
  message_t packet;

  enum{
    STATE_IDLE=0,
    STATE_INIT=1,
    STATE_FLUSH=2,
    STATE_WRITE=3,
    STATE_WRITE_HDR=4,
  };

  uint8_t state=STATE_IDLE;

  event void Boot.booted()
  {
    wbuf = buf1;
    total_data_size=0;
    state=STATE_INIT;
    if (call BlockRead.read(FLASH_HDR_ADDR, &header, sizeof(flash_header_t)) != SUCCESS)
    {
      state=STATE_WRITE_HDR;
      header.total_size=0;
      call BlockWrite.write(FLASH_HDR_ADDR, &header, sizeof(flash_header_t));
    }
  }

  event void BlockWrite.writeDone(storage_addr_t addr, void *buf,
                  storage_len_t len, error_t err)
  {
    if (state == STATE_WRITE)
    {
      signal BufferedFlash.writeDone(err);
      state=STATE_IDLE;
    }
    else if (state == STATE_FLUSH)
    {
      header.total_size=total_data_size;
      state=STATE_WRITE_HDR;
      call BlockWrite.write(FLASH_HDR_ADDR, &header, sizeof(flash_header_t));
      signal BufferedFlash.flushDone(SUCCESS);
    }
    else
      state=STATE_IDLE;
  }

  uint16_t dataWriteSize;
  task void dataWrite()
  {
    uint8_t *ptr = NULL;
    if (wbuf == buf1)
      ptr = buf2;
    else if (wbuf == buf2)
      ptr = buf1;

    if (call BlockWrite.write(FLASH_ADDR+total_data_size, ptr, dataWriteSize) == SUCCESS)
      total_data_size += dataWriteSize;
    else
      signal BlockWrite.writeDone(0,0,0,FAIL);
  }

  void switchWBuffers()
  {
    if (wbuf == buf1)
      wbuf = buf2;
    else
      wbuf = buf1;
    wbuf_idx = 0;
  }

  command error_t BufferedFlash.write(uint8_t *buf, uint8_t num, uint8_t size)
  {
    uint8_t *_buf = buf;
    uint16_t _length = (uint16_t)num*size;

    if (_length>=BUF_SIZE || state != STATE_IDLE)
      return FAIL;

    if ((wbuf_idx+_length) > BUF_SIZE)
    {
      uint8_t copied_len = BUF_SIZE-wbuf_idx;
      memcpy (&wbuf[wbuf_idx], _buf, copied_len);
      _length -= copied_len;
      _buf += copied_len;
      dataWriteSize=BUF_SIZE;
      switchWBuffers();
      post dataWrite();
      state=STATE_WRITE;
    }

    memcpy(&wbuf[wbuf_idx], _buf, _length);
    wbuf_idx+=_length;

    if (state == STATE_IDLE)
      signal BufferedFlash.writeDone(SUCCESS);

    return SUCCESS;
  }

  event void BlockWrite.syncDone(error_t err)
  {
    if (err != SUCCESS)
    {
      signal BufferedFlash.flushDone(FAIL);
      state=STATE_IDLE;
      return;
    }
    if (wbuf_idx==0)
    {
      signal BufferedFlash.flushDone(SUCCESS);
      state=STATE_IDLE;
      return;
    }

    dataWriteSize=wbuf_idx;
    switchWBuffers();
    post dataWrite();
  }

  command error_t BufferedFlash.flush()
  {
    if (state!=STATE_IDLE)
      return FAIL;
    state=STATE_FLUSH;

    return call BlockWrite.sync();
  }

  /* -------------- READ  --------------- */
  uint8_t *ret_buf;
  uint16_t ret_length;

  task void dataRead()
  {
    if ((rdata_idx+ret_length) > BUF_SIZE)
    {
      uint8_t copied_len = BUF_SIZE-rdata_idx;
      memcpy (ret_buf, &rdata[rdata_idx], copied_len);
      ret_buf = &ret_buf[copied_len];
      ret_length -= copied_len;

      if (call BlockRead.read(FLASH_ADDR+raddr_offset, rdata, BUF_SIZE) == SUCCESS)
        raddr_offset += BUF_SIZE;
      else
        signal BufferedFlash.readDone(FAIL);
    }
    else
    {
      memcpy(ret_buf, &rdata[rdata_idx], ret_length);
      rdata_idx += ret_length;
      signal BufferedFlash.readDone(SUCCESS);
    }
  }

  event void BlockRead.readDone(storage_addr_t addr, void *buf,
                  storage_len_t len, error_t err)
  {
    if (state==STATE_INIT)
    {
      if (err == SUCCESS)
        total_data_size = header.total_size;
      state=STATE_IDLE;
      return;
    }

    if (err == SUCCESS)
    {
      rdata_idx = 0;
      post dataRead();
    }
    else
      signal BufferedFlash.readDone(FAIL);
  }

  command error_t BufferedFlash.read(uint8_t *buf, uint16_t length)
  {
    if (length>=BUF_SIZE || length > total_data_size )
      return FAIL;
    ret_length = length;
    ret_buf = buf;
    raddr_offset = 0;
    rdata_idx = 0;
    if (call BlockRead.read(FLASH_ADDR+raddr_offset, rdata, BUF_SIZE) != SUCCESS)
      return FAIL;
    raddr_offset += BUF_SIZE;
    return SUCCESS;
  }

  command error_t BufferedFlash.readNext(uint8_t *buf, uint16_t length)
  {
    if (length>=BUF_SIZE || ((raddr_offset-BUF_SIZE)+rdata_idx+length) > total_data_size )
      return FAIL;
    ret_length = length;
    ret_buf = buf;
    post dataRead();
    return SUCCESS;
  }

  /* -------------- ERASE --------------- */

  command error_t BufferedFlash.erase()
  {
    return call BlockWrite.erase();
  }

  event void BlockWrite.eraseDone(error_t err)
  {
    wbuf_idx = 0;
    total_data_size = 0;
    header.total_size=0;
    state=STATE_WRITE_HDR;
    call BlockWrite.write(FLASH_HDR_ADDR, &header, sizeof(flash_header_t));
  }

  event void BlockRead.computeCrcDone(storage_addr_t addr, storage_len_t len,
                    uint16_t z, error_t err)
  {
  }
}
