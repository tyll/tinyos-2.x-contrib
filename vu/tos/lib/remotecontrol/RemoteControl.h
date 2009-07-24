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
 * Author: Janos Sallai
 *
 **/
 
#if !defined(__REMOTECONTROL_H__)
#define __REMOTECONTROL_H__

enum {
  APPID_REMOTECONTROL = 0x5e,
  AM_REMOTECONTROL = 0x5e,
};

typedef nx_struct reply
{
    nx_uint16_t nodeId;
    nx_uint8_t seqNum;
    nx_uint8_t unique_delimiter[0];
    nx_uint16_t ret;
} reply_t;

typedef nx_struct RemoteControlMsg
    {
        nx_uint8_t seqNum;     // sequence number (incremeneted at the base station)
        nx_uint16_t target;    // node id of final destination, or 0xFFFF for all, or 0xFF?? or a group of nodes
        nx_uint8_t dataType;   // what kind of command is this
        nx_uint8_t appId;      // app id of final destination
        nx_uint8_t data[0];    // variable length data packet
} remotecontrol_t;


#endif /* __REMOTECONTROL_H__ */
