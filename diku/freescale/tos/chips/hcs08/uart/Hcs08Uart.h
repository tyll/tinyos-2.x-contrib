/* Copyright (c) 2007, Tor Petterson <motor@diku.dk>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  - Neither the name of the University of Copenhagen nor the names of its
 *    contributors may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
  @author Tor Petterson <motor@diku.dk>
*/

#ifndef _H_Hsc08Uart_h
#define _H_Hsc08Uart_h

enum {
  //The SCIxBD register is only 13 bits
  HCS08UART_BD_MAX = 8191,
  
  //SCIxC1
  HCS08UART_LOOPS = 0x80,
  HCS08UART_SCISWAI = 0x40,
  HCS08UART_RSRC = 0x20,
  HCS08UART_M = 0x10,
  HCS08UART_WAKE = 0x8,
  HCS08UART_ILT = 0x4,
  HCS08UART_PE = 0x2,
  HCS08UART_PT = 0x1,
  
  //SCIxC2
  HCS08UART_TIE = 0x80,
  HCS08UART_TCIE = 0x40,
  HCS08UART_RIE = 0x20,
  HCS08UART_ILIE = 0x10,
  HCS08UART_TE = 0x8,
  HCS08UART_RE = 0x4,
  HCS08UART_RWU = 0x2,
  HCS08UART_SBK = 0x1,
  
  //SCIxC3
  HCS08UART_R8 = 0x80,
  HCS08UART_T8 = 0x40,
  HCS08UART_TXDIR = 0x20,
  HCS08UART_ORIE = 0x8,
  HCS08UART_NEIE = 0x4,
  HCS08UART_FEIE = 0x2,
  HCS08UART_PEIE = 0x1,
  
  //SCIxS1
  HCS08UART_TDRE = 0x80,
  HCS08UART_TC = 0x40,
  HCS08UART_RDRF = 0x20,
  HCS08UART_IDLE = 0x10,
  HCS08UART_OR = 0x8,
  HCS08UART_NF = 0x4,
  HCS08UART_FE = 0x2,
  HCS08UART_PF = 0x1,
  
  //SCIxS2
  HCS08UART_RAF = 0x1,
  
};
#endif//_H_Hsc08Uart_h