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


//All of the expiration will be taken care of by the Link Estimator module

includes AM;
includes BVR;
includes CoordinateTable;
includes nexthopinfo;


module CoordinateTableM {
  provides {
    interface CoordinateTable;
    interface FreezeThaw;
    interface StdControl;
    interface Init;
  }
  
}

implementation {
  uint8_t num_active;
  CoordinateTableEntry table[COORD_TABLE_SIZE];
  CoordinateTableEntry* tablePtrs[COORD_TABLE_SIZE];

  bool state_is_active;


  command error_t Init.init() {
    int i;
    state_is_active = TRUE;
    dbg("BVR-debug", "CoordinateTableM.init\n");
    for (i = 0; i < COORD_TABLE_SIZE; i++) {      
      CTEntryInit(&table[i]);
    }
    
    dbg("BVR-debug", "CoordinateTableM.init ended\n");
    return SUCCESS;
  }
  command error_t StdControl.start() {
    return SUCCESS;
  }
  command error_t StdControl.stop() {
    return SUCCESS;
  }

  command error_t FreezeThaw.freeze() {
    dbg("BVR-debug","CoordinateTableM$freeze\n");
    state_is_active = FALSE;
    return SUCCESS;
  }
  command error_t FreezeThaw.thaw() {
    dbg("BVR-debug","CoordinateTableM$thaw\n");
    state_is_active = TRUE;
    return SUCCESS;
  }
  command uint8_t CoordinateTable.getSize() {
    return COORD_TABLE_SIZE;
  }

  void printTable() {
    int i;
    for (i = 0; i < num_active; i++) {
      dbg("BVR-debug","CoordinateTable: [%d(%d)] addr:%d through:%d quality:%d age:%d coords: ",
                     i,tablePtrs[i]->pos,tablePtrs[i]->addr,tablePtrs[i]->first_hop,
                     tablePtrs[i]->quality,
                      tablePtrs[i]->age);
      coordinates_print(&tablePtrs[i]->coords);
    }
  }

  /* This sorts the qualifying nextHops and returns the BVR_MAX_NEXT_HOPS best.
   * This is a truncated insertion sort, O(num_active*BVR_MAX_NEXT_HOPS)
   * Update:
   *  - only use nodes that have the components present in the
   *    destination
   *  - this is the first step in using the progressive dropping of
   *    beacons, which will involve adding the distance at each k to
   *    the packet as well.
   */ 
  command error_t CoordinateTable.getNextHops(Coordinates* dest, uint16_t dest_addr, 
                                               uint16_t min_dist, nextHopInfo* next_hops) {
    int i,k;
    uint8_t metric = COORDS_DIST_WEIGHTED;
    uint16_t di = 0;
    bool valid;
#ifdef EXP_PROGRESS
    uint16_t new_exp_progress = 0;
    uint16_t exp_progress[BVR_MAX_NEXT_HOPS];
#endif
    
    if (dest == NULL || next_hops == NULL) {
      return FAIL;
    }
    //return at most BVR_MAX_NEXT_HOPS that have distance smaller than min_dist,
    //sorted by distance and then by quality
    //There is one exception to the ordering: if a node is the destination, it takes
    //precedence over all others
    next_hops->n = 0;
    dbg("BVR","CoordinateTable$getNextHops: min_dist %d max_entries:%d dest_addr:%d\n",
        min_dist,BVR_MAX_NEXT_HOPS,dest_addr);
    for (i = 0; i < num_active; i++) {
      valid = coordinates_has_same_valid_components(&tablePtrs[i]->coords, dest);
      di = coordinates_distance(&tablePtrs[i]->coords, dest, metric);
#ifdef EXP_PROGRESS
      new_exp_progress = (di < min_dist)? (uint16_t)((min_dist - di) * (tablePtrs[i]->quality/255.0)):0;
#endif
      dbg("BVR","CoordinateTable$getNextHops: ct entry: addr %d dist %d qual %d valid %d ",
          tablePtrs[i]->addr, di, tablePtrs[i]->quality, valid);
      coordinates_print(&tablePtrs[i]->coords);
      if (tablePtrs[i]->addr == dest_addr || 
          (valid && di < min_dist)) { 
        /* Add in order to next_hops*/
        /* This is inlined here to save stack space */
        for (k = next_hops->n; k > 0; k--) {
#ifndef EXP_PROGRESS
          if (tablePtrs[i]->addr == dest_addr ||                      //is destination or
              (tablePtrs[next_hops->next_hops[k-1]]->addr != dest_addr &&
              (di <  next_hops->distances[k-1] ||                      //distante is smaller
               (di == next_hops->distances[k-1] &&                      //or distance is equal and
               tablePtrs[i]->quality > 
               tablePtrs[next_hops->next_hops[k-1]]->quality))))        //quality is better
#else
          if (tablePtrs[i]->addr == dest_addr ||                      //is destination or
              (tablePtrs[next_hops->next_hops[k-1]]->addr != dest_addr &&
              (new_exp_progress >  exp_progress[k-1] ||                      //new_exp_progress is larger
               (new_exp_progress == exp_progress[k-1] &&                      //new_exp_progress is is equal and
               di < next_hops->distances[k-1]))))        //distance is better
#endif
          {
            if (k < BVR_MAX_NEXT_HOPS) {                   //shift element at k-1 right
#ifdef EXP_PROGRESS
              dbg("BVR","\tCoordinateTable$getNextHops: shifting entry <i,addr,dist,qual,e_prog> <%d,%d,%d,%d,%d>\n",
                  next_hops->next_hops[k-1],tablePtrs[next_hops->next_hops[k-1]]->addr,next_hops->distances[k-1],
                  tablePtrs[next_hops->next_hops[k-1]]->quality,exp_progress[k-1]);
              exp_progress[k] = exp_progress[k-1];
#else
              dbg("BVR","\tCoordinateTable$getNextHops: shifting entry <i,addr,dist,qual> <%d,%d,%d,%d>\n",
                  next_hops->next_hops[k-1],tablePtrs[next_hops->next_hops[k-1]]->addr,next_hops->distances[k-1],
                  tablePtrs[next_hops->next_hops[k-1]]->quality);
#endif
              next_hops->next_hops[k] = next_hops->next_hops[k-1];
              next_hops->distances[k] = next_hops->distances[k-1];
            } else {
#ifdef EXP_PROGRESS
              dbg("BVR","\tCoordinateTable$getNextHops: replacing entry <i,addr,dist,qual,e_prog> <%d,%d,%d,%d,%d>\n",
                  next_hops->next_hops[k-1],tablePtrs[next_hops->next_hops[k-1]]->addr,next_hops->distances[k-1],
                  tablePtrs[next_hops->next_hops[k-1]]->quality,exp_progress[k-1]);
#else 
              dbg("BVR","\tCoordinateTable$getNextHops: replacing entry <i,addr,dist,qual> <%d,%d,%d,%d>\n",
                  next_hops->next_hops[k-1],tablePtrs[next_hops->next_hops[k-1]]->addr,next_hops->distances[k-1],
                  tablePtrs[next_hops->next_hops[k-1]]->quality);
#endif
            }
          } else 
            break;
        }
        if (k < BVR_MAX_NEXT_HOPS) {                      //insert new element at k
#ifndef EXP_PROGRESS
          dbg("BVR","\tCoordinateTable$getNextHops: * inserting new entry <i,addr,dist,qual> <%d,%d,%d,%d> at k %d\n",
              i,tablePtrs[i]->addr,di,tablePtrs[i]->quality,k);
#else
          dbg("BVR","\tCoordinateTable$getNextHops: * inserting new entry <i,addr,dist,qual,e_prog> <%d,%d,%d,%d,%d> at k %d\n",
              i,tablePtrs[i]->addr,di,tablePtrs[i]->quality,new_exp_progress,k);
          exp_progress[k] = new_exp_progress;
#endif
          next_hops->next_hops[k] = i;
          next_hops->distances[k] = di;
          if (next_hops->n < BVR_MAX_NEXT_HOPS)
            next_hops->n++;
        } else {
          dbg("BVR","\tCoordinateTable$getNextHops: * rejecting new entry <i,addr,dist,qual> <%d,%d,%d,%d> (k %d)\n",
              i,tablePtrs[i]->addr,di,tablePtrs[i]->quality,k);
        }
      }
    }
    /*Convert the stored indices into addresses*/
    for (k = 0; k <next_hops->n ; k++) {
      dbg("BVR","CoordinateTable$getNextHops: nh entry: addr %d dist %d qual %d\n",
          tablePtrs[next_hops->next_hops[k]]->addr, next_hops->distances[k], 
          tablePtrs[next_hops->next_hops[k]]->quality);
      next_hops->next_hops[k] = tablePtrs[next_hops->next_hops[k]]->addr;
    }
    dbg("BVR","coordinateTable$getNextHops: done\n");
    return SUCCESS;
  }


  command uint8_t CoordinateTable.getOccupied() {
    return num_active;
  }

  /*  This function is the same as the provided one, it is here
   *  so that other commands can also use it.
   *  
   *  current_entry is just a hint to speed up the search if
   *  we are looking for the same entry as last time.
   */
  static CoordinateTableEntry* get_entry(uint16_t addr) {
    uint8_t i;
    uint8_t idx = 0;
    static uint8_t current_entry = 0;
    CoordinateTableEntry* e = NULL;

    if (current_entry > num_active) current_entry = 0;

    for (i = 0; i < num_active && e == NULL; i++) {
      idx = (i + current_entry) % num_active;
      if (tablePtrs[idx]->addr == addr)
        e = tablePtrs[idx];
    }
    current_entry = idx;
    dbg("BVR-debug","COORDS: CoordinateTableM$get_entry called w addr: %d returning %p\n",addr,e);
    return e;
  }

  static CoordinateTableEntry* get_free() {
    uint8_t i;
    CoordinateTableEntry* ce = NULL;

    if (num_active == COORD_TABLE_SIZE)
      return NULL;

    for (i = 0; i < COORD_TABLE_SIZE && ce == NULL; i++) {
      if (table[i].valid == FALSE)
        ce = &table[i];
    }
    return ce;
  }
  
  /** Get the entry corresponding to address 
   *  @return Pointer to entry NULL if entry not stored 
   */
  command CoordinateTableEntry* CoordinateTable.getEntry(uint16_t addr) {
    return get_entry(addr);
  }

  /* Remove the entry itself and any entries that have this as the first_hop */
  /* TODO: this is not cleaning up entries that have this as the first_hop! */
  static void removeEntry(uint16_t addr) {
    int i,j,removed;
    removed = 0;
    

    for (i = 0, j=0; j < num_active; i++, j++) {
      while (j < num_active && (tablePtrs[j]->addr == addr || tablePtrs[j]->first_hop == addr)) {
        //clean j
        //call Logger.LogDropNeighbor(tablePtrs[j]->addr);
        tablePtrs[j]->valid = FALSE;
        j++;
        removed++;
      }
      if (i < j && j < num_active) {
        tablePtrs[i] = tablePtrs[j];
        tablePtrs[i]->pos = i;
      }
    }
    if (removed) {
      num_active -= removed;
      dbg("BVR","COORD_TABLE: cleanup\n");
      printTable();
    }
  }
  
 
  command error_t CoordinateTable.removeEntry(uint16_t addr) {
    if (state_is_active) 
      removeEntry(addr);
    return SUCCESS;
  }

  command error_t CoordinateTable.getEntryByIndex(uint8_t i, CoordinateTableEntry ** ce) {
    if (i >= num_active || ce == NULL) 
      return FAIL;
    *ce = tablePtrs[i];
    return SUCCESS;
  }

  /** Store the entry given by the paramters
   *  This method has to deal with the replacement policy
   *  Currently: there is no replacement, but new entries can be added when
   *  old ones expire.
   *  Options: good spread, eliminate repeated entries, etc...
   *  @return Pointer to entry or NULL if cannot store
   */
  command CoordinateTableEntry* CoordinateTable.storeEntry(uint16_t addr, uint16_t first_hop, 
                                                           uint8_t seqno, uint8_t quality, 
                                                           Coordinates* coords)  
  {
    CoordinateTableEntry* e = NULL;
    if (!state_is_active) {
      return e;
    }
    dbg("BVR-debug","CoordinateTable$storeEntry: called with addr: %d first_hop: %d seqno: %d qual: %d \n", 
      addr, first_hop, seqno, quality);
    e = get_entry(addr);
    if (e != NULL) {
      dbg("BVR-debug","CoordinateTable$storeEntry: store called on item that was already stored\n");
    } else {
      //is there space?
      if (num_active < COORD_TABLE_SIZE) {
        //there is space
        tablePtrs[num_active] = get_free();
        if (tablePtrs[num_active] == NULL) 
          dbg("BVR-error","get_free returned null when it shouldn't!!!\n");
        tablePtrs[num_active]->valid = TRUE; 
        tablePtrs[num_active]->first_hop = first_hop;
        tablePtrs[num_active]->last_seqno = seqno;
        tablePtrs[num_active]->addr = addr;
        tablePtrs[num_active]->quality = quality;
        coordinates_copy(coords,&tablePtrs[num_active]->coords);
        tablePtrs[num_active]->age = 0;
        tablePtrs[num_active]->pos = num_active;
        e = tablePtrs[num_active];
        //call Logger.LogAddNeighbor(e);
        num_active++;
      } else {
        //we must replace someone if this guy should really be admitted
        //XXX: will not replace anyone. They will have to expire.
        //I believe that this, and the link quality filtering, will
        //be enough to get us going
        dbg("BVR-debug","CoordinateTable$storeEntry: item not in cache, cache full\n");
      }
    }
    printTable();
    return e;
  }  


  command error_t CoordinateTable.updateQuality(uint16_t addr, uint16_t quality) {
    CoordinateTableEntry *e;

    if (!state_is_active)
      return SUCCESS;

    e = get_entry(addr);
    if (e != NULL) {
      CTEntryUpdateQuality(e,quality);
      //call Logger.LogUpdateNeighbor(e);
    }
    printTable();
    return SUCCESS;
  }
  
    


}
  
