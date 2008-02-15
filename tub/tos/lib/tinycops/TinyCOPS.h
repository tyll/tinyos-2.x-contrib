/* 
 * Copyright (c) 2007, Technische Universitaet Berlin
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
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * ========================================================================
 */

#ifndef __TINYCOPS_H
#define __TINYCOPS_H

#include "message.h"

#define MAX_SUBSCRIPTION_SIZE (TOSH_DATA_LENGTH-10)
 
typedef uint8_t attribute_id_t; //typedef nx_uint8_t attribute_id_t;
typedef nx_uint8_t operation_t;

typedef nx_struct constraint
{
  nx_uint8_t attributeID;
  operation_t operationID;
  nx_uint8_t value[0];
} constraint_t;

typedef nx_struct avpair
{
  nx_uint8_t attributeID;
  nx_int8_t value[0];
} avpair_t;

enum {
  PSITEM_ITEM = 0x80,
  PSITEM_CONSTRAINT = 0x40,
  PSITEM_SIZE_MASK = 0x3F,
};

typedef nx_struct ps_item {

// "control"-field:
// 
//    0 1 2 3 4 5 6 7 
//   +-+-+-+-+-+-+-+-+
//   |   Size    |C|I|
//   +-+-+-+-+-+-+-+-+
//   
// Size = the size of the complete ps_item (in bytes) if I = 1
//        or the available size left in the message if I = 0
// C = constraint-flag: if set the item is a constraint, 
//     otherwise it's an avpair 
// I = item-flag: if set this is a valid ps_item, otherwise
//     it's the termination byte that shows how many bytes are
//     left in the message

 nx_uint8_t control;
 nx_union {
   avpair_t avpair;
   constraint_t constraint;
 };
} ps_item_t;

typedef nx_struct subscription
{
  nx_uint8_t data[0];  // ps_item_t
} subscription_t;

typedef nx_struct notification
{
  nx_uint8_t data[0];  // ps_item_t
} notification_t;

typedef struct { } CSEC_INBOUND;
typedef struct { } CSEC_OUTBOUND;

typedef subscription_t *subscription_handle_t;
typedef notification_t *notification_handle_t;

typedef uint32_t add_up_32_t __attribute__((combine(add32combine)));
uint32_t add32combine(uint32_t s1,uint32_t s2)
{
  return (s1 + s2);
}
enum {
  AM_NOTIFICATION = 155,
  AM_SUBSCRIPTION = 156,
};

#define ATTRIBUTE_COLLECTION_ID "Attribute.Collection.ID"
#define PSCLIENT_ID "PublishSubscribe.PSClient.ID"
#define ATTRIBUTECLIENT_ID "PublishSubscribe.AttributeClient.ID"
#define PSBRIDGE_CLIENT_ID "PublishSubscribe.SubscriberBridge.ID"

#endif
