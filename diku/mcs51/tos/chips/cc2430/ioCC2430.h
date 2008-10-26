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
 *
 * Provide cc2430 specific register maps
 *
 * Absolute addressing in Keil is possible in a number of ways:
 *   Standard C
 *     (uint8_t xdata*) addr
 *   Using sfr types/storrage class specifiers
 *     sfr x = addr
 *   Using the at modifier
 *     uint8_t x at addr
 *
 * Regarding multibyte values, it seems that ChipCon has chosen the
 * follwing semantics that handles latching one or more bytes when
 * reading and writing:
 *
 *  When reading: the _low_ byte must be read first and the high-byte
 *  is latched for glitch free 16-bit operations
 *
 *  When writing: the low byte must be written first and the value
 *  does not take effect before the high byte is written
 *
 *
 * @author Martin Leopold <leopold@diku.dk>
 */

#ifndef _H_ioCC2430_H
#define _H_ioCC2430_H

// Get sfr/sbit dummy definitions
# include <io8051.h>

/*
 * Bit locations for IEN0
 */

enum {
  CC2430_IEN0_EA       = 0x7,
  CC2430_IEN0_STIE     = 0x5,
  CC2430_IEN0_ENCIE    = 0x4,
  CC2430_IEN0_URX1IE   = 0x3,
  CC2430_IEN0_URX0IE   = 0x2,
  CC2430_IEN0_ADCIE    = 0x1,
  CC2430_IEN0_RFERRIE  = 0x0
};

/*
 * Bit locations for IEN2
 */

enum {
  CC2430_IEN2_WDTIE  = 0x5,
  CC2430_IEN2_P1IE   = 0x4,
  CC2430_IEN2_UTX1IE = 0x3,
  CC2430_IEN2_UTX0IE = 0x2,
  CC2430_IEN2_P2IE   = 0x1,
  CC2430_IEN2_RFIE   = 0x0
};

/*
 * Bit locations for IRCON
 */

enum {
  CC2430_IRCON_STIF   = 0x7,
  CC2430_IRCON_P0IF   = 0x5,
  CC2430_IRCON_T4IF   = 0x4,
  CC2430_IRCON_T3IF   = 0x3,
  CC2430_IRCON_T2IF   = 0x2,
  CC2430_IRCON_T1IF   = 0x1,
  CC2430_IRCON_DMAIF  = 0x0
};

/*
 * Bit locations for IRCON2
 */

enum {
  CC2430_IRCON2_WDTIF  = 0x4,
  CC2430_IRCON2_P1IF   = 0x3,
  CC2430_IRCON2_UTX1IF = 0x2,
  CC2430_IRCON2_UTX0IF = 0x1,
  CC2430_IRCON2_P2IF   = 0x0
};

/*
 * Bit locations for RFIM
 */

enum {
  CC2430_RFIM_RREG_PD  = 0x7,
  CC2430_RFIM_TXDONE   = 0x6,
  CC2430_RFIM_FIFOP    = 0x5,
  CC2430_RFIM_SFD      = 0x4,
  CC2430_RFIM_CCA      = 0x3,
  CC2430_RFIM_CSP_WT   = 0x2,
  CC2430_RFIM_CSP_STOP = 0x1,
  CC2430_RFIM_CSP_INT  = 0x0
};

/*
 * Bit locations for RFIF
 */

enum {
  CC2430_RFIF_RREG_ON  = 0x7,
  CC2430_RFIF_TXDONE   = 0x6,
  CC2430_RFIF_FIFOP    = 0x5,
  CC2430_RFIF_SFD      = 0x4,
  CC2430_RFIF_CCA      = 0x3,
  CC2430_RFIF_CSP_WT   = 0x2,
  CC2430_RFIF_CSP_STOP = 0x1,
  CC2430_RFIF_CSP_INT  = 0x0
};


// Interrupt definitions

