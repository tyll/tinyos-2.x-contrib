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
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

#ifndef EXTERNALFLASHVIEWER_H
#define EXTERNALFLASHVIEWER_H

#include "message.h"

typedef nx_struct ViewerMsg {
  nx_uint32_t addr;
  nx_uint16_t len;
  nx_uint8_t cmd;
  nx_uint8_t id; 
  nx_uint8_t data[TOSH_DATA_LENGTH - 8];
} ViewerMsg;


enum {
  AM_VIEWERMSG = 0xA1,
};

enum {
  CMD_READ = 0,
  CMD_WRITE = 1, 
  CMD_ERASE = 2,
  CMD_MOUNT = 3,
  CMD_FLUSH = 4,
  CMD_PING = 5,
  CMD_CRC = 6,
  
  REPLY_READ = 10,
  REPLY_WRITE = 11,
  REPLY_ERASE = 12,
  REPLY_FLUSH = 14,
  REPLY_PING = 15,
  REPLY_CRC = 16,
  
  REPLY_READ_CALL_FAILED = 20,
  REPLY_WRITE_CALL_FAILED = 21,
  REPLY_ERASE_CALL_FAILED = 22,
  REPLY_FLUSH_CALL_FAILED = 24,
  REPLY_CRC_CALL_FAILED = 26,
  
  REPLY_READ_FAILED = 30,
  REPLY_WRITE_FAILED = 31,
  REPLY_ERASE_FAILED = 32,
  REPLY_FLUSH_FAILED = 34,
  REPLY_CRC_FAILED = 36,
  
  REPLY_INVALID_COMMAND = 50,
};


#endif

