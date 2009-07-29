/**
 * Copyright (c) 2009 DEXMA SENSORS SL
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
 * - Neither the name of the DEXMA SENSORS SL nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * DEXMA SENSORS SL OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
 
 /*
 * Copyright (c) 2004-2006, Technische Universitaet Berlin
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Technische Universitaet Berlin nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


/**
 * @author Vlado Handziski <handzisk@tkn.tu-berlin.de>
 * @author Philipp Huppertz <huppertz@tkn.tu-berlin.de>
 * @author Xavier Orduna <xorduna@dexmatech.com>
 */

#ifndef _H_Msp430Usci_h
#define _H_Msp430Usci_h

//USCI B0 module
#define MSP430_HPLUSCIB0_RESOURCE "Msp430UsciB0.Resource"
#define MSP430_HPLUSCIA0_RESOURCE "Msp430UsciA0.Resource"
#define MSP430_HPLUSCIB1_RESOURCE "Msp430UsciB1.Resource"

#define MSP430_SPIBO_BUS "Msp430SpiB0.Resource"
#define MSP430_UARTO_BUS "Msp430UartA0.Resource"
#define MSP430_I2C1_BUS "Msp430I2C1.Resource"


typedef enum
{
  USCI_NONE = 0,
  USCI_UART = 1,
  USCI_SPI = 2,
  USCI_I2C = 3
} msp430_uscimode_t;

typedef struct {
  unsigned int ucsync: 1;   //Synchronous mode enable (0=Asynchronous; 1:Synchronous)
  unsigned int ucmode: 2;   //USCI Mode (00=UART Mode; 01=Idle-Line multiprocesor mode; 10=Addres-Bit multiprocesor Mode; 11=UART Mode with automatic baud rate detection)
  unsigned int ucspb: 1;    //Stop bit select. Number of stop bits (0=One stop bit; 1=Two stop bits)
  unsigned int uc7bit: 1;   //Charactaer lenght, (0=8-bit data; 1=7-bit data)
  unsigned int ucmsb: 1;    //MSB first select. Controls the direction of the receive and transmit shift (0=LSB first, 1=MSB first)
  unsigned int ucpar: 1;    //Parity Select (0=odd parity; 1=Even parity)
  unsigned int ucpen: 1;    //Parity enable (0=Parity disable; 1=Parity enabled)
} __attribute__ ((packed)) msp430_uctl0_t ;

typedef struct {
  unsigned int ucswrst: 1;  //Software reset enable (0=disabled; 1=enabled)
  unsigned int uctxbrk: 1;  //Transmit break. (0=next frame transmitted is not a break; 1=Next frame transmitted is a break or a break/synch)
  unsigned int uctxaddr: 1; //Transmit address. (0=next frame transmitted is data; 1=next frame transmitted is an address)
  unsigned int ucdorm: 1;   //Dormant. Puts USCI into sleep mode (0=not dormant, all received chars will set UCAxRXIFG; 1=Dormant, only some chars will set UCAxRXIFG)
  unsigned int ucbrkie: 1;  //Receive Break character interrupt-enable (0=Received chars do not set UCAxRXIFG, 1=Received chars set UCAxRXIFG)
  unsigned int ucrxeie: 1;  //Receive erroneous-character interrupt-enable (0=Erroneus chars rejected and UCAxRXIFG not set; Erroneus chars received will set UCAxRXFIG)
  unsigned int ucssel: 2;   //USCI clock source select: (00=UCKL; 01=ACLK; 10=SMCLK; 11=SMCLK
} __attribute__ ((packed)) msp430_uctl1_t ;

/* maybe we have to create typedef struct for status register */


//converts from typedefstructs to uint8_t
DEFINE_UNION_CAST(uctl02int,uint8_t,msp430_uctl0_t)
DEFINE_UNION_CAST(int2uctl0,msp430_uctl0_t,uint8_t)
DEFINE_UNION_CAST(uctl12int,uint8_t,msp430_uctl1_t)
DEFINE_UNION_CAST(int2uctl1,msp430_uctl1_t,uint8_t)

typedef struct {
  unsigned int ubr: 16;     //Clock division factor (>=0x0002)
  
  unsigned int :1;
  unsigned int mm: 1;       //Master mode (0=slave; 1=master)
  unsigned int :1;
  unsigned int listen: 1;   //Listen enable (0=disabled; 1=enabled, feed tx back to receiver)
  unsigned int clen: 1;     //Character length (0=7-bit data; 1=8-bit data)
  unsigned int: 3;
  
  unsigned int:1;
  unsigned int stc: 1;      //Slave transmit (0=4-pin SPI && STE enabled; 1=3-pin SPI && STE disabled)
  unsigned int:2;
  unsigned int ssel: 2;     //Clock source (00=external UCLK [slave]; 01=ACLK [master]; 10=SMCLK [master] 11=SMCLK [master]); 
  unsigned int ckpl: 1;     //Clock polarity (0=inactive is low && data at rising edge; 1=inverted)
  unsigned int ckph: 1;     //Clock phase (0=normal; 1=half-cycle delayed)
  unsigned int :0;
} msp430_spi_config_t;