#define  SIG_RFERR   __vector_0   /*  RF TX FIFO Underflow and RX FIFO Overflow   */
#define  SIG_ADC     __vector_1   /*  ADC End of Conversion                       */
#define  SIG_URX0    __vector_2   /*  USART0 RX Complete                          */
#define  SIG_URX1    __vector_3   /*  USART1 RX Complete                          */
#define  SIG_ENC     __vector_4   /*  AES Encryption/Decryption Complete          */
#define  SIG_ST      __vector_5   /*  Sleep Timer Compare                         */
#define  SIG_P2INT   __vector_6   /*  Port 2 Inputs                               */
#define  SIG_UTX0    __vector_7   /*  USART0 TX Complete                          */
#define  SIG_DMA     __vector_8   /*  DMA Transfer Complete                       */
#define  SIG_T1      __vector_9   /*  Timer 1 (16-bit) Capture/Compare/Overflow   */
#define  SIG_T2      __vector_10  /*  Timer 2 (MAC Timer)                         */
#define  SIG_T3      __vector_11  /*  Timer 3 (8-bit) Capture/Compare/Overflow    */
#define  SIG_T4      __vector_12  /*  Timer 4 (8-bit) Capture/Compare/Overflow    */
#define  SIG_P0INT   __vector_13  /*  Port 0 Inputs                               */
#define  SIG_UTX1    __vector_14  /*  USART1 TX Complete                          */
#define  SIG_P1INT   __vector_15  /*  Port 1 Inputs                               */
#define  SIG_RF      __vector_16  /*  RF General Interrupts                       */
#define  SIG_WDT     __vector_17  /*  Watchdog Overflow in Timer Mode             */

uint8_t volatile U0CSR __attribute((sfrAT0x86)); /*  USART 0 Control and Status                      */

//uint8_t volatile TCON      __attribute((sfrAT0x88));
uint8_t volatile P0IFG     __attribute((sfrAT0x89));   /*  Port 0 Interrupt Status Flag         */
uint8_t volatile P1IFG     __attribute((sfrAT0x8A));   /*  Port 1 Interrupt Status Flag         */
uint8_t volatile P2IFG     __attribute((sfrAT0x8B));   /*  Port 2 Interrupt Status Flag         */
uint8_t volatile PICTL     __attribute((sfrAT0x8C));   /*  Port Interrupt Control               */
uint8_t volatile P1IEN     __attribute((sfrAT0x8D));   /*  Port 1 Interrupt Mask                */
uint8_t volatile P0INP     __attribute((sfrAT0x8F));   /*  Port 0 Input Mode                    */

/* TCON sbit definitions */
uint8_t volatile URX1IF    __attribute((sbitAT0x8F));   /*  USART1 RX Interrupt Flag          */
uint8_t volatile _TCON6    __attribute((sbitAT0x8E));   /*  not used                          */
uint8_t volatile ADCIF     __attribute((sbitAT0x8D));   /*  ADC Interrupt Flag                */
uint8_t volatile _TCON5    __attribute((sbitAT0x8C));   /*  not used                          */
uint8_t volatile URX0IF    __attribute((sbitAT0x8B));   /*  USART0 RX Interrupt Flag          */
uint8_t volatile IT1       __attribute((sbitAT0x8A));   /*  reserved (must always be set to 1)*/
uint8_t volatile RFERRIF   __attribute((sbitAT0x89));   /*  RF TX/RX FIFO Interrupt Flag      */
uint8_t volatile IT0       __attribute((sbitAT0x88));   /*  reserved (must always be set to 1)*/

/* Port 1 */
// io8051.h uint8_t volatile  P1        __attribute((sfrAT0x90));
uint8_t volatile  RFIM      __attribute((sfrAT0x91));   /*  RF Interrupt Mask                  */
uint8_t volatile  DPS       __attribute((sfrAT0x92));   /*  Data Pointer Select                */
uint8_t volatile  MPAGE     __attribute((sfrAT0x93));   /*  Memory Page Select                 */
uint8_t volatile  T2CMP     __attribute((sfrAT0x94));   /*  Timer 2 Compare Value              */
uint8_t volatile  ST0       __attribute((sfrAT0x95));   /*  Sleep Timer 0                      */
uint8_t volatile  ST1       __attribute((sfrAT0x96));   /*  Sleep Timer 1                      */
uint8_t volatile  ST2       __attribute((sfrAT0x97));   /*  Sleep Timer 2                      */

/* Interrupt Enable 2 - IEN2 sfr */

uint8_t volatile IEN2       __attribute((sfrAT0x9A));   /*  Interrupt Enable 2           */
uint8_t volatile S1CON      __attribute((sfrAT0x9B));   /*  Interrupt Flags 3            */
uint8_t volatile T2PEROF0   __attribute((sfrAT0x9C));   /*  Timer 2 Overflow Count 0     */
uint8_t volatile T2PEROF1   __attribute((sfrAT0x9D));   /*  Timer 2 Overflow Count 1     */
uint8_t volatile T2PEROF2   __attribute((sfrAT0x9E));   /*  Timer 2 Overflow Count 2     */

