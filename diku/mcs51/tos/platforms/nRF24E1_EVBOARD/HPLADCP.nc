/*									tab:4
 *
 *
 * "Copyright (c) 2000-2002 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 */
/*									tab:4
 *  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.  By
 *  downloading, copying, installing or using the software you agree to
 *  this license.  If you do not agree to this license, do not download,
 *  install, copy or use the software.
 *
 *  Intel Open Source License 
 *
 *  Copyright (c) 2002 Intel Corporation 
 *  All rights reserved. 
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are
 *  met:
 * 
 *	Redistributions of source code must retain the above copyright
 *  notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *      Neither the name of the Intel Corporation nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *  
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *  PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE INTEL OR ITS
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * 
 */
/*
 *
 * Authors:		Jason Hill, David Gay, Philip Levis
 *
 * Ported to 8051 by:	Sidsel Jensen & Anders Egeskov Petersen, 
 * 			Dept of Computer Science, University of Copenhagen
 * Date last modified: Nov 2005
 *
 */

// The hardware presentation layer. See hpl.h for the C side.
// Note: there's a separate C side (hpl.h) to get access to the avr macros

// The model is that HPL is stateless. If the desired interface is as stateless
// it can be implemented here (Clock, FlashBitSPI). Otherwise you should
// create a separate component

module HPLADCP {
  provides interface HPLADC;
}
implementation
{
  /* The port mapping table */

  uint8_t TOSH_adc_portmap[TOSH_ADC_PORTMAPSIZE];

  async command result_t HPLADC.init() {
    uint8_t i;

  /* The default ADC port mapping */
    atomic { 
      for (i = 0; i < TOSH_ADC_PORTMAPSIZE; i++)
        TOSH_adc_portmap[i] = i;

      ADCCON = 0x20;			// NPD=1, ADCRUN=0, EXTREF=0
      ADCSTATIC &= 0x1E;		// CLK/32
      ADCSTATIC |= 0x02;		// 10bit
      ADCCON &= ~0x80;			// Start..
      ADCCON |= 0x80;			//         ..new conversion

      EIE |= 0x1;			// Enable ADC_EOC interrupt
    }    
    return SUCCESS;
  }

  async command result_t HPLADC.setSamplingRate(uint8_t rate) {
    return SUCCESS;
  }

  async command result_t HPLADC.bindPort(uint8_t port, uint8_t adcPort) {
    if (port < TOSH_ADC_PORTMAPSIZE) {
      TOSH_adc_portmap[port] = adcPort;
      return SUCCESS;
    } else
      return FAIL;
  }

  async command result_t HPLADC.samplePort(uint8_t port) {
    ADCCON &= 0xF0;			// Select port
    ADCCON |= TOSH_adc_portmap[port];

    ADCCON &= ~0x80;		// Start..
    ADCCON |= 0x80;		//         ..new conversion

    return SUCCESS;
  }

  async command result_t HPLADC.sampleAgain() {
    ADCCON &= ~0x80;		// Start..
    ADCCON |= 0x80;		//         ..new conversion
    return SUCCESS;
  }

  async command result_t HPLADC.sampleStop() {
    return SUCCESS;
  }

  default async event result_t HPLADC.dataReady(uint16_t done) { return SUCCESS; }
  
  TOSH_INTERRUPT(SIG_ADC) {
    uint16_t tmp;
    
    EXIF &= ~0x10;		// Clear ADC completion bit
    atomic{
      tmp = ADCDATAH;		// Read ADC data
      tmp = tmp<<8;
      tmp += ADCDATAL;
    }

    signal HPLADC.dataReady(tmp);
  }
}
