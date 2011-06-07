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

/*
 * Modified by: Stefano Paniga
 * contact: stefano.paniga@mail.polimi.it
 */


// NOTE: please "includes AM;" before including this file
#ifndef _BIGMSG_H_
#define _BIGMSG_H_
#define VIDEO_HEADER_LENGTH 3
#define PHOTO_HEADER_LENGTH 2
#define BIGMSG_DATA_SHIFT 6
#define PHOTO_DATA_LENGTH 40//(1<<BIGMSG_DATA_SHIFT)
#define VIDEO_DATA_LENGTH 40//64
#define DEST 5
#define MAX_RTX 5

enum
{
	AM_RADIO_IMGSTAT=127,
	AM_RADIO_PHOTO=128,
	AM_RADIO_VIDEO=129,
	AM_RADIO_CMD=120,
	AM_RADIO_TIME_TEST=130,
	AM_RADIO_PKT_TEST=131,
	AM_TIME_TEST_MSG=113,
	AM_PHOTO=110,
	AM_IMGSTAT=5,
	AM_BIGMSG_FRAME_PART=0x6E,
  	AM_BIGMSG_FRAME_REQUEST=0x6F,
	AM_VIDEO_FRAME_PART=0x70,
};

typedef nx_struct radio_command_part{
	nx_uint8_t type;
	nx_uint8_t part_id;
} radio_command_t;

typedef nx_struct photo_frame_part{
	nx_uint16_t part_id;
	nx_uint8_t buf[PHOTO_DATA_LENGTH];
} photo_frame_part_t;

typedef nx_struct video_frame_part{
	nx_uint8_t frame_id;	
	nx_uint16_t part_id;
	nx_uint8_t buf[VIDEO_DATA_LENGTH];
} video_frame_part_t;


typedef nx_struct photo_frame_request{
	nx_uint16_t part_id;
	nx_uint16_t send_next_n_parts;
} photo_frame_request_t;

typedef nx_struct video_frame_request{
	nx_uint8_t frame_id;	
	nx_uint8_t part_id;
	nx_uint8_t send_next_n_parts;
} video_frame_request_t;

typedef nx_struct imgstat_request{
	nx_uint8_t type;
	nx_uint16_t width;
	nx_uint16_t height;
	nx_uint32_t data_size;
	nx_uint32_t timeAcq;
	nx_uint32_t timeProc;
	nx_uint32_t tmp1;
	nx_uint32_t tmp2;
	nx_uint32_t tmp3;
	nx_uint32_t tmp4;
} imgstat_request_t;

#endif //_BIGMSG_H_