uint8_t volatile  T2OF0     __attribute((sfrAT0xA1));   /*  Timer 2 Overflow Count 0     */
uint8_t volatile  T2OF1     __attribute((sfrAT0xA2));   /*  Timer 2 Overflow Count 1     */
uint8_t volatile  T2OF2     __attribute((sfrAT0xA3));   /*  Timer 2 Overflow Count 2     */
uint8_t volatile  T2CAPLPL  __attribute((sfrAT0xA4));   /*  Timer 2 Period Low Byte      */
uint8_t volatile  T2CAPHPH  __attribute((sfrAT0xA5));   /*  Timer 2 Period High Byte     */
uint8_t volatile  T2TLD     __attribute((sfrAT0xA6));   /*  Timer 2 Timer Value Low Byte */
uint8_t volatile  T2THD     __attribute((sfrAT0xA7));   /*  Timer 2 Timer Value High Byte*/

/*  Interrupt Enable 0  */

uint8_t volatile  IEN0    __attribute((sbitAT0xA8)); /* Also known as IE */
uint8_t volatile RFERRIE __attribute((sbitAT0xA8)); /*  RF TX/RX FIFO Interrupt Enable */
uint8_t volatile ADCIE   __attribute((sbitAT0xA9)); /*  ADC Interrupt Enable           */
uint8_t volatile URX0IE  __attribute((sbitAT0xAA)); /*  USART0 RX Interrupt Enable     */
uint8_t volatile URX1IE  __attribute((sbitAT0xAB)); /*  USART1 RX Interrupt Enable     */
uint8_t volatile ENCIE   __attribute((sbitAT0xAC)); /*  AES Interrupt Enable           */
uint8_t volatile STIE    __attribute((sbitAT0xAD)); /*  Sleep Timer Interrupt Enable   */

uint8_t volatile FWT	__attribute((sfrAT0xAB));
uint8_t volatile FADDRL	__attribute((sfrAT0xAC));
uint8_t volatile FADDRH	__attribute((sfrAT0xAD));
uint8_t volatile FCTL	__attribute((sfrAT0xAE));
uint8_t volatile FWDATA	__attribute((sfrAT0xAF));

/*  Interrupt Enable 1  */

uint8_t volatile IEN1    __attribute((sfrAT0xB8)); /* CC2430 specific interrupt mask  */

uint8_t volatile _IEN17 __attribute((sbitAT0xBF));  /*  not used                   */
uint8_t volatile _IEN16 __attribute((sbitAT0xBE));  /*  not used                   */
uint8_t volatile P0IE   __attribute((sbitAT0xBD));  /*  Port 0 Interrupt Enable    */
uint8_t volatile T4IE   __attribute((sbitAT0xBC));  /*  Timer 4 Interrupt Enable   */
uint8_t volatile T3IE   __attribute((sbitAT0xBB));  /*  Timer 3 Interrupt Enable   */
uint8_t volatile T2IE   __attribute((sbitAT0xBA));  /*  Timer 2 Interrupt Enable   */
uint8_t volatile T1IE   __attribute((sbitAT0xB9));  /*  Timer 1 Interrupt Enable   */
uint8_t volatile DMAIE  __attribute((sbitAT0xB8));  /*  DMA Interrupt Enable       */

uint8_t volatile ENCDI   __attribute((sfrAT0xB1)); /*  Encryption Input Data          */
uint8_t volatile ENCDO   __attribute((sfrAT0xB2)); /*  Encryption Output Data         */
uint8_t volatile ENCCS   __attribute((sfrAT0xB3)); /*  Encryption Control and Status  */
uint8_t volatile ADCCON1 __attribute((sfrAT0xB4)); /*  ADC Control 1                  */
uint8_t volatile ADCCON2 __attribute((sfrAT0xB5)); /*  ADC Control 2                  */
uint8_t volatile ADCCON3 __attribute((sfrAT0xB6)); /*  ADC Control 3                  */
uint8_t volatile IEN1    __attribute((sfrAT0xB8)); /*  Defined in io8051.h            */

uint8_t volatile IP1    __attribute((sfrAT0xB9));  /*  Interrupt Priority 1           */
uint8_t volatile ADCL   __attribute((sfrAT0xBA));  /*  ADC Data Low                   */
uint8_t volatile ADCH   __attribute((sfrAT0xBB));  /*  ADC Data High                  */
uint8_t volatile RNDL   __attribute((sfrAT0xBC));  /*  Random Register Low Byte       */
uint8_t volatile RNDH   __attribute((sfrAT0xBD));  /*  Random Register High Byte      */
uint8_t volatile SLEEP  __attribute((sfrAT0xBE));  /*  Sleep Mode Control             */
uint8_t volatile _SFRBF __attribute((sfrAT0xBF));  /*  not used                       */

