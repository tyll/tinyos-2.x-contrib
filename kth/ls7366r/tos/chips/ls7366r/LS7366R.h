/*
 * Copyright (c) 2010, KTH Royal Institute of Technology
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
 * - Neither the name of the KTH Royal Institute of Technology nor the names
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
 *
 */
/**
 * Header where we define the register values and configurations
 *
 * @author Aitor Hernandez <aitorhh@kth.se>
 * @version $Revision$ $Date$
 */

#ifndef __LS7366R_H__
#define __LS7366R_H__
/**
 * MDR0 page 4 datasheet LS7366R
 *
 *  B1 B0 = 00: non-quadrature count mode. (A = clock, B = direction).
 *			= 01: x1 quadrature count mode (one count per quadrature cycle).
 *			= 10: x2 quadrature count mode (two counts per quadrature cycle).
 *			= 11: x4 quadrature count mode (four counts per quadrature cycle).
 *	B3 B2 = 00: free-running count mode.
 *			= 01: single-cycle count mode (counter disabled with carry or borrow, re-enabled with reset or load).
 *			= 10: range-limit count mode (up and down count-ranges are limited between DTR and zero,
 *					respectively; counting freezes at these limits but resumes when direction reverses).
 *			= 11: modulo-n count mode (input count clock frequency is divided by a factor of (n+1),
 *					where n = DTR, in both up and down directions).
 *	B5 B4 = 00: disable index.
 *			= 01: configure index as the "load CNTR" input (transfers DTR to CNTR).
 *			= 10: configure index as the "reset CNTR" input (clears CNTR to 0).
 *			= 11: configure index as the "load OTR" input (transfers CNTR to OTR).
 *	B6 = 0: Asynchronous Index
 *		= 1: Synchronous Index (overridden in non-quadrature mode)
 *	B7 = 0: Filter clock division factor = 1
 *		= 1: Filter clock division factor = 2
 */
enum ls3766R_mdr0_reg_enums {

	LS7366R_MDR0_NON_QUAD_MODE = 0x00,
	LS7366R_MDR0_X1_QUAD_MODE = 0x01,
	LS7366R_MDR0_X2_QUAD_MODE = 0x02,
	LS7366R_MDR0_X4_QUAD_MODE = 0x03,

	LS7366R_MDR0_FREE_RUNNING_MODE = 0x00,
	LS7366R_MDR0_SINGLE_CYCLE_MODE = 0x04,
	LS7366R_MDR0_RANGE_LIMIT_MODE = 0x08,
	LS7366R_MDR0_MOD_N_MODE = 0x0C,

	LS7366R_MDR0_NO_INDEX = 0x00,
	LS7366R_MDR0_LOAD_CNTR_INDEX = 0x01,
	LS7366R_MDR0_RESET_CNTR_INDEX = 0x02,
	LS7366R_MDR0_LOAD_OTR = 0x03,

	LS7366R_MDR0_ASYNC_INDEX = 0x00,//x0xx xxxx
	LS7366R_MDR0_SYNC_INDEX = 0x40, //x1xx xxxx

	LS7366R_MDR0_CLK_0_DIV = 0x00, //0xxx xxx
	LS7366R_MDR0_CLK_2_DIV = 0x80,
//1xxx  xxx
};

/**
 *  MDR1 page 4 datasheet LS7366R
 *
 *	B1 B0 = 00: 4-byte counter mode
 *			= 01: 3-byte counter mode
 *			= 10: 2-byte counter mode.
 *			= 11: 1-byte counter mode
 *	B2 = 0: Enable counting
 *		= 1: Disable counting
 *	B3 = : not used
 *	B4 = 0: NOP
 *		= 1: FLAG on IDX (B4 of STR)
 *	B5 = 0: NOP
 *		= 1: FLAG on CMP (B5 of STR)
 *	B6 = 0: NOP
 *		= 1: FLAG on BW (B6 of STR)
 *	B7 = 0: NOP
 *		= 1: FLAG on CY (B7 of STR)
 */