typedef struct {
  uint16_t ubr;
  uint8_t uctl0;
  uint8_t uctl1;
} msp430_spi_registers_t;

typedef union {
  msp430_spi_config_t spiConfig;
  msp430_spi_registers_t spiRegisters;
} msp430_spi_union_config_t;

msp430_spi_union_config_t msp430_spi_default_config = { 
  {
  /*
  ucsync: 1;   //Synchronous mode enable (0=Asynchronous; 1:Synchronous)
  ucmode: 2;   //USCI Mode (00=UART Mode; 01=Idle-Line multiprocesor mode; 10=Addres-Bit multiprocesor Mode; 11=UART Mode with automatic baud rate detection)
  ucspb: 1;    //Stop bit select. Number of stop bits (0=One stop bit; 1=Two stop bits)
  uc7bit: 1;   //Charactaer lenght, (0=8-bit data; 1=7-bit data)
  nt ucmsb: 1;    //MSB first select. Controls the direction of the receive and transmit shift (0=LSB first, 1=MSB first)
  unsigned int ucpar: 1;    //Parity Select (0=odd parity; 1=Even parity)
  unsigned int ucpen: 1;    //Parity enable (0=Parity disable; 1=Parity enabled)
*/

    ubr : 0x0002, 
    ssel : 0x02, 
    clen : 0, 
    listen : 0, 
    mm : 1, 
    ckph : 1, 
    ckpl : 0, 
    stc : 1
  } 
};
    
    
    
/**
  The calculations were performed using the msp-uart.pl script:
  msp-uart.pl -- calculates the uart registers for MSP430
  
  We will assume they are the same for the msp430x2xxx  NOT!!!!!

  Copyright (C) 2002 - Pedro Zorzenon Neto - pzn dot debian dot org
 **/
typedef enum {
  UBR_32KHZ_1200=0x001B,    UMCTL_32KHZ_1200=0x20,
  UBR_32KHZ_2400=0x000D,    UMCTL_32KHZ_2400=0x60,
  UBR_32KHZ_4800=0x0006,    UMCTL_32KHZ_4800=0x70,
  UBR_32KHZ_9600=0x0003,    UMCTL_32KHZ_9600=0x30,  

  UBR_1048MHZ_9600=0x006D,   UMCTL_1048MHZ_9600=0x20,
  UBR_1048MHZ_19200=0x0036,  UMCTL_1048MHZ_19200=0x50,
  UBR_1048MHZ_38400=0x001B,  UMCTL_1048MHZ_38400=0x20,
  UBR_1048MHZ_56000=0x0012,  UMCTL_1048MHZ_56000=0x60,
  UBR_1048MHZ_115200=0x0009, UMCTL_1048MHZ_115200=0x10,
  UBR_1048MHZ_128000=0x0008, UMCTL_1048MHZ_128000=0x10,
  UBR_1048MHZ_256000=0x0004, UMCTL_1048MHZ_230400=0x10,

  UBR_1MHZ_9600=0x0068,   UMCTL_1MHZ_9600=0x10,
  UBR_1MHZ_19200=0x0034,  UMCTL_1MHZ_19200=0x00,
  UBR_1MHZ_38400=0x001A,  UMCTL_1MHZ_38400=0x00,
  UBR_1MHZ_56000=0x0011,  UMCTL_1MHZ_56000=0x70,
  UBR_1MHZ_115200=0x0008, UMCTL_1MHZ_115200=0x60,
  UBR_1MHZ_128000=0x0007, UMCTL_1MHZ_128000=0x70,
  UBR_1MHZ_256000=0x0003, UMCTL_1MHZ_230400=0x70,

  UBR_8MHZ_9600=0x0341,   UMCTL_8MHZ_9600=0x20,
  UBR_8MHZ_19200=0x01A0,  UMCTL_8MHZ_19200=0x60,
  UBR_8MHZ_38400=0x00D0,  UMCTL_8MHZ_38400=0x30,
  UBR_8MHZ_56000=0x008E,  UMCTL_8MHZ_56000=0x70,
  UBR_8MHZ_115200=0x0045, UMCTL_8MHZ_115200=0x08,
  UBR_8MHZ_128000=0x003E, UMCTL_8MHZ_128000=0x40,
  UBR_8MHZ_256000=0x001F, UMCTL_8MHZ_230400=0x20,
} msp430_uart_rate_t;

