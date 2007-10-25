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

#include "Statistics.h"

/**
 * Log day to day statistics on the computer, characterizing performance and 
 * progress over time
 * @author David Moss
 */
module StatisticsP {
  provides {
    interface Statistics[uint8_t id];
  }
  
  uses {
    interface AMSend;
    interface State;
    interface StatsQuery;
    interface FifoQueue<StatisticsMsg*>;
  }
}

implementation {

  /** Message to send */
  message_t myMsg;
  
  /** Statistics payloads to queue */
  StatisticsMsg statsPayload[uniqueCount(UQ_STATISTICS)];
  
  enum {
    S_IDLE,
    S_BUSY,
  };
  
  /***************** Prototypes ****************/
  
  /***************** Statistics Commands ****************/
  command error_t Statistics.log[uint8_t id](char *units, uint32_t value) {
    StatisticsMsg *stats;
    
    if(id > uniqueCount(UQ_STATISTICS)) {
      return EINVAL;
    }
    
    stats = &(statsPayload[id]);

    stats->value = value;
    stats->unitLength = 0;
    stats->statsId = id;
    
    if(units != NULL) {
      while(*units && stats->unitLength < STATISTICS_LENGTH) {
        stats->units[stats->unitLength] = *units++;
        stats->unitLength++;
      }
    }
    
    return call FifoQueue.enqueue(stats);
  }
  
  /***************** FifoQueue Events ****************/
  event void FifoQueue.available() {
    StatisticsMsg *focusedMsg;

    if(call State.requestState(S_BUSY) != SUCCESS) {
      return;
    }
    
    if(call FifoQueue.dequeue(&focusedMsg, TOSH_DATA_LENGTH) == SUCCESS) {
      memcpy((&myMsg)->data, focusedMsg, sizeof(StatisticsMsg));
      call AMSend.send(0, &myMsg, sizeof(StatisticsMsg));
    
    } else {
      call State.toIdle();
    }
  }
  
  /***************** AMSend Events ****************/
  event void AMSend.sendDone(message_t *msg, error_t error) {
    StatisticsMsg *focusedMsg;
    
    if(call FifoQueue.dequeue(&focusedMsg, TOSH_DATA_LENGTH) == SUCCESS) {
      memcpy((&myMsg)->data, focusedMsg, sizeof(StatisticsMsg));
      call AMSend.send(0, &myMsg, sizeof(StatisticsMsg));
    
    } else {
      call State.toIdle();
    }
  }
  
  /***************** StatsQuery Events ****************/
  /**
   * TUnit will not stop until all statistics have been exfil'd.
   * This event decouples the main TUnit library from the statistics library,
   * allowing TUnit to compile without using this statistics module to save
   * memory footprint
   */
  event bool StatsQuery.isIdle() {
    return call FifoQueue.isEmpty();
  }
  
  /***************** Defaults ****************/
  
}

