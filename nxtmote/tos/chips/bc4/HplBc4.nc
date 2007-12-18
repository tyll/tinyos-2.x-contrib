/*
 * Copyright (c) 2007 Copenhagen Business School (CBS)
 * All rights reserved. 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *	Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *	Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *  
 *   Neither the name of CBS nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE ARCHED
 * ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
 * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 */
/**
 * BlueCore 4 Hpl Interface.
 * @author Rasmus Ulslev Pedersen
 * Based on NXT source files.
 */
interface HplBc4 {
  command error_t doIt();

	command void dBtInit();
	command void dBtExit();
	command void dBtStartADConverter();
	command void dBtSetArm7CmdSignal();
	command void dBtClearArm7CmdSignal();
	command void dBtInitReceive(UBYTE *InputBuffer, UBYTE Mode);
	command void dBtSetBcResetPinLow();
	command void dBtSetBcResetPinHigh();
	command void dBtSendBtCmd(UBYTE Cmd, UBYTE Param1, UBYTE Param2, UBYTE *pBdAddr, UBYTE *pName, UBYTE *pCod, UBYTE *pPin);
	command void dBtSendMsg(UBYTE *pData, UBYTE Length, UWORD MsgSize);
	command void dBtSend(UBYTE *pData, UBYTE Length);
	command void dBtResetTimeOut();
	command void dBtClearTimeOut();
	command UBYTE dBtGetBc4CmdSignal();
	command UWORD dBtTxEnd();
	command UWORD dBtReceivedData(UWORD *pLength, UWORD *pBytesToGo);
	command UWORD dBtCheckForTxBuf();   
}
