
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
 * @author Martin Leopold <leopold@polaric.dk>
 */

#ifndef _H_cip51usb_H
#define _H_cip51usb_H

/* Constants for USB registers */

enum {
  CIP51_USBADR_FADDR	 = 0,
  CIP51_USBADR_POWER	 = 0x01,
  CIP51_USBADR_IN1INT	 = 0x02,
  CIP51_USBADR_OUT1INT	 = 0x04,
  CIP51_USBADR_CMINT	 = 0x06,
  CIP51_USBADR_IN1IE	 = 0x07,
  CIP51_USBADR_OUT1IE	 = 0x09,
  CIP51_USBADR_CMIE	 = 0x0B,
  CIP51_USBADR_FRAMEL	 = 0x0C,
  CIP51_USBADR_FRAMEH	 = 0x0D,
  CIP51_USBADR_INDEX	 = 0x0E,
  CIP51_USBADR_CLKREC	 = 0x0F,
  CIP51_USBADR_INMAX     = 0x10, // Undocumented, may or may not be valid
  CIP51_USBADR_E0CSR	 = 0x11,
  CIP51_USBADR_EINCSRL	 = 0x11,
  CIP51_USBADR_EINCSRH	 = 0x12,
  CIP51_USBADR_OUTMAX    = 0x13, // Undocumented, may or may not be valid
  CIP51_USBADR_EOUTCSRL  = 0x14,
  CIP51_USBADR_EOUTCSRH  = 0x15,
  CIP51_USBADR_E0CNT     = 0x16,
  CIP51_USBADR_EOUTCNTL  = 0x16,
  CIP51_USBADR_EOUTCNTH  = 0x17,
  CIP51_USBADR_FIFO_EP0  = 0x20,
  CIP51_USBADR_FIFO_EP1  = 0x21,
  CIP51_USBADR_FIFO_EP2  = 0x22,
  CIP51_USBADR_FIFO_EP3  = 0x23
};


/* Interrupt sources */

enum {
  CIP51_CMINT_SOF      = 0x3,
  CIP51_CMINT_RSTINT   = 0x2,
  CIP51_CMINT_RSUINT   = 0x1,
  CIP51_CMINT_SUSINT   = 0x0
};

enum {
  CIP51_IN1INT_IN3   = 0x3,
  CIP51_IN1INT_IN2   = 0x2,
  CIP51_IN1INT_IN1   = 0x1,
  CIP51_IN1INT_EP0   = 0x0
};

enum {
  CIP51_OUT1INT_MASK  = 0xE,
  CIP51_OUT1INT_OUT3  = 0x3,
  CIP51_OUT1INT_OUT2  = 0x2,
  CIP51_OUT1INT_OUT1  = 0x1
};

/* Other register constants */

enum {
  CIP51_E0CSR_SSUEND  = 7,
  CIP51_E0CSR_SOPRDY  = 6,
  CIP51_E0CSR_SDSTL   = 5,
  CIP51_E0CSR_SUEND   = 4,
  CIP51_E0CSR_DATAEND = 3,
  CIP51_E0CSR_STSTL   = 2,
  CIP51_E0CSR_INPRDY  = 1,
  CIP51_E0CSR_OPRDY   = 0
};

enum {
  CIP51_EINCSRL_CLRDT  = 6,
  CIP51_EINCSRL_STSTL  = 5,
  CIP51_EINCSRL_SDSTL  = 4,
  CIP51_EINCSRL_FLUSH  = 3,
  CIP51_EINCSRL_UNDRUN = 2,
  CIP51_EINCSRL_FIFONE = 1,
  CIP51_EINCSRL_INPRDY = 0,
};

enum {
  CIP51_EINCSRH_DBIEN  = 7,
  CIP51_EINCSRH_ISO    = 6,
  CIP51_EINCSRH_DIRSEL = 5,
  CIP51_EINCSRH_FCDT   = 3,
  CIP51_EINCSRH_SPLIT  = 2
};

enum {
  CIP51_EOUTCSRL_CLRDT	= 7,
  CIP51_EOUTCSRL_STSTL	= 6,
  CIP51_EOUTCSRL_SDSTL	= 5,
  CIP51_EOUTCSRL_FLUSH	= 4,
  CIP51_EOUTCSRL_DATERR	= 3,
  CIP51_EOUTCSRL_OVRUN	= 2,
  CIP51_EOUTCSRL_FIFOFUL= 1,
  CIP51_EOUTCSRL_OPRDY	= 0
};

enum{
  CIP51_EOUTCSRH_DBOEN = 0x7,
  CIP51_EOUTCSRH_ISO   = 0x6
};

//------------------,-----------------------------------------------------------
// Register Read/Write Macros (borrowed from SiLabs)
//-----------------------------------------------------------------------------

// These first two macros do not poll for busy, and can be used to increase
// program speed where necessary, but should never be used for successive
// reads or writes.

#define CIP51_USBREAD_BYTE(addr, target) {                      \
    USB0ADR = (0x80 | addr);                                    \
    while(USB0ADR & 0x80);                                      \
    target = USB0DAT; }

#define CIP51_USBWRITE_BYTE(addr, data) {                        \
    USB0ADR = (addr);                                   \
    USB0DAT = data; }

// These two macros are polling versions of the above macros, and can be
// used for successive reads writes without taking the chance that the
// Interface Engine is busy from the last register access.

#define CIP51_USBPOLL_READ_BYTE(addr, target)	{       \
    while(USB0ADR & 0x80);                              \
    CIP51_USBREAD_BYTE(addr, target); }

#define CIP51_USBPOLL_WRITE_BYTE(addr, dt) 		{       \
    while(USB0ADR & 0x80);                                      \
    CIP51_USBWRITE_BYTE(addr, dt);    }

typedef struct {
  uint8_t endpoint;
  uint8_t *start;
  uint16_t len;
} in_queue_item_t;

typedef struct {
  uint8_t *start;
  uint8_t *p;
  uint16_t len;
  bool more;
  bool wait_done;
  bool done;
} in_item_t;

#endif //_H_cip51usb_H
