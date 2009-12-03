// $Id$

/*
 * Copyright (c) 2004-2005 Crossbow Technology, Inc.  All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 *
 * IN NO EVENT SHALL CROSSBOW TECHNOLOGY OR ANY OF ITS LICENSORS BE LIABLE TO
 * ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL
 * DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF CROSSBOW OR ITS LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
 * CROSSBOW TECHNOLOGY AND ITS LICENSORS SPECIFICALLY DISCLAIM ALL WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND NEITHER CROSSBOW NOR ANY LICENSOR HAS ANY
 * OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR
 * MODIFICATIONS.
 */

// @author Martin Turon <mturon@xbow.com>

#ifndef _H_Atm1281Uart_h
#define _H_Atm1281Uart_h

//====================== UART Bus ==================================

typedef uint8_t Atm1281_UDR0_t;  //!< USART0 I/O Data Register
typedef uint8_t Atm1281_UDR1_t;  //!< USART0 I/O Data Register

/* UART Control and Status Register A */
typedef union {
  struct Atm1281_UCSRA_t {
    uint8_t mpcm : 1;  //!< UART Multiprocessor Communication Mode
    uint8_t u2x  : 1;  //!< UART Double Transmission Speed
    uint8_t upe  : 1;  //!< UART Parity Error
    uint8_t dor  : 1;  //!< UART Data Overrun
    uint8_t fe   : 1;  //!< UART Frame Error
    uint8_t udre : 1;  //!< USART Data Register Empty
    uint8_t txc  : 1;  //!< USART Transfer Complete
    uint8_t rxc  : 1;  //!< USART Receive Complete
  } bits;
  uint8_t flat;
} Atm1281UartControlA_t;

typedef Atm1281UartControlA_t Atm1281_UCSR0A_t;  //!< UART 0
typedef Atm1281UartControlA_t Atm1281_UCSR1A_t;  //!< UART 1

/* UART Control and Status Register B */
typedef union {
  struct Atm1281_UCSRB_t {
    uint8_t txb8  : 1;  //!< UART Transmit Data Bit 8
    uint8_t rxb8  : 1;  //!< UART Receive Data Bit 8
    uint8_t ucsz2 : 1;  //!< UART Character Size (Bit 2)
    uint8_t txen  : 1;  //!< UART Transmitter Enable
    uint8_t rxen  : 1;  //!< UART Receiver Enable
    uint8_t udrie : 1;  //!< USART Data Register Enable
    uint8_t txcie : 1;  //!< UART TX Complete Interrupt Enable
    uint8_t rxcie : 1;  //!< UART RX Complete Interrupt Enable
  } bits;
  uint8_t flat;
} Atm1281UartControlB_t;

typedef Atm1281UartControlB_t Atm1281_UCSR0B_t;  //!< UART 0
typedef Atm1281UartControlB_t Atm1218_UCSR1B_t;  //!< UART 1

enum {
  ATM128_UART_MODE_NORMAL_ASYNC,
  ATM128_UART_MODE_DOUBLE_SPEED_ASYNC,
  ATM128_UART_MODE_MASTER_SYNC,
  ATM128_UART_MODE_SLAVE_SYNC,
};

enum {
  ATM128_UART_DATA_SIZE_5_BITS,
  ATM128_UART_DATA_SIZE_6_BITS,
  ATM128_UART_DATA_SIZE_7_BITS,
  ATM128_UART_DATA_SIZE_8_BITS,
};

enum {
  ATM128_UART_PARITY_NONE,
  ATM128_UART_PARITY_EVEN,
  ATM128_UART_PARITY_ODD,
};

enum {
  ATM128_UART_STOP_BITS_ONE,
  ATM128_UART_STOP_BITS_TWO,
};


/* UART Control and Status Register C */
typedef union {
  uint8_t flat;
  struct Atm1281_UCSRC_t {
    uint8_t ucpol : 1;  //!< UART Clock Polarity
    uint8_t ucsz  : 2;  //!< UART Character Size (Bits 0 and 1)
    uint8_t usbs  : 1;  //!< UART Stop Bit Select
    uint8_t upm   : 2;  //!< UART Parity Mode
    uint8_t umsel : 2;  //!< USART Mode Select
  } bits;
} Atm1281UartControlC_t;

typedef Atm1281UartControlC_t Atm1281_UCSR0C_t;  //!< UART 0
typedef Atm1281UartControlC_t Atm1281_UCSR1C_t;  //!< UART 1

typedef uint16_t Atm128UartBaudRate_t;

typedef uint16_t Atm128_UBRR0_t;  //!< UART 0 Baud Register
typedef uint16_t Atm128_UBRR1_t;  //!< UART 0 Baud Register

#endif //_H_Atm128UART_h

