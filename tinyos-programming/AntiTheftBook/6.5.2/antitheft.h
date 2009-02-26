/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
#ifndef ANTITHEFT_H
#define ANTITHEFT_H

enum { AM_THEFT = 42, AM_SETTINGS = 43 };
enum { COL_THEFT = 54, DIS_THEFT = 55 };

typedef nx_struct theft {
  nx_uint16_t who;
} theft_t;

typedef nx_struct settings {
  nx_uint16_t accelVariance;
  nx_uint16_t accelInterval;
} settings_t;

#endif
