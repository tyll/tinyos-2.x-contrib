/*
 * Copyright (c) 2002, Vanderbilt University
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
 * @author: Miklos Maroti, Brano Kusy (kusy@isis.vanderbilt.edu)
 * Ported to T2: 3/17/08 by Brano Kusy (branislav.kusy@gmail.com)
 */
typedef nx_struct TimeSyncPoll
{
	nx_uint16_t	senderAddr;
	nx_uint16_t	msgID;
}TimeSyncPoll;

typedef nx_struct TimeSyncPollReply
{
        nx_uint16_t    nodeID;
        nx_uint16_t    msgID;
        nx_uint32_t    globalClock;
        nx_uint32_t    localClock;
        nx_uint32_t    skew;
        nx_uint8_t     is_synced;
        nx_uint16_t    	rootID;
        nx_uint8_t     seqNum;
        nx_uint8_t     numEntries;
} TimeSyncPollReply;
enum
{
	AM_TIMESYNCPOLL = 0xBA,
	AM_TIMESYNCPOLLREPLY = 0xB1,
	TIMESYNCPOLL_LEN = sizeof(TimeSyncPoll),
};

