/******************************************************************************
*                                                                             *
*        **********                                                           *
*       ************                                                          *
*      ***        ***                                                         *
*     ***    ++    ***                                                        *
*     ***   +  +   ***                      CHIPCON                           *
*     ***   +                                                                 *
*     ***   +  +   ***                                                        *
*     ***    ++    ***                                                        *
*      ***        ***                                                         *
*       ************                                                          *
*        **********                                                           *
*                                                                             *
*******************************************************************************

Filename:     flashErasePage.s51
Target:       cc2430
Author:       EFU
Revised:      16/12-2005
Revision:     1.0
******************************************************************************/
;;-----------------------------------------------------------------------------
;; See hal.h for a description of this function.
;;-----------------------------------------------------------------------------

; Standard SFR Symbols 
DPL1	DATA	084H
DPH1	DATA	085H
DPS	DATA	092H
FWT	DATA	0ABH
FADDRL	DATA	0ACH
FADDRH	DATA	0ADH
FCTL	DATA	0AEH
FWDATA	DATA	0AFH
MEMCTR	DATA	0C7H
CLKCON	DATA	0C6H


NAME	flashErasePage

RCODE   SEGMENT CODE
	PUBLIC	_HPLFLASHERASEPAGE

	RSEG  RCODE

_HPLFLASHERASEPAGE:

 
                ; R1 (LSB) and R2 (MSB) contains the start address of the buffer from which the program can be run in RAM

                ; Make sure that interrupts are off
                MOV     R3, #01;
                JBC     EA, intsOffHere;
                MOV     R3, #00;
intsOffHere:

                ; Storing the initial data pointer select.
                PUSH    DPH;
                PUSH    DPL;
                PUSH    DPH1;
                PUSH    DPL1;
                PUSH    DPS;

                ; Set DPTR0 = address in XDATA RAM to which the flash write procedure which is to be copied.
                MOV     A, R2;
                MOV     DPH, A;
                MOV     A, R1;
                MOV     DPL, A;

                ; Saving the start address of the actual flash write procedure in XDATA RAM.
                PUSH    DPL;
                PUSH    DPH;

                ; Set DPTR1 = start address of the procedure template in CODE
                ; This procedure is to be copied to XDATA.
                MOV     DPH1, #HIGH(eraseFlashProcStart);
                MOV     DPL1, #LOW(eraseFlashProcStart);

                ; Use B to count loops...
                MOV     B, #eraseFlashProcEnd - eraseFlashProcStart;

                ; Copy @DPTR1->@DPTR0
copyLoop:       MOV     DPS, #1;
                MOVX    A, @DPTR;
                INC     DPTR;
                MOV     DPS, #0;
                MOVX    @DPTR, A;
                INC     DPTR;
                DJNZ    B, copyLoop;

                ; Setting the flash write timing according to the clock division factor in CLKCON.
                MOV     A, CLKCON
                ANL     A, #07H
                MOV     B, A
                INC     B
                MOV     A, #054H

rotate:         CLR     C
                RRC     A
                DJNZ    B, rotate

                MOV     FWT, A

                ; Data pointer 0 indicates where the start of the copied routine in XDATA is located.
                ; Pointer to start of data to copy is in data pointer 1.
                MOV     DPS, #0;
                POP     DPH;
                POP     DPL;

exit:                ; Using the original data pointer
                POP     DPS;
                POP     DPL1;
                POP     DPH1;
                POP     DPL;
                POP     DPH;

                MOV     A, R3;
                JZ      intsWereOff;
                SETB    EA;
intsWereOff:
                RET;


eraseFlashProcStart:
                ; Erasing the page
                MOV     FCTL, #01H
                NOP

waitEraseLoop:  MOV     A, FCTL
                ANL     A, #80H
                JNZ     waitEraseLoop

done:           RET;

eraseFlashProcEnd:
                END;
                