norace uint8_t volatile U0BUF  __attribute((sfrAT0xC1)); /*  USART 0 Rx/Tx Data Buffer        */
uint8_t volatile U0BAUD __attribute((sfrAT0xC2)); /*  USART 0 Baud Rate Control               */
uint8_t volatile T2CNF  __attribute((sfrAT0xC3)); /*  Timer 2 Configuration                   */
uint8_t volatile U0UCR  __attribute((sfrAT0xC4)); /*  USART 0 UART Control                    */
uint8_t volatile U0GCR  __attribute((sfrAT0xC5)); /*  USART 0 Generic Control                 */
uint8_t volatile CLKCON __attribute((sfrAT0xC6)); /*  Clock Control                           */
uint8_t volatile MEMCTR __attribute((sfrAT0xC7)); /*  Memory Arbiter Control                  */

uint8_t volatile T2CON   __attribute((sfrAT0xC8));   /*  Interrupt Control                    */
uint8_t volatile WDCTL   __attribute((sfrAT0xC9));   /*  Watchdog Timer Control               */
uint8_t volatile T3CNT   __attribute((sfrAT0xCA));   /*  Timer 3 Counter                      */
uint8_t volatile T3CTL   __attribute((sfrAT0xCB));   /*  Timer 3 Control                      */
uint8_t volatile T3CCTL0 __attribute((sfrAT0xCC));   /*  Timer 3 Ch 0 Capture/Compare Control */
uint8_t volatile T3CC0   __attribute((sfrAT0xCD));   /*  Timer 3 Ch 0 Capture/Compare Value   */
uint8_t volatile T3CCTL1 __attribute((sfrAT0xCE));   /*  Timer 3 Ch 1 Capture/Compare Control */
uint8_t volatile T3CC1   __attribute((sfrAT0xCF));   /*  Timer 3 Ch 1 Capture/Compare Value   */

/*  Timers 1/3/4 Interrupt Mask/Flag                   */

uint8_t volatile TIMIF __attribute((sfrAT0xD8));

uint8_t volatile _TIMIF7 __attribute((sbitAT0xDF));  /*  not used                         */
uint8_t volatile OVFIM   __attribute((sbitAT0xDE));  /*  Timer 1 Overflow Interrupt Mask  */
uint8_t volatile T4CH1IF __attribute((sbitAT0xDD));  /*  Timer 4 Channel 1 Interrupt Flag */
uint8_t volatile T4CH0IF __attribute((sbitAT0xDC));  /*  Timer 4 Channel 0 Interrupt Flag */
uint8_t volatile T4OVFIF __attribute((sbitAT0xDB));  /*  Timer 4 Overflow Interrupt Flag  */
uint8_t volatile T3CH1IF __attribute((sbitAT0xDA));  /*  Timer 3 Channel 1 Interrupt Flag */
uint8_t volatile T3CH0IF __attribute((sbitAT0xD9));  /*  Timer 3 Channel 0 Interrupt Flag */
uint8_t volatile T3OVFIF __attribute((sbitAT0xD8));  /*  Timer 3 Overflow Interrupt Flag  */

uint8_t  volatile RFD    __attribute((sfrAT0xD9));  /*  RF Data                                */
uint16_t volatile T1CC0  __attribute((sfr16AT0xDA));/* Timer 1 Ch 0 Capture/Compare Value      */
uint8_t  volatile T1CC0L __attribute((sfrAT0xDA));  /* Timer 1 Ch 0 Capture/Compare Value Low  */
uint8_t  volatile T1CC0H __attribute((sfrAT0xDB));  /* Timer 1 Ch 0 Capture/Compare Value High */
uint16_t volatile T1CC1  __attribute((afr16AT0xDC));/* Timer 1 Ch 1 Capture/Compare Value      */
uint8_t  volatile T1CC1L __attribute((sfrAT0xDC));  /* Timer 1 Ch 1 Capture/Compare Value Low  */
uint8_t  volatile T1CC1H __attribute((sfrAT0xDD));  /* Timer 1 Ch 1 Capture/Compare Value High */
uint16_t volatile T1CC2  __attribute((sfr16AT0xDE));/* Timer 1 Ch 2 Capture/Compare Value      */
uint8_t  volatile T1CC2L __attribute((sfrAT0xDE));  /* Timer 1 Ch 2 Capture/Compare Value Low  */
uint8_t  volatile T1CC2H __attribute((sfrAT0xDF));  /* Timer 1 Ch 2 Capture/Compare Value High */
uint8_t  volatile DMAREQ __attribute((sfrAT0xD7));  /* DMA Channel Start Request and Status    */
uint8_t  volatile DMAARM __attribute((sfrAT0xD6));  /* DMA Channel Arm                         */
uint8_t  volatile DMA0CFGH __attribute((sfrAT0xD5));/* DMA Ch 0 Configuration Address High     */
uint8_t  volatile DMA0CFGL __attribute((sfrAT0xD4));/* DMA Ch 0 Configuration Address Low Byte */
uint8_t  volatile DMA1CFGH __attribute((sfrAT0xD3));/* DMA Ch 1-4 Configuration Address High   */
uint8_t  volatile DMA1CFGL __attribute((sfrAT0xD2));/* DMA Ch 1-4 Configuration Address Low    */
uint8_t  volatile DMAIRQ   __attribute((sfrAT0xD1));/* DMA Interrupt Flag                      */

