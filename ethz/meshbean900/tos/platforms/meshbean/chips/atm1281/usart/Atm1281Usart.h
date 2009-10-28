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
// @author Philipp Sommer <sommer@tik.ee.ethz.ch> (Atmega1281 port)


#ifndef _H_Atm1281Usart_h
#define _H_Atm1281Usart_h

#define ATM1281_HPLUSART0_RESOURCE "Atm1281Usart0.Resource"
#define ATM1281_SPIO_BUS "Atm1281Spi0.Resource"
#define ATM1281_UARTO_BUS "Atm1281Uart0.Resource"
	
#define ATM1281_HPLUSART1_RESOURCE "Atm1281Usart1.Resource"
#define ATM1281_SPI1_BUS "Atm1281Spi1.Resource"
#define ATM1281_UART1_BUS "Atm1281Uart1.Resource"


//====================== USART Bus ==================================

/* USART Status Register */
typedef union {
  struct Atm1281_UCSRA_t {
    uint8_t mpcm : 1;  //!< USART Multiprocessor Communication Mode
    uint8_t u2x  : 1;  //!< USART Double Transmission Speed 
    uint8_t upe  : 1;  //!< USART Parity Error
    uint8_t dor  : 1;  //!< USART Data Overrun
    uint8_t fe   : 1;  //!< USART Frame Error
    uint8_t udre : 1;  //!< USART Data Register Empty
    uint8_t txc  : 1;  //!< USART Transfer Complete
    uint8_t rxc  : 1;  //!< USART Receive Complete
  } bits;
  uint8_t flat;
} Atm1281UsartStatus_t;

/* USART Control Register */
typedef union {
  struct Atm1281_UCSRB_t {
    uint8_t txb8  : 1;  //!< USART Transmit Data Bit 8
    uint8_t rxb8  : 1;  //!< USART Receive Data Bit 8
    uint8_t ucsz2 : 1;  //!< USART Character Size (Bit 2)
    uint8_t txen  : 1;  //!< USART Transmitter Enable
    uint8_t rxen  : 1;  //!< USART Receiver Enable
    uint8_t udrie : 1;  //!< USART Data Register Enable
    uint8_t txcie : 1;  //!< USART TX Complete Interrupt Enable
    uint8_t rxcie : 1;  //!< USART RX Complete Interrupt Enable 
  } bits;
  uint8_t flat;
} Atm1281UsartControl_t;

enum {
  ATM1281_UART_DATA_SIZE_5_BITS = 0,
  ATM1281_UART_DATA_SIZE_6_BITS = 1,
  ATM1281_UART_DATA_SIZE_7_BITS = 2,
  ATM1281_UART_DATA_SIZE_8_BITS = 3,
};

/* USART Control Register */
typedef union {
  uint8_t flat;
  struct Atm1281_UCSRC_t {
    uint8_t ucpol : 1;  //!< USART Clock Polarity
    uint8_t ucsz  : 2;  //!< USART Character Size (Bits 0 and 1)
    uint8_t usbs  : 1;  //!< USART Stop Bit Select
    uint8_t upm   : 2;  //!< USART Parity Mode
    uint8_t umsel : 2;  //!< USART Mode Select
  } bits;
} Atm1281UsartMode_t;

/*
 * ATmega1281 USART baud register settings:
 *      ATM1281_<baudRate>_BAUD_<cpuSpeed>
 */
enum {
  ATM1281_4800_BAUD_1MHZ   = 12,
  ATM1281_9600_BAUD_1MHZ   = 6,
  ATM1281_19200_BAUD_1MHZ  = 2,
  ATM1281_38400_BAUD_1MHZ  = 1,
  ATM1281_57600_BAUD_1MHZ  = 0,

  ATM1281_4800_BAUD_1MHZ_2X   = 25,
  ATM1281_9600_BAUD_1MHZ_2X   = 12,
  ATM1281_19200_BAUD_1MHZ_2X  = 25,
  ATM1281_38400_BAUD_1MHZ_2X  = 2,
  ATM1281_57600_BAUD_1MHZ_2X  = 1,

  ATM1281_4800_BAUD_4MHZ   = 51,
  ATM1281_9600_BAUD_4MHZ   = 25,
  ATM1281_19200_BAUD_4MHZ  = 12,
  ATM1281_38400_BAUD_4MHZ  = 6,
  ATM1281_57600_BAUD_4MHZ  = 3,
  ATM1281_115200_BAUD_4MHZ = 1,

