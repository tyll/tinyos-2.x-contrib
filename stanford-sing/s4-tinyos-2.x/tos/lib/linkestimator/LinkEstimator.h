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


#ifndef LINK_ESTIMATOR_H
#define LINK_ESTIMATOR_H

enum {
  AM_LE_REVERSE_LINK_ESTIMATION_MSG = 59, //0x3B
};

/*Timers*/
enum {
  I_UPDATE_LINK_INTERVAL = 30000u, //Link estimator
  I_REVERSE_LINK_PERIOD = 17500u,   //Reverse link information
  I_REVERSE_LINK_JITTER = 17500u,
};

enum {
#ifdef LE_CACHE_SIZE
  N_CACHE_SIZE = LE_CACHE_SIZE,
#else
  N_CACHE_SIZE = 18,
#endif
  MAX_QUALITY = 255,
  AGE_THRESHOLD = 5,      //This is when to remove a neighbor*

  LINK_ESTIMATOR_FILTER_BY_STRENGTH = 0,
#ifdef PLATFORM_PC
  SIGNAL_STRENGTH_FILTER_THRESHOLD = 60,
#else
  SIGNAL_STRENGTH_FILTER_THRESHOLD = 350,
#endif

  //Rodrigo: changed from 30 to 100, changed hist,new,sum
  EWMA_HIST = 3,           //These are not in effect. Look in LinkEstimatorM for details
  EWMA_NEW  = 1,
  EWMA_SUM  = 4,
  LINK_ESTIMATOR_MIN_PACKETS = 3,      //This is the minimum number of packets expected from a neighbor
                                       //in a I_UPDATE_LINK_INTERVAL
                                       //=I_UPDATE_LINK_INTERVAL/(I_BEACON_INTERVAL+I_BEACON_JITTER/2)
  LINK_ESTIMATOR_PROBATION = 4, //4 for more stability,
                               //Number of iterations so that the link estimation converges to within
                               //10% of a constant value. For a given
                               //alpha (the weight of history in the ewma),
                               //find n > log(0.1)/log(alpha). This grows
                               //pretty fast as alpha gets close to 1.
                               //Some approximate values:
                               // (alpha->c): 0.5->3, 0.6->4, 0.75->7
  LINK_ESTIMATOR_REPLACE_THRESH = 50, //Don't replace a node if the quality is >= this (20% of 255)
  LINK_ESTIMATOR_RECEIVE_WINDOW = 3,
  LINK_ESTIMATOR_MAX_PACKETS = 254,       //Maximum valid number stored by each received and sent slots
  LINK_ESTIMATOR_INVALID_PACKETS = 255,   //Invalid setting for sent and received slots

    //added by Feng Wang on Mar 08
    //LINK_QUALITY_THRESHOLD = 64,
  LINK_QUALITY_THRESHOLD = 80,//50% threshold
};

//  * Age is used to remove a neighbor. It is the number of consecutive
//    link update timers that windows the
//    node has not sent any messages


//Masks for the bits in neighbor state
enum {
  ACTIVE_MASK = 1,
  VALID_ADDR_MASK = 2,
  VALID_QUALITY_MASK = 4,
  VALID_SEQNO_MASK = 8,
  VALID_STRENGTH_MASK = 16,
  VALID_REVERSE_MASK = 32,
  REMOVE_MASK = 64
};

//This table is the 1-hop neighbor cache, and holds link information basically

typedef nx_struct LinkNeighbor {
  nx_uint8_t state;
  nx_uint16_t addr;
  nx_uint8_t reverse_quality;  //The link quality TO this neighbor
  nx_uint8_t reverse_expiration;
  nx_uint8_t quality;          //Our assessment of the incoming link from n
  nx_uint16_t strength;
  nx_uint16_t last_seqno;      //The last sequence number we got from this neighbor
  nx_uint8_t missed[LINK_ESTIMATOR_RECEIVE_WINDOW];
  nx_uint8_t received[LINK_ESTIMATOR_RECEIVE_WINDOW];
  nx_uint8_t age;              //Number of windows with no packets
  nx_uint8_t chances;           //Number of remaining periods in which this neighbor is in probation
}  LinkNeighbor, *LinkNeighbor_ptr;


/* Link Estimator Header */
typedef nx_struct {
  nx_uint16_t last_hop;//where this active message came from
  nx_uint16_t seqno;   //seqno is a routing layer *per node* sequence, used
                    //to estimate link quality. If messages are to be used
                    //as link estimators, don't use for other purposes, such
                    //as application level sequence numbers.

} LEHeader;


#endif


