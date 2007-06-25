/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
* 
*/

#ifndef DSNTEST_H
#define DSNTEST_H

enum {
	BSL_RX_DATA = 0x12,
	BSL_ERASE_SEGMENT = 0x16,
	BSL_MASS_ERASE = 0x18,
	BSL_LOAD_PC = 0x1a,
	BSL_RX_PWD = 0x10,
	BSL_TX_BSLVERSION = 0x1e,
	BSL_TX_DATA = 0x14,
	BSL_ERASE_CHECK = 0x1c,
	BSL_CHANGE_BAUDRATE = 0x20,
	
	RESET_ADDR = 0xfffe,
	ID_ADDR = 0xfe00,
	
	BSL_VERSION_HI = 0x01,
	BSL_VERSION_LO = 0xa5,
	DSN_BOOT_START = 0xf200,
	DSN_BOOT_LAST_SEGMENT = 0xfdff,
	DSN_BOOT_PROGRAM_SEGMENT = 0x4000
};

typedef nx_struct myMsg {
	nx_uint16_t myId;
	nx_uint16_t seqNr;	
} myMsg;

#endif