  ATM1281_4800_BAUD_4MHZ_2X   = 103,
  ATM1281_9600_BAUD_4MHZ_2X   = 51,
  ATM1281_19200_BAUD_4MHZ_2X  = 25,
  ATM1281_38400_BAUD_4MHZ_2X  = 12,
  ATM1281_57600_BAUD_4MHZ_2X  = 8,
  ATM1281_115200_BAUD_4MHZ_2X = 3,

  ATM1281_4800_BAUD_7MHZ   = 95,
  ATM1281_9600_BAUD_7MHZ   = 47,
  ATM1281_19200_BAUD_7MHZ  = 23,
  ATM1281_38400_BAUD_7MHZ  = 11,
  ATM1281_57600_BAUD_7MHZ  = 7,
  ATM1281_115200_BAUD_7MHZ = 3,

  ATM1281_4800_BAUD_7MHZ_2X   = 191,
  ATM1281_9600_BAUD_7MHZ_2X   = 95,
  ATM1281_19200_BAUD_7MHZ_2X  = 47,
  ATM1281_38400_BAUD_7MHZ_2X  = 23,
  ATM1281_57600_BAUD_7MHZ_2X  = 15,
  ATM1281_115200_BAUD_7MHZ_2X = 7,

  ATM1281_4800_BAUD_8MHZ   = 103,
  ATM1281_9600_BAUD_8MHZ   = 51,
  ATM1281_19200_BAUD_8MHZ  = 25,
  ATM1281_38400_BAUD_8MHZ  = 12,
  ATM1281_57600_BAUD_8MHZ  = 8,
  ATM1281_115200_BAUD_8MHZ = 3,

  ATM1281_4800_BAUD_8MHZ_2X   = 207,
  ATM1281_9600_BAUD_8MHZ_2X   = 103,
  ATM1281_19200_BAUD_8MHZ_2X  = 51,
  ATM1281_38400_BAUD_8MHZ_2X  = 25,
  ATM1281_57600_BAUD_8MHZ_2X  = 16,
  ATM1281_115200_BAUD_8MHZ_2X = 8,
};


typedef struct {
  uint16_t ubr : 16;	// USART baud rate
  uint8_t mpcm : 1;  	// USART Multiprocessor Communication Mode
  uint8_t u2x  : 1;  	// USART Double Transmission Speed 
  uint8_t : 1;
  uint8_t : 1;
  uint8_t : 1;
  uint8_t : 1;
  uint8_t : 1;
  uint8_t : 1;

  uint8_t txb8  : 1;  	// USART Transmit Data Bit 8
  uint8_t rxb8  : 1;  	// USART Receive Data Bit 8
  uint8_t ucsz2 : 1;  	// USART Character Size (Bit 2)
  uint8_t txen  : 1;  	// USART Transmitter Enable
  uint8_t rxen  : 1;  	// USART Receiver Enable
  uint8_t udrie : 1;  	// USART Data Register Enable
  uint8_t txcie : 1;  	// USART TX Complete Interrupt Enable
  uint8_t rxcie : 1;  	// USART RX Complete Interrupt Enable
  uint8_t ucpol : 1;  	// USART Clock Polarity
  uint8_t ucsz  : 2;  	// USART Character Size (Bits 0 and 1)
  uint8_t usbs  : 1;  	// USART Stop Bit Select
  uint8_t upm   : 2;  	// USART Parity Mode
  uint8_t umsel : 2;  	// USART Mode Select
  
} Atm1281UartConfig_t;

typedef struct {
  uint8_t UBBRL;
  uint8_t UBBRH;
  uint8_t UCSRA;
  uint8_t UCSRB;
  uint8_t UCSRC;
} Atm1281UartRegisters_t;
    
