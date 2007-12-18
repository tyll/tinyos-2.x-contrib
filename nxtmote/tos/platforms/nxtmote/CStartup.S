/*------------------------------------------------------------------------------
//*-         ATMEL Microcontroller Software Support  -  ROUSSET  -
//*------------------------------------------------------------------------------
//* The software is delivered "AS IS" without warranty or condition of any
//* kind, either express, implied or statutory. This includes without
//* limitation any warranty or condition with respect to merchantability or
//* fitness for any particular purpose, or against the infringements of
//* intellectual property rights of others.
//*-----------------------------------------------------------------------------
//*- File source          : Cstartup.s
//*- Object               : Generic CStartup for KEIL and GCC
//*- Compilation flag     : None
//*-
//*- 1.0 18/Oct/04 JPP    : Creation
//*- 1.1 21/Feb/05 JPP    : Set Interrupt
//*- 1.1 01/Apr/05 JPP    : save SPSR 
//*
//*- WinARM/arm-elf-gcc-version by Martin Thomas - Modifications:
//*  remapping-support, vector-location, stack-position and more...
//*-----------------------------------------------------------------------------*/
/**
 * Adapted for nxtmote.
 * @author Rasmus Pedersen
 */
/* 
   20060902 (mth) : moved IRQ-Handler from section .vect* to 
                    .init/.fastrun
   20061101 (mth) : update IRQ-Handler
                    FIQ-stack init
*/

#include "AT91SAM7S256_inc.h"

/*#include "AT91SAM7S256.h"*/

/* check configuration-options and map to "assembler symbols": */

#define ROM_RUN
/*#define VECTORS_IN_RAM */

#ifdef ROM_RUN
.set RAM_MODE, 0
#ifdef VECTORS_IN_RAM
.set REMAP, 1
.set VECTREMAPPED, 1
#else
.set REMAP, 0
.set VECTREMAPPED, 0
#endif
#endif

#ifdef RAM_RUN
.set RAM_MODE, 1
.set REMAP, 1
.set VECTREMAPPED, 0
#endif


.if (RAM_MODE)
.print "RAM_MODE enabled"
.else
.print "ROM_MODE enabled"
.endif

.if (REMAP)
.print "remapping enabled"
.endif

.if (VECTREMAPPED)
.print "Vectors at start of RAM"
.else
.print "Vectors at start of Code"
.endif
/*
	.equ AIC_IVR,         (256) 
	.equ AIC_FVR,         (260) 
	.equ AIC_EOICR,       (304)
	.equ AT91C_BASE_AIC,  (0xFFFFF000)
*/
/*------------------------------------------------------------------------------
//*- Exception vectors 
//*--------------------
//*- These vectors can be read at address 0 or at RAM address
//*- They ABSOLUTELY requires to be in relative addresssing mode in order to
//*- guarantee a valid jump. For the moment, all are just looping.
//*- If an exception occurs before remap, this would result in an infinite loop.
//*- To ensure if a exeption occurs before start application to infinite loop.
//*------------------------------------------------------------------------------*/

.if (VECTREMAPPED)
.print "Vectors in section .vectmapped -> .data"
.section .vectmapped, "ax"
.else
.print "Vectors in section .vectorg -> .text"
.section .vectorg, "ax"
.endif

			LDR     PC,Reset_Addr		/* 0x00 Reset handler */    
			LDR     PC,Undef_Addr		/* 0x04 Undefined Instruction */
			LDR     PC,SWI_Addr		/* 0x08 Software Interrupt */
			LDR     PC,PAbt_Addr		/* 0x0C Prefetch Abort */
			LDR     PC,DAbt_Addr		/* 0x10 Data Abort */
			NOP                 		/* 0x14 reserved  */
			LDR     PC,IRQ_Addr		/* 0x18 IRQ */
fiqvec:                                 		/* 0x1c FIQ */
/*------------------------------------------------------------------------------
//*- Function             : FIQ_Handler_Entry
//*- Treatments           : FIQ Controller Interrupt Handler.
//*- Called Functions     : AIC_FVR[interrupt] 
//*------------------------------------------------------------------------------*/

FIQ_Handler_Entry:

/*- Switch in SVC/User Mode to allow User Stack access for C code 	*/
/* because the FIQ is not yet acknowledged*/

