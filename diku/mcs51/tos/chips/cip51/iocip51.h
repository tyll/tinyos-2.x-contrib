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
 * @author Martin Leopold <leopold@polaric.dk>
 */
#ifndef _H_iocip51_H
#define _H_iocip51_H

/*
 * Bit locations for SCON
 */

enum {
  cip51_SCON_S0MODE = 0x7,
  cip51_SCON_MCE0   = 0x5,
  cip51_SCON_REN0   = 0x4,
  cip51_SCON_TB80   = 0x3,
  cip51_SCON_RB80   = 0x2,
  cip51_SCON_TI0    = 0x1,
  cip51_SCON_RI0    = 0x0
};

/*
 * Bit locations for SPI0CFG
 */

enum {
  CIP51_SPI0CFG_SPIBSY = 0x7,
  CIP51_SPI0CFG_MSTEN  = 0x6,
  CIP51_SPI0CFG_CKPHA  = 0x5,
  CIP51_SPI0CFG_CKPOL  = 0x4,
  CIP51_SPI0CFG_SLVSEL = 0x3,
  CIP51_SPI0CFG_NSSIN  = 0x2,
  CIP51_SPI0CFG_SRMT   = 0x1,
  CIP51_SPI0CFG_RXBMT  = 0x0
};

/*
 * Bit locations for CLKMUL
 */

enum {
  CIP51_CLKMUL_MULEN  = 0x7,
  CIP51_CLKMUL_MULINT = 0x6,
  CIP51_CLKMUL_MULRDY = 0x5
};

/*
 * Bit locations for IT01CF
 */

enum {
  CIP51_IT01CF_IN1PL  = 0x7,
  CIP51_IT01CF_IN0PL  = 0x3,
  CIP51_IT01CF_IN0SL_MASK = 0x7,
  CIP51_IT01CF_IN1SL_MASK = 0x70
};

/**
 * Special Function Register (sfr) definitions
 */

uint8_t volatile OSCLCN  __attribute((sfrAT0x86)); // Internal Low-Freq Oscillator Control
uint8_t volatile PSCTL   __attribute((sfrAT0x8F)); // Program Store R/W Control

//uint8_t volatile P1      __attribute((sfrAT0x90)); // Port 1 Latch
uint8_t volatile TMR3CN  __attribute((sfrAT0x91)); // Timer/Counter 3 Control
uint8_t volatile TMR3RLL __attribute((sfrAT0x92)); // Timer/Counter 3 Reload Low
uint8_t volatile TMR3RLH __attribute((sfrAT0x93)); // Timer/Counter 3 Reload High
uint8_t volatile TMR3L   __attribute((sfrAT0x94)); // Timer/Counter 3Low
uint8_t volatile TMR3H   __attribute((sfrAT0x95)); // Timer/Counter 3 High
uint8_t volatile USB0ADR __attribute((sfrAT0x96)); // USB0 Indirect Address
uint8_t volatile USB0DAT __attribute((sfrAT0x97)); // USB0 Data Register
uint8_t volatile SCON0   __attribute((sfrAT0x98)); // UART0 Control
uint8_t volatile SBUF0   __attribute((sfrAT0x99)); // UART0 Data Buffer
uint8_t volatile CPT1CN  __attribute((sfrAT0x9A)); // Comparator1 Control
uint8_t volatile CPT0CN  __attribute((sfrAT0x9B)); // Comparator0 Control
uint8_t volatile CPT1MD  __attribute((sfrAT0x9C)); // Comparator1 Mode Selection
uint8_t volatile CPT0MD  __attribute((sfrAT0x9D)); // Comparator0 Mode Selection
uint8_t volatile CPT1MX  __attribute((sfrAT0x9E)); // Comparator1 MUX Selection
uint8_t volatile CPT0MX  __attribute((sfrAT0x9F)); // Comparator0 MUX Selection

