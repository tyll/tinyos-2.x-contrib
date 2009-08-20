/*
 * Copyright (c) 2005-2006 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
 
/**
 * @author Jonathan Hui
 * @author David Moss
 */

#ifndef FCF_H
#define FCF_H

/**
 * FCF 2006
 * bits: 0-1	2		3			4				5			6					7			8-9			10-11					12-13			14-15
 * Frame Type	sFCF=0	Security	Frame Pending	ACK request	PANId Compression	Reserved	Reserved	Dest. Addressing Mode	Frame Version	Source Addressing Mode
 */
 
/** 
 * sFCF
 * bits: 0-1	2		3			4				5			6			7
 * Frame Type	sFCF=1	Security	Frame Pending	ACK request	Reserved	Reserved
 */
 

typedef struct fcf_t {
  uint8_t frameType : 2;
  bool sFcf : 1;
  bool security : 1;
  bool framePending : 1;
  bool ackRequest : 1;
  bool panIdCompression : 1;
  bool reserved0 : 1;
  uint8_t reserved1 : 2;
  uint8_t destAddressMode : 2;
  uint8_t frameVersion : 2;
  uint8_t srcAddressMode : 2;
} fcf_t;

typedef struct sfcf_t {
  uint8_t frameType : 2;
  bool sFcf : 1;
  bool security : 1;
  bool framePending : 1;
  bool ackRequest : 1;
  bool reserved : 1;
  bool frameVersion : 1;
} sfcf_t;

/**
 * This defines the bit-fields of our CCxx00 FCF byte
 */
enum fcf_enums {
  FCF_FRAME_TYPE = 0,
  FCF_SECURITY_ENABLED = 2,
  FCF_FRAME_PENDING = 3,
  FCF_ACK_REQ = 4,
};

enum frame_type_enums {
  FRAME_TYPE_DATA = 0,
  FRAME_TYPE_ACK = 1,
};

enum iee154_fcf_addr_mode_enums {
  IEEE154_ADDR_NONE = 0,
  IEEE154_ADDR_SHORT = 2,
  IEEE154_ADDR_EXT = 3,
};

#endif
