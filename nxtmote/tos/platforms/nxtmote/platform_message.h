/*
 * Copyright (c) 2005-2006 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA,
 * 94704.  Attention:  Intel License Inquiry.
 */
/**
 * Dummy implementation to support the null platform.
 */

/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */

#ifndef PLATFORM_MESSAGE_H
#define PLATFORM_MESSAGE_H

//#include "Serial.h"
#include "Bc4.h"

typedef union message_header {
  //serial_header_t serial;
  bc4_header_t bc4;
} message_header_t;

typedef union message_footer {
  bc4_footer_t bc4;
} message_footer_t;

typedef union message_metadata {
  bc4_metadata_t bc4;
} message_metadata_t;

#endif
