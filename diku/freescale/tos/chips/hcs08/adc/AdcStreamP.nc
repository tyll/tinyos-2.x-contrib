/* $Id$
 * Copyright (c) 2005 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 *
 * Copyright (c) 2004, Technische Universitaet Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without 
 * modification, are permitted provided that the following conditions 
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright 
 *   notice, this list of conditions and the following disclaimer in the 
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitaet Berlin nor the names 
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY 
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

/**
 * Convert Hcs08 HAL A/D interface to the HIL interfaces.
 * originally from atm128 adapted for Hcs08 by Tor Petterson
 * 
 * @author David Gay
 * @author Jan Hauer <hauer@tkn.tu-berlin.de>
 * @author Tor Petterson <motor@diku.dk>
 */
#include "Timer.h"

module AdcStreamP {
  provides {
    interface Init @atleastonce();
    interface ReadStream<uint16_t>[uint8_t client];
  }
  uses {
    interface Hcs08AdcSingle;
    interface Hcs08AdcConfig[uint8_t client];
    interface Alarm<TMicro, uint32_t>;
  }
}
implementation {
  enum {
    NSTREAM = uniqueCount(UQ_ADC_READSTREAM)
  };

  /* Resource reservation is required, and it's incorrect to call getData
     again before dataReady is signaled, so there are no races in correct
     programs */
  norace uint8_t client = NSTREAM;

  /* Stream data */
  struct list_entry_t {
    uint16_t count;
    struct list_entry_t *next;
  };
  struct list_entry_t *bufferQueue[NSTREAM];
  struct list_entry_t **bufferQueueEnd[NSTREAM];
  uint16_t *lastBuffer, lastCount;

  norace uint16_t *buffer, *pos, count;
  norace uint32_t now, period;


  command error_t Init.init() {
    uint8_t i;

    for (i = 0; i != NSTREAM; i++)
      bufferQueueEnd[i] = &bufferQueue[i];
    
    return SUCCESS;
  }

uint8_t channel() {
    return call Hcs08AdcConfig.getChannel[client]();
  }

  uint8_t prescaler() {
    return call Hcs08AdcConfig.getPrescaler[client]();
  }
  
  bool is8bit()
  {
  	return call Hcs08AdcConfig.get8bit[client]();
  }
  
  bool issigned()
  {
  	return call Hcs08AdcConfig.getSigned[client]();
  }
  
  bool leftJustify()
  {
  	return call Hcs08AdcConfig.getLeftJustify[client]();
  }

  void sample() {
    call Hcs08AdcSingle.getData(channel(), leftJustify(), is8bit(), issigned(),  prescaler());
  }

  command error_t ReadStream.postBuffer[uint8_t c](uint16_t *buf, uint16_t n) {
    atomic
      {
	struct list_entry_t *newEntry = (struct list_entry_t *)buf;

	if (!bufferQueueEnd[c]) // Can't post right now.
	  return FAIL;

	newEntry->count = n;
	newEntry->next = NULL;
	*bufferQueueEnd[c] = newEntry;
	bufferQueueEnd[c] = &newEntry->next;
      }
    return SUCCESS;
  }

  task void readStreamDone() {
    uint8_t c = client;
    uint32_t actualPeriod = period; //call Atm128Calibrate.actualMicro(period);

    client = NSTREAM;
    signal ReadStream.readDone[c](SUCCESS, actualPeriod);
  }

  task void readStreamFail() {
    /* By now, the pending bufferDone has been signaled (see readStream). */
    struct list_entry_t *entry;
    uint8_t c = client;

    atomic entry = bufferQueue[c];
    for (; entry; entry = entry->next)
      signal ReadStream.bufferDone[c](FAIL, (uint16_t *)entry, entry->count);

    atomic
      {
	bufferQueue[c] = NULL;
	bufferQueueEnd[c] = &bufferQueue[c];
      }

    client = NSTREAM;
    signal ReadStream.readDone[c](FAIL, 0);
  }

  task void bufferDone() {
    uint16_t *b, c;
    atomic
      {
	b = lastBuffer;
	c = lastCount;
	lastBuffer = NULL;
      }

    signal ReadStream.bufferDone[client](SUCCESS, b, c);
  }

  void nextAlarm() {
    call Alarm.startAt(now, period);
    now += period;
  }

  async event void Alarm.fired() {
    sample();
  }

  command error_t ReadStream.read[uint8_t c](uint32_t usPeriod)
  {
    /* The first reading may be imprecise. So we just do a dummy read
       to get things rolling - this is indicated by setting count to 0 */
    count = 0;
    period = usPeriod; //call Atm128Calibrate.calibrateMicro(usPeriod);
    client = c;
    sample();

    return SUCCESS;
  }

  void nextBuffer() {
    atomic
      {
	struct list_entry_t *entry = bufferQueue[client];

	if (!entry)
	  {
	    // all done
	    bufferQueueEnd[client] = NULL; // prevent post
	    post readStreamDone();
	  }
	else
	  {
	    bufferQueue[client] = entry->next;
	    if (!bufferQueue[client])
	      bufferQueueEnd[client] = &bufferQueue[client];
	    pos = buffer = (uint16_t *)entry;
	    count = entry->count;
	    nextAlarm();
	  }
      }
  }

  async event void Hcs08AdcSingle.dataReady(uint16_t data) {
    if (client == NSTREAM)
      return;

    if (count == 0)
      {
	now = call Alarm.getNow();
	nextBuffer();
      }
    else
      {
	*pos++ = data;
	if (!--count)
	  {
	    atomic
	      {
		if (lastBuffer)
		  {
		    /* We failed to signal bufferDone in time. Fail. */
		    bufferQueueEnd[client] = NULL; // prevent post
		    post readStreamFail();
		    return;
		  }
		else
		  {
		    lastBuffer = buffer;
		    lastCount = pos - buffer;
		  }
	      }
	    post bufferDone();
	    nextBuffer();
	  }
	else
	  nextAlarm();
      }       
  }

  /* Configuration defaults. Read ground fast! ;-) */
 default async command uint8_t Hcs08AdcConfig.getChannel[uint8_t c]() {
    return Hcs08_ADC_VREFL;
  }

  default async command uint8_t Hcs08AdcConfig.getPrescaler[uint8_t c]() {
    return Hcs08_ADC_PRESCALE_18;
  }
  
  default async command bool Hcs08AdcConfig.get8bit[uint8_t c]() {
    return FALSE;
  }
  
  default async command bool Hcs08AdcConfig.getSigned[uint8_t c]() {
    return FALSE;
  }
  
  default async command bool Hcs08AdcConfig.getLeftJustify[uint8_t c]() {
    return FALSE;
  }
}
