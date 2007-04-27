/*----------------------------------------------------------------------------
*         ATMEL Microcontroller Software Support  -  ROUSSET  -
*----------------------------------------------------------------------------
* The software is delivered "AS IS" without warranty or condition of any
* kind, either express, implied or statutory. This includes without
* limitation any warranty or condition with respect to merchantability or
* fitness for any particular purpose, or against the infringements of
* intellectual property rights of others.
*----------------------------------------------------------------------------
* File Name           : Board.h
* Object              : AT91SAM7S Evaluation Board Features Definition File.
*
* Creation            : JPP   16/Jun/2004
* V 1.0 21/Feb/05 JPP : Define __ramfunc
* V 1.1 21/Feb/05 JPP : add Lib definition
* V 1.2 22/Feb/05 JPP : Add DBGU inline definition
*----------------------------------------------------------------------------
*/
/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
#ifndef Board_h
#define Board_h
//#include "stdconst.h"
#include "AT91SAM7S256.h"
#define __inline static inline
#include "lib_AT91SAM7S256.h"
//#include "m_sched.h"
//#include "d_ioctrl.r"

#define __ramfunc

//#define AT91C_US_ASYNC_MODE ( AT91C_US_USMODE_NORMAL + AT91C_US_NBSTOP_1_BIT + AT91C_US_PAR_NONE + AT91C_US_CHRL_8_BITS + AT91C_US_CLKS_CLOCK )
#define 	AT91C_AIC_SRCTYPE_INT_HIGH_LEVEL       ((unsigned int) 0x0 <<  5) // (AIC) Internal Sources Code Label High-level Sensitive

#define true	-1
#define false	0

#define   HARDWAREInit                  {\
                                          ULONG TmpReset;\
                                          ULONG lkjh = 9;\
                                          *AT91C_RSTC_RMR  = 0xA5000401;\
                                          *AT91C_AIC_DCR   = 1;\
                                          *AT91C_PITC_PIMR = (0x000FFFFF | 0x01000000);\
                                          TmpReset         = *AT91C_PITC_PIVR;\
                                          TmpReset         = TmpReset;/* Suppress warning*/\
                                          *AT91C_PMC_PCER   = (1L<<AT91C_ID_PIOA);\
                                        }



/*-------------------------------*/
/* SAM7Board Memories Definition */
/*-------------------------------*/
// The AT91SAM7S64 embeds a 16-Kbyte SRAM bank, and 64 K-Byte Flash

#define  INT_SARM           0x00200000
#define  INT_SARM_REMAP	    0x00000000

#define  INT_FLASH          0x00000000
#define  INT_FLASH_REMAP    0x01000000

#define  FLASH_PAGE_NB	    1024
#define  FLASH_PAGE_LOCK    32
#define  FLASH_PAGE_SIZE    256

/*-----------------*/
/* Leds Definition */
/*-----------------*/
/*                                 PIO   Flash    PA    PB   PIN */
#define LED1            (1<<0)	/* PA0 / PGMEN0 & PWM0 TIOA0  48 */
#define LED2            (1<<1)	/* PA1 / PGMEN1 & PWM1 TIOB0  47 */
#define LED3            (1<<2)	/* PA2          & PWM2 SCK0   44 */
#define LED4            (1<<3)	/* PA3          & TWD  NPCS3  43 */
#define NB_LEB			4

#define LED_MASK        (LED1|LED2|LED3|LED4)


#endif /* Board_h */
