/* $Id$ */

/* author: Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch> */

#ifndef __AVR32_EXCEPTION__
#define __AVR32_EXCEPTION__

/**
 * Exception vector offsets
 */
#define EVBA_UNRECOVERABLE    0x000
#define EVBA_TLB_MULTIPLE     0x004
#define EVBA_BUS_ERROR_DATA   0x008
#define EVBA_BUS_ERROR_INSTR  0x00C
#define EVBA_NMI              0x010
#define EVBA_INSTR_ADDR       0x014
#define EVBA_ITLB_MISS        0x050
#define EVBA_ITLB_PROT        0x018
#define EVBA_BREAKPOINT       0x01C
#define EVBA_ILLEGAL_OPCODE   0x020
#define EVBA_UNIMPLEMENTED    0x024
#define EVBA_PRIVILEGE_VIOL   0x028
#define EVBA_FLOATING_POINT   0x02C
#define EVBA_COP_ABSENT       0x030
#define EVBA_SCALL            0x100
#define EVBA_DATA_ADDR_R      0x034
#define EVBA_DATA_ADDR_W      0x038
#define EVBA_DTLB_MISS_R      0x060
#define EVBA_DTLB_MISS_W      0x070
#define EVBA_DTLB_PROT_R      0x03C
#define EVBA_DTLB_PROT_W      0x040
#define EVBA_DTLB_MODIFIED    0x044

/**
 * The exception handler should return the address which the exception calls after the exception processing.
 */
unsigned int __attribute__((C, spontaneous)) exception_handler(int evba_offset, int return address);

/**
 * The supervision call handler.
 */
void __attribute__((C, spontaneous)) scall_handler(int code, int p1, int p2, int p3, int p4);

#endif