enum ls3766R_mdr1_reg_enums {
	LS7366R_MDR1_COUNTER_BYTES_MASK = 0x03,
	LS7366R_MDR1_ENABLE_COUNTER_SHIFT = 2,
};
/**
 *	B2 B1 B0 = XXX (Don’t care)
 *	B5 B4 B3 = 000: Select none
 *			 = 001: Select MDR0
 *			 = 010: Select MDR1
 *			 = 011: Select DTR
 *			 = 100: Select CNTR
 *			 = 101: Select OTR
 *			 = 110: Select STR
 *			 = 111: Select none
 *  B7 B6 = 00: CLR register
 *		  = 01: RD register
 *		  = 10: WR register
 *		  = 11: LOAD register
 */
enum ls3766R_ir_reg_enums {
	/*******************************************************
	 * WARNING: REGISTERS IN LSB AND WE HAVE TO SEND IN MSB
	 ******************************************************/
	LS7366R_REG_MDR0 = 0x08, //xx00 1xxx
	LS7366R_REG_MDR1 = 0x10, //xx01 0xxx
	LS7366R_REG_DTR = 0x18, //xx01 1xxx
	LS7366R_REG_CNTR = 0x20, //xx10 0xxx
	LS7366R_REG_OTR = 0x28, //xx10 1xxx
	LS7366R_REG_STR = 0x30, //xx11 0xxx

	LS7366R_OP_CLR = 0x00, //00xx xxxx
	LS7366R_OP_RD = 0x40, //01xx xxxx
	LS7366R_OP_WR = 0x80, //10xx xxxx
	LS7366R_OP_LOAD = 0xC0,
};

/**
 * To check the status of the LS7366,
 * we can poll the status register STR
 *
 *  7. CY - Carry (CNTR overflow) latch
 *  6. BW - Borrow (CNTR underflow) latch
 *  5. CMP - Compare (CNTR = DTR) latch
 *  4. IDX - Index latch
 *  3. CEN - Count enable status (Enabled=1, Disabled=0)
 *  2. PLS - Power loss indicator
 *  1. U/D - Count direction (Up=1, Down=0)
 *  0. S - Sign bit (Negative=1, Positive=0)
 */
enum ls7366r_status_enums {
	LS7366R_STATUS_CNTR_OVERFLOW = 1 << 7,
	LS7366R_STATUS_CNTR_UNDERFLOW = 1 << 6,
	LS7366R_STATUS_CNTR_CMP = 1 << 5,
	LS7366R_STATUS_COUNTER_ENABLE = 1 << 4,
	LS7366R_STATUS_POWERLOSS_IND = 1 << 3,
	LS7366R_STATUS_COUNT_DIRECTION = 1 << 2,
	LS7366R_STATUS_SIGN = 1,
};

/**********************************************************
 * DEFAULT CONFIGURATION
 * To modify: Add these vars to the CFLAGS of your compiler
 * 			or modify the default parameters here.
 ***********************************************************/
#ifndef LS7366R_DEF_DISABLED
#define LS7366R_DEF_DISABLED 0
#endif

#ifndef LS7366R_DEF_SIZE
#define LS7366R_DEF_SIZE 2
#endif

#ifndef LS7366R_DEF_QUAD_MODE
#define LS7366R_DEF_QUAD_MODE LS7366R_MDR0_X4_QUAD_MODE
#endif

#ifndef LS7366R_DEF_RUNNING_MODE
#define LS7366R_DEF_RUNNING_MODE LS7366R_MDR0_FREE_RUNNING_MODE
#endif

#ifndef LS7366R_DEF_INDEX
#define LS7366R_DEF_INDEX LS7366R_MDR0_NO_INDEX
#endif

#ifndef LS7366R_DEF_CLK_DIV
#define LS7366R_DEF_CLK_DIV LS7366R_MDR0_CLK_0_DIV
#endif

#ifndef LS7366R_DEF_SYNC_INDEX
#define LS7366R_DEF_SYNC_INDEX LS7366R_MDR0_ASYNC_INDEX
#endif

#ifndef LS7366R_DEF_MOD_N_LIMIT
#define LS7366R_DEF_MOD_N_LIMIT (1 << 12 )  //2^11 = 4096
#endif

#endif
