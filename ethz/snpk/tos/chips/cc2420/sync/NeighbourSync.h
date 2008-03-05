/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
* 
*  @author: Roman Lim <lim@tik.ee.ethz.ch>
*
*/

#ifndef NEIGHBOURSYNC_H
#define NEIGHBOURSYNC_H

#include <AM.h>
#include "CC2420.h"

enum {
  NEIGHBOURSYNCTABLESIZE = 8, // size of sync neighbour table
  TABLE_UPDATE_DELAY = 100, // the neighbour table is updated after this delay [ms], or when radio is off
  MEASURE_HISTORY_SIZE = 4,
  NO_VALID_OFFSET = 0xffffffff,
  NO_VALID_DRIFT = 32767,
  NO_SYNC = 0xffffffff,
  T32KHZ_TO_TMILLI_SHIFT = 5, // factor for conversion TMilli > T32khz

  RADIO_STARTUP_OFFSET = 170, // jiffys until the radio is started and FIFO is loaded, should be calculated from packet length
  REVERSE_SEND_OFFSET = 104, //use 104 if no initial backoff  // less means: transmission begins earlier 
  NO_COMPENSATION_OFFSET = 100,  // less means: transmission begins later. This offset is used to begin transmission earlier when no compensation is done

  ALARM_OFFSET = RADIO_STARTUP_OFFSET,
  AGING_PERIOD = 10,
  TOTAL_AGING_PERIOD = NEIGHBOURSYNCTABLESIZE * AGING_PERIOD, // after AGING_PERIOD packets, each usageCounter is decremented by AGING_PERIOD / 16
  

  SYNC_FAIL_THRESHOLD = 10, // after SYNC_FAIL_THRESHOLD non-acked packets, sync information is not valid anymore
  REQ_SYNC_FLAG = 0x8000,
  MORE_FLAG = 0x4000,
  SYNC_TIMER_PERIOD = 30000UL, // period to gather sync-requests in milliseconds
  DRIFT_CHANGE_LIMIT = 50, 	// value >> 21 that a new measured drift is allowed to differ from the last average
  							// 50 is about 23ppm
  MAX_DRIFT_ERRORS = 5,	// number of false drifts until history is cleared, e.g. when neihgbour node has resetted
  MIN_MEASUREMENT_PERIOD = 131072UL, // 4s, minimal drift measurement period in ticks
 
  RESYNC_AM_TYPE = 26, 
};

typedef struct {	// 18 + MEASURE_HISTORY_SIZE * 4 bytes
  am_addr_t address; // 0
  uint32_t wakeupTimestamp[MEASURE_HISTORY_SIZE]; // 2
  uint32_t newTimestamp; // 4
  uint32_t wakeupAverage; // 20
  bool odd; // 24
  uint8_t measurementCount; // 25
  uint16_t usageCount; // 26
  uint8_t failCount; // 28
  uint8_t driftLimitCount; // 29
  uint32_t lplPeriod; // in ticks 30
  int16_t drift; // 34
  bool dirty; // 36
  // align to word address -> struct size = 38, when MEASURE_HISTORY_SIZE==4
} neighbour_sync_item_t;

typedef nx_struct {
  nx_uint32_t wakeupOffset; // time that has passed between senders wakeup and the time the sfd was sent 
  nx_uint16_t lplPeriod;	// this field contains lpl information and the flags
  							//		REQ_SYNC_FLAG (highest bit)
							//		MORE_FLAG (second highest bit)
  							// lplperiod can be at max 2^14 binary ms ~ 16s
  							// but wakeupOffset is in ticks that can represent max 2 seconds -> this is currently the limit
  } neighbour_sync_header_t;

#endif
