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

interface Neighbor {

  /*****************************************************************/
  /*  Neighbor is the bidirectional link health interface.         */
  /*  It is based on "heartbeats" either as part of time sync      */
  /*  or part of an application that periodically exchanges        */
  /*  messages between a node and all its neighbors, symmetrically */
  /*  at the same rate.  If an application invokes this interface  */
  /*  (which is good from the view of recording health), then the  */
  /*  frequency of its exchange should be at least as fast as the  */
  /*  timesync component -- otherwise the health calculation will  */
  /*  be incorrect and a link could be dropped.                    */
  /*****************************************************************/

  // register a symmetric message type and its associated frequency
  // (freq is the normal delay, in 1/8 seconds, between
  //  sends of this type of message)
  // if freq is zero, then neighbor health will be self-clocking,
  // as determined by sent() calls 
  command error_t regist( uint32_t freq );

  // call this when sending a message (that is, if Send.send() was 
  // successful, so we know TinyOS transmitted it to all neighbors)
  command void sent();   

  // call this when receiving a message from a neighbor
  command void received( uint16_t Id );

  // call this to enquire if someone is connected (= in neighborhood)
  command bool present( uint16_t Id );

  // this is signaled when someone joins the neighborhood
  event void join( uint16_t Id );  

  // this is signaled when someone leaves the neighborhood
  event void leave( uint16_t Id );

  // implement this for topology control
  command bool allow( uint16_t Id );

  // invoke this to "fix" a neighborhood for a while
  command void fix();  

}

