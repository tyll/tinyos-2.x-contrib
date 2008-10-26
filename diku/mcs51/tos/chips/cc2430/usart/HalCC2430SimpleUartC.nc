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
 * This is a simple UART interface. The cc2430 USART has many more
 * features that this implementation does not cover.
 *
 * The USART in the CC2430 does not and does not resemble the UART
 * peripheral generally found in 8051's.
 *
 * This implementaion is inspired by the examples provided with the
 * platform.
 *  
 * The examples can be found in 
 *   IAR EX/AppEx/cc2430/source/uart.c
 *   IAR EX/Library/cc2430/hal/include/hal.h
 *
 */
/**
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

configuration HalCC2430SimpleUartC {
  provides interface Init;
  provides interface SerialByteComm as uart0;
//  provides interface SerialByteComm as uart1;
  //  uses interface HalMcs51Led as Led1;
  // uses interface HalMcs51Led as Led3;
}
implementation {
  components HalCC2430SimpleUartP;

  HalCC2430SimpleUartP.Init = Init;
  HalCC2430SimpleUartP.uart0 = uart0;
//  HalCC2430SimpleUartP.uart1 = uart1;
  //HalCC2430SimpleUartP.Led1 = Led1;
  //HalCC2430SimpleUartP.Led3 = Led3;
}
