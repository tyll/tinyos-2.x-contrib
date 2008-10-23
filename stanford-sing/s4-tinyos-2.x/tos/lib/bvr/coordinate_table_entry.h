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

#ifndef COORD_TABLE_ENTRY_H
#define COORD_TABLE_ENTRY_H

enum {
  MAX_AGE = 255,
  EXPIRATION_AGE_THRESHOLD = 5,
};

typedef nx_struct {
  nx_uint8_t valid;
  nx_uint16_t first_hop;
  nx_uint8_t last_seqno;
  nx_uint16_t addr;
  Coordinates coords;
  nx_uint8_t quality;           //quality is used when this is a 2-hop neighbor+
  nx_uint8_t age;
  nx_uint8_t pos;               //position of this neighbor in the coordinate table
}  CoordinateTableEntry;

/* + in the case of a one hop neighbor, quality is to be taken directly from
 *   the link estimator. */

inline error_t CTEntryInit(CoordinateTableEntry* e) {
  if (e == NULL)
    return FAIL;

  e->valid = FALSE;
  e->first_hop = 0;
  e->last_seqno = 0;
  e->addr = 0;
  e->quality = 0;
  coordinates_init(&e->coords);
  e->pos = 0;
  return SUCCESS;
}

inline error_t CTEntryTouch(CoordinateTableEntry* e) {
  if (e == NULL)
    return FAIL;
  e->age = 0;
  return SUCCESS;
}
inline error_t CTEntryUpdate(CoordinateTableEntry* e,
		uint8_t last_seqno, uint16_t first_hop, uint8_t quality,
		Coordinates* coords) {
  if (e == NULL || e->valid == FALSE)
    return FAIL;
  e->first_hop = first_hop;
  e->last_seqno = last_seqno;
  e->quality = quality;
  coordinates_copy(coords, &e->coords);
  return SUCCESS;
}

inline error_t CTEntryUpdateFirstHop(CoordinateTableEntry* e, uint16_t first_hop)
{
  if (e == NULL)
    return FAIL;
  e->first_hop = first_hop;
  return SUCCESS;
}

inline error_t CTEntryUpdateCoordinates(CoordinateTableEntry* e, Coordinates* c) {
  if (e == NULL || c == NULL)
    return FAIL;
  return coordinates_copy(c, &e->coords);
}

inline error_t CTEntryUpdateSeqno(CoordinateTableEntry* e, uint16_t seqno) {
  if (e == NULL)
    return FAIL;
  e->last_seqno = seqno;
  return SUCCESS;
}

inline error_t CTEntryUpdateQuality(CoordinateTableEntry* e, uint8_t quality) {
  if (e == NULL)
    return FAIL;
  e->quality = quality;
  return SUCCESS;
}
#endif


