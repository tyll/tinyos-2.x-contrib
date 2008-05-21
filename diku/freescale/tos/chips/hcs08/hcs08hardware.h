// $Id$

/* "Copyright (c) 2000-2003 The Regents of the University of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement
 * is hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY
 * OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 */

// @author Cory Sharp <cssharp@eecs.berkeley.edu>
// @author Mads Bondo Dydensborg <madsdyd@diku.dk>
// @author Jan Flora <janflora@diku.dk>

#ifndef _H_hcs08hardware_h
#define _H_hcs08hardware_h
#include "hcs08gt60_interrupts.h"
//#include "hcs08gb60.h"
#include "hcs08regs.h"

// see hcs08gb60_interrupts.h for a list of available interrupts
// SIGNAL means interrupts are disabled within the handler
#define TOSH_SIGNAL(signame) \
void signal_##signame() __attribute__ ((interrupt, spontaneous, C))
// just don't support TOSH_INTERRUPT, thus eliminating confusion

/** Declare the ANSI startup function, see below (TinyOSStartup) */
extern void _Startup(void) __attribute__((C, spontaneous));
/**
 *
 * Our TinyOSStartup code.
 *
 * <p>Now, here there be tigers. In order to disable the watchdog,
 * before the ANSI startup code (from CW: Start08.c) is run, we define
 * our own startup code. This code simply disables the watchdog
 * (configure the SOPT register). Because most of the SOPT register
 * bits are write once, we setup the entire register here. And here
 * comes the tigers: Because the ANSI startup code have not been run,
 * the stack pointer have _not_ been setup. Neither have the data
 * variables been copied to ram, nor have the global variables been
 * zero initialized. In other words: Do _not_ use the stack, do _not_
 * use global variables, or even global consts in this function! (No
 * strings, no initialized variables, no statements like char buf[2] =
 * 0; anything like that. In fact, check the assembler every time you
 * change this function.</p>
 *
 * <p>Oh, and in order to be able to jump to _Startup, we have to
 * declare it as above. The rest is done through the linker
 * script.</p>
 *
 * SOPT Bits: 
 * bit 7 = watchdog (0 disabled)
 * bit 6 = watchdog timeout
 * bit 5 = stop mode enable (0 disabled)
 * bit 4 = 1
 * bit 1 = background debug mode enabled
 * bit 0 = 1 */
#define ICG_FILTER_MSB 0x02;
#define ICG_FILTER_LSB 0x40; // LSB value must be written first

#pragma NO_EXIT /* Dunno if this goes all the way through, assembler
		   looks good though. */
void _TinyOSStartup() __attribute__((C, spontaneous))
{
	// Disable watchdog.
	SOPT = 0x71;
	// Starting up in SCM mode 16 MHz system clock.
	ICGFLTL = ICG_FILTER_LSB; // LSB value must be written first
	ICGFLTU = ICG_FILTER_MSB;

	asm ("jmp _Startup");
}


/**
 * Set up a couple of bits of the SPMSC2
 *
 */ 
// #define DEBUG_SLEEP
#ifdef DEBUG_SLEEP
uint32_t schedules;
#endif

#pragma INLINE
void configureLowLevelRegisters() {
#ifdef DEBUG_SLEEP
  schedules = 0;
#endif
  SPMSC2 = 0x0; // I believe I was fiddling with some sleep modes...
}

/**
 * MBD: The MCU supports a number of stop/sleep modes. 
 * For now, I opt for something very simple, the wait mode. */
extern uint8_t Mlme_Main(void); 
void TOSH_sleep()
{
  // Allow the 802.15.4 stack to do what it needs to do
#ifdef INCLUDEFREESCALE802154
  while(Mlme_Main());
  // asm( "WAIT" );  // This should work, not sure if it does or not.
#else
  // asm( "STOP" ); // Do not work at the moment. 
  asm( "WAIT" );
#endif

#ifdef DEBUG_SLEEP
  ++schedules;
#endif
}

// Serial line debug functions
void initSer()
{
  //SCI2BD = 8000000/(16*38400);
  //SCI2C2 = 0x8;
}

void putSer(uint8_t data)
{
		// Wait for Transmit Data Register to be empty.
		while(!SCI2S1_TDRE);
		SCI2D = data;
		// Wait for Transmission Complete.
		while(!SCI2S1_TC);
}

// Functions for writing to flash from user apps.
// Remember to set FCDIV to scale the flash clock into
// the 150 - 200 KHz range. Closer to 200 means faster operation.
// For 16 MHz operation FCDIV = 0x27 is optimal.
typedef void (*flashfunc)(char *data, uint16_t addr, uint8_t len);
flashfunc flashWrite = (flashfunc)(0xFF8B);

