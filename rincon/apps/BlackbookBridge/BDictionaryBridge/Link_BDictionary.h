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
 * Automatically generated header file for BDictionary
 */
 
#ifndef LINK_BDICTIONARY_H
#define LINK_BDICTIONARY_H

#include "message.h"

#define BDICTIONARY_BYTE_ARRAY_LENGTH (TOSH_DATA_LENGTH-13)

typedef nx_struct BDictionaryMsg {
  nx_uint8_t bool0;
  nx_uint8_t short0;
  nx_uint8_t short1;
  nx_uint16_t int0;
  nx_uint32_t long0;
  nx_uint32_t long1;
  nx_uint8_t byteArray[BDICTIONARY_BYTE_ARRAY_LENGTH];
} BDictionaryMsg;

enum {
    BDICTIONARY_CMD_OPEN = 0,
    BDICTIONARY_REPLY_OPEN = 1,
    BDICTIONARY_CMD_ISOPEN = 2,
    BDICTIONARY_REPLY_ISOPEN = 3,
    BDICTIONARY_CMD_CLOSE = 4,
    BDICTIONARY_REPLY_CLOSE = 5,
    BDICTIONARY_CMD_GETFILELENGTH = 6,
    BDICTIONARY_REPLY_GETFILELENGTH = 7,
    BDICTIONARY_CMD_GETTOTALKEYS = 8,
    BDICTIONARY_REPLY_GETTOTALKEYS = 9,
    BDICTIONARY_CMD_INSERT = 10,
    BDICTIONARY_REPLY_INSERT = 11,
    BDICTIONARY_CMD_RETRIEVE = 12,
    BDICTIONARY_REPLY_RETRIEVE = 13,
    BDICTIONARY_CMD_REMOVE = 14,
    BDICTIONARY_REPLY_REMOVE = 15,
    BDICTIONARY_CMD_GETFIRSTKEY = 16,
    BDICTIONARY_REPLY_GETFIRSTKEY = 17,
    BDICTIONARY_CMD_GETLASTKEY = 18,
    BDICTIONARY_REPLY_GETLASTKEY = 19,
    BDICTIONARY_CMD_GETNEXTKEY = 20,
    BDICTIONARY_REPLY_GETNEXTKEY = 21,
    BDICTIONARY_CMD_ISFILEDICTIONARY = 22,
    BDICTIONARY_REPLY_ISFILEDICTIONARY = 23,
    BDICTIONARY_EVENT_OPENED = 24,
    BDICTIONARY_EVENT_CLOSED = 25,
    BDICTIONARY_EVENT_INSERTED = 26,
    BDICTIONARY_EVENT_RETRIEVED = 27,
    BDICTIONARY_EVENT_REMOVED = 28,
    BDICTIONARY_EVENT_NEXTKEY = 29,
    BDICTIONARY_EVENT_FILEISDICTIONARY = 30,
    BDICTIONARY_EVENT_TOTALKEYS = 31,

};

enum {
  AM_BDICTIONARYMSG = 0xB2,
};

#endif

