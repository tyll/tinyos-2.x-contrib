// ex: set tabstop=2 shiftwidth=2 expandtab syn=c:
// $Id$

/*
 * "Copyright (c) 2000-2003 The Regents of the University  of California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA,
 * 94704.  Attention:  Intel License Inquiry.
 */

/*
 * Authors:  Rodrigo Fonseca
 * Date Last Modified: 2005/05/26
 */
#ifndef REV_LINK_H
#define REV_LINK_H

#include "LinkEstimator.h"

enum {
  NUM_REVERSE_LINK_ENTRIES = 7,
  REVERSE_LINK_INVALID_ADDR = 65535u,
};

typedef nx_struct {
  nx_uint16_t addr;
  nx_uint8_t quality;
}  ReverseLinkEntry;

typedef nx_struct {
  nx_uint8_t num_elements;
  nx_uint8_t total_links;
  ReverseLinkEntry entries[NUM_REVERSE_LINK_ENTRIES];
} ReverseLinkInfo;

typedef nx_struct LE_Reverse_Link_Estimation_Msg {
  LEHeader header;
  ReverseLinkInfo info;
}  ReverseLinkMsg;

error_t reverseLinkInfoInit(ReverseLinkInfo* ptr) {
  int i;
  if (ptr == NULL)
    return FAIL;
  ptr->num_elements = 0;
  for (i = 0; i < NUM_REVERSE_LINK_ENTRIES; i++) {
    ptr->entries[i].addr = REVERSE_LINK_INVALID_ADDR;
    ptr->entries[i].quality = 0;
  }
  return SUCCESS;
}

error_t reverseLinkInfoGetQuality(ReverseLinkInfo* rliPtr, uint16_t addr, uint8_t *quality) {
  int i;
  bool found = FALSE;
  if (rliPtr == NULL)
    return FAIL;
  for (i = 0; i < rliPtr->num_elements && !found; i++) {
	dbg("S4-debug", "%d\n", rliPtr->entries[i].addr);
    found = (rliPtr->entries[i].addr == addr);
    if (found) {
      *quality = rliPtr->entries[i].quality;
    }
  }
  return (found)?SUCCESS:FAIL;
}

error_t reverseLinkInfoReset(ReverseLinkInfo* rliPtr) {
  int i;
  if (rliPtr == NULL)
    return FAIL;
  for (i = 1; i < rliPtr->num_elements; i++)  {
    rliPtr->entries[i].addr = REVERSE_LINK_INVALID_ADDR;
    rliPtr->entries[i].quality = 0;
  }
  rliPtr->num_elements = 0;
  return SUCCESS;
}

/* Appends an entry to this ReverseLinkInfo structure, unless it is full, in which case
 * it returns false. It is up to the caller to save state in order to, for example,
 * add elements in a round robin fashion across messages.
 * @return FAIL is not able to append
 */
error_t reverseLinkInfoAppend(ReverseLinkInfo* rliPtr, uint16_t addr, uint8_t quality) {
  if (rliPtr == NULL)
    return FAIL;
  if (rliPtr->num_elements >= NUM_REVERSE_LINK_ENTRIES)
    return FAIL;
  rliPtr->entries[rliPtr->num_elements].addr = addr;
  rliPtr->entries[rliPtr->num_elements].quality = quality;
  rliPtr->num_elements++;
  return SUCCESS;
}

error_t reverseLinkInfoFromMsg(ReverseLinkInfo* rliPtr, ReverseLinkMsg* msg) {
  *rliPtr = msg->info;
  if (rliPtr->num_elements > NUM_REVERSE_LINK_ENTRIES) {
    rliPtr->num_elements = NUM_REVERSE_LINK_ENTRIES;
  }
  return SUCCESS;
}

error_t reverseLinkInfoToMsg(ReverseLinkInfo* rliPtr, ReverseLinkMsg* msg) {
  if (rliPtr == NULL || msg == NULL)
    return FAIL;
  msg->info = *rliPtr;
  return SUCCESS;
}
#endif