uint8_t  volatile ACC     __attribute((sfrAT0xE0)); /* Accumulator                            */
uint8_t  volatile RFST    __attribute((sfrAT0xE1)); /* RF CSMA-CA / Strobe Processor          */
uint16_t volatile T1CNT   __attribute((sfr16xE2));  /* Timer 1 Counter                        */
uint8_t  volatile T1CNTL  __attribute((sfrAT0xE2)); /* Timer 1 Counter Low                    */
uint8_t  volatile T1CNTH  __attribute((sfrAT0xE3)); /* Timer 1 Counter High                   */
uint8_t  volatile T1CTL   __attribute((sfrAT0xE4)); /* Timer 1 Control and Status             */
uint8_t  volatile T1CCTL0 __attribute((sfrAT0xE5)); /* Timer 1 Ch 0 Capture/Compare Control   */
uint8_t  volatile T1CCTL1 __attribute((sfrAT0xE6)); /* Timer 1 Ch 1 Capture/Compare Control   */
uint8_t  volatile T1CCTL2 __attribute((sfrAT0xE7)); /* Timer 1 Ch 2 Capture/Compare Control   */

/* Bit register definitions for interrupt mask IRCON1 */
uint8_t volatile STIF	   __attribute((sbitAT0xC7));  /* Sleep Timer                   */
uint8_t volatile _IRCON16  __attribute((sbitAT0xC6));  /*  not used                     */
uint8_t volatile P0IF      __attribute((sbitAT0xC5));  /*  Port 0 Interrupt Flag        */
uint8_t volatile T4IF      __attribute((sbitAT0xC4));  /*  Timer 4 Interrupt Flag       */
uint8_t volatile T3IF      __attribute((sbitAT0xC3));  /*  Timer 3 Interrupt Flag       */
uint8_t volatile T2IF	   __attribute((sbitAT0xC2));  /*  Timer 2 Interrupt Flag       */
uint8_t volatile T1IF	   __attribute((sbitAT0xC1));  /*  Timer 1 Interrupt Flag       */
uint8_t volatile DMAIF     __attribute((sbitAT0xC0));  /*  DMA Complete Interrupt Flag  */

/* Bit register definitions for interrupt mask IRCON2 */
uint8_t volatile _IRCON27 __attribute((sbitAT0xEF));  /*  not used                      */
uint8_t volatile _IRCON26 __attribute((sbitAT0xEE));  /*  not used                      */
uint8_t volatile _IRCON25 __attribute((sbitAT0xED));  /*  not used                      */
uint8_t volatile WDTIF    __attribute((sbitAT0xEC));  /*  Watchdog Timer Interrupt Flag */
uint8_t volatile P1IF     __attribute((sbitAT0xEB));  /*  Port 1 Interrupt Flag         */
uint8_t volatile UTX1IF   __attribute((sbitAT0xEA));  /*  USART1 TX Interrupt Flag      */
uint8_t volatile UTX0IF   __attribute((sbitAT0xE9));  /*  USART0 TX Interrupt Flag      */
uint8_t volatile P2IF     __attribute((sbitAT0xE8));  /*  Port 2 Interrupt Flag         */

