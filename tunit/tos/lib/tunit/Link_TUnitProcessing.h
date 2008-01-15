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
 * Automatically generated header file for TUnitProcessing
 */
 
#ifndef LINK_TUNITPROCESSING_H
#define LINK_TUNITPROCESSING_H

#include "message.h"

/**
 * Maximum number of outbound messages in our queue
 */
#ifndef MAX_TUNIT_QUEUE
#define MAX_TUNIT_QUEUE 5
#endif


#define PROCESSING_MSG_LENGTH (TOSH_DATA_LENGTH - 13)
typedef nx_struct TUnitProcessingMsg {
  nx_uint8_t cmd;
  nx_uint8_t id;  // test id
  nx_uint8_t assertionId;
  nx_uint32_t expected;
  nx_uint32_t actual;
  nx_bool lastMsg;
  nx_uint8_t failMsgLength;
  nx_uint8_t failMsg[PROCESSING_MSG_LENGTH];
} TUnitProcessingMsg;


enum {
    TUNITPROCESSING_CMD_PING = 0,
    TUNITPROCESSING_REPLY_PING = 1,
    TUNITPROCESSING_CMD_RUN = 2,
    TUNITPROCESSING_REPLY_RUN = 3,
    TUNITPROCESSING_EVENT_PONG = 4,
    TUNITPROCESSING_EVENT_TESTRESULT_SUCCESS = 5,
    TUNITPROCESSING_EVENT_TESTRESULT_FAILED = 6,
    TUNITPROCESSING_EVENT_TESTRESULT_EQUALS_FAILED = 7,
    TUNITPROCESSING_EVENT_TESTRESULT_NOTEQUALS_FAILED = 8,
    TUNITPROCESSING_EVENT_TESTRESULT_BELOW_FAILED = 9,
    TUNITPROCESSING_EVENT_TESTRESULT_ABOVE_FAILED = 10,
    TUNITPROCESSING_EVENT_ALLDONE = 11,
    TUNITPROCESSING_CMD_TEARDOWNONETIME = 12,
};

enum {
  AM_TUNITPROCESSINGMSG = 0xFF,
};

#endif

