/*
 * Copyright (c) 2005 Yale University.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials provided
 *    with the distribution.
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *       This product includes software developed by the Embedded Networks
 *       and Applications Lab (ENALAB) at Yale University.
 * 4. Neither the name of the University nor that of the Laboratory
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY YALE UNIVERSITY AND CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */

/**
 * @brief Header for Camera Module
 * @author Andrew Barton-Sweeney (abs@cs.yale.edu)
 * @author Thiago Teixeira (thiago.teixeira@yale.edu)
 *
 */ 
/**
 * @brief Ported to TOS2 by Brano Kusy
 * @author Brano Kusy (branislav.kusy@gmail.com)
 */ 

#ifndef _CAMERA_H_
#define _CAMERA_H_

#define BASE_FRAME_ADDRESS	(0xa0000000)
#define MAX_PART_LEN		64
#define TOSH_DATA_LENGTH  MAX_PART_LEN+2

enum {
	AM_FRAME_PART = 1,
	AM_OV_DBG = 2,
	AM_PXA_DBG = 3,
	AM_CMD = 4	
};

typedef nx_struct frame_part{
	nx_uint16_t part_id;
	nx_uint8_t buf[MAX_PART_LEN];
} frame_part_t;

typedef nx_struct {
	nx_uint16_t part_id;
	nx_uint16_t send_next_n_parts;
} frame_part_request_t;

typedef nx_struct {
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
