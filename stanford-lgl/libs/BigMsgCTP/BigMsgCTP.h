/*
* Copyright (c) 2006 Stanford University.
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
* - Neither the name of the Stanford University nor the names of
*   its contributors may be used to endorse or promote products derived
*   from this software without specific prior written permission
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
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */

#ifndef _BIGMSG_H_
#define _BIGMSG_H_

#define BIGMSG_HEADER_LENGTH 4
#define BIGMSG_DATA_SHIFT 6
#define BIGMSG_DATA_LENGTH (1<<BIGMSG_DATA_SHIFT)
#if TOSH_DATA_LENGTH < (BIGMSG_HEADER_LENGTH+BIGMSG_DATA_LENGTH)
  !!!! error -- please set TOSH_DATA_LENGTH large enough in your app/Makefile
#endif

enum
{
  AM_CTP_BIGMSG_FRAME_PART=0x5E
};

typedef nx_struct bigmsg_frame_part{
    nx_uint16_t part_id;
    nx_uint16_t node_id;
    nx_uint8_t buf[BIGMSG_DATA_LENGTH];
} bigmsg_frame_part_t;

typedef nx_struct bigmsg_frame_request{
    nx_uint16_t part_id;
    nx_uint16_t node_id;
    nx_uint16_t send_next_n_parts;
} bigmsg_frame_request_t;
#endif //_BIGMSG_H_


