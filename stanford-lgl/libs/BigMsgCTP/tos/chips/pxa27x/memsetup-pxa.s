
/*
 * memory-pxa.S - memory setup for PXA architecture
 *
 * $Id$
 *
 * Copyright (C) 2003 Abraham van der Merwe <abz@4dllc.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

.ident "$Id$"

#ifdef HAVE_CONFIG_H
#include <blob/config.h>
#endif

/* 
#include <blob/arch.h>
#include "pxa.h"
#include "mainstone.h"
*/

.text

/*
#define MDCNFG_OFFSET	0x00
#define MDREFR_OFFSET	0x04
#define MSC0_OFFSET		0x08
#define MSC1_OFFSET		0x0c
#define MSC2_OFFSET		0x10
#define MECR_OFFSET		0x14
#define SXLCR_OFFSET	0x18
#define SXCNFG_OFFSET	0x1c
#define SXMRS_OFFSET	0x24
#define MCMEM0_OFFSET	0x28
#define MCMEM1_OFFSET	0x2c
#define MCATT0_OFFSET	0x30
#define MCATT1_OFFSET	0x34
#define MCIO0_OFFSET	0x38
#define MCIO1_OFFSET	0x3c
#define MDMRS_OFFSET	0x40
*/

	.equ	MDCNFG_OFFSET,(0x00)
	.equ	MDREFR_OFFSET,(0x04)
	.equ	MSC0_OFFSET,(0x08)
	.equ	MSC1_OFFSET,(0x0c)
	.equ	MSC2_OFFSET,(0x10)
	.equ	MECR_OFFSET,(0x14)
	.equ	SXLCR_OFFSET,(0x18)
	.equ	SXCNFG_OFFSET,(0x1c)
	.equ	SXMRS_OFFSET,(0x24)
	.equ	MCMEM0_OFFSET,(0x28)
	.equ	MCMEM1_OFFSET,(0x2c)
	.equ	MCATT0_OFFSET,(0x30)
	.equ	MCATT1_OFFSET,(0x34)
	.equ	MCIO0_OFFSET,(0x38)
	.equ	MCIO1_OFFSET,(0x3c)
	.equ	MDMRS_OFFSET,(0x40)
	

/* from pxa-regs.h */
	.equ	OSCR,(0x40A00010)
	.equ	MDCNFG_DE0,(1 << 0)	/* SDRAM enable for partition 0 */
	.equ	MDCNFG_DE1,(1 << 1)	/* SDRAM enable for partition 1 */
	.equ	MDCNFG_DE2,(1 << 16)	/* SDRAM enable for partition 2 */
	.equ	MDCNFG_DE3,(1 << 17)	/* SDRAM enable for partition 3 */
/* from mainstone.h 
 * (no msc0_value, mecr_value, mcmem0_value, mcmem1_value, mcatt0_value, mcatt1_value, mcio0_value, mcio1_value)
 *
	.equ	MSC1_VALUE,(0x0000A691)
	.equ	MSC2_VALUE,(0x0000B884)
*/
	.equ	MSC0_VALUE,(0x7FF07FF8)
	.equ	MSC1_VALUE,(0x7FF07FF8)
	.equ	MSC2_VALUE,(0x7FF07FF8)
	
	.equ	MDREFR_VALUE,(0x00000018)
/*
	.equ	MDCNFG_VALUE,(0x00000AC9)
*/
	.equ	MDCNFG_VALUE,(0x0B002BCD)
	
	.equ	PXA_SDRAM_BANK0,(0xa0000000)
	.equ	MDMRS_VALUE,(0x00000000)

/*
 * The sequence below is based on the recommended init steps detailed
 * in the Intel PXA255 Processor Developer's Manual Section 6.11
 */

.macro wait
	ldr		r2, =OSCR
	mov		r3, #0
	str		r3, [r2]
0:
	ldr		r3, [r2]
	cmp		r3, #768
	bls		0b
.endm

.globl memsetup
memsetup:
	/* wait for internal clocks to stabilize */
	wait

	ldr		r1, =0x48000000

	/* write MSC0, read back to ensure data latches */
