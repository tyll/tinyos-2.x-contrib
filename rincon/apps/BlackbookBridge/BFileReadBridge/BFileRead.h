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

/**
 * Automatically generated header file for BFileRead
 */
 
#ifndef BFILEREAD_H
#define BFILEREAD_H

#include "message.h"

#define BFILEREAD_BYTE_ARRAY_LENGTH (TOSH_DATA_LENGTH-9)

typedef nx_struct BFileReadMsg {
  nx_uint8_t bool0;
  nx_uint8_t short0;
  nx_uint8_t short1;
  nx_uint16_t int0;
  nx_uint32_t long0;
  nx_uint8_t byteArray[BFILEREAD_BYTE_ARRAY_LENGTH];
} BFileReadMsg;

enum {
    CMD_OPEN = 0,
    REPLY_OPEN = 1,
    CMD_ISOPEN = 2,
    REPLY_ISOPEN = 3,
    CMD_CLOSE = 4,
    REPLY_CLOSE = 5,
    CMD_READ = 6,
    REPLY_READ = 7,
    CMD_SEEK = 8,
    REPLY_SEEK = 9,
    CMD_SKIP = 10,
    REPLY_SKIP = 11,
    CMD_GETREMAINING = 12,
    REPLY_GETREMAINING = 13,
    EVENT_OPENED = 14,
    EVENT_CLOSED = 15,
    EVENT_READDONE = 16,

};

enum {
  AM_BFILEREADMSG = 0xB5,
};

#endif

