/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
#include "flashsampler.h"

module SummarizerC { 
  provides interface Summary;
  uses interface BlockRead;
  uses interface LogWrite;
}
implementation 
{
  uint16_t summary[SUMMARY_SAMPLES], samples[DFACTOR];
  uint16_t index; // of next summary sample to compute

  void nextSummarySample();

  command void Summary.summarize() {
    // Summarize the current sample block
    index = 0;
    nextSummarySample();
  }

  void nextSummarySample() {
    // Read DFACTOR samples to compute the next summary sample
    call BlockRead.read(index * DFACTOR * sizeof(uint16_t), samples, sizeof samples);
  }

  event void BlockRead.readDone(storage_addr_t addr, void* buf, storage_len_t len, 
				error_t error) {
    // Average the DFACTOR samples which will become one summary sample
    uint32_t sum = 0;
    uint16_t i;

    for (i = 0; i < DFACTOR; i++) sum += samples[i];
    summary[index++] = sum / DFACTOR;

    // Move on to the next sample summary, or log the whole summary if we're done
    if (index < SUMMARY_SAMPLES)
      nextSummarySample();
    else
      call LogWrite.append(summary, sizeof summary);
  }

  event void LogWrite.appendDone(void* buf, storage_len_t len, bool recordsLost,
			         error_t error) {
    // Summary saved! 
    signal Summary.summarized(error);
  }

  event void BlockRead.computeCrcDone(storage_addr_t addr, storage_len_t len,
			    uint16_t crc, error_t error) { }

  event void LogWrite.eraseDone(error_t error) { }

  event void LogWrite.syncDone(error_t error) { }
}