/*#ifdef MSC0_VALUE*/
	ldr		r0, =MSC0_VALUE
	str		r0, [r1, #MSC0_OFFSET]
	ldr		r0, [r1, #MSC0_OFFSET]
/*#endif	 #ifdef MSC0_VALUE */

	/* write MSC1, read back to ensure data latches */
/*#ifdef MSC1_VALUE*/
	ldr		r0, =MSC1_VALUE
	str		r0, [r1, #MSC1_OFFSET]
	ldr		r0, [r1, #MSC1_OFFSET]
/*#endif	 #ifdef MSC1_VALUE */

	/* write MSC2, read back to ensure data latches */
/*#ifdef MSC2_VALUE*/
	ldr		r0, =MSC2_VALUE
	str		r0, [r1, #MSC2_OFFSET]
	ldr		r0, [r1, #MSC2_OFFSET]
/*#endif	 #ifdef MSC2_VALUE */

	/* write MECR */
/*#ifdef MECR_VALUE
	ldr		r0, =MECR_VALUE
	str		r0, [r1, #MECR_OFFSET]
#endif*/	/* #ifdef MECR_VALUE */

	/* write MCMEM0 */
/*#ifdef MCMEM0_VALUE
	ldr		r0, =MCMEM0_VALUE
	str		r0, [r1, #MCMEM0_OFFSET]
#endif*/	/* #ifdef MCMEM0_VALUE */

	/* write MCMEM1 */
/*#ifdef MCMEM1_VALUE
	ldr		r0, =MCMEM1_VALUE
	str		r0, [r1, #MCMEM1_OFFSET]
#endif*/	/* #ifdef MCMEM1_VALUE */

	/* write MCATT0 */
/*#ifdef MCATT0_VALUE
	ldr		r0, =MCATT0_VALUE
	str		r0, [r1, #MCATT0_OFFSET]
#endif*/	/* #ifdef MCATT0_VALUE */

	/* write MCATT1 */
/*#ifdef MCATT1_VALUE
	ldr		r0, =MCATT1_VALUE
	str		r0, [r1, #MCATT1_OFFSET]
#endif*/	/* #ifdef MCATT1_VALUE */

	/* write MCIO0 */
/*#ifdef MCIO0_VALUE
	ldr		r0, =MCIO0_VALUE
	str		r0, [r1, #MCIO0_OFFSET]
#endif*/	/* #ifdef MCIO0_VALUE */

	/* write MCIO1 */
/*#ifdef MCIO1_VALUE
	ldr		r0, =MCIO1_VALUE
	str		r0, [r1, #MCIO1_OFFSET]
#endif*/	/* #ifdef MCIO1_VALUE */

	/* get the mdrefr settings (k0run, e0pin, etc.) */
	ldr		r3,  =MDREFR_VALUE

	/* extract DRI field (we need a valid DRI field) */
	ldr		r2, =0xfff
	and		r3, r3, r2

	/* get the reset state of MDREFR */
	ldr		r4, [r1, #MDREFR_OFFSET]

	/* clear the DRI field */
	bic		r4, r4, r2

	/* insert the valid DRI field loaded above */
	orr		r4, r4, r3

	/* write back MDREFR */
	str		r4, [r1, #MDREFR_OFFSET]

	/*
	 * I am hard-coding in 50/100/300 clock speeds for now.
	 * This needs testing since I hacked up a large, ugly version
	 * of this that was Lubbock-specific. -Rusty
     */

	/* clear the free-running clock bits (clear K0Free, K1Free, K2Free) */
	bic		r4, r4, #(0x00800000 | 0x01000000 | 0x02000000)

	/* set K1RUN if bank 0 installed */
	orr		r4, r4, #0x00010000

	/* set K1DB2 (SDClk[1] = MemClk/2) */
	orreq	r4, r4, #0x00020000

	/* write back MDREFR */
	str		r4, [r1, #MDREFR_OFFSET]
	ldr		r4, [r1, #MDREFR_OFFSET]

	/* deassert SLFRSH */
	bic		r4, r4, #0x00400000

	/* write back MDREFR */
	str		r4, [r1, #MDREFR_OFFSET]

	/* assert E1PIN */
	orr		r4, r4, #0x00008000

	/* write back MDREFR */
	str		r4, [r1, #MDREFR_OFFSET]
	ldr		r4, [r1, #MDREFR_OFFSET]

.rept 3
	nop
.endr

	/* fetch platform value of MDCNFG */
	ldr		r2, =MDCNFG_VALUE

	/* disable all sdram banks */
	bic		r2, r2, #(MDCNFG_DE0 | MDCNFG_DE1)
	bic		r2, r2, #(MDCNFG_DE2 | MDCNFG_DE3)

	/* write initial value of MDCNFG, w/o enabling sdram banks */
	str		r2, [r1, #MDCNFG_OFFSET]

	/* wait for internal clocks to stabilize */
	wait

	/* turn everything off (caches off, MMU off, etc.) */
	mov		r0, #0x78
	mcr		p15, 0, r0, c1, c0, 0

	/*
	 * Access memory *not yet enabled* for CBR refresh cycles (8)
	 * CBR is generated for all banks
	 */

	ldr     r2, =PXA_SDRAM_BANK0

.rept 8
	str		r2, [r2]
.endr

	/* fetch current MDCNFG value */
	ldr		r3, [r1, #MDCNFG_OFFSET]

	/* enable sdram bank 0 if installed (must do for any populated bank) */
	orr		r3, r3, #MDCNFG_DE0

	/* write back mdcnfg, enabling the sdram bank(s) */
	str		r3, [r1, #MDCNFG_OFFSET]

	/* write MDMRS */
	ldr		r2, =MDMRS_VALUE
	str		r2, [r1, #MDMRS_OFFSET]

	mov		pc, lr

