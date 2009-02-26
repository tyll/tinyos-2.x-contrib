/*
 * Copyright (c) 2007-2009 Intel Corporation
 * All rights reserved.

 * This file is distributed under the terms in the attached INTEL-LICENS
 * file. If you do not find this file, a copy can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */
#ifndef RELIABLESERIAL_H
#define RELIABLESERIAL_H

enum { ACK_TIMEOUT = 250,
       AM_ACK_MSG = 22,
       AM_RELIABLE_MSG = 23 };

typedef nx_struct reliable_msg {
  nx_uint8_t cookie;
  nx_uint8_t data[];
} reliable_msg_t;

typedef nx_struct ack_msg {
  nx_uint8_t cookie;
} ack_msg_t;

#endif
