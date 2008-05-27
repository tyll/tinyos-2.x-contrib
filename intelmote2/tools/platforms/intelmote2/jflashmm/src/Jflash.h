/******************************************************************************
**
**  COPYRIGHT (C) 2000, 2001, 2002 Intel Corporation.
**
**  The information in this file is furnished for informational use 
**  only, is subject to change without notice, and should not be construed as 
**  a commitment by Intel Corporation. Intel Corporation assumes no 
**  responsibility or liability for any errors or inaccuracies that may appear 
**  in this document or any software that may be provided in association with 
**  this document. 
**
**  FILENAME:       Jflash.h
**
**  PURPOSE:        General header for the Jflash utility
**
**  LAST MODIFIED:  $Modtime: 2/27/03 11:34a $
******************************************************************************/
#include<string.h>
#define VERSION_MAX_LENGTH	11

char VERSION[VERSION_MAX_LENGTH] = {"5.01.003"};


enum CABLE_TYPES			// The different cable types Jflash currently supports
	{
		Insight_Jtag,
		Parallel_Jtag,
		Wiggler_Jtag
	};


#define LPT1 0x3bc	// hardware base address for parallel port
#define LPT2 0x378	// the search order is LPT1 then 2 then 3
#define LPT3 0x278	// first valid address found is used (re-order if needed for multiple ports)


#define READ 0		// Flags used to modify the SA-1110 JTAG chain data depending on
#define WRITE 1		// the access mode of the Flash Memory
#define SETUP 2
#define HOLD 3
#define RS 4
#define K3 5		// Added for Bulverde/Dimebox

#define ENABLE 1
#define DISABLE 0

#define DRIVE 0
#define HIZ 1    // high Z (impedance)

#define IGNORE_PORT 0		// Flag used when accessing the parallel port
#define READ_PORT 1		    // READ_PORT = 'read port', IGNORE_PORT = 'ignore port', 
                            //   using IGNORE_PORT will speed access
#define IP IGNORE_PORT
#define RP READ_PORT

#define CONTINUE    0       // not the last instruction
#define TERMINATE   1       // this is the last instruction, so go to EXIT-1 IR


#define MAX_IN_LENGTH _MAX_PATH // max length for user input strings
#define STATUS_UPDATE 2	// time between updates of program/verify status in seconds


#define FIRST_HALF_WORD_MASK	0x0000FFFF

