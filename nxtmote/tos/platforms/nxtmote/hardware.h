/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
#ifndef __NXTMOTE_HARDWARE_H__
#define __NXTMOTE_HARDWARE_H__

#include "AT91SAM7S256.h"

#include "AT91SAM7S256_extra.h"
#include "lib_AT91SAM7S256.h"
#include "lib_extra_AT91SAM7S256.h"

#define   OSC                           48054850L

typedef   unsigned char                 UCHAR;  //uint8_t
typedef   unsigned short                USHORT; //uint16_t
typedef   unsigned char                 UBYTE;  //uint8_t
typedef   signed char                   SBYTE;  //int8_t
typedef   unsigned short int            UWORD;  //uint16_t
typedef   signed short int              SWORD;  //int16_t
typedef   unsigned long                 ULONG;  //uint32_t
typedef   signed long                   SLONG;  //int32_t
/*
typedef signed char int8_t;
typedef unsigned char uint8_t;

typedef short int16_t;
typedef unsigned short uint16_t;

typedef int int32_t;
typedef unsigned int uint32_t;

typedef long long int64_t;
typedef unsigned long long uint64_t;

typedef int32_t intptr_t;
typedef uint32_t uintptr_t;
*/

extern void AT91F_Spurious_handler(void);
extern void AT91F_Default_IRQ_handler(void);
extern void AT91F_Default_FIQ_handler(void);

inline void __nesc_enable_interrupt() {
  uint32_t statusReg = 0;

  asm volatile (
	       "mrs %0,CPSR\n\t"
	       "bic %0,%1,#0xc0\n\t"
	       "msr CPSR_c, %1"
	       : "=r" (statusReg)
	       : "0" (statusReg)
	       );
  return;
}

inline void __nesc_disable_interrupt() {
/*
  uint32_t statusReg = 0;

  asm volatile (
		"mrs %0,CPSR\n\t"
		"orr %0,%1,#0xc0\n\t"
		"msr CPSR_c,%1\n\t"
		: "=r" (statusReg)
		: "0" (statusReg)
		);
*/
  return;
}

typedef uint32_t __nesc_atomic_t;
//TODO: enable
inline __nesc_atomic_t __nesc_atomic_start(void) @spontaneous() {
  uint32_t result = 0;
  uint32_t temp = 0;
/*
  asm volatile (
		"mrs %0,CPSR\n\t"
		"orr %1,%2,%4\n\t"
		"msr CPSR_cf,%3"
		: "=r" (result) , "=r" (temp)
		: "0" (result) , "1" (temp) , "i" (ARM_CPSR_INT_MASK)
		);
*/
  return result;
}

inline void __nesc_atomic_end(__nesc_atomic_t oldState) @spontaneous() {
  uint32_t  statusReg = 0;

  oldState &= ARM_CPSR_INT_MASK;
/*
  asm volatile (
		"mrs %0,CPSR\n\t"
		"bic %0, %1, %2\n\t"
		"orr %0, %1, %3\n\t"
		"msr CPSR_c, %1"
		: "=r" (statusReg)
		: "0" (statusReg),"i" (ARM_CPSR_INT_MASK), "r" (oldState)
		);
*/
  return;
}
inline void __nesc_atomic_sleep() {
  //__nesc_enable_interrupt();
}

// Add offset to channel id (first channel id is zero) to get timer peripheral id
#define TIMER_PID(chnl_id) chnl_id + AT91C_ID_TC0

// With MCK at 48054857 Hz and a timer incrementing at MCK/2
// 1 ms is approx. 24028 ticks
#define TICKSONEMSCLK2 (24028)
//#define TICKTOMSCLK2(ticks)



