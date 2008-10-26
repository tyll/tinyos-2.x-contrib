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
 * Command Strobe Processor (CSP) instructions
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

#define _CC2430_SNOP 0xC0

// Immediate command strobes

#define _CC2430_ISSTOP      0xFF
#define _CC2430_ISSTART     0xFE
#define _CC2430_ISTXCALN    0xE1
#define _CC2430_ISRXON      0xE2
#define _CC2430_ISTXON      0xE3
#define _CC2430_ISTXONCCA   0xE4
#define _CC2430_ISRFOFF     0xE5
#define _CC2430_ISFLUSHRX   0xE6
#define _CC2430_ISFLUSHTX   0xE7
#define _CC2430_ISACK       0xE8
#define _CC2430_ISACKPEND   0xE9


// Conditions _c_ for the RPT and SKIP instructions of the CSP
#define _CCA_TRUE            0x00
#define _RECEIVING           0x01
#define _MCU_BIT_IS_1        0x02
#define _COMMAND_BUF_EMPT    0x03
#define _REGX_IS_0           0x04
#define _REGY_IS_0           0x05
#define _REGZ_IS_0           0x06
#define _NO_OP               0x07