typedef struct {
  unsigned int ubr: 16;      //Baud rate (use enum msp430_uart_rate_t for predefined rates)
  
  unsigned int umctl: 8;    //Modulation (use enum msp430_uart_rate_t for predefined rates)
  
  unsigned int : 1;
  unsigned int ucmode: 2;       //Multiprocessor mode (0=idle-line protocol; 1=address-bit protocol)
  unsigned int ucspb: 1;
  unsigned int uc7bit: 1;   //Listen enable (0=disabled; 1=enabled, feed tx back to receiver)
  unsigned int : 1;
  unsigned int ucpar: 1;
  unsigned int ucpen: 1;
  
  unsigned int : 5;
  unsigned int ucrxeie: 1;
  unsigned int ucssel: 2;
  
//UCA0STAT???
  
  unsigned int utxe:1;			// 1:enable tx module
  unsigned int urxe:1;			// 1:enable rx module
} msp430_uart_config_t;

typedef struct {
  uint16_t ubr;
  uint8_t umctl;
  uint8_t uctl0;
  uint8_t uctl1;
  uint8_t ume;
} msp430_uart_registers_t;

typedef union {
  msp430_uart_config_t uartConfig;
  msp430_uart_registers_t uartRegisters;
} msp430_uart_union_config_t;


msp430_uart_union_config_t msp430_uart_default_config = { 
  {
  ubr: UBR_8MHZ_115200,
  
  umctl: UMCTL_8MHZ_115200,
  
  ucmode: 0,
  ucspb: 0,
  uc7bit: 1,
  ucpar: 0,
  ucpen: 0,
  
  ucrxeie: 1,
  ucssel: 0x02,

  } 
};





typedef struct {
  unsigned int i2cstt: 1; // I2CSTT Bit 0 START bit. (0=No action; 1=Send START condition)
  unsigned int i2cstp: 1; // I2CSTP Bit 1 STOP bit. (0=No action; 1=Send STOP condition)
  unsigned int i2cstb: 1; // I2CSTB Bit 2 Start byte. (0=No action; 1=Send START condition and start byte (01h))
  unsigned int i2cctrx: 1; //I2CTRX Bit 3 I2C transmit. (0=Receive mode; 1=Transmit mode) pin.
  unsigned int i2cssel: 2; // I2C clock source select. (00=No clock; 01=ACLK; 10=SMCLK; 11=SMCLK)
  unsigned int i2ccrm: 1;  // I2C repeat mode 
  unsigned int i2cword: 1; // I2C word mode. Selects byte(=0) or word(=1) mode for the I2C data register.
} __attribute__ ((packed)) msp430_i2ctctl_t;

DEFINE_UNION_CAST(i2ctctl2int,uint8_t,msp430_i2ctctl_t)
DEFINE_UNION_CAST(int2i2ctctl,msp430_i2ctctl_t,uint8_t)

typedef struct {
  unsigned int :1;
  unsigned int mst: 1;      //Master mode (0=slave; 1=master)
  unsigned int :1;
  unsigned int listen: 1;   //Listen enable (0=disabled; 1=enabled, feed tx back to receiver)
  unsigned int xa: 1;       //Extended addressing (0=7-bit addressing; 1=8-bit addressing)
  unsigned int :1;
  unsigned int txdmaen: 1;  //DMA to TX (0=disabled; 1=enabled)
  unsigned int rxdmaen: 1;  //RX to DMA (0=disabled; 1=enabled)
    
  unsigned int :4;
  unsigned int i2cssel: 2;  //Clock source (00=disabled; 01=ACLK; 10=SMCLK; 11=SMCLK)
  unsigned int i2crm: 1;    //Repeat mode (0=use I2CNDAT; 1=count in software)
  unsigned int i2cword: 1;  //Word mode (0=byte mode; 1=word mode)
  
  unsigned int i2cpsc: 8;   //Clock prescaler (values >0x04 not recomended)
  
  unsigned int i2csclh: 8;  //High period (high period=[value+2]*i2cpsc; can not be lower than 5*i2cpsc)
  
  unsigned int i2cscll: 8;  //Low period (low period=[value+2]*i2cpsc; can not be lower than 5*i2cpsc)
  
  unsigned int i2coa : 10;  // Own address register.
  unsigned int :6;
} msp430_i2c_config_t;
    
typedef struct {
  uint8_t uctl;
  uint8_t i2ctctl;
  uint8_t i2cpsc;
  uint8_t i2csclh;
  uint8_t i2cscll;
  uint16_t i2coa;
} msp430_i2c_registers_t;

typedef union {
  msp430_i2c_config_t i2cConfig;
  msp430_i2c_registers_t i2cRegisters;
} msp430_i2c_union_config_t;

msp430_i2c_union_config_t msp430_i2c_default_config = { 
  {
    rxdmaen : 0, 
    txdmaen : 0, 
    xa : 0, 
    listen : 0, 
    mst : 1,
    i2cword : 0, 
    i2crm : 1, 
    i2cssel : 0x2, 
    i2cpsc : 0, 
    i2csclh : 0x3, 
    i2cscll : 0x3,
    i2coa : 0,
  } 
};


#endif//_H_Msp430Usci_h
