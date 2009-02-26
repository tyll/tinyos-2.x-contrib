/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
#ifndef FLASHSAMPLER_H
#define FLASHSAMPLER_H

enum {
  SAMPLE_INTERVAL = 1024L * 60
};

enum {
  SAMPLE_PERIOD = 1000, 
  BUFFER_SIZE = 512,     // samples per buffer
  TOTAL_SAMPLES = 32768L, // must be multiple of BUFFER_SIZE
};

enum { SUMMARY_SAMPLES = 256, // total samples in summary
       // downsampling factor: real samples per summary sample
       DFACTOR = 32768L / SUMMARY_SAMPLES };

#endif
