/*
* Copyright (c) 2007 University of Iowa 
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
* - Neither the name of The University of Iowa  nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
* FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
* UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
* INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
* STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * Timesync suite of interfaces, components, testing tools, and documents.
 * @author Ted Herman
 * Development supported in part by NSF award 0519907. 
 */
//--EOCpr712 (do not remove this line, which terminates copyright include)

includes Tnbrhood;
includes OTime;
interface Tnbrhood {

  /*****************************************************************/
  /*  Tnbrhood tracks the status of a node's neighbors:            */
  /*     whether a neighbor is ahead, behind, what mode it's in,   */
  /*     and so forth.                                             */  
  /*****************************************************************/

  /**
   *  Call this to set mode (really, this just duplicates the 
   *  mode variable in TsyncM, and could as well be implemented
   *  using an extern to that variable)
   */
  command void setMode(uint8_t newmode);

  /**
   * Record data from an incoming beacon 
   */
  command void record( uint8_t mode,      // nbr's mode 
                       timeSyncPtr Local, // the local clock
                       timeSyncPtr RemoteLocal,   // nbr's local clock 
                       timeSyncPtr RemoteVirtual, // nbr's virtual clock
                       int16_t diff,      // how much nbr is ahead/behind
                       uint16_t Id );     // Id of nbr
 
  /**
   *  Fetch maximum displacement recorded so far.
   *     value returned indicates result of fetch attempt:
   *     0 => no maximum could be obtained (really poor neighborhood)
   *     1 => maximum could be obtained, but not from any normal node
   *     2 => maximum could be obtained from a normal node
   *     3 => maximum could be obtained from a bidirectional, normal neighbor 
   *     result is put into t
   */
  command uint8_t getMaxDisplacement( timeSyncPtr t );

  /**
   *  get number of "normal" neighbors
   */
  command uint8_t Nsize( );

  /**
   *  Find the Id of any outlier among the set of
   *  normal neighbors;  return Id of said outlier.
   *
   *  Return codes:
   *          0  there is no outlier
   *         -1  there is more than one outlier (ambiguous)
   *          1  there is exactly one outlier
   *             -- in this last case only, the identity
   *             of the outlier is stored at the
   *             caller-provided location.
   */
  command int8_t outlier( uint16_t * IdPtr );

  /**
   *  Return approximate length of time (as 1-byte time value)
   *  since we've last heard from a given neighbor
   */
  command uint8_t age( uint16_t Id, timeSyncPtr curTime );

  /**
   *  This command looks through all normal neighbors to see if 
   *  they have all recently had "diff" values (that is, the difference
   *  between incoming beacon global times and this node's global clock)
   *  which are negative (behind this node) w.r.t. the median;  if not,
   *  then return zero.  Otherwise, return the largest (nearest to zero)
   *  of these median values, scaled, of course, to microseconds.
   */
  command int16_t overDiff( );

  /**
   *  Find the neighborPtr corresponding to a given
   *  mote Id. Result is one of these three cases:
   *  1.  returns NULL -- means not found, and the
   *      table is full.
   *  2.  returns neighborPtr corresponding to the Id
   *  3.  returns neighborPtr corresponding to 
   *      Id = 0, meaning that entry wasn't found, 
   *      but here is a place to insert a new item.
   */
  command neighborPtr findNbr( uint16_t Id );

  /**
   *  suspect:  return TRUE if this node's recent pattern
   *  of diff values does not pass a sanity check
   */
  command bool suspect( uint16_t Id );

  /**
   *  Return start of neighbor_t nbrTab[NUM_NEIGHBORS]
   */
  command neighborPtr nbrTab( );

}

