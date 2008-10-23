
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

/* This file defines coordinates to be a fixed sized array of
 * 8 bit numbers. 255 indicates that a given component is not
 * valid.
 * IMPORTANT: Beware that when changing the number of components, it may be
 * necessary to change the size of message_t*/

#ifndef COORDS_H
#define COORDS_H

#include "util.h"
#include "topology.h"

#ifdef TOSSIM
uint8_t* copy_hc_root_beacon_id[N_NODES];
#endif

/* interface:
These are "exported" from this file. The implementation is subject to change.
 result_t coordinates_init(Coordinates* c)
 result_t coordinates_copy(Coordinates* source, Coordinates* dest)
 uint8_t coordinates_copy_k_closest(Coordinates* source, Coordinates* dest, uint8_t K)
 result_t coordinates_set_component(Coordinates* c, uint8_t pos, uint8_t hopcount)
 uint16_t coordinates_distance(Coordinates* c1, Coordinates* c2)
 uint8_t coordinates_get_closest_beacon(Coordinates* c) {
 void coordinates_print(Coordinates* c)
 bool coordinates_is_valid_component(Coordinates* c, uint8_t pos)
 bool coordinates_has_same_valid_components(Coordinates *q, Coordinates *c) {
 uint8_t coordinates_count_valid_components(Coordinates* c)
*/


#ifndef MAX_ROOT_BEACONS
#define MAX_ROOT_BEACONS 8
#endif

enum {
  INVALID_DISTANCE = 65535u,
  MAX_COORD_DISTANCE = 16384u,
  MAX_COMPONENT_VALUE = 254,
  INVALID_COMPONENT = 255,
};

#ifndef INVALID_NODE_ID
#ifdef TOSSIM
#define INVALID_NODE_ID 65535
#else
#define INVALID_NODE_ID 255
#endif
#endif

typedef nx_struct Coordinates {
  nx_uint8_t comps[MAX_ROOT_BEACONS];
}  Coordinates, *Coordinates_ptr;


/* declaration */
//#ifdef PLATFORM_PC
 void coordinates_print(Coordinates* c);
//#else
//#define coordinates_print(b)
//#endif


error_t coordinates_init(Coordinates* c) {
  int i;
  if (c == NULL)
    return FAIL;
  for (i = 0; i < MAX_ROOT_BEACONS; c->comps[i] = INVALID_COMPONENT, i++);
  return SUCCESS;
}

bool coordinates_is_valid_component(Coordinates* c, uint8_t pos) {
  if (c == NULL || pos >= MAX_ROOT_BEACONS)
    return FALSE;
  return !(c->comps[pos] == INVALID_COMPONENT);
}



uint8_t coordinates_count_valid_components(Coordinates* c) {
  uint8_t i;
  uint8_t count = 0;
  if (c == NULL)
    return 0;
  for (i = 0; i < MAX_ROOT_BEACONS; i++) {
    if (coordinates_is_valid_component(c, i))
      count++;
  }
  return count;
}

error_t coordinates_copy(Coordinates* source, Coordinates* dest) {
  int i;
  if (source == NULL || dest == NULL)
    return FAIL;
  for (i = 0; i < MAX_ROOT_BEACONS; i++)
    dest->comps[i] = source->comps[i];
  return SUCCESS;
}

/** Get the k smallest components of source and copies them to dest.
 *  If there are less valid components than k in source, the rest are set to
 *  invalid in dest. The return is the number of components copied.
 */
 uint8_t coordinates_copy_k_closest(Coordinates* source, Coordinates* dest, uint8_t K) {
  int i,j;
  uint8_t count = 0;
  uint8_t order[MAX_ROOT_BEACONS];

  if (source == NULL || dest == NULL)  {
    dbg("BVR", "CK: null pointer passed (source:%p, dest:%p)\n",source, dest);
    return 0;
  }

  if (K >= MAX_ROOT_BEACONS) {
    for (i = 0; i < MAX_ROOT_BEACONS; i++) {
      dest->comps[i] = source->comps[i];
      if (source->comps[i] != INVALID_COMPONENT)
        count++;
    }
    return count;
  }
  //insert in order at most k indices into order
  for (i = 0; i < MAX_ROOT_BEACONS; i++) {
    if (source->comps[i] != INVALID_COMPONENT) {
      for (j = count ; j > 0; j--) {
        if (source->comps[i] < source->comps[order[j-1]]) {
          if (j < K)  { //shift right the element at j-1
            order[j] = order[j-1];
          //} else {      //replace element at j-1 (do nothing)
          }
        } else
         break;
      }
      if (j < K) {      //insert new element at j
        order[j] = i;
        if (count < K)
          count++;
      //} else {          //ignoring new element (do nothing)
      }
    }
  }
  // now go through order and copy the corresponding entries
  coordinates_init(dest);
  for (i = 0; i < count; i++) {
    dest->comps[order[i]] = source->comps[order[i]];
  }

  dbg("BVR","CK: getting the smallest %d components of ",K);
  coordinates_print(source);
  dbg("BVR","CK: result: ");
  coordinates_print(dest);
  return count;
}