//uint8_t volatile P2      __attribute((sfrAT0xA0)); // Port 2 Latch
uint8_t volatile SPI0CFG __attribute((sfrAT0xA1)); // SPI Configuration
uint8_t volatile SPI0CKR __attribute((sfrAT0xA2)); // SPI Clock Rate Control
uint8_t volatile SPI0DAT __attribute((sfrAT0xA3)); // SPI Data
uint8_t volatile P0MDOUT __attribute((sfrAT0xA4)); // Port 0 Output Mode Config
uint8_t volatile P1MDOUT __attribute((sfrAT0xA5)); // Port 1 Output Mode Configuration
uint8_t volatile P2MDOUT __attribute((sfrAT0xA6)); // Port 2 Output Mode Configuration
uint8_t volatile P3MDOUT __attribute((sfrAT0xA7)); // Port 3 Output Mode Configuration
uint8_t volatile IE      __attribute((sfrAT0xA8)); // Interrupt Enable
uint8_t volatile CLKSEL  __attribute((sfrAT0xA9)); // Clock Select
uint8_t volatile EMI0CN  __attribute((sfrAT0xAA)); // External Memory Interface Control
uint8_t volatile SBCON1  __attribute((sfrAT0xAC)); // UART1 Baud Rate Generator Control
uint8_t volatile P4MDOUT __attribute((sfrAT0xAE)); // Port 4 Output Mode Configuration
uint8_t volatile PFE0CN  __attribute((sfrAT0xAF)); // Prefetch Engine Control

uint8_t volatile P3     __attribute((sfrAT0xB0)); // Port 4 Input Mode Config
uint8_t volatile OSCXCN __attribute((sfrAT0xB1)); //External Oscillator Control
uint8_t volatile OSCICN __attribute((sfrAT0xB2)); //Internal Oscillator Control
uint8_t volatile OSCICL __attribute((sfrAT0xB3)); //Internal Oscillator Calibration
uint8_t volatile SBRLL1 __attribute((sfrAT0xB4)); //UART1 Baud Rate Generator Low
uint8_t volatile SBRLH1 __attribute((sfrAT0xB5)); //UART1 Baud Rate Generator High
uint8_t volatile FLSCL  __attribute((sfrAT0xB6)); //Flash Scale
uint8_t volatile FLKEY  __attribute((sfrAT0xB7)); //Flash Lock and Key
uint8_t volatile IP     __attribute((sfrAT0xB8)); //Interrupt Priority
uint8_t volatile CLKMUL __attribute((sfrAT0xB9)); //Clock Multiplier
uint8_t volatile AMX0N  __attribute((sfrAT0xBA)); //AMUX0 Negative Channel Select
uint8_t volatile AMX0P  __attribute((sfrAT0xBB)); //AMUX0 Positive Channel Select
uint8_t volatile ADC0CF __attribute((sfrAT0xBC)); //ADC0 Configuration
uint8_t volatile ADC0L  __attribute((sfrAT0xBD)); //ADC0 Low
uint8_t volatile ADC0H  __attribute((sfrAT0xBE)); //ADC0 High

uint8_t volatile SMB0CN __attribute((sfrAT0xC0)); //SMBus Control
uint8_t volatile SMB0CF __attribute((sfrAT0xC1)); //SMBus Configuration
uint8_t volatile SMB0DA __attribute((sfrAT0xC2)); //SMBus Data
uint8_t volatile ADC0GT __attribute((sfrAT0xC3)); //ADC0 Greater-Than Compare Low
uint8_t volatile ADC0GT __attribute((sfrAT0xC4)); //ADC0 Greater-Than Compare High
uint8_t volatile ADC0LT __attribute((sfrAT0xC5)); //ADC0 Less-Than Compare Word Low
uint8_t volatile ADC0LT __attribute((sfrAT0xC6)); //ADC0 Less-Than Compare Word High
uint8_t volatile P4     __attribute((sfrAT0xC7)); //Port 4 Latch
uint8_t volatile TMR2CN __attribute((sfrAT0xC8)); //Timer/Counter 2 Control
uint8_t volatile REG0CN __attribute((sfrAT0xC9)); //Voltage Regulator Control
uint8_t volatile TMR2RL __attribute((sfrAT0xCA)); //Timer/Counter 2 Reload Low
uint8_t volatile TMR2RL __attribute((sfrAT0xCB)); //Timer/Counter 2 Reload High
uint8_t volatile TMR2L  __attribute((sfrAT0xCC)); //Timer/Counter 2 Low
uint8_t volatile TMR2H  __attribute((sfrAT0xCD)); //Timer/Counter 2 High