uint8_t volatile  IRCON2   __attribute((sfrAT0xE8)); /*  Interrupt Flags 5 */
uint8_t volatile  RFIF     __attribute((sfrAT0xE9)); /*  RF Interrupt Flags                   */
uint8_t volatile  T4CNT    __attribute((sfrAT0xEA)); /*  Timer 4 Counter                      */
uint8_t volatile  T4CTL    __attribute((sfrAT0xEB)); /*  Timer 4 Control                      */
uint8_t volatile  T4CCTL0  __attribute((sfrAT0xEC)); /*  Timer 4 Ch 0 Capture/Compare Control */
uint8_t volatile  T4CC0    __attribute((sfrAT0xED)); /*  Timer 4 Ch 0 Capture/Compare Value   */
uint8_t volatile  T4CCTL1  __attribute((sfrAT0xEE)); /*  Timer 4 Ch 1 Capture/Compare Control */
uint8_t volatile  T4CC1    __attribute((sfrAT0xEF)); /*  Timer 4 Ch 1 Capture/Compare Value   */

uint8_t volatile B      __attribute((sfrAT0xF0)); /*  B Register                              */
uint8_t volatile PERCFG __attribute((sfrAT0xF1)); /*  Peripheral Control                      */
uint8_t volatile ADCCFG __attribute((sfrAT0xF2)); /*  ADC Input Configuration                 */
uint8_t volatile P1INP  __attribute((sfrAT0xF6)); /*  Port 1 Input Mode                       */
uint8_t volatile P2INP  __attribute((sfrAT0xF7)); /*  Port 2 Input Mode                       */
uint8_t volatile P0_DIR __attribute((sfrAT0xFD));
uint8_t volatile P1_DIR __attribute((sfrAT0xFE));
uint8_t volatile P2_DIR __attribute((sfrAT0xFF));

// This is denoted as P0SEL, but for consistency we name it this way
uint8_t volatile P0_ALT __attribute((sfrAT0xF3));

// This is denoted as P1SEL, but for consistency we name it this way
uint8_t volatile P1_ALT __attribute((sfrAT0xF4));

// This is denoted as P2SEL, but for consistency we name it this way
uint8_t volatile P2_ALT __attribute((sfrAT0xF5));

/* ------------------------------------------------------------------------------------------------
 *                                       Xdata Radio Registers
 * ------------------------------------------------------------------------------------------------
 */

/*
 * Note: these registers are located in the xdata memory area, not sfr
 * - therefore the sfr16 types cannot be used. Instead the variables
 * have to be assigned to xdata space using appropriate storrage
 * clases using the mangle script.
 *
 * uint16_t values are stored as big ending (MSB first, see io8051.h)
 * so in the following definitions high order byte (MSB) is selected
 * as the address for uint16 values.
 *
 * The registers are not double buffered (latched) and thus the
 * read/write order does not make a difference.
 *
 *
 * As an alternative you could imagine defining these as variables
 * with absolute locations:
 *   uint8_t xdata MDMCTRL0H_VAR at addr;
 *
 * However mangling this in a compiler agnostic way is probaby more
 * difficult than stickting to something that looks like ANSI-C
 *
 *
 */

typedef uint16_t uint16_t_xdata;   // will be replaced by uint16_t xdata
typedef uint8_t uint8_t_xdata;     // will be replaced by uint8_t xdata

typedef uint16_t uint16_t_code;   // will be replaced by uint16_t code
typedef uint8_t uint8_t_code;     // will be replaced by uint8_t code


// I would say these should be volatile, but nesc throws up
//#define _XIO16(addr) (*((volatile unint16_t_xdata*) addr))
//#define _XIO8(addr) (*((uint8_t volatile_xdata*) addr))

#define _XIO16(addr) (*(( uint16_t_xdata*) addr))
#define _XIO8(addr) (*(( uint8_t_xdata*) addr))