error_t coordinates_set_component(Coordinates* c, uint8_t pos, uint8_t hopcount) {
  dbg("BVR","coordinates_set_component\n");
  if (c == NULL || pos >= MAX_ROOT_BEACONS)
    return FAIL;
  c->comps[pos] = hopcount;
  return SUCCESS;
}

uint8_t coordinates_get_component(Coordinates* c, uint8_t pos) {
  if (c == NULL || pos > MAX_ROOT_BEACONS)
    return INVALID_COMPONENT;
  return c->comps[pos];
}

 uint16_t coordinates_distance_original(Coordinates* c1, Coordinates* c2) {
  uint16_t distance = 0;
  int i,compared;
  compared = 0;
  if (c1 == NULL || c2 == NULL) {
    dbg("BVR","coordinates_distance: %p or %p is null...\n",c1,c2);
    return INVALID_DISTANCE;
  }
  for (i = 0; i < MAX_ROOT_BEACONS; i++) {
    if (coordinates_is_valid_component(c1,i) &&
        coordinates_is_valid_component(c2,i)) {
      compared++;
      distance += int_abs(c1->comps[i] - c2->comps[i]);
    }
  }
  if (compared > 0)
    return distance;
  else
    return MAX_COORD_DISTANCE;
}


/* Lower bound of the true hop distance between 2 coordinates */
 uint16_t coordinates_distance_L(Coordinates* c1, Coordinates* c2) {
  uint16_t d = 0;
  uint16_t max = 0;
  int i,compared;
  compared = 0;
  if (c1 == NULL || c2 == NULL) {
    dbg("BVR","coordinates_distance: %p or %p is null...\n",c1,c2);
    return INVALID_DISTANCE;
  }
  for (i = 0; i < MAX_ROOT_BEACONS; i++) {
    if (coordinates_is_valid_component(c1,i) &&
        coordinates_is_valid_component(c2,i)) {
      compared++;
      d = int_abs(c1->comps[i] - c2->comps[i]);
      if (d > max) max = d;
    }
  }
  if (compared > 0)
    return max;
  else
    return MAX_COORD_DISTANCE;
}

/* Upper bound to the true distance between the two coordinates */
 uint16_t coordinates_distance_U(Coordinates* c1, Coordinates* c2) {
  uint16_t d = 0;
  uint16_t min = MAX_COORD_DISTANCE;
  int i,compared;
  compared = 0;
  if (c1 == NULL || c2 == NULL) {
    dbg("BVR","coordinates_distance: %p or %p is null...\n",c1,c2);
    return INVALID_DISTANCE;
  }
  for (i = 0; i < MAX_ROOT_BEACONS; i++) {
    if (coordinates_is_valid_component(c1,i) &&
        coordinates_is_valid_component(c2,i)) {
      compared++;
      d = c1->comps[i] + c2->comps[i];
      if (d < min) min = d;
    }
  }
  if (compared > 0)
    return min;
  else
    return MAX_COORD_DISTANCE;
}

/* This is used to move towards the beacon which is closest to the destination.
   It is not symmetric: it returns the component of c1 that corresponds to the
   smallest component in c2. If c2 is (10,3), then it returns the second component
   of c1.
   In this case c2 should be the destination for this metric to make sense for
   routing */
uint16_t coordinates_distance_closest(Coordinates *c1, Coordinates *c2) {
  uint8_t i,smallest;
  uint8_t closest_beacon;

  if (c1 == NULL || c2 == NULL) {
    dbg("BVR","coordinates_distance: %p or %p is null...\n",c1,c2);
    return INVALID_DISTANCE;
  }
  //Find the smallest coordinate in c2
  if (coordinates_count_valid_components(c2) == 0)
    return INVALID_DISTANCE;
  smallest = (uint8_t)-1;
  closest_beacon = (uint8_t)-1;
  for (i = 0; i < MAX_ROOT_BEACONS; i++) {
    if (coordinates_is_valid_component(c2,i)) {
      if (c2->comps[i] < smallest) {
        smallest = c2->comps[i];
        closest_beacon = i;
      }
    }
  }
  if (closest_beacon == (uint8_t)-1)
    return INVALID_DISTANCE;
  if (coordinates_is_valid_component(c1,closest_beacon))
    return c1->comps[closest_beacon];
  else
    return INVALID_DISTANCE;
}

enum {
  COORDS_WEIGHT = 10,
};

/* This is the orginial metric, except that it weights the positive differences
   more than the negative differences. The reasoning is that positive differences
   should be more meaningful in guiding you towards the destination.
   The weight is currently defined at compile time. */

