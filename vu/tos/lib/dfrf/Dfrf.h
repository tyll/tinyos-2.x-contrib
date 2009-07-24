/*
 * Copyright (c) 2009, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 *
 * Author: Miklos Maroti, Gabor Pap
 * 	   Brano Kusy, kusy@isis.vanderbilt.edu
 *         Janos Sallai
 */


#ifndef __DFRF_H__
#define __DFRF_H__

#include "AM.h"
#include "DfrfMsg.h"

/**
* Block is an encapsulation of data packet that is routed.
* Blocks are stored sequentially in a buffer that the user of FloodRouting
*   provides.
*/
typedef struct block
{
    uint8_t priority;   // lower value is higher priority
    uint32_t timeStamp; //time information is stored in the packet
    uint8_t data[0];    // the packet data of length dataLength
} dfrf_block_t;

/**
* Descriptor is a logical structure which we build on top of a buffer (
*   a 'chunk of data' provided by user), each parametrized FloodRouting
*   interface has one descriptor.
*   buffer is structured the following way: the first 10 bytes is a header and
*   the next bytes are sequentially stored data packets (called blocks).
*   sequential representation of blocks saves space, to be able to access the blocks,
*   we use the fact that blocks have uniform size (blockLength), and we store
*   a pointer to the first block (blocks) and to the last block(blocksEnd).
*/
typedef struct descriptor
{
    uint8_t appId;      // comes from parametrized FloodRouting interface
    struct descriptor *nextDesc;// allows to go through multiple buffers
    uint8_t dataLength;     // size of a data packet in bytes (i.e. size of block.data)
    uint8_t uniqueLength;   // size of unique part of data a packet in bytes
    uint8_t maxDataPerMsg;  // how many packets can fit in the buffer
    uint8_t dirty;      // common information about states of all blocks
    dfrf_block_t* blocksEnd;// pointer to the last block in the descriptor
    dfrf_block_t blocks[0]; // pointer to the first block in the descriptor
} dfrf_desc_t;


#endif // __DFRF_H__
