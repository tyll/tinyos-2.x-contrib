/*
 * Copyright (c) 2007 nxtmote project
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
 *   Neither the name of nxtmote project nor the names of its
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
 * BlueCore 4 Hpl module.
 * @author Rasmus Ulslev Pedersen
 * Based on NXT files.
 */

#include "d_bt.h"
#include "d_bt.r"

enum
{
  BT_FAST_TIMEOUT   = 500,
  BT_CMD_TIMEOUT_2S = 2000,
  BT_TIMEOUT_30S    = 30000
};

#define   SETTimeout(TOut)              CmdTOut      = 0;\
                                        CmdTOutLimit = TOut
#define   RESETTimeout                  CmdTOut      = 0

//#define   STREAM_MODE                   1
//#define   CMD_MODE                      2

module HplBc4M {
  provides {
    interface HplBc4;
  }
  
}

implementation {
  static    UWORD CmdTOut;
  static    UWORD CmdTOutLimit;
 /* 
	void      dBtInit();
	void      dBtExit();
	void      dBtStartADConverter();
	void      dBtSetArm7CmdSignal();
	void      dBtClearArm7CmdSignal();
	void      dBtInitReceive(UBYTE *InputBuffer, UBYTE Mode);
	void      dBtSetBcResetPinLow();
	void      dBtSetBcResetPinHigh();
	void      dBtSendBtCmd(UBYTE Cmd, UBYTE Param1, UBYTE Param2, UBYTE *pBdAddr, UBYTE *pName, UBYTE *pCod, UBYTE *pPin);
	void      dBtSendMsg(UBYTE *pData, UBYTE Length, UWORD MsgSize);
	void      dBtSend(UBYTE *pData, UBYTE Length);
	void      dBtResetTimeOut();
	void      dBtClearTimeOut();
	UBYTE     dBtGetBc4CmdSignal();
	UWORD     dBtTxEnd();
	UWORD     dBtReceivedData(UWORD *pLength, UWORD *pBytesToGo);
	UWORD     dBtCheckForTxBuf();  
*/  
  command error_t HplBc4.doIt(){
    error_t error = SUCCESS;
    
    call HplBc4.dBtInit();
    
    return error;
  }
  
  command void HplBc4.dBtInit()
	{
	  SETTimeout(0);
	  BTInit;
	  BTInitPIOPins;			
	  BTInitADC;
  }
  
	command void HplBc4.dBtSetBcResetPinLow()
	{
		BTSetResetLow;			/* Set Reset pin to Bluecore chip low */
	}

	command void HplBc4.dBtSetBcResetPinHigh()
	{
		BTSetResetHigh;			/* Set Reset pin to Bluecore chip high */
	}

	command void HplBc4.dBtStartADConverter()
	{
		BTStartADConverter;
	}

	command void HplBc4.dBtInitReceive(UBYTE *InputBuffer, UBYTE Mode)
	{
		BTInitReceiver(InputBuffer, Mode);
	}

	command void HplBc4.dBtSetArm7CmdSignal()
	{
		BT_SetArm7CmdPin;
	}

	command void HplBc4.dBtClearArm7CmdSignal()
	{
		BT_ClearArm7CmdPin;	
	}

	command UBYTE HplBc4.dBtGetBc4CmdSignal()
	{
		UWORD ADValue;

		BTReadADCValue(ADValue);

		if (ADValue > 0x200)
		{
			ADValue = 1;
		}
		else
		{
			ADValue = 0;
		}	
		return(ADValue);
	}


	command UWORD HplBc4.dBtTxEnd()
	{
		UWORD   TxEnd;

		REQTxEnd(TxEnd);

		return(TxEnd);

	}

	command UWORD HplBc4.dBtCheckForTxBuf()
	{
		UWORD   AvailBytes;

		AVAILOutBuf(AvailBytes);

		return(AvailBytes);
	}

	command void HplBc4.dBtSendMsg(UBYTE *OutputBuffer, UBYTE BytesToSend, UWORD MsgSize)
	{

		/* Used for sending a complete message that can be placed in the buffer -     */
		/* or to send the first part of a message that cannot be placed in the buffer */
		/* once (bigger than the buffer)                                              */
		BTSendMsg(OutputBuffer,BytesToSend, MsgSize);
	}

	command void HplBc4.dBtSend(UBYTE *OutputBuffer, UBYTE BytesToSend)
	{

		/* Used for continous stream of data to be send */
		BTSend(OutputBuffer, BytesToSend);
	}

	command UWORD HplBc4.dBtReceivedData(UWORD *pLength, UWORD *pBytesToGo)
	{
		UWORD    RtnVal;

		RtnVal = TRUE;
		BTReceivedData(pLength, pBytesToGo);
		if (*pLength)
		{
//{togglepin(0);}
			SETTimeout(0);
		}
		else
		{
			if (CmdTOut < CmdTOutLimit)
			{
				CmdTOut++;
				if (CmdTOut >= CmdTOutLimit)
				{
					SETTimeout(0);
					RtnVal = FALSE;
				}
			}
		}
		return(RtnVal);
	}

	command void HplBc4.dBtResetTimeOut()
	{
		RESETTimeout;
	}

	command void HplBc4.dBtClearTimeOut()
	{
		SETTimeout(0);
	}

	command void HplBc4.dBtSendBtCmd(UBYTE Cmd, UBYTE Param1, UBYTE Param2, UBYTE *pBdAddr, UBYTE *pName, UBYTE *pCod, UBYTE *pPin)
	{
		UBYTE   Tmp;
		UBYTE   SendData;
		UWORD   CheckSumTmp;
		UBYTE   BtOutBuf[128];
		UBYTE   BtOutCnt;

		SendData = 0;
		BtOutCnt = 0;
		switch (Cmd)
		{
			case MSG_BEGIN_INQUIRY:
			{
				BtOutBuf[BtOutCnt++] = MSG_BEGIN_INQUIRY;
				BtOutBuf[BtOutCnt++] = Param1;
				BtOutBuf[BtOutCnt++] = 0x00;
				BtOutBuf[BtOutCnt++] = Param2;
				BtOutBuf[BtOutCnt++] = 0x00;
				BtOutBuf[BtOutCnt++] = 0x00;
				BtOutBuf[BtOutCnt++] = 0x00;
				BtOutBuf[BtOutCnt++] = 0x00;

				SendData = 1;
				SETTimeout(BT_TIMEOUT_30S);
			}
			break;

			case MSG_CANCEL_INQUIRY:
			{
				BtOutBuf[BtOutCnt++] = MSG_CANCEL_INQUIRY;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_CONNECT:
			{
				BtOutBuf[BtOutCnt++] = MSG_CONNECT;
				memcpy(&(BtOutBuf[BtOutCnt]), pBdAddr, SIZE_OF_BDADDR);
				BtOutCnt            += SIZE_OF_BDADDR;

				SendData = 1;
				SETTimeout(BT_TIMEOUT_30S);
			}
			break;

			case MSG_OPEN_PORT:
			{
				BtOutBuf[BtOutCnt++] = MSG_OPEN_PORT;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_LOOKUP_NAME:
			{
				BtOutBuf[BtOutCnt++] = MSG_LOOKUP_NAME;
				memcpy(&(BtOutBuf[BtOutCnt]), pBdAddr, SIZE_OF_BDADDR);
				BtOutCnt            += SIZE_OF_BDADDR;

				SendData = 1;
				SETTimeout(BT_TIMEOUT_30S);
			}
			break;

			case MSG_ADD_DEVICE:
			{
				BtOutBuf[BtOutCnt++] = MSG_ADD_DEVICE;
				memcpy(&(BtOutBuf[BtOutCnt]), pBdAddr, SIZE_OF_BDADDR);
				BtOutCnt += SIZE_OF_BDADDR;
				memcpy(&(BtOutBuf[BtOutCnt]), pName, SIZE_OF_BT_NAME);
				BtOutCnt += SIZE_OF_BT_NAME;
				memcpy(&(BtOutBuf[BtOutCnt]), pCod, SIZE_OF_CLASS_OF_DEVICE);
				BtOutCnt += SIZE_OF_CLASS_OF_DEVICE;

				SendData = 1;
				SETTimeout(BT_TIMEOUT_30S);
			}
			break;

			case MSG_REMOVE_DEVICE:
			{
				BtOutBuf[BtOutCnt++] = MSG_REMOVE_DEVICE;
				memcpy(&(BtOutBuf[BtOutCnt]), pBdAddr, SIZE_OF_BDADDR);
				BtOutCnt            += SIZE_OF_BDADDR;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_DUMP_LIST:
			{
				BtOutBuf[BtOutCnt++] = MSG_DUMP_LIST;

				SendData = 1;
				SETTimeout(BT_TIMEOUT_30S);
			}
			break;

			case MSG_CLOSE_CONNECTION:
			{
				BtOutBuf[BtOutCnt++] = MSG_CLOSE_CONNECTION;
				BtOutBuf[BtOutCnt++] = Param1;

				SendData = 1;
				SETTimeout(BT_TIMEOUT_30S);
			}
			break;

			case MSG_ACCEPT_CONNECTION:
			{
				BtOutBuf[BtOutCnt++] = MSG_ACCEPT_CONNECTION;
				BtOutBuf[BtOutCnt++] = Param1;

				SendData = 1;
				SETTimeout(BT_TIMEOUT_30S);
			}
			break;

			case MSG_PIN_CODE:
			{
				BtOutBuf[BtOutCnt++] = MSG_PIN_CODE;
				memcpy(&(BtOutBuf[BtOutCnt]), pBdAddr, SIZE_OF_BDADDR);
				BtOutCnt            += SIZE_OF_BDADDR;
				memcpy(&(BtOutBuf[BtOutCnt]), pPin, SIZE_OF_BT_PINCODE);
				BtOutCnt            += SIZE_OF_BT_PINCODE;

				SendData = 1;
				SETTimeout(BT_TIMEOUT_30S);
			}
			break;

			case MSG_OPEN_STREAM:
			{
				BtOutBuf[BtOutCnt++] = MSG_OPEN_STREAM;
				BtOutBuf[BtOutCnt++] = Param1;

				SendData = 1;
				SETTimeout(BT_TIMEOUT_30S);
			}
			break;

			case MSG_START_HEART:
			{
				BtOutBuf[BtOutCnt++] = MSG_START_HEART;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_SET_DISCOVERABLE:
			{
				BtOutBuf[BtOutCnt++] = MSG_SET_DISCOVERABLE;
				BtOutBuf[BtOutCnt++] = Param1;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_CLOSE_PORT:
			{
				BtOutBuf[BtOutCnt++] = MSG_CLOSE_PORT;
				BtOutBuf[BtOutCnt++] = 0x03;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_SET_FRIENDLY_NAME:
			{
				BtOutBuf[BtOutCnt++] = MSG_SET_FRIENDLY_NAME;
				memcpy(&(BtOutBuf[BtOutCnt]), pName, SIZE_OF_BT_NAME);
				BtOutCnt += SIZE_OF_BT_NAME;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_GET_LINK_QUALITY:
			{
				BtOutBuf[BtOutCnt++] = MSG_GET_LINK_QUALITY;
				BtOutBuf[BtOutCnt++] = Param1;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_SET_FACTORY_SETTINGS:
			{
				BtOutBuf[BtOutCnt++] = MSG_SET_FACTORY_SETTINGS;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_GET_LOCAL_ADDR:
			{
				BtOutBuf[BtOutCnt++] = MSG_GET_LOCAL_ADDR;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_GET_FRIENDLY_NAME:
			{
				BtOutBuf[BtOutCnt++] = MSG_GET_FRIENDLY_NAME;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_GET_DISCOVERABLE:
			{
				BtOutBuf[BtOutCnt++] = MSG_GET_DISCOVERABLE;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_GET_PORT_OPEN:
			{
				BtOutBuf[BtOutCnt++] = MSG_GET_PORT_OPEN;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_GET_VERSION:
			{
				BtOutBuf[BtOutCnt++] = MSG_GET_VERSION;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_GET_BRICK_STATUSBYTE:
			{
				BtOutBuf[BtOutCnt++] = MSG_GET_BRICK_STATUSBYTE;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;

			case MSG_SET_BRICK_STATUSBYTE:
			{
				BtOutBuf[BtOutCnt++] = MSG_SET_BRICK_STATUSBYTE;
				BtOutBuf[BtOutCnt++] = Param1;
				BtOutBuf[BtOutCnt++] = Param2;

				SendData = 1;
				SETTimeout(BT_FAST_TIMEOUT);
			}
			break;
		}

		if (SendData == 1)
		{
			CheckSumTmp = 0;
			for(Tmp = 0; Tmp < BtOutCnt; Tmp++)
			{
				CheckSumTmp += BtOutBuf[Tmp];
			}
			CheckSumTmp = (UWORD) (1 + (0xFFFF - CheckSumTmp));
			BtOutBuf[BtOutCnt++] = (UBYTE)((CheckSumTmp & 0xFF00)>>8);
			BtOutBuf[BtOutCnt++] = (UBYTE)(CheckSumTmp & 0x00FF);
			BTSendMsg(BtOutBuf, BtOutCnt, (UWORD)BtOutCnt);
		}
	}



	command void HplBc4.dBtExit()
	{
		BTExit;
	}
  
}