uint16_t coordinates_distance_weighted(Coordinates *c1, Coordinates *c2) {
  uint16_t distance = 0;
  int i,compared;
  uint16_t weight = 1;
  compared = 0;
  if (c1 == NULL || c2 == NULL) {
    dbg("BVR","coordinates_distance: %p or %p is null...\n",c1,c2);
    return INVALID_DISTANCE;
  }
  for (i = 0; i < MAX_ROOT_BEACONS; i++) {
    if (coordinates_is_valid_component(c1,i) &&
        coordinates_is_valid_component(c2,i)) {
      compared++;
      if (c1->comps[i] > c2->comps[i])  //positive difference
        weight = COORDS_WEIGHT;
      else
        weight = 1;
      distance += weight * int_abs(c1->comps[i] - c2->comps[i]);
    }
  }
  if (compared > 0)
    return distance;
  else
    return MAX_COORD_DISTANCE;
}

enum {
  COORDS_DIST_NORMAL = 0,
  COORDS_DIST_L = 1,
  COORDS_DIST_U = 2,
  COORDS_DIST_UL = 3,
  COORDS_DIST_WEIGHTED = 5,
  COORDS_DIST_BEACON = 6
};

uint16_t coordinates_distance(Coordinates *c1, Coordinates *c2, uint8_t metric) {
  switch(metric) {
    case 0: //normal (original) distance
      return coordinates_distance_original(c1,c2);
    case 1: //L (lower bound, max(|i-j|)
      return coordinates_distance_L(c1,c2);
    case 2: //U (upper bound, min(|i+j|)
      return coordinates_distance_U(c1,c2);
    case 3: //U+L
      return coordinates_distance_U(c1,c2)+coordinates_distance_L(c1,c2);
    case 5: //10:1 weighted original distance
      return coordinates_distance_weighted(c1,c2);
    case 6: //closest beacon
      return coordinates_distance_closest(c1,c2);
  }
  return INVALID_DISTANCE;
}

/* Given coords, returns the beacon that is closest to it, i.e., the
   index of the smallest component */
 uint8_t coordinates_get_closest_beacon(Coordinates* c) {
  uint8_t i;
  uint8_t closest = INVALID_COMPONENT;
  uint8_t closest_distance = INVALID_COMPONENT;
  if (c == NULL)
    return INVALID_COMPONENT;
  for (i = 0; i < MAX_ROOT_BEACONS; i++) {
    if (coordinates_is_valid_component(c, i)) {
      if (c->comps[i] < closest_distance) {
        closest = i;
        closest_distance = c->comps[i];
      }
    }
  }
  return closest;
}

/* Returns true if the set of valid components of c is a subset of the
 * valid components in q, i.e., if q can route to c */
 bool coordinates_has_same_valid_components(Coordinates *q, Coordinates *c) {
  bool result;
  int i;
  if (c == NULL || q == NULL) {
    dbg("BVR", "COORDS: coordinates_has_same_valid_components called with a NULL coordinate!\n");
    return 0;
  }
  result = 1;
  for (i = 0; i < MAX_ROOT_BEACONS; i++) {
    result &= (!coordinates_is_valid_component(c,i) ||
               (coordinates_is_valid_component(c,i) && coordinates_is_valid_component(q,i)));
  }
  dbg("BVR", "COORDS: q has all components in c?  %s\n",(result)?"yes":"no");
  dbg("BVR", "COORDS: q "); coordinates_print(q);
  dbg("BVR", "COORDS: c "); coordinates_print(c);
  return result;
}


 void coordinates_print(Coordinates* c) {
#ifdef TOSSIM
  int i;
  dbg_clear("BVR-debug","%d",coordinates_is_valid_component(c,0)?(c->comps[0]):-1);
  for (i = 1; i < MAX_ROOT_BEACONS; i++) {
    dbg_clear("BVR-debug",", %d",coordinates_is_valid_component(c,i)?(c->comps[i]):-1);
  }
  dbg_clear("BVR-debug","\n");
#endif
}


void coordinates_print2(char* mode, Coordinates* c) {
#ifdef TOSSIM
  int i;
  dbg_clear("TestBVR","%d",coordinates_is_valid_component(c,0)?(c->comps[0]):-1);
  for (i = 1; i < MAX_ROOT_BEACONS; i++) {
    dbg_clear("TestBVR",", %d",coordinates_is_valid_component(c,i)?(c->comps[i]):-1);
  }
  dbg_clear("TestBVR","\n");
#endif
}

uint16_t search(uint8_t* array, int size, uint8_t val) {
    uint16_t i;

    for (i=0; i<size; i++)
      if (array[i] == val) { return i; }

    return INVALID_NODE_ID;
}

#endif