uint32_t busClock = 8000000; // We init busClock to be 8 MHz.
uint32_t extClock;
uint32_t fIRG = 250000;  // f_IRG is 243 KHz, but 250 KHz gives nice round numbers.

void enterFEIMode(uint8_t multFact, uint8_t divFact)
{
	// f_IRG = 243 KHz
	// f_ICGOUT = (f_IRG / 7) * 64 * multFact / divFact
	// 16 MHz = ( 243 kHz / 7) * 64 * 14 / 2
	// multFact : 4, 6, 8, 10, 12, 14, 16,  18
	// divFact  : 1, 2, 4,  8, 16, 32, 64, 128
	
	uint8_t MFD, RFD = 0;
	
	// Set busClock variable.
	busClock = (fIRG / 7) * 64 * (multFact / divFact)/2;
	
	// Calculate MFD bits.
	MFD = (multFact - 4)>>1;
	MFD &= 0x07;
	
	// Calculate RFD bits.
	while (divFact) {
		divFact = divFact>>1;
		RFD++;
	}
	RFD--;
	RFD &= 0x07;
	
	// Set clock into FEI mode.	
	ICGC1 = 0x28;  //00101000, REFS = 1, CLKS = 1.
	while (!ICGS2_DCOS); // Wait for DCO to be stable.
	ICGC2_MFD = MFD;
	ICGC2_RFD = RFD;	
	ICGC2_LOLRE = 0;
	ICGC2_LOCRE = 0;
}

void enterFBEMode(uint8_t divFact)
{
	// f_ICGOUT = f_EXT / divFact
	// divFact  : 1, 2, 4,  8, 16, 32, 64, 128

	uint8_t RFD = 0;

	// Set busClock variable.
	busClock = (extClock / divFact)/2;

	// Calculate RFD bits.
	while (divFact) {
		divFact = divFact>>1;
		RFD++;
	}
	RFD--;
	RFD &= 0x07;
	
	// Set clock into FBE mode.
	ICGC1 = 0x50; // 01010000, RANGE = 1, CLKS = 2.
	while (!ICGS1_ERCS); // Wait for External Clock to be stable.
	ICGC2_RFD = RFD;	
	ICGC2_LOLRE = 0;
	ICGC2_LOCRE = 0;
}

void enterFEEMode(bool rng, uint8_t multFact, uint8_t divFact)
{
	// f_ICGOUT = f_EXT * (64*!rng) * multFact / divFact
	// multFact : 4, 6, 8, 10, 12, 14, 16,  18
	// divFact  : 1, 2, 4,  8, 16, 32, 64, 128

	uint8_t MFD, RFD = 0;
	
	// Set busClock variable.
	busClock = (extClock * (64*!rng) * (multFact / divFact))/2;
	
	// Calculate MFD bits.
	MFD = (multFact - 4)>>1;
	MFD &= 0x07;
	
	// Calculate RFD bits.
	while (divFact) {
		divFact = divFact>>1;
		RFD++;
	}
	RFD--;
	RFD &= 0x07;
	
	// Set clock into FEE mode.
	if (rng) {
		ICGC1 = 0x58; // 01011000
	} else {
		ICGC1 = 0x18; // 00011000
	}

	while (!ICGS2_DCOS || !ICGS1_ERCS); // Wait for DCO and External Clock to be stable.
	ICGC2_MFD = MFD;
	ICGC2_RFD = RFD;	
	ICGC2_LOLRE = 0;
	ICGC2_LOCRE = 0;
	// Wait for frequency loop to lock.
	while (!ICGS1_LOCK);
}

/**
 * Hmm. I dunno if this is needed, really. 
 */
#pragma INLINE
void TOSH_wait(void)
{
	asm("BRN 0");
	asm("BRN 0");
	asm("BRN 0");
	asm("BRN 0");
  // asm("nop"); asm("nop");
}

// Cycle time is related to bus clock speed:
//   Bus clock      Cycle time
// ------------------------------
//     20 MHz         50 ns
//     16 Mhz         63 ns
//     12 Mhz         83 ns
//      8 Mhz        125 ns
//      4 Mhz        250 ns
#define TOSH_CYCLE_TIME_NS 125
#define HCS08_CYCLES_PER_US 8
// FIXED: The below functions should of course be written in asm to make
//        them compiler independent. Note that they are dependent on
//        MCU bus clock speed.

#pragma INLINE
void TOSH_wait_250ns(void)
{
	#if HCS08_CYCLES_PER_US < 12
		asm("NOP");
		#if HCS08_CYCLES_PER_US > 4
			asm("NOP");
		#endif
	#else
		asm("BRN 0");
		#if HCS08_CYCLES_PER_US > 12
			asm("NOP");
		#endif
		#if HCS08_CYCLES_PER_US > 16
			asm("NOP");
		#endif
	#endif
}

