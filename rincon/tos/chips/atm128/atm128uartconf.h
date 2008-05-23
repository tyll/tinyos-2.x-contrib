/*
 * Copyright (c) 2008 Rincon Research Corporation
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
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 * 
 * @author Mark Hays
 */
 
#ifndef __atm128uart_h__
#define __atm128uart_h__

typedef struct atm128_uart_config {
  // UBRRx
  uint16_t br;       // baud rate in hundreds of bps
  // UCSRxA
  uint8_t  u2x  : 1; // double speed mode
  // UCSRxB
  uint8_t  ucsz : 2; // char size 5678
  uint8_t  upar : 2; // parity    NEO
  uint8_t  usb  : 1; // stop bits 12
} atm128_uart_config_t;

typedef enum atm128_uart_baud {
  ATM128_UART_BAUD_300    =    3,
  ATM128_UART_BAUD_600    =    6,
  ATM128_UART_BAUD_1200   =   12,
  ATM128_UART_BAUD_2400   =   24,
  ATM128_UART_BAUD_4800   =   48,
  ATM128_UART_BAUD_9600   =   96,
  ATM128_UART_BAUD_14400  =  144,
  ATM128_UART_BAUD_19200  =  192,
  ATM128_UART_BAUD_28800  =  288,
  ATM128_UART_BAUD_38400  =  384,
  ATM128_UART_BAUD_57600  =  576,
  ATM128_UART_BAUD_76800  =  768,
  ATM128_UART_BAUD_115200 = 1152,
} atm128_uart_baud_t;

typedef enum atm128_uart_clock {
  ATM128_UART_CLOCK_NORMAL = 0,
  ATM128_UART_CLOCK_DOUBLE = 1,
} atm128_uart_clock_t;

typedef enum atm128_uart_charsize {
  ATM128_UART_CHARSIZE_5 = 0,
  ATM128_UART_CHARSIZE_6 = 1,
  ATM128_UART_CHARSIZE_7 = 2,
  ATM128_UART_CHARSIZE_8 = 3,
} atm128_uart_charsize_t;

typedef enum atm128_uart_parity {
  ATM128_UART_PARITY_NONE = 0,
  ATM128_UART_PARITY_EVEN = 2,
  ATM128_UART_PARITY_ODD  = 3,
} atm128_uart_parity_t;

typedef enum atm128_uart_stopbits {
  ATM128_UART_STOPBITS_1 = 0,
  ATM128_UART_STOPBITS_2 = 1,
} atm128_uart_stopbits_t;

#endif

