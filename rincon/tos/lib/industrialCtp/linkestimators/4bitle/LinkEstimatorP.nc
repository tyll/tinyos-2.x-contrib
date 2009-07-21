
/*
 * "Copyright (c) 2006 University of Southern California.
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written
 * agreement is hereby granted, provided that the above copyright
 * notice, the following two paragraphs and the author appear in all
 * copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF SOUTHERN CALIFORNIA BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS
 * DOCUMENTATION, EVEN IF THE UNIVERSITY OF SOUTHERN CALIFORNIA HAS BEEN
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF SOUTHERN CALIFORNIA SPECIFICALLY DISCLAIMS ANY
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
 * SOUTHERN CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE,
 * SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */

/*
 * @author Omprakash Gnawali
 * @author David Moss
 */

#include "LinkEstimator.h"
#include "Ctp.h"

module LinkEstimatorP {
  provides {
    interface Init;
    interface AMSend;
    interface Receive;
    interface LinkEstimator;
    interface Packet;
  }

  uses {
    interface AMSend as SubAMSend;
    interface AMPacket as SubAMPacket;
    interface Packet as SubPacket;
    interface Receive as SubReceive;
    interface LinkPacketMetadata;
    interface Random;
    interface CompareBit;
  }
}

implementation {

  // configure the link estimator and some constants
  enum {
    // If the eetx estimate is below this threshold
    // do not evict a link
    EVICT_EETX_THRESHOLD = 55,
    
    // maximum link update rounds before we expire the link
    MAX_AGE = 6,
    
    // if received sequence number if larger than the last sequence
    // number by this gap, we reinitialize the link
    MAX_PKT_GAP = 10,
    
    BEST_EETX = 0,
    
    INVALID_RVAL = 0xFF,
    
    INVALID_NEIGHBOR_ADDR = 0xFF,
    
    // if we don't know the link quality, we need to return a value so
    // large that it will not be used to form paths
    VERY_LARGE_EETX_VALUE = 0xFF,
    
    // decay the link estimate using this alpha
    // we use a denominator of 10, so this corresponds to 0.2
    ALPHA = 9,
    
    // number of packets to wait before computing a new
    // DLQ (Data-driven Link Quality)
    DLQ_PKT_WINDOW = 5,
    
    // number of beacons to wait before computing a new
    // BLQ (Beacon-driven Link Quality)
    BLQ_PKT_WINDOW = 3,
    
    // largest EETX value that we feed into the link quality EWMA
    // a value of 60 corresponds to having to make six transmissions
    // to successfully receive one acknowledgement
    LARGE_EETX_VALUE = 60
  };

  // keep information about links from the neighbors
  neighbor_table_entry_t neighborTable[NEIGHBOR_TABLE_SIZE];
  
  // link estimation sequence, increment every time a beacon is sent
  uint8_t linkEstSeq = 0;
  
  // if there is not enough room in the packet to put all the neighbor table
  // entries, in order to do round robin we need to remember which entry
  // we sent in the last beacon
  uint8_t prevSentIdx = 0;



  /***************** Prototypes ****************/
  void processReceivedMessage(message_t *ONE msg, void *COUNT_NOK(len) payload, uint8_t len);
  
  linkest_header_t* getHeader(message_t *m);
  
  linkest_footer_t* getFooter(message_t *m, uint8_t len);
  
  uint8_t addLinkEstHeaderAndFooter(message_t *msg, uint8_t len);
  
  void initNeighborIdx(uint8_t i, am_addr_t linkLayerAddress);
  
  uint8_t findIdx(am_addr_t linkLayerAddress);
  
  uint8_t findEmptyNeighborIdx();
  
  uint8_t findRandomNeighborIdx();
  
  uint8_t findWorstNeighborIdx(uint8_t thresholdEetx);
    
  void updateEetx(neighbor_table_entry_t *ne, uint16_t newEst);
  
  void updateDeetx(neighbor_table_entry_t *ne);
    
  uint8_t computeEetx(uint8_t q1);
  
  void updateNeighborTableEst(am_addr_t n);
  
  void updateNeighborEntryIdx(uint8_t idx, uint8_t seq);
  
  void printNeighborTable();
  
  void printPacket(message_t *msg, uint8_t len);
  
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;

    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      neighborTable[i].flags = 0;
    }
    
    return SUCCESS;
  }


  /***************** LinkEstimator Commands ****************/
  /**
   * @return bi-directional link quality to the neighbor
   */
  command uint16_t LinkEstimator.getLinkQuality(am_addr_t neighbor) {
    uint8_t idx;
    idx = findIdx(neighbor);
    
    if (idx == INVALID_RVAL) {
      return VERY_LARGE_EETX_VALUE;
      
    } else {
      if (neighborTable[idx].flags & MATURE_ENTRY) {
        return neighborTable[idx].eetx;
        
      } else {
        return VERY_LARGE_EETX_VALUE;
      }
    }
  }

  /**
   * Insert the neighbor at any cost (if there is a room for it)
   * even if eviction of a perfectly fine neighbor is called for
   * @param neighbor the neighbor address to insert
   * @return SUCCESS if the neighbor was inserted.
   */
  command error_t LinkEstimator.insertNeighbor(am_addr_t neighbor) {
    uint8_t nidx;
    
    nidx = findIdx(neighbor);
    
    if (nidx != INVALID_RVAL) {
      ////printf("LI: insert: Found the entry, no need to insert\n\r");
      return SUCCESS;
    }
    
    nidx = findEmptyNeighborIdx();
    
    if (nidx != INVALID_RVAL) {
      ////printf("LI: insert: inserted into the empty slot\n\r");
      initNeighborIdx(nidx, neighbor);
      return SUCCESS;
      
    } else {
      nidx = findWorstNeighborIdx(BEST_EETX);
      if (nidx != INVALID_RVAL) {
        ////printf("LI: insert: inserted by replacing an entry for neighbor: %d\n\r", neighborTable[nidx].linkLayerAddress);
        signal LinkEstimator.evicted(neighborTable[nidx].linkLayerAddress);
        initNeighborIdx(nidx, neighbor);
        return SUCCESS;
      }
    }
    
    return FAIL;
  }

  /** 
   * Pin a neighbor so that it does not get evicted
   * @param neighbor
   * @return SUCCSES if the neighbor was found and pinned
   */
  command error_t LinkEstimator.pinNeighbor(am_addr_t neighbor) {
    uint8_t nidx = findIdx(neighbor);
    
    if (nidx == INVALID_RVAL) {
      return FAIL;
    }
    
    neighborTable[nidx].flags |= PINNED_ENTRY;
    return SUCCESS;
  }

  /**
   * Unpin a neighbor
   * @param neighbor 
   * @return SUCCESS if the entry was found and unpinned
   */
  command error_t LinkEstimator.unpinNeighbor(am_addr_t neighbor) {
    uint8_t nidx = findIdx(neighbor);
    
    if (nidx == INVALID_RVAL) {
      return FAIL;
    }
    
    neighborTable[nidx].flags &= ~PINNED_ENTRY;
    return SUCCESS;
  }


  /** 
   * Called when an acknowledgement is received; sign of a successful
   * data transmission; to update forward link quality
   * @param neighbor
   * @return SUCCESS if the neighbor was found 
   */
  command error_t LinkEstimator.txAck(am_addr_t neighbor) {
    neighbor_table_entry_t *ne;
    uint8_t nidx = findIdx(neighbor);
    
    if (nidx == INVALID_RVAL) {
      return FAIL;
    }
    
    ne = &neighborTable[nidx];
    ne->dataSuccess++;
    ne->dataTotal++;
    
    if (ne->dataTotal >= DLQ_PKT_WINDOW) {
      updateDeetx(ne);
    }
    
    return SUCCESS;
  }

  /**
   * Called when an acknowledgement is not received; could be due to
   * data pkt or acknowledgement loss; to update forward link quality
   * @param neighbor
   * @return SUCCESS if the neighbor was found
   */
  command error_t LinkEstimator.txNoAck(am_addr_t neighbor) {
    neighbor_table_entry_t *ne;
    uint8_t nidx = findIdx(neighbor);
    
    if (nidx == INVALID_RVAL) {
      return FAIL;
    }

    ne = &neighborTable[nidx];
    ne->dataTotal++;
    
    if (ne->dataTotal >= DLQ_PKT_WINDOW) {
      updateDeetx(ne);
    }
    
    return SUCCESS;
  }

  /**
   * Called when the parent changes; clear state about data-driven link quality
   * @param neighbor
   * @return SUCCESS if the neighbor was found
   */
  command error_t LinkEstimator.clearDLQ(am_addr_t neighbor) {
    neighbor_table_entry_t *ne;
    uint8_t nidx = findIdx(neighbor);
    
    if (nidx == INVALID_RVAL) {
      return FAIL;
    }
    
    ne = &neighborTable[nidx];
    ne->dataTotal = 0;
    ne->dataSuccess = 0;
    return SUCCESS;
  }


  command error_t LinkEstimator.evict(am_addr_t neighbor) {
    uint8_t nidx = findIdx(neighbor);
    
    if (nidx == INVALID_RVAL) {
      return FAIL;
    }
    
    signal LinkEstimator.evicted(neighborTable[nidx].linkLayerAddress);
    initNeighborIdx(nidx, neighborTable[nidx].linkLayerAddress);
    return SUCCESS;
  }

  /***************** Packet Commands ****************/
  command void Packet.clear(message_t *msg) {
    call SubPacket.clear(msg);
  }

  /**
   * Subtract the space occupied by the link estimation
   * header and footer from the incoming payload size
   */
  command uint8_t Packet.payloadLength(message_t *msg) {
    linkest_header_t *hdr;
    hdr = getHeader(msg);
    
    return call SubPacket.payloadLength(msg)
      - sizeof(linkest_header_t)
      - sizeof(linkest_footer_t) * (NUM_ENTRIES_FLAG & hdr->flags);
  }

  /**
   * Account for the space used by header and footer while setting the payload 
   * length
   */
  command void Packet.setPayloadLength(message_t *msg, uint8_t len) {
    linkest_header_t *hdr;
    hdr = getHeader(msg);
    
    call SubPacket.setPayloadLength(msg,
                                    len
                                    + sizeof(linkest_header_t)
                                    + sizeof(linkest_footer_t)*(NUM_ENTRIES_FLAG & hdr->flags));
  }

  command uint8_t Packet.maxPayloadLength() {
    return call SubPacket.maxPayloadLength() - sizeof(linkest_header_t);
  }

  /**
   * Application payload pointer is just past the link estimation header
   */
  command void *Packet.getPayload(message_t *msg, uint8_t len) {
    void *payload = call SubPacket.getPayload(msg, len + sizeof(linkest_header_t));
    
    if (payload != NULL) {
      payload += sizeof(linkest_header_t);
    }
    
    return payload;
  }
  
  
  /***************** AMSend Commands ****************/
  /**
   * User of link estimator calls send here slap the header and footer before 
   * sending the message
   * @param addr
   * @param msg
   * @param len
   */
  command error_t AMSend.send(am_addr_t addr, message_t *msg, uint8_t len) {
    uint8_t newlen;
    newlen = addLinkEstHeaderAndFooter(msg, len);
    ////printf("LI: %s packet of length %hhu became %hhu\n\r", __FUNCTION__, len, newlen);
    ////printf("LI: Sending seq: %d\n\r", linkEstSeq);
    printPacket(msg, newlen);
    
    return call SubAMSend.send(addr, msg, newlen);
  }
  
  command uint8_t AMSend.cancel(message_t *msg) {
    return call SubAMSend.cancel(msg);
  }

  command uint8_t AMSend.maxPayloadLength() {
    return call Packet.maxPayloadLength();
  }

  command void *AMSend.getPayload(message_t *msg, uint8_t len) {
    return call Packet.getPayload(msg, len);
  }

  
  /***************** SubAMSend Events ****************/
  event void SubAMSend.sendDone(message_t *msg, error_t error ) {
    signal AMSend.sendDone(msg, error);
  }
  

  /***************** SubReceive Events ****************/
  /** 
   * New messages are received here.
   * Update the neighbor table with the header and footer in the message
   * then signal the user of this component
   */
  event message_t *SubReceive.receive(message_t *msg,
                                      void *payload,
                                      uint8_t len) {
    ////printf("LI: Received upper packet. Will signal up\n\r");
    processReceivedMessage(msg, payload, len);
    
    return signal Receive.receive(msg,
                                  call Packet.getPayload(msg, call Packet.payloadLength(msg)),
                                  call Packet.payloadLength(msg));
  }

  /***************** Functions ****************/
  /** 
   * Called when link estimator generator packet or
   * packets from upper layer that are wired to pass through
   * link estimator is received
   */
  void processReceivedMessage(message_t *ONE msg, void *COUNT_NOK(len) payload, uint8_t len) {
    uint8_t nidx;
    uint8_t numEntries;

    ////printf("LI: LI receiving packet, buf addr: %x\n\r", payload);
    printPacket(msg, len);

    if (call SubAMPacket.destination(msg) == AM_BROADCAST_ADDR) {
      linkest_header_t* hdr = getHeader(msg);
      am_addr_t linkLayerAddress;

      linkLayerAddress = call SubAMPacket.source(msg);

      ///printf("LI: Got seq: %d from link: %d\n\r", hdr->seq, linkLayerAddress);

      numEntries = hdr->flags & NUM_ENTRIES_FLAG;
      printNeighborTable();

      // update neighbor table with this information
      // find the neighbor
      // if found
      //   update the entry
      // else
      //   find an empty entry
      //   if found
      //     initialize the entry
      //   else
      //     find a bad neighbor to be evicted
      //     if found
      //       evict the neighbor and init the entry
      //     else
      //       we can not accommodate this neighbor in the table
      nidx = findIdx(linkLayerAddress);
      if (nidx != INVALID_RVAL) {
        ////printf("LI: Found the entry so updating\n\r");
        updateNeighborEntryIdx(nidx, hdr->seq);
        
      } else {
        nidx = findEmptyNeighborIdx();
        if (nidx != INVALID_RVAL) {
          ////printf("LI: Found an empty entry\n\r");
          initNeighborIdx(nidx, linkLayerAddress);
          updateNeighborEntryIdx(nidx, hdr->seq);
          
        } else {
          nidx = findWorstNeighborIdx(EVICT_EETX_THRESHOLD);
          if (nidx != INVALID_RVAL) {
            ////printf("LI: Evicted neighbor %d at idx %d\n\r", neighborTable[nidx].linkLayerAddress, nidx);
            signal LinkEstimator.evicted(neighborTable[nidx].linkLayerAddress);
            initNeighborIdx(nidx, linkLayerAddress);
            
          } else {
            ////printf("LI: No room in the table\n\r");
            if (call CompareBit.shouldInsert(msg, 
                                               call Packet.getPayload(msg, call Packet.payloadLength(msg)),
                                               call Packet.payloadLength(msg),
                                               call LinkPacketMetadata.highChannelQuality(msg))) {
              nidx = findRandomNeighborIdx();
              
              if (nidx != INVALID_RVAL) {
                signal LinkEstimator.evicted(neighborTable[nidx].linkLayerAddress);
                initNeighborIdx(nidx, linkLayerAddress);
              }
            }
          }
        }
      }
    }
  }
  
  
  /**
   * Get the link estimation header in the packet
   */
  linkest_header_t* getHeader(message_t *m) {
    return (linkest_header_t*) call SubPacket.getPayload(m, sizeof(linkest_header_t));
  }

  /**
   * Get the link estimation footer (neighbor entries) in the packet
   */
  linkest_footer_t* getFooter(message_t *m, uint8_t len) {
    // To get a footer at offset "len", the payload must be len + sizeof large.
    return (linkest_footer_t*)(len + (uint8_t *) call Packet.getPayload(m,len + sizeof(linkest_footer_t)));
  }

  /** 
   * Add the link estimation header (seq no) and link estimation
   * footer (neighbor entries) in the packet. Call just before sending
   * the packet.
   */
  uint8_t addLinkEstHeaderAndFooter(message_t *msg, uint8_t len) {
    uint8_t newlen;
    linkest_header_t * ONE hdr;
    linkest_footer_t * ONE footer;
    uint8_t i;
    uint8_t j;
    uint8_t k;
    uint8_t maxEntries;
    uint8_t newPrevSentIdx;
    
    ////printf("LI: newlen1 = %d\n\r", len);
    
    hdr = getHeader(msg);
    footer = getFooter(msg, len);

    maxEntries = ((call SubPacket.maxPayloadLength() - len - sizeof(linkest_header_t))
                  / sizeof(linkest_footer_t));

    // Depending on the number of bits used to store the number
    // of entries, we can encode up to NUM_ENTRIES_FLAG using those bits
    if (maxEntries > NUM_ENTRIES_FLAG) {
      maxEntries = NUM_ENTRIES_FLAG;
    }
    
    ////printf("LI: Max payload is: %d, maxEntries is: %d\n\r", call SubPacket.maxPayloadLength(), maxEntries);

    j = 0;
    
    newPrevSentIdx = 0;
    
    for (i = 0; i < NEIGHBOR_TABLE_SIZE && j < maxEntries; i++) {
      uint8_t neighborCount;
      neighbor_stat_entry_t * COUNT(neighborCount) neighborLists;
      
      if(maxEntries <= NEIGHBOR_TABLE_SIZE) {
        neighborCount = maxEntries;
      } else {
        neighborCount = NEIGHBOR_TABLE_SIZE;
      }
      
      neighborLists = TCAST(neighbor_stat_entry_t * COUNT(neighborCount), footer->neighborList);
      k = (prevSentIdx + i + 1) % NEIGHBOR_TABLE_SIZE;
      
      if ((neighborTable[k].flags & VALID_ENTRY) &&
          (neighborTable[k].flags & MATURE_ENTRY)) {
        neighborLists[j].linkLayerAddress = neighborTable[k].linkLayerAddress;
        neighborLists[j].quality = neighborTable[k].quality;
        newPrevSentIdx = k;
        ////printf("LI: Loaded on footer: %d %d %d\n\r", j, neighborLists[j].linkLayerAddress, neighborLists[j].quality);
        j++;
      }
    }
    
    prevSentIdx = newPrevSentIdx;

    hdr->seq = linkEstSeq++;
    hdr->flags = 0;
    hdr->flags |= (NUM_ENTRIES_FLAG & j);
    newlen = sizeof(linkest_header_t) + len + j*sizeof(linkest_footer_t);
    ////printf("LI: newlen2 = %d\n\r", newlen);
    
    return newlen;
  }


  /**
   * Initialize the given entry in the table for neighbor linkLayerAddress
   */
  void initNeighborIdx(uint8_t i, am_addr_t linkLayerAddress) {
    neighbor_table_entry_t *ne;
    ne = &neighborTable[i];
    ne->linkLayerAddress = linkLayerAddress;
    ne->lastSequence = 0;
    ne->receiveCount = 0;
    ne->failCount = 0;
    ne->flags = (INIT_ENTRY | VALID_ENTRY);
    ne->age = MAX_AGE;
    ne->quality = 0;
    ne->eetx = 0;
  }

  /**
   * Find the index to the entry for neighbor linkLayerAddress
   */
  uint8_t findIdx(am_addr_t linkLayerAddress) {
    uint8_t i;
    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      if (neighborTable[i].flags & VALID_ENTRY) {
        if (neighborTable[i].linkLayerAddress == linkLayerAddress) {
          return i;
        }
      }
    }
    return INVALID_RVAL;
  }

  /**
   * Find an empty slot in the neighbor table
   */
  uint8_t findEmptyNeighborIdx() {
    uint8_t i;
    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      if (!(neighborTable[i].flags & VALID_ENTRY)) {
        return i;
      }
    }
    
    return INVALID_RVAL;
  }

  /**
   * Find the index to the worst neighbor if the eetx
   * estimate is greater than the given threshold
   */
  uint8_t findWorstNeighborIdx(uint8_t thresholdEetx) {
    uint8_t i;
    uint8_t worstNeighborIdx;
    uint16_t worstEETX;
    uint16_t thisEETX;

    worstNeighborIdx = INVALID_RVAL;
    worstEETX = 0;
    
    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      if (!(neighborTable[i].flags & VALID_ENTRY)) {
        ////printf("LI: Invalid so continuing\n\r");
        continue;
      }
      
      if (!(neighborTable[i].flags & MATURE_ENTRY)) {
        ////printf("LI: Not mature, so continuing\n\r");
        continue;
      }
      
      if (neighborTable[i].flags & PINNED_ENTRY) {
        ////printf("LI: Pinned entry, so continuing\n\r");
        continue;
      }
      
      thisEETX = neighborTable[i].eetx;
      
      if (thisEETX >= worstEETX) {
        worstNeighborIdx = i;
        worstEETX = thisEETX;
      }
    }
    
    
    if (worstEETX >= thresholdEetx) {
      return worstNeighborIdx;
    
    } else {
      return INVALID_RVAL;
    }
  }


  /**
   * Find the index to a random entry that is valid but not pinned
   */
  uint8_t findRandomNeighborIdx() {
    uint8_t i;
    uint8_t cnt;
    uint8_t num_eligible_eviction;

    num_eligible_eviction = 0;
    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      if (neighborTable[i].flags & VALID_ENTRY) {
        if (!(neighborTable[i].flags & PINNED_ENTRY ||
            neighborTable[i].flags & MATURE_ENTRY)) {
            
          num_eligible_eviction++;
        }
      }
    }

    if (num_eligible_eviction == 0) {
      return INVALID_RVAL;
    }

    cnt = call Random.rand16() % num_eligible_eviction;

    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      if (!neighborTable[i].flags & VALID_ENTRY) {
        continue;
      }
        
      if (neighborTable[i].flags & PINNED_ENTRY ||
          neighborTable[i].flags & MATURE_ENTRY) {
        continue;
      }
      
      if (cnt-- == 0) {
        return i;
      }
    }
    return INVALID_RVAL;
  }


  /**
   * Update the EETX estimator, called when new beacon estimate is done
   * also called when new DEETX estimate is done
   */
  void updateEetx(neighbor_table_entry_t *ne, uint16_t newEst) {
    ne->eetx = (ALPHA * ne->eetx + (10 - ALPHA) * newEst)/10;
    ///printf("LI: %d eetx set to %d\n\r", ne->linkLayerAddress, ne->eetx);
  }


  /**
   * Update data driven EETX
   */
  void updateDeetx(neighbor_table_entry_t *ne) {
    uint16_t estimatedEtx;

    if (ne->dataSuccess == 0) {
      // if there were no successful packet transmission in the
      // last window, our current estimate is the number of failed
      // transmissions
      estimatedEtx = (ne->dataTotal - 1)* 10;
    } else {
      estimatedEtx = (10 * ne->dataTotal) / ne->dataSuccess - 10;
      ne->dataSuccess = 0;
      ne->dataTotal = 0;
    }
    updateEetx(ne, estimatedEtx);
  }


  /**
   * EETX (Extra Expected number of Transmission)
   * EETX = ETX - 1
   * computeEetx returns EETX*10
   */
  uint8_t computeEetx(uint8_t q1) {
    uint16_t q;
    if (q1 > 0) {
      q =  2550 / q1 - 10;
      if (q > 255) {
        q = VERY_LARGE_EETX_VALUE;
      }
      return (uint8_t)q;
      
    } else {
      return VERY_LARGE_EETX_VALUE;
    }
  }

  /**
   * Update the inbound link quality by munging receive, fail count since 
   * last update
   */
  void updateNeighborTableEst(am_addr_t n) {
    uint8_t i;
    uint8_t totalPkt;
    neighbor_table_entry_t *ne;
    uint8_t newEst;
    uint8_t minPkt;

    minPkt = BLQ_PKT_WINDOW;
    ///printf("LI: %s\n\r", __FUNCTION__);
    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      ne = &neighborTable[i];
      if (ne->linkLayerAddress == n) {
        if (ne->flags & VALID_ENTRY) {
          if (ne->age > 0) {
            ne->age--;
          }
          
          if (ne->age == 0) {
            ne->flags ^= VALID_ENTRY;
            ne->quality = 0;
            
          } else {
            ///printf("LI: Making link: %d mature\n\r", i);
            ne->flags |= MATURE_ENTRY;
            totalPkt = ne->receiveCount + ne->failCount;
            ///printf("LI: MinPkt: %d, totalPkt: %d\n\r", minPkt, totalPkt);
            
            if (totalPkt < minPkt) {
              totalPkt = minPkt;
            }
            
            if (totalPkt == 0) {
              ne->quality = (ALPHA * ne->quality) / 10;
            } else {
              newEst = (255 * ne->receiveCount) / totalPkt;
              ///printf("LI:   %hu: %hhu -> %hhu\n\r", ne->linkLayerAddress, ne->quality, (ALPHA * ne->quality + (10-ALPHA) * newEst)/10);
              ne->quality = (ALPHA * ne->quality + (10-ALPHA) * newEst)/10;
            }
            
            ne->receiveCount = 0;
            ne->failCount = 0;
          }
          updateEetx(ne, computeEetx(ne->quality));
          
        } else {
          ////printf("LI:  - entry %i is invalid.\n\r", (int)i);
        }
      }
    }
  }


  /**
   * We received seq from the neighbor in idx update the last seen seq, receive 
   * and fail count refresh the age
   */
  void updateNeighborEntryIdx(uint8_t idx, uint8_t seq) {
    uint8_t packetGap;

    if (neighborTable[idx].flags & INIT_ENTRY) {
      ///printf("LI: Init entry update\n\r");
      neighborTable[idx].lastSequence = seq;
      neighborTable[idx].flags &= ~INIT_ENTRY;
    }
    
    packetGap = seq - neighborTable[idx].lastSequence;
    ///printf("LI: updateNeighborEntryIdx: prevseq %d, curseq %d, gap %d\n\r", neighborTable[idx].lastSequence, seq, packetGap);
    neighborTable[idx].lastSequence = seq;
    neighborTable[idx].receiveCount++;
    neighborTable[idx].age = MAX_AGE;
    
    if (packetGap > 0) {
      neighborTable[idx].failCount += packetGap - 1;
    }
    
    if (packetGap > MAX_PKT_GAP) {
      neighborTable[idx].failCount = 0;
      neighborTable[idx].receiveCount = 1;
      neighborTable[idx].quality = 0;
    }

    if (neighborTable[idx].receiveCount >= BLQ_PKT_WINDOW) {
      updateNeighborTableEst(neighborTable[idx].linkLayerAddress);
    }

  }



  /**
   * Print the neighbor table for debugging.
   */
  void printNeighborTable() {
   /*
    uint8_t i;
    neighbor_table_entry_t *ne;
    
    for (i = 0; i < NEIGHBOR_TABLE_SIZE; i++) {
      ne = &neighborTable[i];
      
      if (ne->flags & VALID_ENTRY) {
        ///printf("LI: %d:%d inQ=%d, inA=%d, rcv=%d, fail=%d, Q=%d\n\r",
            i, ne->linkLayerAddress, ne->quality, ne->age,
            ne->receiveCount, ne->failCount, computeEetx(ne->quality));
      }
    }
    */
  }

  /**
   * Print the packet for debugging.
   */
  void printPacket(message_t *msg, uint8_t len) {
   /*
    uint8_t i;
    uint8_t* b;

    b = (uint8_t *)msg->data;
    
    for(i=0; i<len; i++) {
      dbg_clear("LI", "%x ", b[i]);
    }
    
    dbg_clear("LI", "\n\r");
    */
  }
  
  
}
