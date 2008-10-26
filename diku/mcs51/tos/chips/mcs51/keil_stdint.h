/*
 * Copyright (c) 2007 University of Copenhagen
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
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/**
 *
 * The sizes are slightly diffrent in Keil than avr-gcc
 *
 * See "Data Storage Formats"
 *   http://www.keil.com/support/man/docs/c51/c51_ap_datastorage.htm
 *
 * @author Martin Leopold <leopold@diku.dk>
 *
 */

#ifndef _KEIL_STDINT_H
#define _KEIL_STDINT_H	1

/* Signed.  */

typedef signed char		int8_t;
typedef short		        int16_t;

// In Keil both are 16 bit, but not to Nesc!
//typedef int 		        int16_t;
typedef long			int32_t;

/* This will be removed later Keil does not support 64 bit types */
typedef long long int		int64_t;


/* Unsigned.  */

typedef unsigned char		uint8_t;
typedef unsigned short	        uint16_t; 

// In Keil in is 16 bit
//typedef unsigned int	        uint16_t;
typedef unsigned long		uint32_t;

/* This will be removed later Keil does not support 64 bit types*/
typedef unsigned long long int	uint64_t;

#endif //_KEIL_STDINT_H	1