typedef union {
  Atm1281UartConfig_t uartConfig;
  Atm1281UartRegisters_t uartRegisters;
} Atm1281UartUnionConfig_t;
     
     
Atm1281UartUnionConfig_t atm1281_uart_default_config = {{
#if MHZ == 8
  #if PLATFORM_BAUDRATE == 115200L
  ubr : ATM1281_115200_BAUD_8MHZ_2X,
  #elif PLATFORM_BAUDRATE == 57600L
  ubr : ATM1281_57600_BAUD_8MHZ_2X,
  #elif PLATFORM_BAUDRATE == 38400L
  ubr : ATM1281_38400_BAUD_8MHZ_2X,
  #elif PLATFORM_BAUDRATE == 19200L
  ubr : ATM1281_19200_BAUD_8MHZ_2X,
  #endif
#elif MHZ == 4
  #if PLATFORM_BAUDRATE == 115200L
  ubr : ATM1281_115200_BAUD_4MHZ_2X,
  #elif PLATFORM_BAUDRATE == 57600L
  ubr : ATM1281_57600_BAUD_4MHZ_2X,
  #elif PLATFORM_BAUDRATE == 38400L
  ubr : ATM1281_38400_BAUD_4MHZ_2X,
  #elif PLATFORM_BAUDRATE == 19200L
  ubr : ATM1281_19200_BAUD_4MHZ_2X,
  #endif
#elif MHZ == 1
  #if PLATFORM_BAUDRATE == 57600L
  ubr : ATM1281_57600_BAUD_1MHZ_2X,
  #elif PLATFORM_BAUDRATE == 38400L
  ubr : ATM1281_38400_BAUD_1MHZ_2X,
  #elif PLATFORM_BAUDRATE == 19200L
  ubr : ATM1281_19200_BAUD_1MHZ_2X,
  #endif
#else
 #error "Unsupported settings for MHZ/PLATFORM_BAUDRATE, see Atm1281Usart.h"
#endif


  mpcm : 0,  	// ignored
  u2x  : 1,  	// USART Double Transmission Speed 
  txb8  : 0,  	// ignored
  rxb8  : 0,  	// ignored
  ucsz2 : 0,  	// 8-bit data
  txen  : 1,  	// USART Transmitter Enable
  rxen  : 1,  	// USART Receiver Enable
  udrie : 0,  	// no data register empty interrupt
  txcie : 0,  	// USART TX Complete Interrupt Enable
  rxcie : 0,  	// USART RX Complete Interrupt Enable
  ucpol : 0,  	// not used for asynchronous mode
  ucsz  : 3,  	// 8-bit data
  usbs  : 0,  	// 1 stop bit
  upm   : 0,  	// No parity
  umsel : 0,  	// Asynchronous UART
}};     
     


typedef struct {
  uint16_t ubr : 16;	// SPI baud rate
  uint8_t : 8;  
  uint8_t : 3;		// Reserved bits in SPI mode
  uint8_t txen  : 1;  	// USART Transmitter Enable
  uint8_t rxen  : 1;  	// USART Receiver Enable
  uint8_t udrie : 1;  	// USART Data Register Enable
  uint8_t txcie : 1;  	// USART TX Complete Interrupt Enable
  uint8_t rxcie : 1;  	// USART RX Complete Interrupt Enable
  uint8_t ucpol : 1;  	// SPI Clock Polarity
  uint8_t ucpha  : 1;  	// SPI Clock Phase
  uint8_t udord  : 1;  	// SPI Data Order
  uint8_t : 3;		// Reserved bits in SPI mode
  uint8_t umsel : 2;  	// USART Mode Select
  
} Atm1281SpiConfig_t;

typedef struct {
  uint8_t UBBRL;
  uint8_t UBBRH;
  uint8_t UCSRA;
  uint8_t UCSRB;
  uint8_t UCSRC;
} Atm1281SpiRegisters_t;
    
typedef union {
  Atm1281SpiConfig_t uartConfig;
  Atm1281SpiRegisters_t uartRegisters;
} Atm1281SpiUnionConfig_t;
     
     

     
Atm1281SpiUnionConfig_t atm1281_spi_default_config = {{
  ubr : 8,	// 1 MHz speed
  txen  : 1,  	// USART Transmitter Enable
  rxen  : 1,  	// USART Receiver Enable
  udrie : 0,  	// no data register empty interrupt
  txcie : 0,  	// USART TX Complete Interrupt Enable
  rxcie : 0,  	// USART RX Complete Interrupt Enable
  ucpol : 0,  	// clock polarity
  ucpha  : 0,  	// clock phase
  udord  : 0,  	// data order (0=MSB, 1=LSB)
  umsel : 3,  	// Master SPI
}};     


#endif // H_Atm1281Usart_h

