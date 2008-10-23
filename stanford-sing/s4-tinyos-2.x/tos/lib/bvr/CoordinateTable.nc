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



includes BVR;
includes nexthopinfo;

interface CoordinateTable {
  command uint8_t getSize();
  command uint8_t getOccupied();

  /** Get the entry corresponding to address 
   *  @return Pointer to entry NULL if entry not stored 
   */
  command CoordinateTableEntry* getEntry(uint16_t addr);

  /* This is used by the command interface. The interface is such for
     uniformity with other command interfaces */
  command error_t getEntryByIndex(uint8_t idx, CoordinateTableEntry** ce);

  /* Tell the table to not use link addr anymore. This is primarily
     to maintain the consistency with a table of available links,
     such as that provided by LinkEstimator */
  command error_t removeEntry(uint16_t addr);

  command error_t updateQuality(uint16_t addr, uint16_t quality);



  /** Store the entry given by the parameters
   *  This method has to deal with the replacement policy
   *  @return Pointer to entry or NULL if cannot store
   */
  command CoordinateTableEntry* storeEntry(uint16_t addr, uint16_t first_hop, 
                                                           uint8_t seqno, uint8_t quality, 
                                                           Coordinates* coords);

  /* Returns an ordered list of neighbors that are closer than min_dist
   * The list is ordered by distance,quality
   */
  command error_t getNextHops(Coordinates* dest, uint16_t dest_addr, 
                                               uint16_t min_dist, nextHopInfo* next_hops);
                                               

}

