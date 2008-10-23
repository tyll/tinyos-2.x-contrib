/* ex: set tabstop=2 shiftwidth=2 expandtab syn=c:*/
/* $Id$ */

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

/* The LinkEstimator is updated by LinkEstimatorComm, and used by whoever needs
 * information about a neighbor's link quality */
includes AM;
includes ReverseLinkInfo;

interface LinkEstimator {
    command error_t find(uint16_t addr,uint8_t* idx);
    command error_t store(uint16_t addr, uint16_t seqno, 
                           uint16_t strength, uint8_t* idx);

    command error_t updateSeqno(uint8_t idx, uint16_t seqno);
    command error_t updateReverse(uint8_t idx, uint8_t reverse, uint8_t expiration);
    /* If a reverseLink is received and we are not included, we may start to
     * worry that our link to them is not that great */
    command error_t ageReverse(uint8_t idx);
    command error_t updateStrength(uint8_t idx, uint16_t strength);

    command error_t getQuality(uint8_t idx, uint8_t* quality);
    command error_t getBidirectionalQuality(uint8_t idx, uint8_t* quality);
    command error_t getStrength(uint8_t idx, uint16_t* quality);
    command error_t getReverseQuality(uint8_t idx, bool* reverse);
      command error_t goodBidirectionalQuality(uint8_t idx, bool* good) ;


    /** Set the reverse link info with the quality of the links to neighbors.
        Index tells the LinkEstimator where to start. In the end, the index of
        the next element to be included is written to index */
    command error_t setReverseLinkInfo(ReverseLinkInfo* rli, uint8_t* start);

    /* Status information */
    command error_t getNumLinks(uint8_t *n);
    command error_t getLinkInfo(uint8_t idx, LinkNeighbor ** n);
    command error_t getLinkList(uint8_t start, uint8_t count, uint16_t* addr);

    /** Signalled whenever the LinkEstimator is about to remove a 
        neighbor. Will only remove the neighbor if all of the users
        of the interface return SUCCESS. This is automatically taken 
        care of by NesC if there are multiple components wired to the
        interface */
    event error_t canEvict(uint16_t addr);

}

