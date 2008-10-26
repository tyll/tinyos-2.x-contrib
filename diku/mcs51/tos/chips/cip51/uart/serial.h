/*
 * Copyright (c) 2008 Polaric
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
 * - Neither the name of Polaric nor the names of its contributors may
 *   be used to endorse or promote products derived from this software
 *   without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 * CONTRIBUTORS ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL POLARIC OR ITS CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * 
 * This file defines the allowed serial settings
 *
 * @author Martin Leopold <leopold@polaric.dk>
 *
 */

#ifndef _H_SERIAL_H
#define _H_SERIAL_H

/**
 * The enums are defined as multiples of 75 since Keil can't handle
 * large constant enums
 */
typedef enum {
  B75=1u,
  B150=2U,
  B300=4U,	
  B600=8U,
  B1200=16U,
  B1800=24U,
  B2400=32U,
  B4800=64U,
  B9600=128U,
  B19200=256U,
  B38400=512U,
  B57600=768U,
  B76800=1024U,
  B115200=1536U,
  B230400=3072U,
  B460800=6144U,
  B576000=7680U,
  B921600=12288U,
  B1152000=15360U,
  B3000000=40000U,
} ser_rate_t;

typedef enum {
  par_none  = 0,
  //  par_bit_1 = 1,
} ser_parity_t;

typedef enum {
/*   CS5 = 5, */
/*   CS6 = 6, */
/*   CS7 = 7, */
  CS8 = 8
} ser_data_bits_t;

typedef enum {
  stop_bit_1 = 1,
  //  stop_bit_2 = 2
} ser_stop_bits_t;

#endif //_H_SERIAL_H