#define _CC2430_MDMCTRL0   _XIO16(0xDF02 ) /* Modem Control 0                                   */
#define _CC2430_MDMCTRL0H  _XIO8( 0xDF02 ) /* Modem Control 0 High Byte                         */
#define _CC2430_MDMCTRL0L  _XIO8( 0xDF03 ) /* Modem Control 0 Low Byte                          */
#define _CC2430_MDMCTRL1   _XIO16(0xDF04 ) /* Modem Control 1                                   */
#define _CC2430_MDMCTRL1H  _XIO8( 0xDF04 ) /* Modem Control 1 High Byte                         */
#define _CC2430_MDMCTRL1L  _XIO8( 0xDF05 ) /* Modem Control 1 Low Byte                          */
#define _CC2430_RSSIH      _XIO8( 0xDF06 ) /* RSSI and CCA Status and Control High Byte         */
#define _CC2430_RSSIL      _XIO8( 0xDF07 ) /* RSSI and CCA Status and Control Low Byte          */
#define _CC2430_SYNCWORD   _XIO16(0xDF08 ) /* Synchronization and Control                       */
#define _CC2430_SYNCWORDH  _XIO8( 0xDF08 ) /* Synchronization and Control High Byte             */
#define _CC2430_SYNCWORDL  _XIO8( 0xDF09 ) /* Synchronization and Control Low Byte              */
#define _CC2430_TXCTRL     _XIO16(0xDF0A ) /* Transmit Control                                  */
#define _CC2430_TXCTRLH    _XIO8( 0xDF0A ) /* Transmit Control High Byte                        */
#define _CC2430_TXCTRLL    _XIO8( 0xDF0B ) /* Transmit Control Low Byte                         */
#define _CC2430_RXCTRL0    _XIO16(0xDF0C ) /* Receive Control 0                                 */
#define _CC2430_RXCTRL0H   _XIO8( 0xDF0C ) /* Receive Control 0 High Byte                       */
#define _CC2430_RXCTRL0L   _XIO8( 0xDF0D ) /* Receive Control 0 Low Byte                        */
#define _CC2430_RXCTRL1    _XIO8( 0xDF0E ) /* Receive Control 1                                 */
#define _CC2430_RXCTRL1H   _XIO8( 0xDF0E ) /* Receive Control 1 High Byte                       */
#define _CC2430_RXCTRL1L   _XIO8( 0xDF0F ) /* Receive Control 1 Low Byte                        */
#define _CC2430_FSCTRL     _XIO16(0xDF10 ) /* Frequency Synthesizer Control and Status          */
#define _CC2430_FSCTRLH    _XIO8( 0xDF10 ) /* Frequency Synthesizer Control and Status High Byte*/
#define _CC2430_FSCTRLL    _XIO8( 0xDF11 ) /* Frequency Synthesizer Control and Status Low Byte */
#define _CC2430_CSPX       _XIO8( 0xDF12 ) /* CSMA/CA Strobe Processor X Data Register          */
#define _CC2430_CSPY       _XIO8( 0xDF13 ) /* CSMA/CA Strobe Processor Y Data Register          */
#define _CC2430_CSPZ       _XIO8( 0xDF14 ) /* CSMA/CA Strobe Processor Z Data Register          */
#define _CC2430_CSPCTRL    _XIO8( 0xDF15 ) /* CSMA/CA Strobe Processor CPU Control Input        */
#define _CC2430_CSPT       _XIO8( 0xDF16 ) /* CSMA/CA Strobe Processor T Data Register          */
#define _CC2430_RFPWR      _XIO8( 0xDF17 ) /* Radio Power                                       */
#define _CC2430_FSMTCH     _XIO8( 0xDF20 ) /* Finite State Machine Time Constants High Byte     */
#define _CC2430_FSMTCL     _XIO8( 0xDF21 ) /* Finite State Machine Time Constants Low Byte      */
#define _CC2430_MANANDH    _XIO8( 0xDF22 ) /* Manual Signal AND Override High Byte              */
#define _CC2430_MANANDL    _XIO8( 0xDF23 ) /* Manual Signal AND Override Low Byte               */
#define _CC2430_MANORH     _XIO8( 0xDF24 ) /* Manual Signal OR Override High Byte               */
#define _CC2430_MANORL     _XIO8( 0xDF25 ) /* Manual Signal OR Override High Byte               */
#define _CC2430_AGCCTRLH   _XIO8( 0xDF26 ) /* AGC Control High Byte                             */
#define _CC2430_AGCCTRLL   _XIO8( 0xDF27 ) /* AGC Control Low Byte                              */
#define _CC2430_FSMSTATE   _XIO8( 0xDF39 ) /* Finite State Machine State                        */
#define _CC2430_ADCTSTH    _XIO8( 0xDF3A ) /* ADC Test High Byte                                */
#define _CC2430_ADCTSTL    _XIO8( 0xDF3B ) /* ADC Test Low Byte                                 */
#define _CC2430_DACTSTH    _XIO8( 0xDF3C ) /* DAC Test High Byte                                */
#define _CC2430_DACTSTL    _XIO8( 0xDF3D ) /* DAC Test Low Byte                                 */
#define _CC2430_IEEE_ADDR0 _XIO8( 0xDF43 ) /* IEEE Address Byte 0 (LSB)                         */
#define _CC2430_IEEE_ADDR1 _XIO8( 0xDF44 ) /* IEEE Address Byte 1                               */
#define _CC2430_IEEE_ADDR2 _XIO8( 0xDF45 ) /* IEEE Address Byte 2                               */
#define _CC2430_IEEE_ADDR3 _XIO8( 0xDF46 ) /* IEEE Address Byte 3                               */
#define _CC2430_IEEE_ADDR4 _XIO8( 0xDF47 ) /* IEEE Address Byte 4                               */
#define _CC2430_IEEE_ADDR5 _XIO8( 0xDF48 ) /* IEEE Address Byte 5                               */
#define _CC2430_IEEE_ADDR6 _XIO8( 0xDF49 ) /* IEEE Address Byte 6                               */
#define _CC2430_IEEE_ADDR7 _XIO8( 0xDF4A ) /* IEEE Address Byte 7 (MSB)                         */

