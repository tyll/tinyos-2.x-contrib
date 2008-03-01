/*
 * Copyright (c) 2007 nxtmote project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of nxtmote project nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

#include "c_input.iom"
#include "d_input.r"


module HplInputP {

  provides {
    interface HplInput;
  }
}
implementation {
	command void HplInput.dInputInit()
	{
		INPUTInit;
	}


	command void HplInput.dInputGetRawAd(UWORD *pValues, UBYTE No)
	{
		INPUTGetVal(pValues, No);
	}


	command void HplInput.dInputSetDirOutDigi0(UBYTE Port)
	{
		INPUTSetOutDigi0(Port);
	}

	command void HplInput.dInputSetDirOutDigi1(UBYTE Port)
	{
		INPUTSetOutDigi1(Port);
	}

	command void HplInput.dInputSetDirInDigi0(UBYTE Port)
	{
		INPUTSetInDigi0(Port);
	}

	command void HplInput.dInputSetDirInDigi1(UBYTE Port)
	{
		INPUTSetInDigi1(Port);
	}

	command void HplInput.dInputClearDigi0(UBYTE Port)
	{
		INPUTClearDigi0(Port);
	}

	command void HplInput.dInputClearDigi1(UBYTE Port)
	{
		INPUTClearDigi1(Port);
	}

	command void HplInput.dInputSetDigi0(UBYTE Port)
	{
		INPUTSetDigi0(Port);
	}

	command void HplInput.dInputSetDigi1(UBYTE Port)
	{
		INPUTSetDigi1(Port);
	}

	command void HplInput.dInputRead0(UBYTE Port, UBYTE *pData)
	{
		INPUTReadDigi0(Port, pData);
	}

	command void HplInput.dInputRead1(UBYTE Port, UBYTE * pData)
	{
		INPUTReadDigi1(Port, pData);
	}

	command void HplInput.dInputSetActive(UBYTE Port)
	{
		INPUTSetActive(Port);
	}

	command void HplInput.dInputSet9v(UBYTE Port)
	{
		INPUTSet9v(Port);
	}

	command void HplInput.dInputSetInactive(UBYTE Port)
	{
		INPUTSetInactive(Port);
	}


	command void HplInput.dInputExit()
	{
		INPUTExit;
	}

}