// priorities which are used in HplAt91InterruptM
const uint8_t TOSH_IRP_TABLE[] = {
  0xFF, // AT91C_ID_FIQ         ID  0, Advanced Interrupt Controller (FIQ)
  0xFF, // AT91C_ID_SYS         ID  1, System Peripheral
  0xFF, // AT91C_ID_PIOA        ID  2, Parallel IO Controller
  0xFF, // AT91C_ID_3_Reserved  ID  3, Reserved
  0xFF, // AT91C_ID_ADC         ID  4, Analog-to-Digital Converter
  0xFF, // AT91C_ID_SPI         ID  5, Serial Peripheral Interface
  0xFF, // AT91C_ID_US0         ID  6, USART 0
  0xFF, // AT91C_ID_US1         ID  7, USART 1
  0xFF, // AT91C_ID_SSC         ID  8, Serial Synchronous Controller
  AT91C_AIC_PRIOR_HIGHEST, // AT91C_ID_TWI         ID  9, Two-Wire Interface
  0xFF, // AT91C_ID_PWMC        ID 10, PWM Controller
  0xFF, // AT91C_ID_UDP         ID 11, USB Device Port
  0x04, // AT91C_ID_TC0         ID 12, Timer Counter 0
  0xFF, // AT91C_ID_TC1         ID 13, Timer Counter 1
  0xFF, // AT91C_ID_TC2         ID 14, Timer Counter 2
  0xFF, // AT91C_ID_15_Reserved ID 15, Reserved
  0xFF, // AT91C_ID_16_Reserved ID 16, Reserved
  0xFF, // AT91C_ID_17_Reserved ID 17, Reserved
  0xFF, // AT91C_ID_18_Reserved ID 18, Reserved
  0xFF, // AT91C_ID_19_Reserved ID 19, Reserved
  0xFF, // AT91C_ID_20_Reserved ID 20, Reserved
  0xFF, // AT91C_ID_21_Reserved ID 21, Reserved
  0xFF, // AT91C_ID_22_Reserved ID 22, Reserved
  0xFF, // AT91C_ID_23_Reserved ID 23, Reserved
  0xFF, // AT91C_ID_24_Reserved ID 24, Reserved
  0xFF, // AT91C_ID_25_Reserved ID 25, Reserved
  0xFF, // AT91C_ID_26_Reserved ID 26, Reserved
  0xFF, // AT91C_ID_27_Reserved ID 27, Reserved
  0xFF, // AT91C_ID_28_Reserved ID 28, Reserved
  0xFF, // AT91C_ID_29_Reserved ID 29, Reserved
  0xFF, // AT91C_ID_IRQ0        ID 30, Advanced Interrupt Controller (IRQ0)
  0xFF, // AT91C_ID_IRQ1        ID 31, Advanced Interrupt Controller (IRQ1)
  0xFF, // AT91C_ALL_INT        ID 0xC0007FF7 ALL VALID INTERRUPTS
};

