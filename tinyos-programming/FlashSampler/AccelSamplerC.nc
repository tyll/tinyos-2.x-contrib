/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
#include "flashsampler.h"

module AccelSamplerC
{
  provides interface Sample;
  uses interface ReadStream<uint16_t> as Accel;
  uses interface BlockWrite;
  uses interface Leds;
}
implementation
{
  uint16_t buffer1[BUFFER_SIZE], buffer2[BUFFER_SIZE];
  int8_t nbuffers; // how many buffers have been filled

  command void Sample.sample() {
    // Sampling requested, start by erasing the block
    call BlockWrite.erase();
  }

  event void BlockWrite.eraseDone(error_t ok) {
    call Leds.led2On();
    // Block erased. Post both buffers and initiate sampling
    call Accel.postBuffer(buffer1, BUFFER_SIZE);
    call Accel.postBuffer(buffer2, BUFFER_SIZE);
    nbuffers = 0;
    call Accel.read(SAMPLE_PERIOD);
  }

  event void Accel.bufferDone(error_t ok, uint16_t *buf, uint16_t count) {
    // A buffer is full. Write it to the block
    call Leds.led2Toggle();
    call BlockWrite.write(nbuffers * sizeof buffer1, buf, sizeof buffer1);
  }

  event void BlockWrite.writeDone(storage_addr_t addr, void* buf, storage_len_t len, 
		                  error_t error) {
    // Buffer written. TOTAL_SAMPLES is a multiple of BUFFER_SIZE, so 
    // once we've posted TOTAL_SAMPLES / BUFFER_SIZE buffers we're done.
    // As we started by posting two buffers, the test below includes a -2
    if (++nbuffers <= TOTAL_SAMPLES / BUFFER_SIZE - 2)
      call Accel.postBuffer(buf, BUFFER_SIZE);
    else if (nbuffers == TOTAL_SAMPLES / BUFFER_SIZE)
      // Once we've written all the buffers, flush writes to the buffer
      call BlockWrite.sync();
  }

  event void BlockWrite.syncDone(error_t error) {
    call Leds.led2Off();
    signal Sample.sampled(error);
  }

  event void Accel.readDone(error_t ok, uint32_t usActualPeriod) {
    // If we didn't use all buffers something went wrong, e.g., flash writes were
    // too slow, so the buffers did not get reposted in time
    signal Sample.sampled(FAIL);
  }
}
