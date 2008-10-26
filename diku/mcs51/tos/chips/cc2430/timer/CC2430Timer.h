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
 *  The 4 timers are controlled through 3 interfaces, that are very
 *  similar. Each type of timer has been given a seperate interface to
 *  avoid the misunderstanding that the timers are interchangeable - the
 *  timers differ substantially in bit width, prescaler (clock divider)
 *  values, timer modes, etc. even though there methods are very similar
 *  (get/set mode, prescaler, etc.).
 *
 *  Timer 1 through 4 uses the system clock as source. This frequency
 *  the system clock is determined by the CLKCON.TICKSPD register, which
 *  then again is subdevided by the appropriate presc
 * 
 *  The sleep and watch dog timer uses the 32.768 kHz clock as source
 *  (either internal or external). Despites it's name the sleep timer
 *  can operate in all modes.
 * 
 *  The sleep and watch dog timers are not exported at this time.
 *
 */
/**
 *
 * @author Martin Leopold <leopold@diku.dk>
 */


#ifndef _H_CC2430Timer_H
#define _H_CC2430Timer_H



/***********************************************************************
 *                                CLKCON                               *
 ***********************************************************************/

/*
 * Bit field constants
 */

enum {
  CC2430_SLEEP_OSC32K_CALDIS = 7,
  CC2430_SLEEP_XOSC_STB      = 6,
  CC2430_SLEEP_HFRC_STB      = 5,
  CC2430_SLEEP_DIV           = 3, // first bit in 2-bit field
  CC2430_SLEEP_OSC_PD        = 2, 
  CC2430_SLEEP_MODE          = 0, // first bit in 2-bit field
  CC2430_SLEEP_MODE_MASK     = 3
};

enum {
  CC2430_SLEEP_POWERMODE_0   = 0,
  CC2430_SLEEP_POWERMODE_1   = 1,
  CC2430_SLEEP_POWERMODE_2   = 2,
  CC2430_SLEEP_POWERMODE_3   = 3
};

enum {
  CC2430_CLKCON_OSC32K       = 7,
  CC2430_CLKCON_OSC          = 6,
  CC2430_CLKCON_TICKSPD      = 3, // first bit in 2-bit field
  CC2430_CLKCON_CLKSPD       = 0, // Will be set by MCU when OSC is selected
  CC2430_CLKCON_TICKSPD_MASK = 0x38
};

/*
 * CLKCON.TICKSPD values. The timers further subdevide this value
 */
enum cc2430_tick_spd_t {
  CC2430_TICKF_DIV_1   = 0x0 << CC2430_CLKCON_TICKSPD,
  CC2430_TICKF_DIV_2   = 0x1 << CC2430_CLKCON_TICKSPD,
  CC2430_TICKF_DIV_4   = 0x2 << CC2430_CLKCON_TICKSPD,
  CC2430_TICKF_DIV_8   = 0x3 << CC2430_CLKCON_TICKSPD,
  CC2430_TICKF_DIV_16  = 0x4 << CC2430_CLKCON_TICKSPD,
  CC2430_TICKF_DIV_32  = 0x5 << CC2430_CLKCON_TICKSPD,
  CC2430_TICKF_DIV_64  = 0x6 << CC2430_CLKCON_TICKSPD,
  CC2430_TICKF_DIV_128 = 0x7 << CC2430_CLKCON_TICKSPD
};

/***********************************************************************
 *                                Timer 1                              *
 ***********************************************************************/


/* 
 * T1CTL bit fields. See cc2430 datasheet p. 97 
 */

enum {
  CC2430_T1CTL_CH2IF = 0x7,
  CC2430_T1CTL_CH1IF = 0x6,
  CC2430_T1CTL_CH0IF = 0x5,
  CC2430_T1CTL_OVFIF = 0x4,
  CC2430_T1CTL_DIV   = 0x2, // 2 bit field
  CC2430_T1CTL_MODE  = 0x0, // 2 bit field
  CC2430_T1CTL_MODE_MASK = 0x3,
  CC2430_T1CTL_DIV_MASK  = 0xc,
  CC2430_T1CTL_IF_MASK  = 0xf0
};