uint8_t volatile PSW     __attribute((sfrAT0xD0)); //Program Status Word
uint8_t volatile REF0CN  __attribute((sfrAT0xD1)); //Voltage Reference Control
uint8_t volatile SCON1   __attribute((sfrAT0xD2)); //UART1 Control
uint8_t volatile SBUF1   __attribute((sfrAT0xD3)); //UART1 Data Buffer
uint8_t volatile P0SKIP  __attribute((sfrAT0xD4)); //Port 0 Skip
uint8_t volatile P1SKIP  __attribute((sfrAT0xD5)); //Port 1 Skip
uint8_t volatile P2SKIP  __attribute((sfrAT0xD6)); //Port 2 Skip
uint8_t volatile USB0XCN __attribute((sfrAT0xD7)); //USB0 Transceiver Control
uint8_t volatile PCA0CN  __attribute((sfrAT0xD8)); //PCA Control
uint8_t volatile PCA0MD  __attribute((sfrAT0xD9)); //PCA Mode

uint8_t volatile P3SKIP  __attribute((sfrAT0xDF)); // Port 2 Skip

uint8_t volatile XBR0     __attribute((sfrAT0xE1));
uint8_t volatile XBR1     __attribute((sfrAT0xE2));
uint8_t volatile XBR2     __attribute((sfrAT0xE3));
uint8_t volatile IT01CF   __attribute((sfrAT0xE4));             // INT0/INT1 Configuration
uint8_t volatile SMOD1    __attribute((sfrAT0xE5));             // UART1 Mode
uint8_t volatile EIE1     __attribute((sfrAT0xE6));             // Extended Interrupt Enable 1
uint8_t volatile EIE2     __attribute((sfrAT0xE7));             // Extended Interrupt Enable 2
uint8_t volatile ADC0CN   __attribute((sfrAT0xE8));             // ADC0 Control
uint8_t volatile PCA0CPL1 __attribute((sfrAT0xE9));             // PCA0 Capture 1 Low
uint8_t volatile PCA0CPH1 __attribute((sfrAT0xEA));             // PCA0 Capture 1 High
uint8_t volatile PCA0CPL2 __attribute((sfrAT0xEB));             // PCA0 Capture 2 Low
uint8_t volatile PCA0CPH2 __attribute((sfrAT0xEC));             // PCA0 Capture 2 High
uint8_t volatile PCA0CPL3 __attribute((sfrAT0xED));             // PCA0 Capture 3 Low
uint8_t volatile PCA0CPH3 __attribute((sfrAT0xEE));             // PCA0 Capture 3 High
uint8_t volatile RSTSRC   __attribute((sfrAT0xEF));             // Reset Source Configuration/Status

uint8_t volatile B        __attribute((sfrAT0xF0));             // B Register
uint8_t volatile P0MDIN   __attribute((sfrAT0xF1)); // Port 0 Input Mode Config
uint8_t volatile P1MDIN   __attribute((sfrAT0xF2)); // Port 1 Input Mode Config
uint8_t volatile P2MDIN   __attribute((sfrAT0xF3)); // Port 2 Input Mode Config
uint8_t volatile P3MDIN   __attribute((sfrAT0xF4)); // Port 4 Input Mode Config
uint8_t volatile P4MDIN   __attribute((sfrAT0xF5)); // Port 4 Input Mode Config
uint8_t volatile EIP1     __attribute((sfrAT0xF6)); // Extended Interrupt Priority 1
uint8_t volatile EIP2     __attribute((sfrAT0xF7)); // Extended Interrupt Priority 2
uint8_t volatile SPI0CN   __attribute((sfrAT0xF8)); // SPI0 Control
uint8_t volatile PCA0L    __attribute((sfrAT0xF9)); // PCA0 Counter Low
uint8_t volatile PCA0H    __attribute((sfrAT0xFA)); // PCA0 Counter High
uint8_t volatile PCA0CPL0 __attribute((sfrAT0xFB)); // PCA0 Capture 0 Low
uint8_t volatile PCA0CPH0 __attribute((sfrAT0xFC)); // PCA0 Capture 0 High
uint8_t volatile PCA0CPL4 __attribute((sfrAT0xFD)); // PCA0 Capture 4 Low
uint8_t volatile PCA0CPH4 __attribute((sfrAT0xFE)); // PCA0 Capture 4 High
uint8_t volatile VDM0CN   __attribute((sfrAT0xFF)); // VDD Monitor Control


/**
 * Bit adresseable locations
 */