/*- Save and r0 in FIQ_Register */
            mov         r9,r0
            ldr         r0 , [r8, #AIC_FVR]
            msr         CPSR_c,#I_BIT | F_BIT | ARM_MODE_SVC

/*- Save scratch/used registers and LR in User Stack */
            stmfd       sp!, { r1-r3, r12, lr}

/*- Branch to the routine pointed by the AIC_FVR */
            mov         r14, pc
            bx          r0

/*- Restore scratch/used registers and LR from User Stack */
            ldmia       sp!, { r1-r3, r12, lr}

/*- Leave Interrupts disabled and switch back in FIQ mode */
            msr         CPSR_c, #I_BIT | F_BIT | ARM_MODE_FIQ

/*- Restore the R0 ARM_MODE_SVC register */
            mov         r0,r9

/*- Restore the Program Counter using the LR_fiq directly in the PC */
            subs        pc,lr,#4

/* end of fiqhandler */

Reset_Addr:       .word     InitReset
Undef_Addr:       .word     Undef_Handler
//SWI_Addr:         .word     SWI_Handler
SWI_Addr:         .word     SWI_Addr
//SWI_Addr:         .word     SoftwareInterruptASM      /* in swi_handler.S */
PAbt_Addr:        .word     PAbt_Handler
DAbt_Addr:        .word     DAbt_Handler
IRQ_Addr:         .word     IRQ_Handler_Entry
  
Undef_Handler:  B       Undef_Handler
/* SWI_Handler:    B       SWI_Handler */
PAbt_Handler:   B       PAbt_Handler
DAbt_Handler:   B       DAbt_Handler


        .arm
        .section .init, "ax"
        .global _startup
        .func   _startup
_startup:
reset: 

.if (VECTREMAPPED)
/* mthomas: Dummy used during startup */
				LDR PC,=Reset_Addr_F
				NOP
				NOP
				NOP
				NOP
				NOP /*.word 0xdeadbeef*/ /* Reserved Address */
				NOP
				NOP
Reset_Addr_F:       .word     InitReset
.endif

.RAM_TOP:
	.word	__TOP_STACK 

InitReset:

/*------------------------------------------------------------------------------
/*- Remapping
/*------------------------------------------------------------------------------*/
.if (VECTREMAPPED)
		.print "RCR setting for remapping enabled"
		.equ    MC_BASE,0xFFFFFF00  /* MC Base Address */
		/*.equ    MC_RCR, 0x00*/        /* MC_RCR Offset */
		

		/* store first word in RAM into r4 */
		ldr r0,=__FIRST_IN_RAM
		ldr r4,[r0]
		/* load value at address 0 into R2 */
		ldr r1,=0x00000000
		ldr r2,[r1]	
		/* xor value from address 0 (flip all bits), store in R3 */
		ldr r3,=0xffffffff
		eor r3, r2, r3
		/* write xored value to first word in RAM 
		if already remapped this will also change
		the value at 0 */
		str r3,[r0]
		/* load from address 0 again into R3 */
		ldr r3,[r1]
		/* restore first value in RAM */
		str r4,[r0]
		
		/* compare */
		cmp r3, r2
		bne already_remapped
	
		/* if both values have been equal the change of the
		RAM-value had no effect on the value at 0x00000000 
		so we are not remapping yet -> remap now: */
		LDR     R0, =MC_BASE
		MOV     R1, #1
		STR     R1, [R0, #MC_RCR]
		
already_remapped:
.endif


/*------------------------------------------------------------------------------
/*- Low level Init (PMC, AIC, ? ....) by C function AT91F_LowLevelInit
/*------------------------------------------------------------------------------*/
// rup: Moved initialization code to PlatformP.Init.init()
//            .extern   AT91F_LowLevelInit
/*- minumum C initialization */
/*- call  AT91F_LowLevelInit( void) */

//            ldr     sp, .RAM_TOP            /* temporary stack in internal RAM (**) */
/*--Call Low level init function in ABSOLUTE through the Interworking	*/
//            ldr     r0,=AT91F_LowLevelInit
//            mov     lr, pc
//            bx      r0
/*------------------------------------------------------------------------------
//*- Stack Sizes Definition
//*------------------------
//*- Interrupt Stack requires 2 words x 8 priority level x 4 bytes when using
//*- the vectoring. This assume that the IRQ management.
//*- The Interrupt Stack must be adjusted depending on the interrupt handlers.
//*- Fast Interrupt not requires stack If in your application it required you must
//*- be definehere.
//*- The System stack size is not defined and is limited by the free internal
//*- SRAM.
//*------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
//*- Top of Stack Definition
//*-------------------------
//*- Interrupt and Supervisor Stack are located at the top of internal memory in 
//*- order to speed the exception handling context saving and restoring.
//*- ARM_MODE_SVC (Application, C) Stack is located at the top of the external memory.
//*------------------------------------------------------------------------------*/

          .EQU		IRQ_STACK_SIZE,    (3*8*4)
          .EQU		FIQ_STACK_SIZE,    (3*8*4)

          .EQU		ARM_MODE_FIQ,       0x11
          .EQU		ARM_MODE_IRQ,       0x12
          .EQU		ARM_MODE_SVC,       0x13

          .EQU		I_BIT,              0x80
          .EQU		F_BIT,              0x40

/*------------------------------------------------------------------------------
//*- Setup the stack for each mode
//*-------------------------------*/
                mov     r0, sp /* see (**) */

/*- Set up Fast Interrupt Mode and set FIQ Mode Stack*/
                msr    CPSR_c, #ARM_MODE_FIQ | I_BIT | F_BIT
                mov    sp, r0
                sub    r0, r0, #FIQ_STACK_SIZE
/*- Init the FIQ register*/
                ldr     r8, =AT91C_BASE_AIC

/*- Set up Interrupt Mode and set IRQ Mode Stack*/
                msr     CPSR_c, #ARM_MODE_IRQ | I_BIT | F_BIT
                mov     sp, r0                     /* Init stack IRQ */
                sub     r0, r0, #IRQ_STACK_SIZE

/*- Set up Supervisor Mode and set Supervisor Mode Stack*/
//				/* start with INT and FIQ enabled */
				msr     CPSR_c, #ARM_MODE_SVC 

				/* start with INT and FIQ disabled */
//				msr     CPSR_c, #ARM_MODE_SVC | I_BIT | F_BIT 

				mov     sp, r0                     /* Init stack Sup */


/*- Enable interrupt & Set up Supervisor Mode and set Supervisor Mode Stack*/

/* Relocate .data section (Copy from ROM to RAM) 
   This will also copy the .vectmapped and .fastrun */
                LDR     R1, =_etext
                LDR     R2, =_data
                LDR     R3, =_edata
LoopRel:        CMP     R2, R3
                LDRLO   R0, [R1], #4
                STRLO   R0, [R2], #4
                BLO     LoopRel

/* Clear .bss section (Zero init) */
                MOV     R0, #0
                LDR     R1, =__bss_start__
                LDR     R2, =__bss_end__
LoopZI:         CMP     R1, R2
                STRLO   R0, [R1], #4
                BLO     LoopZI


/* call C++ constructors of global objects */
		LDR 	r0, =__ctors_start__
		LDR 	r1, =__ctors_end__
ctor_loop:
		CMP 	r0, r1
		BEQ 	ctor_end
		LDR 	r2, [r0], #4
		STMFD 	sp!, {r0-r1}
		MOV 	lr, pc
/*		MOV 	pc, r2 */
		BX r2 /* mthomas 8/2006 */
		LDMFD 	sp!, {r0-r1}
		B 		ctor_loop
ctor_end:

/* rup: Set up fast interrupt and interrupt functions */
/* Mapped to handler(s) in HplAT91InterruptM.nc */
		ldr     r0, =AT91C_BASE_AIC
		add     r0, r0, #AIC_SVR
		ldr	r1, =fiqhandler
		str     r1, [r0], #4 	/* store the fiqhandler address in AIC_SVR[0] */
		ldr	r1, =irqhandler
		mov     r2, #31
		cmp     r2, #0		/* just in case we want to this "mov     r2, #0" (see above) */
		beq     Svr_done
Svr_loop:		
		str     r1, [r0]	/* store the irqhandler address in AIC_SVR[1..31] */ /*rup: removed ,#4 to test */
		add     r0, r0, #4
		subs    r2, r2, #1
		bne     Svr_loop

Svr_done: /* call main() */
		ldr	lr,=exit
		ldr	r0,=main
// rup test
//ldr	r0, =irqhandler
/* rup: test irqhandler */
		bx	r0

        .size   _startup, . - _startup
        .endfunc

/* "exit" dummy added by mthomas to avoid sbrk write read etc. needed
   by the newlib default "exit" */
        .global exit
        .func   exit
exit:
        b    .
        .size   exit, . - exit
        .endfunc




/*------------------------------------------------------------------------------
//*- Manage exception
//*---------------
//*- This module The exception must be ensure in ARM mode
//*------------------------------------------------------------------------------
//*------------------------------------------------------------------------------
//*- Function             : IRQ_Handler_Entry
//*- Treatments           : IRQ Controller Interrupt Handler.
//*- Called Functions     : AIC_IVR[interrupt] 
//*------------------------------------------------------------------------------*/

.if (VECTREMAPPED)
.print "IRQ_Handler_Entry in section .fastrun -> .data"
.section .fastrun, "ax"
.else
.print "IRQ_Handler_Entry in section .init -> .text"
.section .init, "ax"
.endif

        .global IRQ_Handler_Entry
        .func   IRQ_Handler_Entry
IRQ_Handler_Entry:
/*---- Adjust and save return address on the stack */
    sub     lr, lr, #4
    stmfd   sp!, {lr}

/*---- Save r0 and SPSR on the stack */
    mrs     r14, SPSR
    stmfd   sp!, {r0, r14}

/*---- Write in the IVR to support Protect mode */
/*---- No effect in Normal Mode */
/*---- De-assert NIRQ and clear the source in Protect mode */
    ldr     r14, =AT91C_BASE_AIC
    ldr     r0, [r14, #AIC_IVR]
    str     r14, [r14, #AIC_IVR]

/*---- Enable nested interrupts and switch to Supervisor mode */
    msr     CPSR_c, #ARM_MODE_SVC

/*---- Save scratch/used registers and LR on the stack */
    stmfd   sp!, {r1-r3, r12, r14}

/*---- Branch to the routine pointed by AIC_IVR */
    //rup: Always irqhandler as set up in this file
    mov     r14, pc
    bx      r0

/*---- Restore scratch/used registers and LR from the stack */
    ldmia   sp!, {r1-r3, r12, r14}

/*---- Disable nested interrupts and switch back to IRQ mode */
    msr     CPSR_c, #I_BIT | ARM_MODE_IRQ

/*---- Acknowledge interrupt by writing AIC_EOICR */
    ldr     r14, =AT91C_BASE_AIC
    str     r14, [r14, #AIC_EOICR]

/*---- Restore SPSR and r0 from the stack */
    ldmia   sp!, {r0, r14}
    msr     SPSR_cxsf, r14

/*---- Return from interrupt handler */
    ldmia   sp!, {pc}^

        .size   IRQ_Handler_Entry, . - IRQ_Handler_Entry
        .endfunc


/*---------------------------------------------------------------
//* ?EXEPTION_VECTOR
//* This module is only linked if needed for closing files.
//*---------------------------------------------------------------*/
//PIOPER:        .word   0xFFFFF400
//PIOOER:	.word   0xFFFFF410
//PIOCODR:	.word   0xFFFFF434	
//LEDVAL:	.word   0x00000002


        .global AT91F_Default_FIQ_handler
        .func   AT91F_Default_FIQ_handler
AT91F_Default_FIQ_handler:
            b     AT91F_Default_FIQ_handler
        .size   AT91F_Default_FIQ_handler, . - AT91F_Default_FIQ_handler
        .endfunc

        .global AT91F_Default_IRQ_handler
        .func   AT91F_Default_IRQ_handler
AT91F_Default_IRQ_handler:
//rup toggle
//ldr	r0, PIOPER
//ldr	r1, LEDVAL
//str	r1, [r0]
//ldr	r0, PIOOER
//str	r1, [r0]
//ldr	r0, PIOCODR
//str	r1, [r0]
//            b     AT91F_Default_IRQ_handler
        b     AT91F_Default_IRQ_handler
        .size   AT91F_Default_IRQ_handler, . - AT91F_Default_IRQ_handler
        .endfunc

        .global AT91F_Spurious_handler
        .func   AT91F_Spurious_handler
AT91F_Spurious_handler:
        b     AT91F_Spurious_handler
        .size   AT91F_Spurious_handler, . - AT91F_Spurious_handler
        .endfunc

        .end