/* 
 * Timer 1 modes. See cc2430 datasheet p. 97 
 */

enum cc2430_timer1_mode_t {
  CC2430_TIMER1_MODE_OFF    = 0x0 << CC2430_T1CTL_MODE,
  CC2430_TIMER1_MODE_FREE   = 0x1 << CC2430_T1CTL_MODE,
  CC2430_TIMER1_MODE_MODULO = 0x2 << CC2430_T1CTL_MODE,
  CC2430_TIMER1_MODE_UPDOWN = 0x3 << CC2430_T1CTL_MODE
};

/*
 * Timer 1 provides additional information on why an interrupt was
 * generated in the register T1CTL.  See cc2430 datasheep p. 104
 */

enum cc2430_timer1_if_t {
  CC2430_T1_CH2IF = _BV(CC2430_T1CTL_CH2IF),
  CC2430_T1_CH1IF = _BV(CC2430_T1CTL_CH1IF),
  CC2430_T1_CH0IF = _BV(CC2430_T1CTL_CH0IF),
  CC2430_T1_OVFIF = _BV(CC2430_T1CTL_OVFIF)
};

/* 
 * See cc2430 datasheet p. 104
 */

enum cc2430_timer1_prescaler_t {
  CC2430_TIMER1_DIV_1   = 0x0 << CC2430_T1CTL_DIV,
  CC2430_TIMER1_DIV_8   = 0x1 << CC2430_T1CTL_DIV,
  CC2430_TIMER1_DIV_32  = 0x2 << CC2430_T1CTL_DIV,
  CC2430_TIMER1_DIV_128 = 0x3 << CC2430_T1CTL_DIV 
};

/*
 * T1CCTLx bit locations
 */

enum {
  CC2430_T1CCTLx_CPSEL = 0x7,
  CC2430_T1CCTLx_IM    = 0x6,
  CC2430_T1CCTLx_CMP   = 0x3,
  CC2430_T1CCTLx_MODE  = 0x2,
  CC2430_T1CCTLx_CAP   = 0x0
};

/***********************************************************************
 *                             Timer 2 (MAC)                           *
 ***********************************************************************/


/* 
 * Timer MAC modes. See cc2430 datasheet p. 97 
 */

enum cc2430_timerMAC_mode_t {
  CC2430_TIMERMAC_MODE_IDLE  = 0x0,  
  CC2430_TIMERMAC_MODE_RUN   = 0x1
};

/* 
 * T2CNF bit fields
 */

enum cc2430_timerMAC_T2CNF_t {
  CC2430_T2CNF_CMPIF   = 0x7,
  CC2430_T2CNF_PERIF   = 0x6,
  CC2430_T2CNF_OFCMPIF = 0x5,
  CC2430_T2CNF_CMSEL   = 0x3,
  CC2430_T2CNF_SYNC    = 0x1,
  CC2430_T2CNF_RUN     = 0x0
};


/* 
 * T2PEROF2 bit fields
 */

enum cc2430_timerMAC_T2PEROF2_t {
  CC2430_T2PEROF2_CMPIM = 0x7,
  CC2430_T2PEROF2_PERIM = 0x6,
  CC2430_T2PEROF2_OFCMPIM = 0x5
};

enum cc2430_timerMAC_if_t {
  CC2430_TMAC_CMPIF   = _BV(CC2430_T2CNF_CMPIF),
  CC2430_TMAC_PERIF   = _BV(CC2430_T2CNF_PERIF),
  CC2430_TMAC_OFCMPIF = _BV(CC2430_T2CNF_OFCMPIF)
};

enum cc2430_timerMAC_interval_t {
  CC2430_TIMERWDT_32768 = 0,
  CC2430_TIMERWDT_8192 = 1,
  CC2430_TIMERWDT_512 = 2,
  CC2430_TIMERWDT_64 = 3
};