// SCON0  0x98
uint8_t volatile S0MODE __attribute((sbitAT0x9F)); // Serial mode control bit 0
uint8_t volatile MCE0   __attribute((sbitAT0x9E)); // Multiprocessor communication enable
uint8_t volatile REN0   __attribute((sbitAT0x9C)); // Receive enable
uint8_t volatile TB80   __attribute((sbitAT0x9B)); // Transmit bit 8
uint8_t volatile RB80   __attribute((sbitAT0x9A)); // Receive bit 8
uint8_t volatile TI0    __attribute((sbitAT0x99)); // Transmit interrupt flag
uint8_t volatile RI0    __attribute((sbitAT0x98)); // Receive interrupt flag

// IE 0xA8

//uint8_t volatile EA     __attribute((sbitAT0xAF));  // Global interrupt enable
uint8_t volatile ESPI0  __attribute((sbitAT0xAE));  // SPI0 interrupt enable
uint8_t volatile ET2    __attribute((sbitAT0xAD));  // Timer2 interrupt enable
uint8_t volatile ES0    __attribute((sbitAT0xAC));  // UART0 interrupt enable
uint8_t volatile ET1    __attribute((sbitAT0xAB));  // Timer1 interrupt enable
uint8_t volatile EX1    __attribute((sbitAT0xAA));  // External interrupt 1 enable
uint8_t volatile ET0    __attribute((sbitAT0xA9));  // Timer0 interrupt enable
uint8_t volatile EX0    __attribute((sbitAT0xA8));  // External interrupt 0 enable

/*  P3 (0xB0) bit adressable locations */

uint8_t volatile P3_0 __attribute((sbitAT0xB0));
uint8_t volatile P3_1 __attribute((sbitAT0xB1));
uint8_t volatile P3_2 __attribute((sbitAT0xB2));
uint8_t volatile P3_3 __attribute((sbitAT0xB3));
uint8_t volatile P3_4 __attribute((sbitAT0xB4));
uint8_t volatile P3_5 __attribute((sbitAT0xB5));
uint8_t volatile P3_6 __attribute((sbitAT0xB6));
uint8_t volatile P3_7 __attribute((sbitAT0xB7));

/*  SPICN (0xF8) bit adressable locations */

uint8_t volatile SPIF   __attribute((sbitAT0xFF)); // SPI0 interrupt flag
uint8_t volatile WCOL   __attribute((sbitAT0xFE)); // SPI0 write collision flag
uint8_t volatile MODF   __attribute((sbitAT0xFD)); // SPI0 mode fault flag
uint8_t volatile RXOVRN __attribute((sbitAT0xFC)); // SPI0 rx overrun flag
uint8_t volatile NSSMD1 __attribute((sbitAT0xFB)); // SPI0 slave select mode 1
uint8_t volatile NSSMD0 __attribute((sbitAT0xFA)); // SPI0 slave select mode 0
uint8_t volatile TXBMT  __attribute((sbitAT0xF9)); // SPI0 transmit buffer empty
uint8_t volatile SPIEN  __attribute((sbitAT0xF8)); // SPI0 SPI enable


/* Interrupt vector definitions */

#define SIG_INT0             __vector_0   // External Interrupt 0
#define SIG_TIMER0           __vector_1   // Timer0 Overflow
#define SIG_INT1             __vector_2   // External Interrupt 1
#define SIG_TIMER1           __vector_3   // Timer1 Overflow
#define SIG_UART0            __vector_4   // Serial Port 0
#define SIG_TIMER2           __vector_5   // Timer2 Overflow
#define SIG_SPI0             __vector_6   // Serial Peripheral Interface 0
#define SIG_SMBUS0           __vector_7   // SMBus0 Interface
#define SIG_USB0             __vector_8   // USB Interface
#define SIG_ADC0_WINDOW      __vector_9   // ADC0 Window Comparison
#define SIG_ADC0_EOC         __vector_10  // ADC0 End Of Conversion
#define SIG_PCA0             __vector_11  // PCA0 Peripheral
#define SIG_COMPARATOR0      __vector_12  // Comparator0
#define SIG_COMPARATOR1      __vector_13  // Comparator1
#define SIG_TIMER3           __vector_14  // Timer3 Overflow
#define SIG_VBUS_LEVEL       __vector_15  // VBUS level-triggered interrupt
#define SIG_UART1            __vector_16  // Serial Port 1


#endif //_H_iocip51_H
