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

?XD?my_seg SEGMENT XDATA                ; define a SEGMENT of class XDATA
  	PUBLIC	REGISTER_R0
  	PUBLIC	REGISTER_R1
	PUBLIC	REGISTER_R2
	PUBLIC	REGISTER_R3
	PUBLIC	REGISTER_R4
	PUBLIC	REGISTER_R5
	PUBLIC	REGISTER_R6
	PUBLIC	REGISTER_R7
           RSEG    ?XD?my_seg
REGISTER_R0:	DS	1
REGISTER_R1:	DS	1
REGISTER_R2:	DS	1
REGISTER_R3:	DS	1
REGISTER_R4:	DS	1
REGISTER_R5:	DS	1
REGISTER_R6:	DS	1
REGISTER_R7:	DS	1


NAME	flashWritePage

RCODE   SEGMENT CODE
	PUBLIC	_HPLFLASHWRITEPAGE

	RSEG  RCODE

_HPLFLASHWRITEPAGE:

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
                MOV     DPH1, #HIGH(writeFlashProcStart);
                MOV     DPL1, #LOW(writeFlashProcStart);

                ; Use B to count loops...
                MOV     B, #writeFlashProcEnd - writeFlashProcStart;

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


writeFlashProcStart:

begin:
                ; Turn off interrupts if not already off - save state in R3
                MOV     R3, #01;
                JBC     EA, interruptsOff;
                MOV     R3, #00;
interruptsOff:

                ; Storing the initial data pointer select.
                PUSH    DPH;
                PUSH    DPL;
                PUSH    DPH1;
                PUSH    DPL1;
                PUSH    DPS;

		; Setting up source pointer in DP0
                MOV     A, R2;
                MOV     DPH, A;
                MOV     A, R1;
                MOV     DPL, A;
                
                ; Select DP0
                MOV     DPS, #0;                

		; Wait if flash is busy
waitEraseLoop:  MOV     A, FCTL
                ANL     A, #80H
                JNZ     waitEraseLoop

                ; Turning on flash write.
                MOV     FCTL,#02H

                ; Writing data
                ; if high byte is zero - jump to low byte
		MOV	A, R4
		JZ	writeLow

		/**************************************************************
		* write blocks of 256 bytes from high byte R4 
		**************************************************************/
writeHigh:			
		; write 256 byte blocks
			MOV R2, #40H
writeHighBlock:				MOV 	R1, #04H
writeHighByte:				MOVX    A, @DPTR
                                        INC     DPTR
                                        MOV     FWDATA, A                                        
	                                DJNZ    R1, writeHighByte

				; Write dummy byte
				MOV FWDATA, #00H

waitHighLoop:                   MOV     A, FCTL
                                ANL     A, #40H
                                JNZ     waitHighLoop

                        DJNZ    R2, writeHighBlock
                DJNZ    R4,writeHigh
                
		/**************************************************************
		* Write low byte R5
		**************************************************************/
writeLow:
		; abort if R5 is zero
                MOV	A, R5
		JZ	flashWriteDone

		; writing 4 bytes at a time - divide R5 by 4
                MOV A, R5
                ANL A, #0FCH
		RR A
		RR A
		MOV R5, A

		; write less than 256 bytes
		
writeLowBlock:				MOV 	R1, #04H
writeLowByte:				MOVX    A, @DPTR
                                        INC     DPTR
                                        MOV     FWDATA, A                                        
	                                DJNZ    R1, writeLowByte

				; Write dummy byte
				MOV FWDATA, #00H

waitLowLoop:                    MOV     A, FCTL
                                ANL     A,#40H
                                JNZ     waitLowLoop

                        DJNZ    R5, writeLowBlock

flashWriteDone:
                ; Using the original data pointer
                POP     DPS;
                POP     DPL1;
                POP     DPH1;
                POP     DPL;
                POP     DPH;

		; Restore interrupt state from R3
                MOV     A, R3;
                JZ      interruptsWereOff;
                SETB    EA;

interruptsWereOff:

done:           RET;

writeFlashProcEnd:
                END;
                

