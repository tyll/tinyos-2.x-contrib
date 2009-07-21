/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
 
#ifndef CTPROUTINGENGINE_H
#define CTPROUTINGENGINE_H

/**
 * TRUE if we are to use congestion in the routing engine
 */
#ifndef ECN_ON
#define ECN_ON FALSE
#endif

/**
 * Minimum routing interval
 */
#ifndef CTP_MIN_BEACON_INTERVAL
#define CTP_MIN_BEACON_INTERVAL 5120U  // 5 seconds
#endif

/**
 * The amount of time dedicated to network setup
 * Where beacons are generated more rapidly
 */
#ifndef CTP_SETUP_DURATION
#define CTP_SETUP_DURATION 3686400U  // 1 hour setup period with more beacons
#endif

/**
 * The maximum beacon interval during the setup phase
 */
#ifndef CTP_SETUP_MAX_BEACON_INTERVAL
#define CTP_SETUP_MAX_BEACON_INTERVAL 614400U  // 10 minutes
#endif

/** 
 * The maximum beacon interval after setup
 */
#ifndef CTP_MAX_BEACON_INTERVAL
#define CTP_MAX_BEACON_INTERVAL 3686400U  // 1 hour
#endif


enum {
    AM_TREE_ROUTING_CONTROL = 0xCE,
    BEACON_INTERVAL = 30720,    // Increased the minimum beacon interval
    INVALID_ADDR  = TOS_BCAST_ADDR,
    ETX_THRESHOLD = 50,         // link quality=20% -> ETX=5 -> Metric=50 
    PARENT_SWITCH_THRESHOLD = 15,
    MAX_METRIC = 0xFFFF,
}; 
 

typedef struct {
  am_addr_t parent;
  uint16_t etx;
  bool haveHeard;
  bool congested;
} route_info_t;

typedef struct {
  am_addr_t neighbor;
  route_info_t info;
} routing_table_entry;



#endif