/***********************************************************************
 *                              Timer 3 and 4                          *
 ***********************************************************************/

/*
 * Timer 3 and 4 provide additional information on why an interrupt was
 * generated in the register TIMIF.  See cc2430 datasheep p. 124.
 *
 * These registers are also bitaddressable
 */

enum {
  CC2430_TIMIF_OVFIM   = 0x6
};

enum cc2430_timer34_if_t {
  CC2430_TIMIF_T4CH1IF = 0x5, // Corresponds to sbit T4CH1IF
  CC2430_TIMIF_T4CH0IF = 0x4, // Corresponds to sbit T4CH0IF
  CC2430_TIMIF_T4OVFIF = 0x3, // Corresponds to sbit T4OVFIF
  CC2430_TIMIF_T3CH1IF = 0x2, // Corresponds to sbit T3CH1IF
  CC2430_TIMIF_T3CH0IF = 0x1, // Corresponds to sbit T3CH0IF
  CC2430_TIMIF_T3OVFIF = 0x0  // Corresponds to sbit T3OVFIF
};


/* 
 * Timer 3 and 4 modes. See cc2430 datasheet p. 118
 */

enum cc2430_timer3_4_mode_t {
  CC2430_TIMER3_4_MODE_FREE   = 0x0,
  CC2430_TIMER3_4_MODE_DOWN   = 0x1,
  CC2430_TIMER3_4_MODE_MODULO = 0x2,
  CC2430_TIMER3_4_MODE_UPDOWN = 0x3
};

/* 
 * Bitmasks for T3CTL
 */

enum {
  CC2430_T34CTL_DIV   = 0x5, // 3 bit fild
  CC2430_T34CTL_START = 0x4,
  CC2430_T34CTL_OVFIM = 0x3,
  CC2430_T34CTL_WDTIF = 0x3,
  CC2430_T34CTL_CLR   = 0x2,
  CC2430_T34CTL_MODE  = 0x0, // 2 bit fild
  CC2430_T34CTL_MODE_MASK = 0x3,
  CC2430_T34CTL_DIV_MASK = 0xe0
};

/* 
 * See cc2430 datasheet p. 118
 */

enum cc2430_timer3_4_prescaler_t {
  CC2430_TIMER3_4_DIV_1   = 0x0 << CC2430_T34CTL_DIV,
  CC2430_TIMER3_4_DIV_2   = 0x1 << CC2430_T34CTL_DIV,
  CC2430_TIMER3_4_DIV_4   = 0x2 << CC2430_T34CTL_DIV,
  CC2430_TIMER3_4_DIV_8   = 0x3 << CC2430_T34CTL_DIV,
  CC2430_TIMER3_4_DIV_16  = 0x4 << CC2430_T34CTL_DIV,
  CC2430_TIMER3_4_DIV_32  = 0x5 << CC2430_T34CTL_DIV,
  CC2430_TIMER3_4_DIV_64  = 0x6 << CC2430_T34CTL_DIV,
  CC2430_TIMER3_4_DIV_128 = 0x7 << CC2430_T34CTL_DIV
};


/***********************************************************************
 *                               Timer WDT                             *
 ***********************************************************************/

/*
 * Bit locations for WDCTL
 */ 

enum {
  CC2430_WDCTL_CLR  = 0x4,
  CC2430_WDCTL_EN   = 0x3,
  CC2430_WDCTL_MODE = 0x2,
  CC2430_WDCTL_INT  = 0x0,
  CC2430_WDCTL_INT_MASK = 0x3
};

enum cc2430_timerWDT_mode_t {
  CC2430_TIMERWDT_MODE_WDT    = 0x0 << CC2430_WDCTL_MODE,  
  CC2430_TIMERWDT_MODE_TIMER  = 0x1 << CC2430_WDCTL_MODE
};



#endif //_H_CC2430Timer_H