#pragma INLINE
void HCS08_short_wait_finish(void)
{
	// We have already waited for 2 cycles
	// During initial LDA. Make that 1us.
	#if HCS08_CYCLES_PER_US == 4 || HCS08_CYCLES_PER_US == 16
		// Wait for 2 cycles more.
		asm("NOP");
		asm("NOP");
	#endif
	#if HCS08_CYCLES_PER_US > 4
		#if HCS08_CYCLES_PER_US > 12
			// Wait for 12 cycles more
			asm("BRN 0");
			asm("BRN 0");
			asm("BRN 0");
			asm("BRN 0");
		#endif
		#if HCS08_CYCLES_PER_US != 16
			// Wait for 6 cycles more
			asm("BRN 0");
			asm("BRN 0");
		#endif
		#if HCS08_CYCLES_PER_US == 12
			// Wait for 4 cycles more
			asm("BRN 0");
			asm("NOP");
		#endif
	#endif
}

#pragma INLINE
void HCS08_short_wait_loop(void)
{
	// We are going to wait for 4 cycles
	// during DBNZA. Make that 1us.
	#if HCS08_CYCLES_PER_US > 4
		#if HCS08_CYCLES_PER_US > 12
			// Wait for 12 cycles more
			asm("BRN 0");
			asm("BRN 0");
			asm("BRN 0");
			asm("BRN 0");
		#endif
		#if HCS08_CYCLES_PER_US != 16
			// Wait for 4 cycles more
			asm("BRN 0");
			asm("NOP");
		#endif
		#if HCS08_CYCLES_PER_US == 12
			// Wait for 4 cycles more
			asm("BRN 0");
			asm("NOP");
		#endif
	#endif
}