#define _CC2430_PANID      _XIO16(0xDF4B ) /* PAN Identifier                                    */
#define _CC2430_PANIDH     _XIO8( 0xDF4B ) /* PAN Identifier High Byte                          */
#define _CC2430_PANIDL     _XIO8( 0xDF4C ) /* PAN Identifier Low Byte                           */

#define _CC2430_SHORTADDR  _XIO16(0xDF4D ) /* Short Address                                     */
#define _CC2430_SHORTADDRH _XIO8( 0xDF4D ) /* Short Address High Byte                           */
#define _CC2430_SHORTADDRL _XIO8( 0xDF4E ) /* Short Address Low Byte                            */
#define _CC2430_IOCFG01    _XIO16(0xDF4F ) /* Input/Output Control 0+1                          */
#define _CC2430_IOCFG0     _XIO8( 0xDF4F ) /* Input/Output Control 0                            */
#define _CC2430_IOCFG1     _XIO8( 0xDF50 ) /* Input/Output Control 1                            */
#define _CC2430_IOCFG23    _XIO16(0xDF51 ) /* Input/Output Control 2+3                          */
#define _CC2430_IOCFG2     _XIO8( 0xDF51 ) /* Input/Output Control 2                            */
#define _CC2430_IOCFG3     _XIO8( 0xDF52 ) /* Input/Output Control 3                            */
#define _CC2430_RXFIFOCNT  _XIO8( 0xDF53 ) /* Receive FIFO Count                                */
#define _CC2430_FSMTC1     _XIO8( 0xDF54 ) /* Finite State Machine Time Constants               */
#define _CC2430_CHVER      _XIO8( 0xDF60 ) /* Chip Revision Number                              */
#define _CC2430_CHIPID     _XIO8( 0xDF61 ) /* Chip ID Number                                    */
#define _CC2430_RFSTATUS   _XIO8( 0xDF62 ) /* Radio Status                                      */

/* Bit fields for xdata registers */

enum {
  CC2430_RFPWR_ADI_RADIO_PD  = 0x4,
  CC2430_RFPWR_RREG_RADIO_PD = 0x3,
  CC2430_RFPWR_RREG_DELAY    = 0x0, // 3 bit field
  CC2430_RFPWR_RREG_DELAY_MASK = 0x7
};

enum {
  CC2430_RREG_DELAY_0    = 0x0, //    0 us delay
  CC2430_RREG_DELAY_31   = 0x1, //   31 us delay
  CC2430_RREG_DELAY_63   = 0x2, //   63 us delay
  CC2430_RREG_DELAY_125  = 0x3, //  125 us delay
  CC2430_RREG_DELAY_250  = 0x4, //  250 us delay
  CC2430_RREG_DELAY_500  = 0x5, //  500 us delay
  CC2430_RREG_DELAY_1000 = 0x6, // 1000 us delay
  CC2430_RREG_DELAY_2000 = 0x7  // 2000 us delay
};

enum {
  CC2430_MDMCTRL0L_AUTOCRC = 0x5,
  CC2430_MDMCTRL0L_AUTOACK = 0x4
};

enum {
  CC2430_MDMCTRL0H_FRAME_FILT          = 0x6, // 2-bit field
  CC2430_MDMCTRL0H_RESERVED_FRAME_MODE = 0x5,
  CC2430_MDMCTRL0H_PAN_COORDINATOR     = 0x4,
  CC2430_MDMCTRL0H_ADDR_DECODE         = 0x3,
  CC2430_MDMCTRL0H_CCA_HYST            = 0x0  // 3-bit field
};

enum {
  CC2430_RFSTATUS_TX_ACTIVE   = 0x4,
  CC2430_RFSTATUS_FIFO        = 0x3,
  CC2430_RFSTATUS_FIFOP       = 0x2,
  CC2430_RFSTATUS_SFD         = 0x1,
  CC2430_RFSTATUS_CCA         = 0x0
};


#endif // _H_ioCC2430_H
