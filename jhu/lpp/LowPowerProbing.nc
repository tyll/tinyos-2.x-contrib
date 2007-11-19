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
 * Low Power Probing interface. This is a simplified version of
 * the LowPowerListening interface from T2.
 *
 * @author Jonathan Hui
 * @author David Moss
 * @author Razvan Musaloiu-E.
 */
 
#include "message.h"
 
interface LowPowerProbing {

  /**
   * Set the radio sleep interval, in milliseconds. Once every
   * interval, the node will wake up and probe for awake neighbors.
   * The function schedules a task to turn the radio off. If the radio
   * is already off then the timer for the sleepIntervalMs is started
   * immediately.
   *
   * Setting the sleep interval to 0 will disable the probing.  The
   * radio will be left in its current state.
   *
   * @param sleepIntervalMs the length of the node's sleep interval, in [ms]
   */
  command void setLocalSleepInterval(uint16_t sleepIntervalMs);
  
  /**
   * @return the local node's sleep interval, in [ms]
   */
  command uint16_t getLocalSleepInterval();
}
