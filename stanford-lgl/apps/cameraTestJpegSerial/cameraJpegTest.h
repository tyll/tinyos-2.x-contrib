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
 
#ifndef _CAMERA_H_
#define _CAMERA_H_

enum {
	AM_OV_DBG = 2,
	AM_PXA_DBG = 3,
	AM_CMD_MSG = 4,
	AM_IMG_STAT = 5
};
enum {
  IMG_COL=1,
  IMG_JPG=2,
};

typedef nx_struct img_stat{
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
} img_stat_t;

typedef nx_struct cmd_msg{
	nx_uint8_t cmd;
	nx_uint16_t val1;
	nx_uint16_t val2;
} cmd_msg_t;

typedef nx_struct {
	nx_uint32_t addr;
	nx_uint32_t reg_val;
} dbg_msg32_t;

typedef nx_struct {
	nx_uint8_t addr;
	nx_uint8_t reg_val;
} dbg_msg8_t;

#endif //_CAMERA_H_