// LDA is 2 cycles and DBNZA is 4 cycles.
#define HCS08_short_uwait(u_sec) \
		asm("LDA #"#u_sec); \
		asm("uWait:"); \
		HCS08_short_wait_loop(); \
		asm("DBNZA uWait"); \
		HCS08_short_wait_finish();

// The if is resolved at compile time, when u is constant.
#define TOSH_short_uwait(u) \
	if ((u)==1) { \
 		HCS08_short_wait_loop(); \
		asm("NOP"); \
		asm("BRA uWaitDone"); \
	} \
	HCS08_short_uwait(u-1) \
	asm("uWaitDone:");


// TOSH_long_uwait valid only for 4 u_sec or longer
// Shorter wait times will wait 1.6us regardless of u_sec.

#pragma NO_INLINE // timing depends on call/return
void TOSH_long_uwait( unsigned int u_sec )
{
/*
0000 87               PSHA                     ; A: 2 cycles
0001 89               PSHX                     ; A: 2 cycles
0002 8b               PSHH                     ; A: 2 cycles
164:    if( u_sec >= 3 )
0003 89               PSHX                     ; A: 2 cycles
0004 8a               PULH                     ; A: 2 cycles
0005 97               TAX                      ; A: 2 cycles
0006 650003           CPHX  #3                 ; A: 3 cycles
0009 2522             BCS   L2D ;abs = 002d    ; A: 2 cycles
165:    {
166:      u_sec -= 3;
000b a003             SUB   #3                 ; B: 2 cycles
000d 8b               PSHH                     ; B: 2 cycles
000e 95               TSX                      ; B: 2 cycles
000f e703             STA   3,X                ; B: 3 cycles
0011 86               PULA                     ; B: 3 cycles
0012 a200             SBC   #0                 ; B: 2 cycles
0014 e702             STA   2,X                ; B: 3 cycles
167:      {
168:        unsigned char u = (u_sec & 255);
0016 e603             LDA   3,X                ; B: 3 cycles
0018 e701             STA   1,X                ; B: 3 cycles
169:        if( u > 0 )
001a 2702             BEQ   L1E ;abs = 001e    ; B: 3 cycles
170:  	TOSH_short_uwait( u );
001c ad00             BSR   TOSH_short_uwait   ; ... wait ... subtract 2 cycles
001e          L1E:    
171:  
172:        u = u_sec >> 8;
001e 95               TSX                      ; B: 2 cycles
001f e601             LDA   1,X                ; B: 3 cycles
0021 f7               STA   ,X                 ; B: 2 cycles
173:        while( u > 0 )
0022 2006             BRA   L2A ;abs = 002a    ; B: 3 cycles
0024          L24:    
174:        {
175:  	TOSH_short_uwait( 255 );
0024 a6ff             LDA   #-1                // calcualted as part of short_wait
0026 ad00             BSR   TOSH_short_uwait   // ... wait ...
176:  	u--;
0028 95               TSX                      ; C: 2 cycles
0029 7a               DEC   ,X                 ; C: 4 cycles
002a          L2A:    
002a 7d               TST   ,X                 ; C: 3 cycles
002b 26f7             BNE   L24 ;abs = 0024    ; C: 3 cycles
002d          L2D:    
177:        }
178:      }
179:    }
180:  }
002d a703             AIS   #3                 ; A: 2 cycles
002f 81               RTS                      ; A: 6 cycles
*/

  // A total: 25 cycles
  // B total: 34 cycles
  // C total: 12 cycles

  if( u_sec >= 4 )
  {
    u_sec -= 4;
    {
      unsigned char u = (u_sec & 255);
      if( u > 0 )
	TOSH_short_uwait( u );

      u = u_sec >> 8;
      while( u > 0 )
      {
	TOSH_short_uwait( 255 );
	u--;

	// loop overhead from C is 12 cycles, add 4 more to get 1us total
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
      }
    }

    // Total overhead from A and B is 59 cycles, but don't add any more,
    // because just the BSR to get here is 5 cycles.
  }
}

// The only observed use of TOSH_uwait is with constants, so this selection
// will be resolved at compile time.
#define TOSH_uwait(u) (((u)<=255) ? TOSH_short_uwait(u) : TOSH_long_uwait(u))
/*
#pragma INLINE
void TOSH_uwait( unsigned int u_sec )
{
  if( (u_sec >> 8) == 0 ) TOSH_short_uwait( u_sec & 255 );
  else TOSH_long_uwait( u_sec );
}
*/


//inline void __nesc_disable_interrupt() { hcs08_disable_interrupt(); }
//inline void __nesc_enable_interrupt() { hcs08_enable_interrupt(); }
#define __nesc_disable_interrupt() hcs08_disable_interrupt()
#define __nesc_enable_interrupt() hcs08_enable_interrupt()

/*
// Force the spontaneous attribute to prevent inlining by nesc.
// And, if the hcs08 compiler tries to inline it, it screws it up, badly.
unsigned char getCCR() __attribute__ ((spontaneous, noinline))
{ 
  asm( "TPA" );
  asm( "RTS" );
  // This spurious return will be removed by the compiler and eliminates
  // warnings and errors about no return statement.
  return 0;
}
*/
// this code is safer, even though the asm for it is more ugly
inline unsigned char getCCR()
{
  // MBD: We initialize to 0 in order to get rid of warnings about
  // this variable not beeing initialized. We do not make it static however
  // as we wish for it to be on the stack. I guess.
  unsigned char ccr = 0;
  asm( "TPA" );
  asm( "STA ccr" );
  return ccr;
}

typedef unsigned char __nesc_atomic_t;

inline __nesc_atomic_t __nesc_atomic_start(void)
{
  __nesc_atomic_t result = getCCR();
  __nesc_disable_interrupt();
  return result;
}

inline void __nesc_atomic_end( __nesc_atomic_t oldCCR )
{
  // 0x08 is the interrupt *mask* in the CCR
  // which means interrupts are enabled when it's 0
  if( (oldCCR & 0x08) == 0 )
    __nesc_enable_interrupt();
}

#define HCS08_PORT(port, type, bit) PT##port##type##_PT##port##type##bit
#define TOSH_ASSIGN_PIN(name, port, bit) \
void TOSH_SET_##name##_PIN() { HCS08_PORT(port,D,bit) = 1; } \
void TOSH_CLR_##name##_PIN() { HCS08_PORT(port,D,bit) = 0; } \
uint8_t TOSH_READ_##name##_PIN() { return HCS08_PORT(port,D,bit); } \
void TOSH_MAKE_##name##_OUTPUT() { HCS08_PORT(port,DD,bit) = 1; } \
void TOSH_MAKE_##name##_INPUT() { HCS08_PORT(port,DD,bit) = 0; } \
void TOSH_PULLUP_##name##_ENABLE() { HCS08_PORT(port,PE,bit) = 1; } \
void TOSH_PULLUP_##name##_DISABLE() { HCS08_PORT(port,PE,bit) = 0; }

typedef uint8_t mcu_power_t;

enum {
  HCS08_POWER_WAIT			= 0,
  HCS08_POWER_STOP3			= 1,
  HCS08_POWER_STOP2			= 2,
  HCS08_POWER_STOP1			= 3,
};

/* Combine function.  */
mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2) {
  return (m1 < m2)? m1: m2;
}

#endif//_H_hcs08hardware_h

