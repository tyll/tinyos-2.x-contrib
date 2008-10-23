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


/* 
 * This link estimator does passive estimation, loosely based on the one by
 * Alec Woo. Does not use any signal strength info from radio, rather we keep
 * statistics about each link and the fraction of packets have been lost.
 * It relies on the assumption that all packets sent by all nodes will have
 * the LinkEstimation header (source and sequence number). This is accomplished
 * when LinkEstimatorComm and LinkEstimatorTaggerComm are wired in the Comm stack.
 * 
 * There are three things going on here.
 * 1. Information gathering
 *     Whenever a packet is received from a node, or reverse link info is
 *     received, LinkEstimator.update* are called. These trigger the internal
 *     info about the neighbors to be updated, and nodes to be inserted in the
 *     cache if necessary.
 * 2. Periodic recalculation
 *     Periodically an internal timer (UpdateLinkTimer) fires, and calls
 *     updateLinkTask. This will recalculate the link qualities from past
 *     observations.
 * 3. Information usage
 *     Clients to this module will query the link qualities, and also be
 *     updated by upcalls in the LinkEstimatorSynch interface, whenever
 *     qualities change, or nodes are evicted.
 */

//TODO: Change the replacement policy to have n-k nodes active and k probation slots.

includes ReverseLinkInfo;


module LinkEstimatorM {
  provides {
    interface LinkEstimator;
    interface LinkEstimatorSynch;
    interface FreezeThaw;
    interface StdControl;
    interface Init;
  }
  uses {
    interface Timer<TMilli> as UpdateLinkTimer;
    //interface StdControl as TimerControl;
#ifndef NO_LE_LOGGING
    interface Logger;
#endif
  }
}