// Lookup table for some peripheral ids
AT91_REG PID_ADR_TABLE[] = {
  0x00000000,     // AT91C_ID_FIQ         ID  0, Advanced Interrupt Controller (FIQ)
  0x00000000,     // AT91C_ID_SYS         ID  1, System Peripheral
  0x00000000,     // AT91C_ID_PIOA        ID  2, Parallel IO Controller
  0x00000000,     // AT91C_ID_3_Reserved  ID  3, Reserved
  0x00000000,     // AT91C_ID_ADC         ID  4, Analog-to-Digital Converter
  0x00000000,     // AT91C_ID_SPI         ID  5, Serial Peripheral Interface
  0x00000000,     // AT91C_ID_US0         ID  6, USART 0
  0x00000000,     // AT91C_ID_US1         ID  7, USART 1
  0x00000000,     // AT91C_ID_SSC         ID  8, Serial Synchronous Controller
  0x00000000,     // AT91C_ID_TWI         ID  9, Two-Wire Interface
  0x00000000,     // AT91C_ID_PWMC        ID 10, PWM Controller
  0x00000000,     // AT91C_ID_UDP         ID 11, USB Device Port
  AT91C_BASE_TC0, // AT91C_ID_TC0         ID 12, Timer Counter 0
  AT91C_BASE_TC1, // AT91C_ID_TC1         ID 13, Timer Counter 1
  AT91C_BASE_TC2, // AT91C_ID_TC2         ID 14, Timer Counter 2
  0x00000000,     // AT91C_ID_15_Reserved ID 15, Reserved
  0x00000000,     // AT91C_ID_16_Reserved ID 16, Reserved
  0x00000000,     // AT91C_ID_17_Reserved ID 17, Reserved
  0x00000000,     // AT91C_ID_18_Reserved ID 18, Reserved
  0x00000000,     // AT91C_ID_19_Reserved ID 19, Reserved
  0x00000000,     // AT91C_ID_20_Reserved ID 20, Reserved
  0x00000000,     // AT91C_ID_21_Reserved ID 21, Reserved
  0x00000000,     // AT91C_ID_22_Reserved ID 22, Reserved
  0x00000000,     // AT91C_ID_23_Reserved ID 23, Reserved
  0x00000000,     // AT91C_ID_24_Reserved ID 24, Reserved
  0x00000000,     // AT91C_ID_25_Reserved ID 25, Reserved
  0x00000000,     // AT91C_ID_26_Reserved ID 26, Reserved
  0x00000000,     // AT91C_ID_27_Reserved ID 27, Reserved
  0x00000000,     // AT91C_ID_28_Reserved ID 28, Reserved
  0x00000000,     // AT91C_ID_29_Reserved ID 29, Reserved
  0x00000000,     // AT91C_ID_IRQ0        ID 30, Advanced Interrupt Controller (IRQ0)
  0x00000000,     // AT91C_ID_IRQ1        ID 31, Advanced Interrupt Controller (IRQ1)
  0x00000000,     // AT91C_ALL_INT        ID 0xC0007FF7 ALL VALID INTERRUPTS
};

//Clock selection constants
//enum {
//  TC_CLKS         = 0x7,
//  TC_CLKS_MCK2    = 0x0,
//  TC_CLKS_MCK8    = 0x1,
//  TC_CLKS_MCK32   = 0x2,
//  TC_CLKS_MCK128  = 0x3,
//  TC_CLKS_MCK1024 = 0x4
//};

// GPIO pins
// See AT91SAM7S256 LEGO MINDSTORMS HW sheet 1
// and J7, J8, J9, and J6 on sheet 3
#define DIGIA0 (23) // Port 1 pin 5 (yellow)
#define DIGIA1 (18) // Port 1 pin 6 (blue)

#define DIGIB0 (28) // Port 2 pin 5
#define DIGIB1 (19) // Port 2 pin 6

#define DIGIC0 (29) // Port 3 pin 5
#define DIGIC1 (20) // Port 3 pin 6

#define DIGID0 (30) // Port 4 pin 5
#define DIGID1 (2)  // Port 4 pin 6
// See HW appendix page 1. Pin5 on port 1 is PA18 that is DIGIA1
#define LEDVAL_ (1 << DIGIA0)
// Little function to toggle a pin
// Usage: write {toggle(0);}
//   in your code to turn off the led
#define togglepin(toggle)	{/* GPIO register addresses */\
							/* Register use */\
							*AT91C_PIOA_PER = LEDVAL_;\
							*AT91C_PIOA_OER = LEDVAL_;\
							if(toggle == 0)\
							  *AT91C_PIOA_CODR = LEDVAL_;  /* port 1 pin 5 at 0.0 v (enable this line OR the next)*/\
							else\
							  *AT91C_PIOA_SODR = LEDVAL_;  /* port 1 pin 5 (blue) at 3.25-3.27 v (GND is on pin 2 (black)) */\
							while(1); /* stop here */\
						    }

#endif //__NXTMOTE_HARDWARE_H__
