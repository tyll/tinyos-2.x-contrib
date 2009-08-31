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
 * Clear threshold estimation based on RSSI measurements.
 *
 * @author Philip Buonadonna
 * @author Jaein Jeong
 * @author Joe Polastre
 * @author David Gay
 * @author Mark Hays
 * @author David Moss
 */
  
#include "Squelch.h"

module SquelchP {
  provides {
    interface Init;
    interface Squelch[uint8_t client];
  }
}

implementation {

  /** The threshold before we see a clear channel */
  uint16_t clearThreshold[uniqueCount(UQ_SQUELCH_CLIENT)];
  
  /** The squelch table */
  uint16_t squelchTable[uniqueCount(UQ_SQUELCH_CLIENT)][SQUELCH_TABLE_SIZE];
  
  /** The index we're currently storing to in our squelch table */
  uint8_t  squelchIndex[uniqueCount(UQ_SQUELCH_CLIENT)];
  
  /** Number of samples taken to determine settling */
  uint16_t  squelchCount[uniqueCount(UQ_SQUELCH_CLIENT)];
  
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;

    for(i = 0; i < uniqueCount(UQ_SQUELCH_CLIENT); i++) {
      call Squelch.restart[i]();
    }
    
    return SUCCESS;
  }

  /***************** Squelch Commands ****************/
  command void Squelch.adjust[uint8_t client](uint16_t data) {
    uint16_t buf[SQUELCH_TABLE_SIZE];
    uint16_t cur;
    uint16_t med;
    uint16_t upd;
    uint32_t tmp;
    uint8_t  i;

    // add data to table
    squelchTable[client][squelchIndex[client]++] = data;
    
    if (squelchIndex[client] >= SQUELCH_TABLE_SIZE) {
      squelchIndex[client] = 0;
    }
    
    // settled?
    if (squelchCount[client] <= SQUELCH_MIN_COUNT) {
      squelchCount[client]++;
    }

    // compute median using... (partial) bubble sort!
    memcpy(buf, squelchTable[client], sizeof(buf));
    for (i = 0; i <= SQUELCH_TABLE_SIZE >> 1; i++) { // only need to sort bottom half
      uint8_t  mp = i, j;
      uint16_t mv = buf[i], v;

      for (j = i + 1; j < SQUELCH_TABLE_SIZE; j++) {
        if ((v = buf[j]) < mv) {
          mv = v;
          mp = j;
        }
      }
      
      if (mp != i) {
        v       = buf[i];
        buf[i]  = mv;
        buf[mp] = v;
      }
    }
    
    med = buf[SQUELCH_TABLE_SIZE >> 1];

    // Do an exponentially weighted moving average (EWMA) update
    atomic cur = clearThreshold[client];
    tmp  = ((uint32_t) cur) * ((uint32_t) SQUELCH_NUMERATOR);
    tmp += ((uint32_t) med) * ((uint32_t) (SQUELCH_DENOMINATOR - SQUELCH_NUMERATOR));
    tmp /= (uint32_t) SQUELCH_DENOMINATOR;
    upd  = tmp;
    
    // if the division truncated the result, give it a kick
    if ((upd == cur) && (med > upd)) {
      upd++;
    }

    // and save it
    atomic clearThreshold[client] = upd;
  }
  
  command void Squelch.restart[uint8_t client]() {
    int i;

    clearThreshold[client] = SQUELCH_INITIAL_THRESHOLD;
    squelchCount[client] = 0;
    squelchIndex[client] = 0;
    for (i = 0; i < SQUELCH_TABLE_SIZE; i++) {
      squelchTable[client][i] = SQUELCH_INITIAL_THRESHOLD;
    }
  }
  
  async command uint16_t Squelch.get[uint8_t client]() {
    return clearThreshold[client];
  }
  
  command bool Squelch.settled[uint8_t client]() {
    return squelchCount[client] >= SQUELCH_MIN_COUNT;
  }
  
}