implementation {

  uint8_t active_neighbors;
  LinkNeighbor neighborCache[N_CACHE_SIZE];
  LinkNeighbor* neighborCachePtrs[N_CACHE_SIZE];

  /* state_is_active:
   *   controlled by start and stop 
   *   if false:
   *     updateLinkTimer stops
   *     store returns FAIL and does not change the cache
   *     you can read from the table, but no changes are made 
   */

  bool state_is_active;

  uint8_t current_window;
  uint8_t min_packets;

  uint32_t link_upd_timer_int;

/* Forward declarations */
  static void neighborInit(LinkNeighbor* n);
  static error_t updateSeqno(uint8_t idx, uint16_t seqno);
  static error_t updateStrength(uint8_t idx, uint16_t seqno);
  static uint8_t getQuality(uint8_t idx);
  static uint8_t getBidirectionalQuality(LinkNeighbor* n);
  //static LinkNeighbor* findNeighbor(uint16_t addr);
  //static LinkNeighbor* getNeighbor(uint16_t addr);
  //static LinkNeighbor* getFreeNeighbor();
  //static void neighborSetActive(LinkNeighbor* n);
  //static void neighborSetAddress(LinkNeighbor *n, uint16_t addr);
  //static void updateLinkQualityInfo(LinkNeighbor *n, uint16_t seqno);
  //static void neighborSetCoordinates(LinkNeighbor* n, uint16_t x , uint16_t y, bool received_state);
  //static void neighborUpdateReverseQuality(LinkNeighbor* n);

/* StdControl */
  command error_t Init.init() { 
    int i;
    //call TimerControl.init(); //No need to initialize the Timer in tinyos-2.x
    state_is_active = TRUE;
    link_upd_timer_int  = I_UPDATE_LINK_INTERVAL;
    min_packets = (LINK_ESTIMATOR_RECEIVE_WINDOW * LINK_ESTIMATOR_MIN_PACKETS);
    current_window = 0;
    active_neighbors = 0;
    for (i = 0; i<N_CACHE_SIZE; i++) {
      neighborCachePtrs[i] = &neighborCache[i];
      neighborInit(&neighborCache[i]);
    }


    return SUCCESS;
  }
  command error_t StdControl.start() {
    //call TimerControl.start();
    call UpdateLinkTimer.startPeriodic(link_upd_timer_int);
    state_is_active = TRUE;
    return SUCCESS;
  }

  command error_t StdControl.stop() {
    state_is_active = FALSE;
    call UpdateLinkTimer.stop();
    //call TimerControl.stop();
    return SUCCESS;
  }
  command error_t FreezeThaw.freeze() {
    dbg("BVR-debug","LinkEstimatorM$freeze\n");
     state_is_active = FALSE;
    call UpdateLinkTimer.stop();
    return SUCCESS;
  }
  command error_t FreezeThaw.thaw() {
    dbg("BVR-debug","LinkEstimatorM$thaw\n");
    call UpdateLinkTimer.startPeriodic(link_upd_timer_int);
    state_is_active = TRUE;
    return SUCCESS;
  }

/* Internal Functions */
   
  static void neighborInit(LinkNeighbor* n) {
    int i;
    n->state = 0;
    n->addr = 0;
    n->reverse_quality = 0;
    n->reverse_expiration = 0;
    n->strength = 0;
    n->quality = 0;
    n->last_seqno = 0;
    n->age = 0;
    n->chances = LINK_ESTIMATOR_PROBATION + LINK_ESTIMATOR_RECEIVE_WINDOW;
    for (i = 0; i < LINK_ESTIMATOR_RECEIVE_WINDOW; i++) {
      n->missed[i] = LINK_ESTIMATOR_INVALID_PACKETS;
      n->received[i] = LINK_ESTIMATOR_INVALID_PACKETS;
    }
    n->received[current_window] = 0;
    n->missed[current_window] = 0;
  }

  /* Returns the first inactive neighbor record 
   * Precondition: there is at least one inactive neighbor */
  static LinkNeighbor* getFreeNeighbor() {
    int i;
    LinkNeighbor* n = NULL;
    for (i = 0; i < N_CACHE_SIZE; i++) {
      if ((neighborCache[i].state & ACTIVE_MASK) == 0) {
        n = (LinkNeighbor*) &(neighborCache[i]);
        break;
      }
    }
    dbg("BVR-temp","getFreeNeighbor returning pos %d (%p). Active:%d. Cache Size:%d\n",i,neighborCache[i],active_neighbors,N_CACHE_SIZE);
    return n;
  }
  
  static void neighborSetActive(LinkNeighbor* n) {
    n->state |= ACTIVE_MASK;
  }
  
  static void neighborSetAddress(LinkNeighbor *n, uint16_t addr) {
    n->state |= VALID_ADDR_MASK;
    n->addr = addr;
  }
 

  static error_t find(uint16_t addr,uint8_t* idx) {
    int i;
    uint8_t neighbor = 0;
    bool found = FALSE;
    
    //dbg("BVR-debug", "LinkEstimatorM.find: active_neighbors = %d\n", active_neighbors);

    for (i = 0; i < active_neighbors && !found; i++ ) {
      if (!(neighborCachePtrs[i]->state & ACTIVE_MASK)) {
        dbg("BVR-error","Assertion failed: active_neighbor index %d has ACTIVE bit unset\n",i);
      }
      
      //dbg("BVR-debug", "LinkEstimatorM.find: neighborCachePtrs[i]->addr = %d\n", neighborCachePtrs[i]->addr);
      if (neighborCachePtrs[i]->addr == addr) {
        neighbor = i;
        found = TRUE;
      }
    }
    *idx = neighbor;
    
    //dbg("BVR-debug", "LinkEstimatorM.find: returning = %d\n", (found)?SUCCESS:FAIL);
    
    return (found)?SUCCESS:FAIL;
  }


  /* This is based on the ewma of Terrence and Alec Woo.
   * It is called (on average) every UPDATE_LINK_INTERVAL.
   * Each node is examined here in turn, and updated or evicted.
   * Eviction: if we haven't heard from a node in AGE_THRESHOLD, we evict the
   * node unless canEvict returns FAIL, in which case some user of the
   * LinkEstimator wants this neighbor around
   * Update: we know how many packets we received and how many we missed.
   *  total_packets = max (min_packets, received + missed)
   *  quality = received/total_packets
   * total_packets is counted over a total period of
   *    LINK_ESTIMATOR_RECEIVE_WINDOW * UPDATE_LINK_INTERVAL
   * This allows more precise estimates, but not so spaced. Each packet is
   * taken into account RECEIVE_WINDOW times, and this has an additional 
   * smoothing effect.
   */
   task void updateLinkTask() {
    uint8_t i,j;
    LinkNeighbor* n;
    uint8_t new_quality;
    uint8_t to_remove = 0;
    bool not_ready = FALSE;
    bool changed = FALSE;
    
    uint16_t received;
    uint16_t missed;
    uint16_t total_packets;

    /* This loops through every active neighbor, and updates the link quality
     * information. 
     * If the node has not been heard from for AGE_THRESHOLD consecutive periods,
     * we flag it for removal, and the next loop actually performs the removal
     */
    
    for (i = 0; i < active_neighbors; i++) {
      n = neighborCachePtrs[i];
      dbg("BVR-temp","UpdateLinkTimer: for pos %d (node %d) chances=%d\n",i,n->addr,n->chances);
      not_ready = 0;
      received = missed = 0;

      dbg("BVR-temp","UpdateLinkTimer: (node %d) [rcv,miss]: ",n->addr);
      for (j = 0; j < LINK_ESTIMATOR_RECEIVE_WINDOW; j++){
        dbg_clear("BVR-temp"," [%d,%d]",n->received[j],n->missed[j]);
      }
      dbg_clear("BVR-temp","\n");
      //will only update the quality if all slots have been filled...
      for (j = 0; j < LINK_ESTIMATOR_RECEIVE_WINDOW; j++) {
        if (n->received[j] == LINK_ESTIMATOR_INVALID_PACKETS) {
          not_ready = 1;
          dbg("BVR-temp","UpdateLinkTimer: (node %d) receive window[%d] invalid. Will not update yet.\n",n->addr,j);
          break;
        }
        dbg("BVR-temp","UpdateLinkTimer: (node %d) Adding received:%d + r[%d]:%d = %d, missed:%d + m[%d]:%d = %d\n",
             n->addr,received, j, n->received[j], received + n->received[j],
                     missed,   j, n->missed[j],   missed   + n->missed[j]);
        received += n->received[j];
        missed += n->missed[j];
      }


      if (! not_ready) { 
        //Update quality 
        total_packets = received + missed;
        if (total_packets < min_packets) {
          total_packets = min_packets; 
        }
        new_quality = (uint8_t) 255 * (received / (total_packets * 1.0));
        dbg("BVR-temp","UpdateLinkTimer: (node %d) will update. total_packets:%d new_quality:%d current_window:%d\n",
           n->addr,total_packets,new_quality,current_window);

        if (n->state & VALID_QUALITY_MASK) {
          //Exponential moving average
          //new_quality = (uint8_t) (EWMA_HIST * n->quality + EWMA_NEW * new_quality)/EWMA_SUM;
          //new_quality = (uint8_t) (0.25 * n->quality + 0.75 * new_quality);
          new_quality = (uint8_t) (0.60 * n->quality + 0.40 * new_quality);
          //more stability
          //new_quality = (uint8_t) (0.80 * n->quality + 0.20 * new_quality);
          changed = (new_quality != n->quality);
        } else {
          n->state |= VALID_QUALITY_MASK;
          changed = TRUE;
        }

        dbg("BVR-temp","UpdateLinkTimer: (node %d) will update. Total received:%d, missed:%d quality was:%d new:%d\n",
          n->addr, received, missed,
          n->quality, new_quality
        );
        n->quality = new_quality;
      }

      //Has this neighbor died?
      if (n->received[current_window] == 0 ) {
        n->age++;
        dbg("BVR-temp","UpdateLinkTimer: increased age(%d) to %d\n",n->addr, n->age);
      } else {
        n->age = 0;
        dbg("BVR-temp","UpdateLinkTimer: reset age, received a packet!\n");
      }
      //Remove neighbor, we haven't heard from it for AGE_THRESHOLD consecutive periods 
      if (n->age > AGE_THRESHOLD) {
        bool can_evict = (signal LinkEstimator.canEvict(n->addr) == SUCCESS);
        if (!can_evict) {
          n->age = AGE_THRESHOLD;
        } else {
#ifndef NO_LE_LOGGING
          call Logger.LogDropLink(n->addr);
#endif
          dbg("BVR-temp","Neighborhood DIRECTED GRAPH: remove edge %d\n",n->addr);
          dbg("BVR-temp","UpdateLinkTimer: remove. Active neighbors:%d\n",active_neighbors);
          to_remove++;  
          n->state |= REMOVE_MASK;
          continue; //there is no point in updating since it will be removed
        }
      }
     
      //Decrement from initial probation period
      if (n->chances > 0) 
        n->chances--; 

#ifndef NO_LE_LOGGING
      call Logger.LogChangeLink(n);
#endif
      dbg("BVR-temp","Neighborhood DIRECTED GRAPH: remove edge %d\n",n->addr);
      dbg("BVR-temp","Neighborhood DIRECTED GRAPH: add edge %d label: %d\n",n->addr,getQuality(i));

      n->missed[(current_window+1) % LINK_ESTIMATOR_RECEIVE_WINDOW] = 0;
      n->received[(current_window+1) % LINK_ESTIMATOR_RECEIVE_WINDOW] = 0;
    }

    current_window = (current_window+1) % LINK_ESTIMATOR_RECEIVE_WINDOW;

    if (to_remove > 0) {
      //clean the neighbor table
      for (i = 0, j = 0; j < active_neighbors; i++, j++) {
        dbg("BVR-temp","cleaning. i = %d, j = %d \n",i,j);
        while (j < active_neighbors && neighborCachePtrs[j]->state & REMOVE_MASK) {
          dbg("BVR-temp","Initializing cache pos %d (%p) (was addr %d).\n",j,
            neighborCachePtrs[j],neighborCachePtrs[j]->addr);
          signal LinkEstimatorSynch.linkRemoved(neighborCachePtrs[j]->addr);
          neighborInit(neighborCachePtrs[j]); 
          j++;
        }
        if (i < (active_neighbors - to_remove) && (j > i)) {
          neighborCachePtrs[i] = neighborCachePtrs[j];  
        }
      }
      active_neighbors -= to_remove;
    }
    dbg("BVR-temp","Link Table: (active = %d)\n",active_neighbors);
    for (i = 0; i < N_CACHE_SIZE; i++) {
      dbg("BVR-temp","\t[%d](%p). Cache[%d](%p): valid=%d, addr=%d\n",i,neighborCachePtrs[i],i,
        &neighborCache[i],(neighborCache[i].state & ACTIVE_MASK)?1:0,neighborCache[i].addr);
    }
    
    dbg("BVR-debug","updateLinkTask ended\n");

  }

/* Provided Commands */

  command error_t LinkEstimator.find(uint16_t addr,uint8_t* idx) {
    return find(addr, idx);
  }

   /* 
    * Returns the index of the neighbor with address addr 
    * If there isn't one currently, evict one less used,
    * and make room.
    * @return SUCCESS if found or stored, FAIL otherwise.
    *
    * Currently: if there is no room, we reject the neighbor.
    * Strength can also be used as an indicator of whether to replace
    * a neighbor.
    */
 
  command error_t LinkEstimator.store(uint16_t addr, uint16_t seqno, 
                         uint16_t strength, uint8_t* idx) {
    int i;
    uint8_t n;
    uint8_t min_quality = MAX_QUALITY;
    uint8_t victim = N_CACHE_SIZE;
    bool found;
    bool can_evict;

    dbg("BVR-debug","NCache: store %d\n",addr);
    if (state_is_active) {
      found = find(addr,&n);
      if (found == FAIL) {
        /* addr not in cache */
        if (active_neighbors < N_CACHE_SIZE) {
          dbg("BVR-debug","NCache: miss (%d). There is space. No replacement necessary.\n",addr);
          /* there is free space */
          neighborCachePtrs[active_neighbors] = getFreeNeighbor();
          n = active_neighbors;
          if (neighborCachePtrs[n] == NULL) {
            dbg("BVR-temp","LinkEstimatorM$store: getFreeNeighbor returned NULL, there's no actual free space\n");
          }
          active_neighbors++;
          dbg("BVR-temp","LinkEstimatorM$store: %d not in cache. There was space. active_neighbors = %d\n",addr,active_neighbors);
        } else {
          //cache is FULL.

          //assert(active_neighbors == N_CACHE_SIZE);
          if (active_neighbors != N_CACHE_SIZE) 
            dbg("BVR-temp","LinkEstimatorM$store: assertion failed: active_neighbor == N_CACHE_SIZE is false (%d)(%d)\n", active_neighbors,N_CACHE_SIZE);
          dbg("BVR-debug","NCache: miss (%d). There is no space. Replacement necessary.\n",addr);
          /* Replacement is as follows: 

           * Find the node which is not in probation (has been around for some time > LINK_ESTIMATOR_PROBATION)
           * with the smallest quality
           * If the quality is smaller than LINK_ESTIMATOR_REPLACE_THRESH, then replace the node
           * n->chances is initialized with LINK_ESTIMATOR_PROBATION, and decremented every 
           * estimation interval.
           */
          for (i = 0; i < active_neighbors; i++) {
            if(neighborCachePtrs[i]->chances == 0 && 
                 neighborCachePtrs[i]->quality < min_quality &&
                 neighborCachePtrs[i]->quality < LINK_ESTIMATOR_REPLACE_THRESH) {

              can_evict = (signal LinkEstimator.canEvict(neighborCachePtrs[i]->addr) == SUCCESS);
              if (can_evict) {
                min_quality = neighborCachePtrs[i]->quality;
                victim = i;
              }
            }
          }
#if PLATFORM_MICAZ //just debugging info
          dbg("BVR-debug","NCache: CacheTable\n");
          for (i = 0; i < active_neighbors; i++) {
              dbg("BVR-debug","NCache:\t Cache[%d]. Addr:%d Quality:%d Chance:%d%s\n",
                  i,neighborCachePtrs[i]->addr,
                  neighborCachePtrs[i]->quality,
                  neighborCachePtrs[i]->chances,
                  (i == victim)?" <-- victim HA HA HA!!!":""
                 );
          }
#endif
          if (victim == N_CACHE_SIZE) {
            dbg("BVR-debug","NCache: miss (%d). Did not find victim to replace, ignoring\n",addr);
            return FAIL;
          } else {
            /* evict victim */
            n = victim;
#ifndef NO_LE_LOGGING
            call Logger.LogDropLink(neighborCachePtrs[n]->addr);
#endif
            signal LinkEstimatorSynch.linkRemoved(neighborCachePtrs[n]->addr);
            dbg("BVR-debug","NCache: miss (%d) replace [%d], addr:%d\n",addr,n,neighborCachePtrs[n]->addr);
            dbg("BVR-temp","Neighborhood DIRECTED GRAPH: remove edge %d\n",neighborCachePtrs[n]->addr);
            dbg("BVR-temp","LinkEstimatorM$Store: replacing entry no. %d (addr %d)\n",n, neighborCachePtrs[n]->addr);
            neighborInit(neighborCachePtrs[n]);
          }
        } // if there is space else if full
        //Node is in cache now
        neighborSetActive(neighborCachePtrs[n]);
        neighborSetAddress(neighborCachePtrs[n],addr); 
#ifndef NO_LE_LOGGING
        call Logger.LogAddLink(neighborCachePtrs[n]);
#endif
        dbg("BVR-temp","Neighborhood DIRECTED GRAPH: add edge %d label: %d\n",addr, getQuality(n));
      } else {
        //if found.
        dbg("BVR-debug","NCache: store called, but addr (%d) already in cache\n",addr);
      }
      updateSeqno(n, seqno);
      updateStrength(n, strength);
  
      *idx = n;
      return SUCCESS;
    } else {
      //state_is_active is false
      return FAIL;
    }
  }

  static error_t updateSeqno(uint8_t idx, uint16_t seqno) {
    LinkNeighbor* n = neighborCachePtrs[idx];
    uint8_t missed;
    if (n == NULL || !(n->state & ACTIVE_MASK))
      return FAIL;

    if (n->received[current_window] < LINK_ESTIMATOR_MAX_PACKETS)
      n->received[current_window]++;
    //The very first packet we see from this neighbor does not allow us to infer misses
    if (n->state & VALID_SEQNO_MASK) {
      missed = seqno - n->last_seqno - 1;
      if (n->missed[current_window] > (LINK_ESTIMATOR_MAX_PACKETS - missed)) {
        n->missed[current_window] = LINK_ESTIMATOR_MAX_PACKETS;
      } else {
        n->missed[current_window] += missed;
      }
    }
    dbg("BVR-debug","updateLinkQualityInfo: from=%d received=%d last_seq=%d rcv_seqno=%d missed=%d quality:%d\n",
            n->addr, n->received[current_window], n->last_seqno, seqno, n->missed[current_window], n->quality);
    n->state |= VALID_SEQNO_MASK;
    n->last_seqno = seqno;
    return SUCCESS;
  } 

  command error_t LinkEstimator.updateSeqno(uint8_t idx, uint16_t seqno) {
    if (state_is_active)
      return updateSeqno(idx, seqno);
    else 
      return FAIL;
  }


  command error_t LinkEstimator.updateReverse(uint8_t idx, uint8_t reverse, uint8_t expiration) {
    LinkNeighbor* n = neighborCachePtrs[idx];
    bool changed;
    
    dbg("BVR-debug","Linkestimator.updateReverse called\n");

    
    if (!state_is_active || n == NULL || !(n->state & ACTIVE_MASK))
      return FAIL;
    dbg("BVR-debug","LinkEstimator$updateReverseLink: from %d result:%d expiration:%d\n",n->addr, reverse, expiration);
    changed = (!(n->state & VALID_REVERSE_MASK) || 
               ((n->state & VALID_REVERSE_MASK) && reverse != n->reverse_quality));
    n->state |= VALID_REVERSE_MASK;
    n->reverse_quality = reverse;
    n->reverse_expiration = expiration;
    if (changed) {
      signal LinkEstimatorSynch.reverseQualityChanged(n->addr,n->reverse_quality);
      signal LinkEstimatorSynch.bidirectionalQualityChanged(n->addr, getBidirectionalQuality(n));
#ifndef NO_LE_LOGGING
      call Logger.LogChangeLink(n);
#endif
    }
    return SUCCESS;
  }

  /* If we did no receive the reverse link estimation for some time, 
   * age it so that it will eventually disappear */
  command error_t LinkEstimator.ageReverse(uint8_t idx) {
    LinkNeighbor* n = neighborCachePtrs[idx];
    if (!state_is_active || n == NULL || !(n->state & ACTIVE_MASK))
      return FAIL;
    if (n->reverse_expiration > 0) {
      n->reverse_expiration--;
      if (n->reverse_expiration == 0) {
        n->reverse_quality = 0;
        signal LinkEstimatorSynch.reverseQualityChanged(n->addr,n->reverse_quality);
#ifndef NO_LE_LOGGING
      	call Logger.LogChangeLink(n);
#endif
      }
    }
    dbg("BVR-debug","LinkEstimator$ageReverseLink: from %d to_expire:%d\n",n->addr, n->reverse_expiration);
    return SUCCESS;
  }

  static error_t updateStrength(uint8_t idx, uint16_t strength) {
    uint16_t new_strength;
    LinkNeighbor* n = neighborCachePtrs[idx];

    if (!state_is_active || n == NULL || !(n->state & ACTIVE_MASK))
      return FAIL;
    if (n->state & VALID_STRENGTH_MASK) {
      new_strength = (uint16_t) (0.25 * n->strength + 0.75 * strength);
      dbg("BVR-debug","LinkEstimator$updateStrength: node [%d] addr:%d strength was:%d is:%d\n",
              idx,n->addr,n->strength,new_strength);
      n->strength = new_strength;
    } else {
      dbg("BVR-debug","LinkEstimator$updateStrength: node [%d] addr:%d strength was:-- is:%d\n",
              idx,n->addr,strength);
      n->strength = strength;
      n->state |= VALID_STRENGTH_MASK;
    }
    return SUCCESS; 
  }

  command error_t LinkEstimator.updateStrength(uint8_t idx, uint16_t strength) {
    if (state_is_active) 
      return updateStrength(idx,strength);
    else 
      return FAIL;
  }

  /* Return the quality of the link from the neighbor, as estimated */
  static uint8_t getQuality(uint8_t idx) {
    LinkNeighbor* n = neighborCachePtrs[idx];
    if (n == NULL || !(n->state & ACTIVE_MASK)  || !(n->state & VALID_QUALITY_MASK))
      return 0;
    return n->quality;
  }

  inline static uint8_t getBidirectionalQuality(LinkNeighbor* n) {
    if (n == NULL || !(n->state & ACTIVE_MASK) ||
        !(n->state & VALID_QUALITY_MASK) || !(n->state & VALID_REVERSE_MASK)) {
      return 0;
    }
    return (uint8_t) (((n->quality/255.0)*(n->reverse_quality/255.0))*255); 
  }

  command error_t LinkEstimator.getQuality(uint8_t idx, uint8_t* quality) {
    LinkNeighbor* n = neighborCachePtrs[idx];
    if (n == NULL || !(n->state & ACTIVE_MASK) || !(n->state & VALID_QUALITY_MASK)) {
      *quality = 0;
      return FAIL;
    }
    *quality = getQuality(idx);
    return SUCCESS;
  }

  command error_t LinkEstimator.getBidirectionalQuality(uint8_t idx, uint8_t* quality) {
    LinkNeighbor* n = neighborCachePtrs[idx];
    if (n == NULL || !(n->state & ACTIVE_MASK) || !(n->state & VALID_QUALITY_MASK) ||
       !(n->state & VALID_REVERSE_MASK)) {
      *quality = n->quality; // this will break on purpose if nil if nil
      return FAIL; 
    }
    *quality = getBidirectionalQuality(n);
    return SUCCESS;
  }

  command error_t LinkEstimator.getStrength(uint8_t idx, uint16_t* strength) {
    LinkNeighbor* n = neighborCachePtrs[idx];
    if (n == NULL || !(n->state & ACTIVE_MASK) || !(n->state & VALID_STRENGTH_MASK))
      return FAIL;
    *strength = n->strength;
    return SUCCESS;
  }

  command error_t LinkEstimator.getReverseQuality(uint8_t idx, uint8_t* reverse) {
    LinkNeighbor* n = neighborCachePtrs[idx];
    if (n == NULL || !(n->state & ACTIVE_MASK) || !(n->state & VALID_REVERSE_MASK))
      return FAIL;
    *reverse = n->reverse_quality;
    return SUCCESS;
  }

    /** Set the reverse link info with the quality of the links to neighbors.
        Index tells the LinkEstimator where to start. In the end, the start of
        the next element to be included is written to start */
  command error_t LinkEstimator.setReverseLinkInfo(ReverseLinkInfo* rli, uint8_t* start) {
    uint8_t i;
    bool full = FALSE;
    int count = 0;
    uint8_t real_index;
    real_index = *start;
    if (real_index >= active_neighbors) real_index = 0;
    for (i = 0; i < active_neighbors && !full; i++) {
      dbg("BVR-debug","LinkEstimator$setReverseLinkInfo: n (addr):%d(%d) valid:%d quality:%d\n",
        real_index,neighborCachePtrs[real_index]->addr,((neighborCachePtrs[real_index]->state & VALID_SEQNO_MASK)?1:0),
        neighborCachePtrs[real_index]->quality
      );
      if ((neighborCachePtrs[real_index]->state & VALID_SEQNO_MASK)
            && (neighborCachePtrs[real_index]->quality > 0)) {
        full |= (reverseLinkInfoAppend(rli,neighborCachePtrs[real_index]->addr,
                                        neighborCachePtrs[real_index]->quality)==FAIL)?TRUE:FALSE;
        if (!full) count++;
      }
      real_index = (real_index + 1) % active_neighbors; 
    }
    rli->total_links = active_neighbors;
    *start = real_index;
    dbg("BVR-debug","LinkEstimator$setReverseLinkInfo: added %d of %d neighbors (full:%s)\n"
                , count, active_neighbors, full?"y":"n");
    return SUCCESS;
  }

  command error_t LinkEstimator.getNumLinks(uint8_t * n) {
    *n = active_neighbors;    
    return SUCCESS;
  }

  command error_t LinkEstimator.getLinkInfo(uint8_t idx, LinkNeighbor** n) {
    if (idx >= active_neighbors || n == NULL)
      return FAIL;
    if (neighborCachePtrs[idx] == NULL || !(neighborCachePtrs[idx]->state & ACTIVE_MASK))
      return FAIL;
    *n = neighborCachePtrs[idx];
    return SUCCESS;
  } 
  
  //added by Feng Wang on Mar 08
  command error_t LinkEstimator.goodBidirectionalQuality(uint8_t idx, bool* good) {
      LinkNeighbor* n = neighborCachePtrs[idx];
      
      dbg(DBG_USR2, "idx=%d, n=%x, n->state=%d, n->quality=%d\n", idx, n, n->state, n->quality);
      
      if (n == NULL || !(n->state & ACTIVE_MASK) || !(n->state & VALID_QUALITY_MASK) ||
         !(n->state & VALID_REVERSE_MASK) ) {
        *good = FALSE;
        return FAIL; 
      }
      *good = (n->quality > LINK_QUALITY_THRESHOLD && n->reverse_quality > LINK_QUALITY_THRESHOLD);
      return SUCCESS;
  }
  
  //TODO!!
  command error_t LinkEstimator.getLinkList(uint8_t start, uint8_t count, uint16_t* addr) {
    return SUCCESS;
  }

  event void UpdateLinkTimer.fired() {
    dbg("BVR-temp", "LinkEstimatorM.UpdateLinkTimer.fired\n");
    if (state_is_active)
      post updateLinkTask();
    return ;
  }

  default event error_t LinkEstimator.canEvict(uint16_t addr) {
    return SUCCESS;
  }

  default event error_t LinkEstimatorSynch.linkRemoved(uint16_t addr) {
    return SUCCESS;
  }

  default event error_t LinkEstimatorSynch.reverseQualityChanged(uint16_t addr, uint8_t reverseQuality) {
    return SUCCESS;
  }

  default event error_t LinkEstimatorSynch.qualityChanged(uint16_t addr, uint8_t quality) {
    return SUCCESS;
  }

  default event error_t LinkEstimatorSynch.bidirectionalQualityChanged(uint16_t addr, uint8_t quality) {
    return SUCCESS;
  }
}
