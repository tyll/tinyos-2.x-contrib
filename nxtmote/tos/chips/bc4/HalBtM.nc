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
 *  Neither the name of nxtmote project nor the names of its
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
 * BlueCore 4 Hal module.
 * @author Rasmus Ulslev Pedersen
 * Based on NXT files.
 */

// 1227: cCommReceivedBtData
// 1552: cCommUpdateBt()
// 3553: HalBt.cCommReq

#include "LCD.h"
#include "c_comm.h"
#include "c_comm.iom"
#include "d_bt.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define   UI_NAME_DEFAULT     "NXT"           // Default blue tooth name 

enum
{
  DEVICE_VERIFIED,
  DEVICE_UPDATED,
  DEVICE_INSERTED
};

#define   DEFAULTBTADR                  "\x00\x16\x53\xFF\xFF\xFF"
#define   BTSTREAMTOUT                  610

#define   LOOKUPNO                      3

#define   CLEARExtMode                  {\
                                          UBYTE Tmp2;\
                                          for(Tmp2 = 0; Tmp2 < NO_OF_CHANNELS; Tmp2++)\
                                          {\
                                            VarsComm.ExtMode[Tmp2].Status = FALSE;\
                                          }\
                                        }

#define   CHNumber(Bit)                 (Bit>>1)
#define   SETBtStateIdle                VarsComm.ActiveUpdate   = UPD_IDLE;\
                                        VarsComm.UpdateState    = 0;\
                                        VarsComm.StreamStateCnt = 0;\
                                        VarsComm.CmdSwitchCnt   = 0;\
                                        VarsComm.CloseConn0Cnt  = 0;\
                                        VarsComm.DiscAllCnt     = 0;\
                                        VarsComm.ResetBtCnt     = 0

#define   SETBtCmdState                 VarsComm.BtState           = BT_ARM_CMD_MODE;\
                                        IOMapComm.BtInBuf.InPtr    = 0;\
                                        CLEARExtMode;\
                                        call HplBc4.dBtClearArm7CmdSignal();\
                                        call HplBc4.dBtInitReceive(VarsComm.BtModuleInBuf.Buf, (UBYTE)CMD_MODE);

#define   SETBtDataState                IOMapComm.BtInBuf.InPtr  = 0;\
                                        VarsComm.BtState         = BT_ARM_DATA_MODE;\
                                        call HplBc4.dBtClearTimeOut(); /* stop cmd timeout because in datamode  */\
                                        call HplBc4.dBtSetArm7CmdSignal();\
                                        call HplBc4.dBtInitReceive(VarsComm.BtModuleInBuf.Buf, (UBYTE)STREAM_MODE)

#define   SETBtOff                      VarsComm.BtState = BT_ARM_OFF;\
                                        call HplBc4.dBtSetBcResetPinLow()

#define   CLEARConnEntry(Index)         memset((IOMapComm.BtConnectTable[Index].BdAddr), 0, SIZE_OF_BDADDR);\
                                        memset(IOMapComm.BtConnectTable[Index].Name, 0, SIZE_OF_BT_NAME);\
                                        memset((IOMapComm.BtConnectTable[Index].ClassOfDevice), 0, SIZE_OF_CLASS_OF_DEVICE);\
                                        memset((IOMapComm.BtConnectTable[Index].PinCode), 0, SIZE_OF_BT_PINCODE);\
                                        IOMapComm.BtConnectTable[Index].HandleNr = BLUETOOTH_HANDLE_UNDEFIEND;\
                                        IOMapComm.BtConnectTable[Index].StreamStatus = 0;\
                                        IOMapComm.BtConnectTable[Index].LinkQuality = 0

#define   FILETXTOUT                    30000

module HalBtM {
  provides {
    interface HalBt;
  }
  
  uses {
    interface HplBc4;
    
    interface HplAT91Pit as PitTimer;
    
    interface HalLCD;
    
    interface Boot;
    
    interface BTIOMapComm;
    
    interface Init as BTInit;
  }
}

implementation {

	const     UBYTE BootString[] = {"Let's dance: SAMBA"};
	const     UBYTE NoName[SIZE_OF_BT_NAME] = {"No Name"};
	
	IOMAPCOMM  IOMapComm;
	VARSCOMM   VarsComm;
	
  uint8_t nxtindex;
  
//static    HEADER     **pHeaders;


//	const     HEADER       cComm =
//	{
//		0x00050001L,
//		"Comm",
//		cCommInit,
//		cCommCtrl,
//		cCommExit,
//		(void *)&IOMapComm,
//		(void *)&VarsComm,
//		(UWORD)sizeof(IOMapComm),
//		(UWORD)sizeof(VarsComm),
//		0x0000                      /* Code size - not used so far */
//	};

	void      cCommInit(void* pHeader);
	void      cCommCtrl();
	UWORD     cCommReceivedBtData();
	void      cCommBtCmdInterpreter();
	UWORD     cCommInterprete(UBYTE *pInBuf, UBYTE *pOutBuf, UBYTE *pLength, UBYTE CmdBit, UWORD MsgLength);
	UWORD     cCommInterpreteCmd(UBYTE Cmd, UBYTE *pInBuf, UBYTE *pOutBuf, UBYTE *pLength, UBYTE CmdBit, UWORD MsgLength);
	void      cCommCpyToUpper(UBYTE *pDst, UBYTE *pSrc, UBYTE Length);
	void      cCommCopyFileName(UBYTE *pDst, UBYTE *pSrc);
	void      cCommSendHiSpeedData();
	void      cCommReceivedHiSpeedData();
	//UWORD     cCommReq(UBYTE Cmd, UBYTE Param1, UBYTE Param2, UBYTE Param3, UBYTE *pName, UWORD *pRetVal);
	UBYTE     cCommBtValidateCmd();

  task void cCommUpdateTask();
  task void dataReceivedTask();

	void      cCommClearStreamStatus();
	void      cCommUpdateBt();
	UWORD     cCommCopyBdaddr(UBYTE *pDst, UBYTE *pSrc);
	UWORD     cCommInsertBtName(UBYTE *pDst, UBYTE *pSrc);
	UWORD     cCommCheckBdaddr(UBYTE *pAdr, UBYTE *pSrc);
	UWORD     cCommInsertDevice(UBYTE *pBdaddr, UBYTE *pName, UBYTE *pCod, UBYTE DeviceStatus, UBYTE *pAddInfo);
	void      cCommsSetCmdMode(UBYTE *pNextState);
	void      cCommsOpenStream(UBYTE *pNextState);
	void      cCommsCloseConn0(UBYTE *pNextState);
	void      cCommsDisconnectAll(UBYTE *pNextState);
	void      cCommsBtReset(UBYTE *pNextState);
	void      cCommPinCode(UBYTE *pPinCode);
	void      cCommClrConnTable();

  event void Boot.booted() {
    call BTIOMapComm.setIOMapCommAddr(&IOMapComm);
	  call BTInit.init();
	  cCommInit(NULL);
  }
  
  command error_t HalBt.sendMsg(uint8_t* msg){
	  error_t error = SUCCESS;
    return error;
  }

  command void HalBt.getFullControl(VARSCOMM** ppVarsComm, IOMAPCOMM** ppIOMapComm){
    *ppVarsComm = &VarsComm;
    *ppIOMapComm = &IOMapComm;
  }

	void cCommInit(void* pHeader)
	{
		UBYTE Tmp;

		//pHeaders                   = pHeader;
		//IOMapComm.pFunc            = &cCommReq;
		IOMapComm.pFunc2           = &cCommPinCode;
		IOMapComm.UsbState         = FALSE;
		IOMapComm.UsbOutBuf.OutPtr = 0;

		CLEARExtMode;

		//dUsbInit();
		call HplBc4.dBtInit();

		SETBtStateIdle;
		VarsComm.BtModuleInBuf.InPtr    = 0;
		VarsComm.BtWaitTimeCnt          = 0;

		/* Force a reset sequence on the BC4 */
		VarsComm.pRetVal                = &(VarsComm.RetVal);
		VarsComm.ActiveUpdate           = UPD_RESET;

		VarsComm.BtState                = BT_ARM_CMD_MODE;
		//IOMapComm.BrickData.BtHwStatus  = BT_DISABLE;
		IOMapComm.BrickData.BtHwStatus  = BT_ENABLE; //rup

		for (Tmp = 0; Tmp < SIZE_OF_BT_DEVICE_TABLE; Tmp++)
		{
			IOMapComm.BtDeviceTable[Tmp].DeviceStatus = BT_DEVICE_EMPTY;
		}
		IOMapComm.BtDeviceCnt = 0;
		IOMapComm.BrickData.BtStateStatus = 0;

		cCommClrConnTable();

		call HplBc4.dBtInitReceive(VarsComm.BtModuleInBuf.Buf, (UBYTE)CMD_MODE);
		call HplBc4.dBtStartADConverter();

		//dHiSpeedInit();
		VarsComm.HsState    = 0;

		IOMapComm.UsbPollBuf.InPtr  = 0;
		IOMapComm.UsbPollBuf.OutPtr = 0;

		VarsComm.BtAdrStatus = COLDBOOT;
	}

  task void cCommUpdateTask(){
	  cCommCtrl();
	  signal HalBt.btUpdateEvent(VarsComm.ActiveUpdate, VarsComm.UpdateState);
	}

	async event void PitTimer.fired(){
	  post cCommUpdateTask();
	}
	
	event void PitTimer.firedTask(uint32_t miss){
	}
	
	// Called by PIT timer each 1 ms
	void      cCommCtrl()
	{
		if (FALSE == cCommReceivedBtData())
		{
	  	  
			/* there has been a timeout on the BC4 channel */
			SETBtStateIdle;
			*(VarsComm.pRetVal) = BTTIMEOUT;
			if (COLDBOOT == VarsComm.BtAdrStatus)
			{

				/* there is an BT fatal error - set default bt adr and name*/
				strcpy((char*)IOMapComm.BrickData.Name, (char*)UI_NAME_DEFAULT);
				//dUsbStoreBtAddress((UBYTE*)DEFAULTBTADR);
				//pMapUi->Flags |= UI_REDRAW_STATUS;
				call HplBc4.dBtSetBcResetPinLow();
				VarsComm.BtAdrStatus = BTADRERROR;
			}
		}

		cCommUpdateBt();
		VarsComm.BtBcPinLevel = call HplBc4.dBtGetBc4CmdSignal();
		
		if (UPD_IDLE == VarsComm.ActiveUpdate)
		{
			switch (VarsComm.BtState) //Check
			{
				/* Bluetooth device can either be in CMD, DATA or OFF state at top level */
				case BT_ARM_OFF:
				{
				}
				break;
				case BT_ARM_CMD_MODE:
				{
					if (VarsComm.BtBcPinLevel)
					{
						SETBtDataState;
					}
				}
				break;

				case BT_ARM_DATA_MODE:
				{
					if (!(VarsComm.BtBcPinLevel))
					{
						SETBtCmdState;
					}
				}
				break;
			}

		}
		IOMapComm.BtInBuf.Buf[BT_CMD_BYTE] = 0;


		/* Here comes the the HIGHSPEED_PORT implementation */
		/*
		if (IOMapComm.HsFlags & HS_UPDATE)
		{
			IOMapComm.HsFlags &= ~HS_UPDATE;
			switch (IOMapComm.HsState)
			{
				case HS_INITIALISE:
				{
					dHiSpeedSetupUart();
					IOMapComm.HsState = HS_INIT_RECEIVER;
					IOMapComm.HsFlags |= HS_UPDATE;
				}
				break;

				case HS_INIT_RECEIVER:
				{
					dHiSpeedInitReceive(VarsComm.HsModuleInBuf.Buf);
					VarsComm.HsState = 0x01;
				}
				break;

				case HS_SEND_DATA:
				{
					cCommSendHiSpeedData();
				}
				break;

				case HS_DISABLE:
				{
					VarsComm.HsState = 0x00;
					dHiSpeedExit();
				}
				break;
			}
		}

		if (VarsComm.HsState != 0)
		{
			cCommReceivedHiSpeedData();
		}
    */
    
		/* Here comes the the USB implementation */
		/*
		ULONG   Length;
		UWORD   Status;

		if (0 != IOMapComm.UsbOutBuf.OutPtr)
		{
			dUsbWrite((const UBYTE *)IOMapComm.UsbOutBuf.Buf, (ULONG)IOMapComm.UsbOutBuf.OutPtr);
			IOMapComm.UsbOutBuf.OutPtr = 0;
		}

		Length = 0;

		if (TRUE == dUsbCheckConnection())
		{
			pMapUi->UsbState = 1;
			if (TRUE == dUsbIsConfigured())
			{
				Length = dUsbRead(IOMapComm.UsbInBuf.Buf, sizeof(IOMapComm.UsbInBuf.Buf));
				IOMapComm.UsbState = TRUE;
				pMapUi->UsbState = 2;
			}
		}
		else
		{
			pMapUi->UsbState = 0;
			dUsbResetConfig();
			if (TRUE == IOMapComm.UsbState)
			{
				IOMapComm.UsbState = FALSE;
				Status =  dUsbGetFirstHandle();
				while(0 == LOADER_ERR(Status))
				{
					IOMapComm.UsbInBuf.Buf[0] = LOADER_HANDLE(Status);
					pMapLoader->pFunc(CLOSE, &(IOMapComm.UsbInBuf.Buf[0]), &(IOMapComm.UsbInBuf.Buf[2]), &Length);
					dUsbRemoveHandle(IOMapComm.UsbInBuf.Buf[0]);
					Status = dUsbGetNextHandle();
				}
			}
		}

		if (0 != Length)
		{
			cCommInterprete(IOMapComm.UsbInBuf.Buf, IOMapComm.UsbOutBuf.Buf, (UBYTE*)&Length, USB_CMD_READY, (UWORD)Length);
			if (Length)
			{
				dUsbWrite((const UBYTE *)IOMapComm.UsbOutBuf.Buf, Length);
			}
		}
		*/
		call HplBc4.dBtStartADConverter();
	}

	void      cCommExit()
	{
		//dUsbExit();
		//dHiSpeedExit();
		call HplBc4.dBtExit();
	}

  
	UWORD     cCommInterprete(UBYTE *pInBuf, UBYTE *pOutBuf, UBYTE *pLength, UBYTE CmdBit, UWORD MsgLength)
	{
		UWORD   ReturnStatus;
		UBYTE   Channel;

		Channel = CHNumber(CmdBit);
		if (FALSE == VarsComm.ExtMode[Channel].Status)
		{

			switch (((pInBuf[0]) & ~NO_REPLY_BIT))
			{
				case SYSTEM_CMD:
				{
					ReturnStatus = cCommInterpreteCmd(pInBuf[1], &(pInBuf[1]), &(pOutBuf[2]), pLength, CmdBit, MsgLength);

					/* Check if reply is requested */
					if ((pInBuf[0]) & NO_REPLY_BIT)
					{

						/* Sender has choosen no reply */
						*pLength = 0;

						/* if extended mode then remember the reply bit */
						VarsComm.ExtMode[Channel].Type |= NO_REPLY_BIT;
					}
					else
					{

						/* Check if receiver wants to reply */
						if (*pLength)
						{
							(*pLength)+= 2;
							pOutBuf[0] = REPLY_CMD;
							pOutBuf[1] = pInBuf[1];
						}
					}
				}
				break;

				case DIRECT_CMD:
				{

					/* Adjust length to account for cmd type byte */
					(*pLength) -= 1;

					/* If no reply requested, pass NULL output buffer pointer and clear *pLength */
					if ((pInBuf[0]) & NO_REPLY_BIT)
					{
						//pMapCmd->pRCHandler(&(pInBuf[0]), NULL, pLength);
					}
					else
					{
						//pMapCmd->pRCHandler(&(pInBuf[0]), &(pOutBuf[2]), pLength);
						if (*pLength)
						{
							(*pLength) += 2;
							pOutBuf[0] = REPLY_CMD;
							pOutBuf[1] = pInBuf[1];
						}
					}
				}
				break;

				case REPLY_CMD:
				{

					/* If this is a reply to a direct command opcode, pRCHandler will handle it */
					if (pInBuf[1] < NUM_RC_OPCODES)
						//pMapCmd->pRCHandler(&(pInBuf[0]), NULL, pLength);

					/* No Reply ever required on REPLY_CMD messages */
					*pLength = 0;
				}
				break;

				default:
				{

					/* UNSUPPORTED - don't reply on these messages */
					*pLength = 0;
				}
				break;
			}

		}
		else
		{
			switch (VarsComm.ExtMode[Channel].Type & ~NO_REPLY_BIT)
			{
				case SYSTEM_CMD:
				{
					ReturnStatus = cCommInterpreteCmd(VarsComm.ExtMode[Channel].Cmd, &(pInBuf[0]), &(pOutBuf[2]), pLength, CmdBit, MsgLength);
					if ((VarsComm.ExtMode[Channel].Type) & NO_REPLY_BIT)
					{

						/* Sender has choosen no reply */
						*pLength = 0;
					}
					else
					{

						/* Check if receiver wants to reply */
						if (*pLength)
						{
							(*pLength) += 2;
							pOutBuf[0] = REPLY_CMD;
							pOutBuf[1] = VarsComm.ExtMode[Channel].Cmd;
						}
					}
				}
				break;
				case DIRECT_CMD:
				{
				}
				break;
				case REPLY_CMD:
				{
				}
				break;
				default:
				{
				}
				break;
			}
		}

		return(ReturnStatus);
	}

  //Handles SYSTEM_CMD in DATA mode
	UWORD     cCommInterpreteCmd(UBYTE Cmd, UBYTE *pInBuf, UBYTE *pOutBuf, UBYTE *pLength, UBYTE CmdBit, UWORD MsgLength)
	{
		ULONG   FileLength = 0;
		UWORD   Status = 0;
		UBYTE   Channel;

		Channel = CHNumber(CmdBit);
		switch(Cmd)
		{
			case OPENWRITE:
			{
				UBYTE TmpFilename[FILENAME_LENGTH + 1];

				FileLength  = pInBuf[21];
				FileLength += (ULONG)pInBuf[22] << 8;
				FileLength += (ULONG)pInBuf[23] << 16;
				FileLength += (ULONG)pInBuf[24] << 24;

				cCommCpyToUpper(TmpFilename, &pInBuf[1], (UBYTE)(FILENAME_LENGTH + 1));

				if ((0 != strstr((PSZ)(TmpFilename), ".RXE")) ||
						(0 != strstr((PSZ)(TmpFilename), ".SYS")) ||
						(0 != strstr((PSZ)(TmpFilename), ".RTM")))
				{
					//Status = pMapLoader->pFunc(OPENWRITELINEAR, &pInBuf[1], NULL, &FileLength);
				}
				else
				{
					//Status = pMapLoader->pFunc(OPENWRITE, &pInBuf[1], NULL, &FileLength);
				}
Status = 0;				
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = LOADER_HANDLE(Status);
				*pLength = 2;
				if ((SUCCESS == LOADER_ERR(Status)) && (CmdBit & USB_CMD_READY))
				{
					//dUsbInsertHandle(LOADER_HANDLE(Status));
				}
			}
			break;
			case WRITE:
			{

				if (FALSE == VarsComm.ExtMode[Channel].Status)
				{

					FileLength = *pLength - 3;
					//Status = pMapLoader->pFunc(WRITE, &(pInBuf[1]), &(pInBuf[2]), &FileLength);
Status = 0;					
					pOutBuf[2] = (UBYTE)(FileLength);
					pOutBuf[3] = (UBYTE)(FileLength >> 8);
					if ((*pLength != MsgLength) && (MsgLength != 0))
					{

						/* This is the beginnig of and extended write command*/
						VarsComm.ExtMode[Channel].Cmd    = WRITE;
						VarsComm.ExtMode[Channel].Type   = SYSTEM_CMD;
						VarsComm.ExtMode[Channel].Status = TRUE;
						VarsComm.ExtMode[Channel].Handle = LOADER_HANDLE(Status);
						*pLength = 0;
					}
					else
					{

						/* Normal write */
						pOutBuf[0] = LOADER_ERR_BYTE(Status);
						pOutBuf[1] = LOADER_HANDLE(Status);
						*pLength   = 4;
					}
				}
				else
				{
					UWORD TmpLen;
					FileLength = *pLength;
					//Status = pMapLoader->pFunc(WRITE, &(VarsComm.ExtMode[Channel].Handle), &(pInBuf[0]), &FileLength);
Status = 0;					
					TmpLen     = pOutBuf[3];
					TmpLen   <<= 8;
					TmpLen    |= pOutBuf[2];
					TmpLen    += FileLength;
					pOutBuf[2] = (UBYTE)(TmpLen);
					pOutBuf[3] = (UBYTE)(TmpLen >> 8);
					if (MsgLength)
					{

						/* Don't answer before complete message has been received */
						*pLength = 0;
					}
					else
					{

						/* Complete msg has been received */
						VarsComm.ExtMode[Channel].Status = FALSE;
						pOutBuf[0] = LOADER_ERR_BYTE(Status);
						pOutBuf[1] = LOADER_HANDLE(Status);
						*pLength   = 4;  /* Remember the 2 length bytes */

					}
				}

			}
			break;
			case OPENWRITEDATA:
			{
				FileLength  = pInBuf[21];
				FileLength += (ULONG)pInBuf[22] << 8;
				FileLength += (ULONG)pInBuf[23] << 16;
				FileLength += (ULONG)pInBuf[24] << 24;

				//Status = pMapLoader->pFunc(OPENWRITEDATA, &pInBuf[1], NULL, &FileLength);
Status = 0;				

				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = LOADER_HANDLE(Status);
				*pLength = 2;
				if ((SUCCESS == LOADER_ERR(Status)) && (CmdBit & USB_CMD_READY))
				{
					//dUsbInsertHandle(LOADER_HANDLE(Status));
				}
			}
			break;
			case OPENAPPENDDATA:
			{
				//Status = pMapLoader->pFunc(OPENAPPENDDATA, &pInBuf[1], NULL, &FileLength);
FileLength = 0;				
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = LOADER_HANDLE(Status);

				pOutBuf[2] = (UBYTE)FileLength;
				pOutBuf[3] = (UBYTE)(FileLength >> 8);
				pOutBuf[4] = (UBYTE)(FileLength >> 16);
				pOutBuf[5] = (UBYTE)(FileLength >> 24);
				*pLength = 6;
				if ((SUCCESS == LOADER_ERR(Status)) && (CmdBit & USB_CMD_READY))
				{
					//dUsbInsertHandle(LOADER_HANDLE(Status));
				}
			}
			break;
			case CLOSE:
			{
				if (CmdBit & USB_CMD_READY)
				{
					//dUsbRemoveHandle(pInBuf[1]);
				}
				//Status = pMapLoader->pFunc(CLOSE, &(pInBuf[1]), NULL, &FileLength);
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = LOADER_HANDLE(Status);
				*pLength = 2;
			}
			break;
			case OPENREAD:
			{
				//Status = pMapLoader->pFunc(OPENREAD, &pInBuf[1], NULL, &FileLength);
FileLength = 0;				
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = LOADER_HANDLE(Status);
				pOutBuf[2] = (UBYTE)FileLength;
				pOutBuf[3] = (UBYTE)(FileLength >> 8);
				pOutBuf[4] = (UBYTE)(FileLength >> 16);
				pOutBuf[5] = (UBYTE)(FileLength >> 24);
				*pLength = 6;
				if ((SUCCESS == LOADER_ERR(Status)) && (CmdBit & USB_CMD_READY))
				{
					//dUsbInsertHandle(LOADER_HANDLE(Status));
				}
			}
			break;
			case READ:
			{
				ULONG Length;

				FileLength   = pInBuf[3];
				FileLength <<= 8;
				FileLength  |= pInBuf[2];
				Length       = FileLength;

				/* Here test for channel - USB can only handle a 64 byte return (- wrapping )*/
				if (CmdBit & USB_CMD_READY)
				{
					if (FileLength > (SIZE_OF_USBBUF - 6))
					{

						/* Buffer cannot hold the requested data adjust to buffer size */
						FileLength = (SIZE_OF_USBBUF - 6);
					}
					*pLength   = FileLength + 4;
					//Status     = pMapLoader->pFunc(READ, &pInBuf[1], &pOutBuf[4], &FileLength);
					pOutBuf[0] = LOADER_ERR_BYTE(Status);
					pOutBuf[1] = LOADER_HANDLE(Status);
					pOutBuf[2] = (UBYTE)Length;
					pOutBuf[3] = (UBYTE)(Length >> 8);

					if (FileLength < Length)
					{

						/* End of file is detcted - add up with zeros to the requested msg length */
						Length -= FileLength;
						memset(&(pOutBuf[(FileLength + 4)]),0x00,Length);
					}
				}
				else
				{

					/* This is a BT request - BT can handle large packets */
					if (FileLength > (SIZE_OF_BTBUF - 6))
					{

						/* Read length exceeds buffer length check for extended read back */
						if (SUCCESS == call HalBt.cCommReq(EXTREAD, 0x00, 0x00, 0x00, NULL, &(VarsComm.RetVal)))
						{

							/* More data requested than buffer can hold .... go into extended mode */
							VarsComm.ExtTx.RemMsgSize = FileLength;
							VarsComm.ExtTx.SrcHandle  = pInBuf[1];
							VarsComm.ExtTx.Cmd        = READ;
							*pLength                  = 0;
						}
						else
						{

							/* We were not able to go into extended mode bt was busy */
							/* for now do not try to reply as it is not possible to  */
							/* return the requested bytes                            */
							*pLength = 0;
						}
					}
					else
					{

						*pLength   = FileLength + 4;
						//Status     = pMapLoader->pFunc(READ, &pInBuf[1], &pOutBuf[4], &FileLength);
						pOutBuf[0] = LOADER_ERR_BYTE(Status);
						pOutBuf[1] = LOADER_HANDLE(Status);
						pOutBuf[2] = (UBYTE)Length;
						pOutBuf[3] = (UBYTE)(Length >> 8);

						if (FileLength < Length)
						{

							/* End of file is detcted - add up with zeros to the requested msg length */
							Length -= FileLength;
							memset(&(pOutBuf[(FileLength + 4)]),0x00,Length);
						}
					}
				}
			}
			break;
			case DELETE:
			{
				//Status = pMapLoader->pFunc(DELETE, &pInBuf[1], NULL, &FileLength);
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				cCommCopyFileName(&pOutBuf[1], &pInBuf[1]);
				*pLength = FILENAME_LENGTH + 1 + 1; /*Filemname + 0 terminator + error byte */
			}
			break;
			case FINDFIRST:
			{
				//Status = pMapLoader->pFunc(FINDFIRST, &(pInBuf[1]), &(pOutBuf[2]), &FileLength);
Status = 0;
FileLength = 0;
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = LOADER_HANDLE(Status);
				if (LOADER_ERR_BYTE(SUCCESS) == pOutBuf[0])
				{
					pOutBuf[22] = (UBYTE)FileLength;
					pOutBuf[23] = (UBYTE)(FileLength >> 8);
					pOutBuf[24] = (UBYTE)(FileLength >> 16);
					pOutBuf[25] = (UBYTE)(FileLength >> 24);
					if (CmdBit & USB_CMD_READY)
					{
						//dUsbInsertHandle(pOutBuf[1]);
					}
				}
				else
				{

					/* ERROR - Fill with zeros */
					memset(&(pOutBuf[2]),0x00,24);
				}

				*pLength = 26;
			}
			break;
			case FINDNEXT:
			{
				//Status = pMapLoader->pFunc(FINDNEXT, &(pInBuf[1]), &(pOutBuf[2]), &FileLength);
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = LOADER_HANDLE(Status);
				if (LOADER_ERR_BYTE(SUCCESS) == pOutBuf[0])
				{
					pOutBuf[22] = (UBYTE)FileLength;
					pOutBuf[23] = (UBYTE)(FileLength >> 8);
					pOutBuf[24] = (UBYTE)(FileLength >> 16);
					pOutBuf[25] = (UBYTE)(FileLength >> 24);
				}
				else
				{

					/* ERROR - Fill with zeros */
					memset(&(pOutBuf[2]),0x00,24);
				}
				*pLength = 26;
			}
			break;
			case OPENREADLINEAR:
			{

				/* For internal use only */
			}
			break;
			case VERSIONS:
			{
				pOutBuf[0] = LOADER_ERR_BYTE(SUCCESS);
				pOutBuf[1] = (UBYTE)PROTOCOLVERSION;
				pOutBuf[2] = (UBYTE)(PROTOCOLVERSION>>8);
				pOutBuf[3] = (UBYTE)FIRMWAREVERSION;
				pOutBuf[4] = (UBYTE)(FIRMWAREVERSION>>8);
				*pLength = 5;
			}
			break;
			case OPENWRITELINEAR:
			{
				FileLength  = pInBuf[21];
				FileLength += (ULONG)pInBuf[22] << 8;
				FileLength += (ULONG)pInBuf[23] << 16;
				FileLength += (ULONG)pInBuf[24] << 24;
				//Status = pMapLoader->pFunc(OPENWRITELINEAR, &pInBuf[1], NULL, &FileLength);
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = LOADER_HANDLE(Status);
				*pLength = 2;
				if ((SUCCESS == LOADER_ERR(Status)) && (CmdBit & USB_CMD_READY))
				{
					//dUsbInsertHandle(LOADER_HANDLE(Status));
				}
			}
			break;
			case FINDFIRSTMODULE:
			{
				//Status = pMapLoader->pFunc(FINDFIRSTMODULE, &pInBuf[1], &pOutBuf[2], &FileLength);
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = 0;

				if (LOADER_ERR_BYTE(SUCCESS) != pOutBuf[0])
				{
					memset(&pOutBuf[2], 0x00, 30);
				}
				*pLength = 32;
			}
			break;

			case FINDNEXTMODULE:
			{
				//Status = pMapLoader->pFunc(FINDNEXTMODULE, pInBuf, &pOutBuf[2], &FileLength);
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = 0;

				if (LOADER_ERR_BYTE(SUCCESS) != pOutBuf[0])
				{
					memset(&pOutBuf[2], 0x00, 30);
				}
				*pLength = 32;
			}
			break;

			case CLOSEMODHANDLE:
			{
				//Status = pMapLoader->pFunc(CLOSEMODHANDLE, NULL, NULL, NULL);
				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[1] = 0;
				*pLength = 2;
			}
			break;

			case IOMAPREAD:
			{
				ULONG ModuleId;
				UWORD Length;

				ModuleId     = pInBuf[1];
				ModuleId    |= (ULONG)pInBuf[2] << 8;
				ModuleId    |= (ULONG)pInBuf[3] << 16;
				ModuleId    |= (ULONG)pInBuf[4] << 24;

				/* Transfer the Module id */
				pOutBuf[1]   = pInBuf[1];
				pOutBuf[2]   = pInBuf[2];
				pOutBuf[3]   = pInBuf[3];
				pOutBuf[4]   = pInBuf[4];

				/* Transfer the offset into the iomap (pOutBuf[6] is intended...)*/
				pOutBuf[5]   = pInBuf[5];
				pOutBuf[6]   = pInBuf[6];

				/* Get the read *pLength */
				FileLength   = pInBuf[8];
				FileLength <<= 8;
				FileLength  |= pInBuf[7];

				if (CmdBit & USB_CMD_READY)
				{

					/* test for USB buffer overrun */
					if (FileLength > (SIZE_OF_USBBUF - 9))
					{
						FileLength = SIZE_OF_USBBUF - 9;
					}
				}
				else
				{

					/* test for BT buffer overrun */
					if (FileLength > (SIZE_OF_BTBUF - 9))
					{
						FileLength = SIZE_OF_BTBUF - 9;
					}
				}

				Length   = FileLength;
				*pLength = Length + 7;
				//Status = pMapLoader->pFunc(IOMAPREAD, (UBYTE *)&ModuleId, &pOutBuf[5], &FileLength);

				pOutBuf[0] = LOADER_ERR_BYTE(Status);
				pOutBuf[5] = (UBYTE)FileLength;
				pOutBuf[6] = (UBYTE)(FileLength >> 8);

				if (Length > FileLength)
				{
					Length -= FileLength;
					memset(&(pOutBuf[FileLength + 7]), 0x00, Length);
				}
			}
			break;

			case IOMAPWRITE:
			{
				ULONG ModuleId;

				pOutBuf[1]  = pInBuf[1];
				pOutBuf[2]  = pInBuf[2];
				pOutBuf[3]  = pInBuf[3];
				pOutBuf[4]  = pInBuf[4];

				ModuleId  = pInBuf[1];
				ModuleId |= (ULONG)pInBuf[2] << 8;
				ModuleId |= (ULONG)pInBuf[3] << 16;
				ModuleId |= (ULONG)pInBuf[4] << 24;

				FileLength   = pInBuf[8];
				FileLength <<= 8;
				FileLength  |= pInBuf[7];

				/* Place offset right before data */
				pInBuf[8] = pInBuf[6];
				pInBuf[7] = pInBuf[5];

				//Status = pMapLoader->pFunc(IOMAPWRITE, (UBYTE *)&ModuleId, &pInBuf[7], &FileLength);

				pOutBuf[0]  = LOADER_ERR_BYTE(Status);
				pOutBuf[5]  = (UBYTE)FileLength;
				pOutBuf[6]  = (UBYTE)(FileLength >> 8);

				*pLength = 7;
			}
			break;

			case BOOTCMD:
			{

				UBYTE Tmp;

				/* The boot command is only allowed by USB - as firmware download can ONLY */
				/* be send by USB                                                          */
				pOutBuf[0] =  LOADER_ERR_BYTE(UNDEFINEDERROR);
				memset(&(pOutBuf[1]), 0, 4);
				*pLength = 5;

				if (CmdBit & USB_CMD_READY)
				{

					Tmp = 0;
					while((Tmp < (sizeof(BootString) - 1)) && (BootString[Tmp] == pInBuf[Tmp+1]))
					{
						Tmp++;
					}
					if (Tmp == (sizeof(BootString) - 1))
					{

						/* Yes valid boot sequence */
						//pMapDisplay->Flags  &= ~DISPLAY_ON;
						//pMapDisplay->Flags  |=  DISPLAY_REFRESH;
						//pMapIoCtrl->PowerOn  = BOOT;
						pOutBuf[0] =  LOADER_ERR_BYTE(SUCCESS);
						pOutBuf[1] = 'Y';
						pOutBuf[2] = 'e';
						pOutBuf[3] = 's';
						pOutBuf[4] = '\0';
					}
				}
			}
			break;

			case SETBRICKNAME:
			{

				UWORD RtnVal;

				*pLength = 1;

				/* Update the name in the BT device - reply for this command is send */
				/* before command is actually executed                               */
				if (SUCCESS == call HalBt.cCommReq(SETBTNAME, 0, 0, 0, &pInBuf[1], &RtnVal))
				{
					pOutBuf[0] = LOADER_ERR_BYTE(SUCCESS);
					cCommInsertBtName(IOMapComm.BrickData.Name, &pInBuf[1]);
					//pMapUi->Flags |= UI_REDRAW_STATUS;
				}
				else
				{
					pOutBuf[0] = LOADER_ERR_BYTE(BTBUSY);
				}
			}
			break;

			case BTGETADR:
			{
				UBYTE Tmp;
				UBYTE *pAdr;

				pAdr = (IOMapComm.BrickData.BdAddr);
				for (Tmp = 0; Tmp < 7; Tmp++)
				{
					pOutBuf[Tmp + 1] = pAdr[Tmp];
				}
				pOutBuf[0] = LOADER_ERR_BYTE(SUCCESS);
				*pLength = 8;
			}
			break;

			case DEVICEINFO:
			{

				pOutBuf[0] = LOADER_ERR_BYTE(SUCCESS);

				/* Brick name */
				memcpy(&(pOutBuf[1]), IOMapComm.BrickData.Name, 15);

				/* BT address */
				cCommCopyBdaddr(&(pOutBuf[16]), (IOMapComm.BrickData.BdAddr));

				/* Link quality of the 4 possible connected devices */
				pOutBuf[23] = IOMapComm.BtConnectTable[0].LinkQuality;
				pOutBuf[24] = IOMapComm.BtConnectTable[1].LinkQuality;
				pOutBuf[25] = IOMapComm.BtConnectTable[2].LinkQuality;
				pOutBuf[26] = IOMapComm.BtConnectTable[3].LinkQuality;

				/* Free user flash */
				//memcpy(&(pOutBuf[27]), &(pMapLoader->FreeUserFlash), sizeof(pMapLoader->FreeUserFlash));

				/* Set answer length */
				*pLength = 31;
			}
			break;

			case DELETEUSERFLASH:
			{
				//Status     = pMapLoader->pFunc(DELETEUSERFLASH, NULL, NULL, NULL);
				pOutBuf[0] = LOADER_ERR_BYTE(SUCCESS);
				*pLength   = 1;
			}
			break;

			case POLLCMDLEN:
			{

				pOutBuf[0] = LOADER_ERR_BYTE(SUCCESS);
				pOutBuf[1] = pInBuf[1];                 /* This is the Buf Number */
				if (0 == pInBuf[1])
				{

					/* USB poll buffer */
					pOutBuf[2] = ((IOMapComm.UsbPollBuf.InPtr - IOMapComm.UsbPollBuf.OutPtr) & (SIZE_OF_USBBUF - 1));
				}
				else
				{

					/* HI speed poll buffer */
					pOutBuf[2] = ((IOMapComm.HsInBuf.InPtr - IOMapComm.HsInBuf.OutPtr) & (SIZE_OF_HSBUF - 1));
				}
				*pLength = 3;
			}
			break;

			case POLLCMD:
			{
				UBYTE Tmp;
				UBYTE MaxBufData;

				pOutBuf[0] = LOADER_ERR_BYTE(SUCCESS);
				pOutBuf[1] = pInBuf[1];
				*pLength   = pInBuf[2];

				if (CmdBit & USB_CMD_READY)
				{
					MaxBufData = (SIZE_OF_USBDATA - 5); /* Substract wrapping */
				}
				else
				{
					MaxBufData = (SIZE_OF_BTBUF - 7);  /* Substract wrapping + length bytes for BT*/
				}

				if (0x00 == pInBuf[1])
				{

					/* Data from USB poll buffer are requested */
					if (*pLength <= MaxBufData)
					{
						for (Tmp = 0; ((Tmp < (*pLength)) && (IOMapComm.UsbPollBuf.InPtr != IOMapComm.UsbPollBuf.OutPtr)); Tmp++)
						{
							pOutBuf[3 + Tmp]            = IOMapComm.UsbPollBuf.Buf[IOMapComm.UsbPollBuf.OutPtr];
							IOMapComm.UsbPollBuf.OutPtr = ((IOMapComm.UsbPollBuf.OutPtr) + 1) % SIZE_OF_USBBUF;
						}
						pOutBuf[2] = Tmp;

						/* if end of buffer has been reached fill up with zeros */
						memset(&(pOutBuf[Tmp + 3]), 0x00, (*pLength - Tmp));
					}
					else
					{

						/* if more data requested than possible to return */
						pOutBuf[0] = LOADER_ERR_BYTE(UNDEFINEDERROR);
						pOutBuf[1] = pInBuf[1];                           /* This is buffer number */
						pOutBuf[2] = 0;                                   /* no of bytes returned  */
						*pLength   = 0;
					}
				}
				else
				{

					/* Data from hi speed buffer are requested */
					if (*pLength <= MaxBufData)
					{
						for (Tmp = 0; ((Tmp < (*pLength)) && (IOMapComm.HsInBuf.InPtr != IOMapComm.HsInBuf.OutPtr)); Tmp++)
						{
							pOutBuf[3 + Tmp]         = IOMapComm.HsInBuf.Buf[IOMapComm.HsInBuf.OutPtr];
							IOMapComm.HsInBuf.OutPtr = ((IOMapComm.HsInBuf.OutPtr) + 1) % SIZE_OF_USBBUF;
						}
						pOutBuf[2] = Tmp;

						/* if end of buffer has been reached fill up with zeros */
						memset(&(pOutBuf[Tmp + 3]), 0x00, (*pLength - Tmp));
					}
					else
					{

						/* if more data requested than possible to return */
						pOutBuf[0] = LOADER_ERR_BYTE(UNDEFINEDERROR);
						pOutBuf[1] = pInBuf[1];                           /* This is buffer number */
						pOutBuf[2] = 0;                                   /* no of bytes returned  */
						*pLength   = 0;
					}
				}
				(*pLength) += 3; /* Add 3 bytes for the status byte, length byte and Buf no */
			}
			break;

			case BTFACTORYRESET:
			{
				UWORD RtnVal;

				if (CmdBit & USB_CMD_READY)
				{
					if (SUCCESS == call HalBt.cCommReq(FACTORYRESET, 0, 0, 0, NULL, &RtnVal))
					{

						/* Request success */
						pOutBuf[0] = LOADER_ERR_BYTE(SUCCESS);
					}
					else
					{

						/* BT request error */
						pOutBuf[0] = LOADER_ERR_BYTE(UNDEFINEDERROR);
					}
				}
				else
				{

					/* Factory reset request cannot be done by bluetooth */
					pOutBuf[0] = LOADER_ERR_BYTE(UNDEFINEDERROR);
				}
				*pLength = 1;
			}
			break;

			default:
			{
			}
			break;
		}
		return(Status);
	}


	UWORD     cCommReceivedBtData()
	{
		UWORD   NumberOfBytes;
		UWORD   BytesToGo;
		UWORD   RtnVal;

		RtnVal = call HplBc4.dBtReceivedData(&NumberOfBytes, &BytesToGo);
		if (TRUE == RtnVal)
		{

			/* Everything is fine go on */
			if (NumberOfBytes != 0)
			{

				/* Copy the bytes into the IOMapBuffer */
				memcpy((IOMapComm.BtInBuf.Buf), (VarsComm.BtModuleInBuf.Buf), NumberOfBytes);

				if (VarsComm.BtState == BT_ARM_CMD_MODE)
				{

					/* Call the BC4 command interpreter */
					cCommBtCmdInterpreter();
					IOMapComm.BtInBuf.InPtr  = 0;
				}
				else
				{

					/* ActiveUpdate has to be idle because BC4 can send stream data even if CMD */
					/* mode has been requested - dont try to interprete the data                */
					/* VarsComm.CmdSwitchCnt != 0 if a transition to Cmd mode is in process     */
					if ((VarsComm.BtState == BT_ARM_DATA_MODE) && (0 == VarsComm.CmdSwitchCnt))
					{
sprintf((char *)lcdstr,"%d stream b (%d)", NumberOfBytes, BytesToGo);
call HalLCD.displayString(lcdstr,2);			
sprintf((char *)lcdstr,"%x.%x.%x.%x.%x.%x.%x.%x", IOMapComm.BtInBuf.Buf[0],IOMapComm.BtInBuf.Buf[1],IOMapComm.BtInBuf.Buf[2],IOMapComm.BtInBuf.Buf[3],IOMapComm.BtInBuf.Buf[4],IOMapComm.BtInBuf.Buf[5],IOMapComm.BtInBuf.Buf[6],IOMapComm.BtInBuf.Buf[7]);
call HalLCD.displayString(lcdstr,3);			
sprintf((char *)lcdstr,"%x.%x.%x.%x.%x.%x.%x.%x", IOMapComm.BtInBuf.Buf[8],IOMapComm.BtInBuf.Buf[9],IOMapComm.BtInBuf.Buf[10],IOMapComm.BtInBuf.Buf[11],IOMapComm.BtInBuf.Buf[12],IOMapComm.BtInBuf.Buf[13],IOMapComm.BtInBuf.Buf[14],IOMapComm.BtInBuf.Buf[15]);
call HalLCD.displayString(lcdstr,4);			

						/* Move the inptr ahead */
						IOMapComm.BtInBuf.InPtr = NumberOfBytes;

						/* using the outbuf inptr in order to get the number of bytes in the return answer at the right place*/
						IOMapComm.BtOutBuf.InPtr = NumberOfBytes;

						/* call the data stream interpreter */
						//cCommInterprete(IOMapComm.BtInBuf.Buf, IOMapComm.BtOutBuf.Buf, &(IOMapComm.BtOutBuf.InPtr), (UBYTE) BT_CMD_READY, BytesToGo);
						post dataReceivedTask();

						/* if there is a reply to be send then send it */
						if (IOMapComm.BtOutBuf.InPtr)
						{
							//call HplBc4.dBtSendMsg(IOMapComm.BtOutBuf.Buf, IOMapComm.BtOutBuf.InPtr, IOMapComm.BtOutBuf.InPtr);
							IOMapComm.BtOutBuf.InPtr = 0;
						}
					}
				}
			}
		}
		return(RtnVal);
	}

	void cCommBtCmdInterpreter()
	{

		/* this function handles all bluecode commands that can be */
		/* initiated from the outside (rup: or this brick), meaning from other devices   */
		if(cCommBtValidateCmd())
		{
			switch (IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
			{
				case MSG_REQUEST_PIN_CODE:
				{

					/* Pass the pin request on to cCommReq it'l handle it */
					call HalBt.cCommReq(PINREQ, 0x00, 0x00, 0x00, NULL, &(VarsComm.RetVal));
				}
				break;

				case MSG_REQUEST_CONNECTION:
				{

					/* Connect request from the outside */
					call HalBt.cCommReq(CONNECTREQ, 0x00, 0x00, 0x00, NULL, &(VarsComm.RetVal));
sprintf((char *)lcdstr,"CONNECTREQ");
call HalLCD.displayString(lcdstr,2);			
					
				}
				break;

				case MSG_LIST_RESULT:
				{
					switch (IOMapComm.BtInBuf.Buf[2])
					{
						case LR_SUCCESS:
						{
						}
						break;
						case LR_ENTRY_REMOVED:
						{
						}
						break;
	/*
						case LR_COULD_NOT_SAVE:
						case LR_STORE_IS_FULL:
						case LR_UNKOWN_ADDR:
	*/
						default:
						{
							//pMapUi->Error           = (UBYTE)IOMapComm.BtInBuf.Buf[2];
							//pMapUi->BluetoothState |= BT_ERROR_ATTENTION;
						}
						break;
					}
				}
				break;

				case MSG_CLOSE_CONNECTION_RESULT:
				{
					UBYTE ConnNo;

					for (ConnNo = 0; ConnNo < SIZE_OF_BT_CONNECT_TABLE; ConnNo++)
					{
						if (IOMapComm.BtConnectTable[ConnNo].HandleNr == IOMapComm.BtInBuf.Buf[3])
						{
							IOMapComm.BrickData.BtStateStatus &= ~(BT_CONNECTION_0_ENABLE<<ConnNo);
							CLEARConnEntry(ConnNo);
							ConnNo = SIZE_OF_BT_CONNECT_TABLE;
						}
					}

					if (!(IOMapComm.BrickData.BtStateStatus & (BT_CONNECTION_0_ENABLE | BT_CONNECTION_1_ENABLE | BT_CONNECTION_2_ENABLE | BT_CONNECTION_3_ENABLE)))
					{
						//pMapUi->BluetoothState &= ~BT_STATE_CONNECTED;
					}
					//pMapUi->Flags |= UI_REDRAW_STATUS;
				}
				break;

				case MSG_PORT_OPEN_RESULT:
				{
					if (IOMapComm.BtInBuf.Buf[2] == 1)
					{
						IOMapComm.BtConnectTable[0].HandleNr = IOMapComm.BtInBuf.Buf[3];
						IOMapComm.BrickData.BtStateStatus   |= BT_BRICK_PORT_OPEN;
					}
					else
					{

						/* There was an error setting up the OpenPort command in BC4 */
						IOMapComm.BtConnectTable[0].HandleNr =  BLUETOOTH_HANDLE_UNDEFIEND;
						IOMapComm.BrickData.BtStateStatus   &= ~BT_BRICK_PORT_OPEN;
					}
				}
				break;

				case MSG_CLOSE_PORT_RESULT:
				{
					if (IOMapComm.BtInBuf.Buf[2] == 1)
					{
						IOMapComm.BtConnectTable[0].HandleNr =  BLUETOOTH_HANDLE_UNDEFIEND;
						IOMapComm.BrickData.BtStateStatus   &= ~BT_BRICK_PORT_OPEN;
					}
				}
				break;

				case MSG_PIN_CODE_ACK:
				{
					//pMapUi->BluetoothState &= ~BT_PIN_REQUEST;
				}
				break;

				case MSG_DISCOVERABLE_ACK:
				{
					if (VarsComm.BtCmdData.ParamOne == 1)
					{
						IOMapComm.BrickData.BtStateStatus |= BT_BRICK_VISIBILITY;
						//pMapUi->BluetoothState            |= BT_STATE_VISIBLE;
					}
					else
					{
						IOMapComm.BrickData.BtStateStatus &= ~BT_BRICK_VISIBILITY;
						//pMapUi->BluetoothState            &= ~BT_STATE_VISIBLE;
					}
				}
				break;
				case MSG_RESET_INDICATION:
				{
					if ((UPD_RESET        != VarsComm.ActiveUpdate) &&
							(UPD_BRICKNAME    != VarsComm.ActiveUpdate) &&
							(UPD_FACTORYRESET != VarsComm.ActiveUpdate))
					{

						/* Not intended reset indication - restart the bluecore */
						if (VarsComm.ActiveUpdate != UPD_IDLE)
						{

							/* Something was ongoing send error message */
							*(VarsComm.pRetVal)  = (UWORD)ERR_COMM_BUS_ERR;
							*(VarsComm.pRetVal) |= 0x8000;
						}

						SETBtStateIdle;
						VarsComm.pRetVal      = &(VarsComm.RetVal);
						VarsComm.ActiveUpdate = UPD_RESET;
					}
				}
				break;
			}
		}
		else
		{
			/* Receive a message with wrong checkSum ! */
		}
	}

	void      cCommCpyToUpper(UBYTE *pDst, UBYTE *pSrc, UBYTE Length)
	{
		UBYTE   Tmp;

		for(Tmp = 0; Tmp < Length; Tmp++)
		{
			pDst[Tmp] =(UBYTE)toupper((UWORD)pSrc[Tmp]);
		}

		/* The requried length has been copied - now fill with zeros */
		for(Tmp = Length; Tmp < (FILENAME_LENGTH + 1); Tmp++)
		{
			pDst[Tmp] = '\0';
		}
	}

	void     cCommCopyFileName(UBYTE *pDst, UBYTE *pSrc)
	{
		UBYTE  Tmp;

		for(Tmp = 0; Tmp < (FILENAME_LENGTH + 1); Tmp++, pDst++)
		{
			if ('\0' != *pSrc)
			{
				*pDst = *pSrc;
				pSrc++;
			}
			else
			{
				*pDst = '\0';
			}
		}
	}

	void cCommSendHiSpeedData()
	{
		VarsComm.HsModuleOutBuf.OutPtr = 0;
		for (VarsComm.HsModuleOutBuf.InPtr = 0; VarsComm.HsModuleOutBuf.InPtr < IOMapComm.HsOutBuf.InPtr; VarsComm.HsModuleOutBuf.InPtr++)
		{
			VarsComm.HsModuleOutBuf.Buf[VarsComm.HsModuleOutBuf.InPtr] = IOMapComm.HsOutBuf.Buf[IOMapComm.HsOutBuf.OutPtr];
			IOMapComm.HsOutBuf.OutPtr++;
		}
		//dHiSpeedSendData(VarsComm.HsModuleOutBuf.Buf, (VarsComm.HsModuleOutBuf.InPtr - VarsComm.HsModuleOutBuf.OutPtr));
	}

	void cCommReceivedHiSpeedData()
	{
		UWORD NumberOfBytes;
		UWORD Tmp;

		//dHiSpeedReceivedData(&NumberOfBytes);

		if (NumberOfBytes != 0)
		{
			for (Tmp = 0; Tmp < NumberOfBytes; Tmp++)
			{
				IOMapComm.HsInBuf.Buf[IOMapComm.HsInBuf.InPtr] = VarsComm.HsModuleInBuf.Buf[Tmp];
				IOMapComm.HsInBuf.InPtr++;
				if (IOMapComm.HsInBuf.InPtr > (SIZE_OF_HSBUF - 1))
				{
					IOMapComm.HsInBuf.InPtr = 0;
				}
				VarsComm.HsModuleInBuf.Buf[Tmp] = 0;
			}

			/* Now new data is available from the HIGH SPEED port ! */
		}
	}

	UBYTE cCommBtValidateCmd()
	{
		UWORD CheckSumTmp = 0;
		UBYTE Tmp, CheckSumHigh, CheckSumLow;

		for (Tmp = 0; Tmp < (IOMapComm.BtInBuf.Buf[0] - 1);Tmp++)
		{
			CheckSumTmp += IOMapComm.BtInBuf.Buf[Tmp];
		}
		CheckSumTmp = (UWORD) (1 + (0xFFFF - CheckSumTmp));
		CheckSumHigh = (UBYTE)((CheckSumTmp & 0xFF00)>>8);
		CheckSumLow = (UBYTE)(CheckSumTmp & 0x00FF);

		if ((CheckSumHigh == IOMapComm.BtInBuf.Buf[IOMapComm.BtInBuf.Buf[0] - 1]) && (CheckSumLow == IOMapComm.BtInBuf.Buf[IOMapComm.BtInBuf.Buf[0]]))
		{
			return(TRUE);
		}
		else
		{
			return(FALSE);
		}
	}

	void      cCommClearStreamStatus()
	{
		IOMapComm.BtConnectTable[0].StreamStatus = 0;
		IOMapComm.BtConnectTable[1].StreamStatus = 0;
		IOMapComm.BtConnectTable[2].StreamStatus = 0;
		IOMapComm.BtConnectTable[3].StreamStatus = 0;
	}
  
  //State machine
	void      cCommUpdateBt()
	{
		UBYTE   Tmp, Tmp2, Handle;

		Tmp  = 0;
		Tmp2 = 0;

		switch(VarsComm.ActiveUpdate)
		{
			case UPD_RESET:
			{

				switch(VarsComm.UpdateState)
				{
					case 0:
					{
						/* Setup Reset sequence */
						//pMapUi->BluetoothState  = BT_STATE_OFF;
						VarsComm.UpdateState    = 1;
					}
					break;

					case 1:
					{

						cCommsBtReset(&(VarsComm.UpdateState));
					}
					break;

					case 2:
					{
						(VarsComm.UpdateState)++;
						call HplBc4.dBtSendBtCmd((UBYTE)MSG_GET_LOCAL_ADDR, 0, 0, NULL, NULL, NULL, NULL);
					}
					break;

					case 3:
					{

						if (MSG_GET_LOCAL_ADDR_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							cCommCopyBdaddr((IOMapComm.BrickData.BdAddr), &(IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 1]));
							//dUsbStoreBtAddress( &(IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 1]));
							call HplBc4.dBtSendBtCmd((UBYTE)MSG_GET_FRIENDLY_NAME, 0, 0, NULL, NULL, NULL, NULL);
							VarsComm.BtAdrStatus = INITIALIZED;
							(VarsComm.UpdateState)++;
						}
					}
					break;

					case 4:
					{
						if (MSG_GET_FRIENDLY_NAME_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							memcpy(IOMapComm.BrickData.Name, &(IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 1]), SIZE_OF_BRICK_NAME);
							//pMapUi->Flags |= UI_REDRAW_STATUS;
							IOMapComm.BtDeviceCnt     = 0;
							IOMapComm.BtDeviceNameCnt = 0;
							call HplBc4.dBtSendBtCmd((UBYTE)MSG_DUMP_LIST, 0, 0, NULL, NULL, NULL, NULL);
							(VarsComm.UpdateState)++;
						}
					}
					break;

					case 5:
					{
						if (MSG_LIST_ITEM == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							cCommCopyBdaddr((IOMapComm.BtDeviceTable[IOMapComm.BtDeviceCnt].BdAddr), &(IOMapComm.BtInBuf.Buf[2]));
							cCommInsertBtName(IOMapComm.BtDeviceTable[IOMapComm.BtDeviceCnt].Name, &(IOMapComm.BtInBuf.Buf[9]));
							IOMapComm.BtDeviceTable[IOMapComm.BtDeviceCnt].DeviceStatus = BT_DEVICE_KNOWN;

							memcpy(IOMapComm.BtDeviceTable[IOMapComm.BtDeviceCnt].ClassOfDevice, &(IOMapComm.BtInBuf.Buf[9+SIZE_OF_BT_NAME]), sizeof(IOMapComm.BtDeviceTable[IOMapComm.BtDeviceCnt].ClassOfDevice));

							IOMapComm.BtDeviceCnt++;
							IOMapComm.BtDeviceNameCnt++;
						}

						if (MSG_LIST_DUMP_STOPPED == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							call HplBc4.dBtSendBtCmd((UBYTE)MSG_GET_VERSION, 0, 0, NULL, NULL, NULL, NULL);
							(VarsComm.UpdateState)++;
						}
						IOMapComm.BtInBuf.Buf[BT_CMD_BYTE] = 0;
					}
					break;

					case 6:
					{
						if (MSG_GET_VERSION_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{

							IOMapComm.BrickData.BluecoreVersion[0] = IOMapComm.BtInBuf.Buf[3];
							IOMapComm.BrickData.BluecoreVersion[1] = IOMapComm.BtInBuf.Buf[2];
	
							/* BtHwStatus indicates cold boot or user interaction */
							if (BT_DISABLE == IOMapComm.BrickData.BtHwStatus)
							{

								/* This is from brick turning on */
								call HplBc4.dBtSendBtCmd((UBYTE)MSG_GET_BRICK_STATUSBYTE, 0, 0, NULL, NULL, NULL, NULL);
							}
							else
							{
								/* this is user interaction setting the brick on */
								call HplBc4.dBtSendBtCmd((UBYTE)MSG_SET_BRICK_STATUSBYTE, BT_ENABLE, 0, NULL, NULL, NULL, NULL);
							}
							(VarsComm.UpdateState)++;
							//pMapUi->Flags |= UI_REDRAW_STATUS;
						}
					}
					break;

					case 7:
					{
						if (MSG_GET_BRICK_STATUSBYTE_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							IOMapComm.BrickData.TimeOutValue = IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 2];

							/* Check for brick to be on or off */
							if (BT_ENABLE == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 1])
							{
								//pMapUi->BluetoothState        &= ~BT_STATE_OFF;
								IOMapComm.BrickData.BtHwStatus = BT_ENABLE;
								call HplBc4.dBtSendBtCmd((UBYTE)MSG_GET_DISCOVERABLE, 0, 0, NULL, NULL, NULL, NULL);
								(VarsComm.UpdateState)++;
							}
							else
							{
								SETBtOff;
								IOMapComm.BrickData.BtHwStatus = BT_ENABLE;
								SETBtStateIdle;
								*(VarsComm.pRetVal) = SUCCESS;
							}
						}
						if (MSG_SET_BRICK_STATUSBYTE_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{

							/* brick to be on*/
							//pMapUi->BluetoothState        &= ~BT_STATE_OFF;
							IOMapComm.BrickData.BtHwStatus = BT_ENABLE;
							call HplBc4.dBtSendBtCmd((UBYTE)MSG_GET_DISCOVERABLE, 0, 0, NULL, NULL, NULL, NULL);
							(VarsComm.UpdateState)++;
						}
					}
					break;

					case 8:
					{
						if (MSG_GET_DISCOVERABLE_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							if (IOMapComm.BtInBuf.Buf[2] & 0x01)
							{
								IOMapComm.BrickData.BtStateStatus |= BT_BRICK_VISIBILITY;
								//pMapUi->BluetoothState            |= BT_STATE_VISIBLE;
							}
							else
							{
								IOMapComm.BrickData.BtStateStatus &= ~BT_BRICK_VISIBILITY;
  							//pMapUi->BluetoothState            &= ~BT_STATE_VISIBLE;
							}
							call HplBc4.dBtSendBtCmd((UBYTE)MSG_OPEN_PORT, 0, 0, NULL, NULL, NULL, NULL);
							(VarsComm.UpdateState)++;
						}
					}
					break;

					case 9:
					{

						if (MSG_PORT_OPEN_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							if (IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 1] & 0x01)
							{
								IOMapComm.BrickData.BtStateStatus |= BT_BRICK_PORT_OPEN;
							}
							else
							{
								IOMapComm.BrickData.BtStateStatus &= ~BT_BRICK_PORT_OPEN;
							}

							SETBtStateIdle; // sets UPD_IDLE
							*(VarsComm.pRetVal) = SUCCESS;
						}
					}
					break;
				}
			}
			break;

			case UPD_FACTORYRESET:
			{
				switch(VarsComm.UpdateState)
				{

					case 0:
					{
						if (1) //BT_STATE_OFF & (pMapUi->BluetoothState)) //Check
						{

							/* Bluetooth is off - now start it up  */
							(VarsComm.UpdateState)++;
						}
						else
						{

							/* BT is already on - continue */
							(VarsComm.UpdateState) += 2;
						}
					}
					break;
					case 1:
					{
						cCommsBtReset(&(VarsComm.UpdateState));
					}
					break;
					case 2:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;
					case 3:
					{
						cCommsDisconnectAll(&(VarsComm.UpdateState));
					}
					break;
					case 4:
					{

						/* Now bc4 is in cmd mode now factory can be sent */
						/* Just leave the BC4 in cmd mode                 */
						call HplBc4.dBtSendBtCmd((UBYTE)MSG_SET_FACTORY_SETTINGS, 0, 0, NULL, NULL, NULL, NULL);
						(VarsComm.UpdateState)++;
					}
					break;
					case 5:
					{
						if (MSG_SET_FACTORY_SETTINGS_ACK == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							SETBtStateIdle;
							IOMapComm.BrickData.BtHwStatus = BT_DISABLE; /* Boot BT like cold boot*/
							VarsComm.ActiveUpdate          = UPD_RESET;
						}
					}
					break;
				}
			}
			break;

			case UPD_BRICKNAME:
			{
				switch(VarsComm.UpdateState)
				{
					case 0:
					{

						if (1) //BT_STATE_OFF & (pMapUi->BluetoothState)) //Check if use if UI is possible
						{

							/* Bluetooth is off - now start it up  */
							(VarsComm.UpdateState)++;
						}
						else
						{
							VarsComm.UpdateState = 2;
						}
					}
					break;

					case 1:
					{
						cCommsBtReset(&(VarsComm.UpdateState));
					}
					break;

					case 2:
					{
						VarsComm.BtUpdateDataConnectNr = 0;
						if (BT_ARM_DATA_MODE == VarsComm.BtState)
						{
							for (Tmp = 0; Tmp < SIZE_OF_BT_CONNECT_TABLE; Tmp++)
							{
								if (IOMapComm.BtConnectTable[Tmp].StreamStatus)
								{
									VarsComm.BtUpdateDataConnectNr = Tmp | 0x80;
								}
							}
							(VarsComm.UpdateState)++;
						}
						else
						{
							(VarsComm.UpdateState) += 2;
						}
					}
					break;

					case 3:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;

					case 4:
					{

						/* Brick name has been updated prior to this */
						call HplBc4.dBtSendBtCmd((UBYTE)MSG_SET_FRIENDLY_NAME, 0, 0, NULL, IOMapComm.BrickData.Name, NULL, NULL);
						(VarsComm.UpdateState)++;
					}
					break;

					case 5:
					{
						if (MSG_SET_FRIENDLY_NAME_ACK == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{

							/* Set name has been executed */
							if (VarsComm.BtUpdateDataConnectNr & 0x80)
							{
								call HplBc4.dBtSendBtCmd((UBYTE)MSG_OPEN_STREAM, IOMapComm.BtConnectTable[(VarsComm.BtUpdateDataConnectNr & ~0x80)].HandleNr,
																0, NULL, NULL, NULL, NULL);
								(VarsComm.UpdateState)++;
							}
							else
							{
								if (1) //BT_STATE_OFF & (pMapUi->BluetoothState)) // Check UI use
								{
									SETBtOff;
								}
								SETBtStateIdle;
								*(VarsComm.pRetVal) = SUCCESS;
							}
							//pMapUi->Flags |= UI_REDRAW_STATUS;
						}
					}
					break;
					case 6:
					{
						if (VarsComm.BtBcPinLevel)
						{
							IOMapComm.BtConnectTable[(VarsComm.BtUpdateDataConnectNr & ~0x80)].StreamStatus = 1;
							*(VarsComm.pRetVal) = SUCCESS;
							SETBtDataState;
							SETBtStateIdle;
						}
					}
					break;
				}
			}
			break;

			case UPD_REQCMDMODE:
			{
				switch(VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;
					case 1:
					{
					 *(VarsComm.pRetVal) = SUCCESS;
						SETBtStateIdle;
					}
					break;
				}
			}
			break;

			case UPD_OPENSTREAM:
			{
				switch(VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsOpenStream(&(VarsComm.UpdateState));
					}
					break;

					case 1:
					{
						*(VarsComm.pRetVal) = SUCCESS;
						SETBtStateIdle;
					}
					break;
				}
			}
			break;

			case UPD_SENDFILE:
			{
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsOpenStream(&(VarsComm.UpdateState));
					}
					break;

					case 1:
					{

						/* Here we wait for the open stream to succeed*/
						if (IOMapComm.BtConnectTable[VarsComm.ExtTx.SlotNo].StreamStatus)
						{

							/* Stream has been opened send the openwrite command */
							VarsComm.BtModuleOutBuf.Buf[0] = SYSTEM_CMD;
							VarsComm.BtModuleOutBuf.Buf[1] = OPENWRITE;
							memcpy((UBYTE*)&(VarsComm.BtModuleOutBuf.Buf[2]),(UBYTE*)VarsComm.ExtTx.FileName, FILENAME_LENGTH + 1);
							memcpy((UBYTE*)&(VarsComm.BtModuleOutBuf.Buf[22]),(UBYTE*)&(VarsComm.ExtTx.RemFileSize), sizeof(VarsComm.ExtTx.RemFileSize));
							call HplBc4.dBtSendMsg(VarsComm.BtModuleOutBuf.Buf, 26, 26);

							VarsComm.ExtTx.Timer = 0;
							VarsComm.UpdateState = 2;

						}
						else
						{
							if (VarsComm.ExtTx.Timer >= FILETXTOUT)
							{
								*(VarsComm.pRetVal)  = FILETX_STREAMERROR;
								VarsComm.UpdateState = 8;
							}
							else
							{
								(VarsComm.ExtTx.Timer)++;
							}
						}
					}
					break;

					case 2:
					{

						if (4 == IOMapComm.BtInBuf.InPtr)
						{

							/* Data has been received - examine the answer */
							if ((REPLY_CMD == IOMapComm.BtInBuf.Buf[0]) && (OPENWRITE == IOMapComm.BtInBuf.Buf[1]))
							{

								/* OpenWrite answer */
								if (LOADER_ERR_BYTE(SUCCESS) == IOMapComm.BtInBuf.Buf[2])
								{

									/* save the handle from the other brick */
									VarsComm.ExtTx.DstHandle = IOMapComm.BtInBuf.Buf[3];
									VarsComm.UpdateState     = 3;
									IOMapComm.BtInBuf.InPtr  = 0;
								}
								else
								{

									/* Open write failiure - terminate file transfer */
									*(VarsComm.pRetVal)  = IOMapComm.BtInBuf.Buf[2];
									VarsComm.UpdateState = 8;
								}
							}
						}

						if (VarsComm.ExtTx.Timer >= FILETXTOUT)
						{
							*(VarsComm.pRetVal)  = FILETX_TIMEOUT;
							VarsComm.UpdateState = 8;
						}
						else
						{
							(VarsComm.ExtTx.Timer)++;
						}
					}
					break;

					case 3: /*SENDWRITE:*/
					{
						ULONG Length;
						UWORD MsgSize;

						VarsComm.ExtTx.Timer = 0;

						if (VarsComm.ExtTx.RemFileSize > (MAX_BT_MSG_SIZE - 5))
						{

							/* need to use the maximum size available - approx 64K */
							VarsComm.ExtTx.RemMsgSize = (MAX_BT_MSG_SIZE - 5);
						}
						else
						{

							/* Message can hold the remaining message */
							VarsComm.ExtTx.RemMsgSize = VarsComm.ExtTx.RemFileSize;
						}

						if (VarsComm.ExtTx.RemMsgSize > (SIZE_OF_BTBUF - 5))
						{
							Length = SIZE_OF_BTBUF - 5;
							VarsComm.UpdateState = 4;
						}
						else
						{
							Length = VarsComm.ExtTx.RemMsgSize;
							VarsComm.UpdateState = 5;
						}

						Handle = (UBYTE)(VarsComm.ExtTx.SrcHandle);
						//pMapLoader->pFunc(READ, &Handle, &(VarsComm.BtModuleOutBuf.Buf[3]), &Length);
						MsgSize = VarsComm.ExtTx.RemMsgSize + 3;
						VarsComm.BtModuleOutBuf.Buf[0] = SYSTEM_CMD;
						VarsComm.BtModuleOutBuf.Buf[1] = WRITE;
						VarsComm.BtModuleOutBuf.Buf[2] = VarsComm.ExtTx.DstHandle;
						call HplBc4.dBtSendMsg(VarsComm.BtModuleOutBuf.Buf, Length + 3, MsgSize);

						VarsComm.ExtTx.RemMsgSize  -= Length;
						VarsComm.ExtTx.RemFileSize -= Length;
					}
					break;

					case 4: /* CONTINOUSWRITE:*/
					{
						ULONG Length;
						UWORD Status;

						if(call HplBc4.dBtCheckForTxBuf())
						{

							/* do only send more data if buffer is empty */
							VarsComm.ExtTx.Timer     = 0;
							if (VarsComm.ExtTx.RemMsgSize >= SIZE_OF_BTBUF)
							{
								Length = SIZE_OF_BTBUF;
							}
							else
							{
								Length = VarsComm.ExtTx.RemMsgSize;
							}

							VarsComm.ExtTx.RemMsgSize  -= Length;
							VarsComm.ExtTx.RemFileSize -= Length;
							Handle = (UBYTE)(VarsComm.ExtTx.SrcHandle);
							//Status = pMapLoader->pFunc(READ, &Handle, &(VarsComm.BtModuleOutBuf.Buf[0]), &Length);
Status = 0;							
							if (Status >= 0x8000)
							{
								Length = 0;
							}
							call HplBc4.dBtSend(VarsComm.BtModuleOutBuf.Buf, Length);
							if (!(VarsComm.ExtTx.RemMsgSize))
							{

								/* at this point due to large write command acknowledge is expected */
								VarsComm.UpdateState    = 5;
								VarsComm.ExtTx.Timer    = 0;
								IOMapComm.BtInBuf.InPtr = 0;
							}
						}
					}
					break;

					case 5: /* WRITEACK: */
					{
						if (6 == IOMapComm.BtInBuf.InPtr)
						{
							if ((WRITE == IOMapComm.BtInBuf.Buf[1]) &&
									(REPLY_CMD == IOMapComm.BtInBuf.Buf[0]) &&
									(VarsComm.ExtTx.DstHandle == IOMapComm.BtInBuf.Buf[3]))
							{

								/* Ok the the return reply is for me - was it ok? */
								if (LOADER_ERR_BYTE(SUCCESS) == IOMapComm.BtInBuf.Buf[2])
								{

									/* Ok send next write*/
									if (VarsComm.ExtTx.RemFileSize)
									{
										VarsComm.UpdateState = 3;
									}
									else
									{
										VarsComm.UpdateState = 6;
									}
									IOMapComm.BtInBuf.InPtr = 0;
								}
							}
						}

						if (VarsComm.ExtTx.Timer >= FILETXTOUT)
						{
							*(VarsComm.pRetVal)  = FILETX_TIMEOUT;
							VarsComm.UpdateState = 8;
						}
						else
						{
							(VarsComm.ExtTx.Timer)++;
						}
					}
					break;

					case 6: /*TERMINATESEND: */
					{

						/* Stream still open close the receiver handle */
						VarsComm.BtModuleOutBuf.Buf[0] = SYSTEM_CMD;
						VarsComm.BtModuleOutBuf.Buf[1] = CLOSE;
						VarsComm.BtModuleOutBuf.Buf[2] = VarsComm.ExtTx.DstHandle;
						call HplBc4.dBtSendMsg(VarsComm.BtModuleOutBuf.Buf, 3, 3);

						VarsComm.ExtTx.Timer = 0;
						VarsComm.UpdateState = 7;
					}
					break;
					case 7: /* TERMINATEACK:*/
					{

						if (4 == IOMapComm.BtInBuf.InPtr)
						{

							if ((CLOSE == IOMapComm.BtInBuf.Buf[1]) &&
									(REPLY_CMD == IOMapComm.BtInBuf.Buf[0]) &&
									(VarsComm.ExtTx.DstHandle == IOMapComm.BtInBuf.Buf[3]))
							{
								if (LOADER_ERR_BYTE(SUCCESS) == IOMapComm.BtInBuf.Buf[2])
								{
									*(VarsComm.pRetVal)  = SUCCESS;
									VarsComm.UpdateState = 8;
								}
								else
								{
									*(VarsComm.pRetVal)  = FILETX_CLOSEERROR;
									VarsComm.UpdateState = 8;
								}
								IOMapComm.BtInBuf.InPtr = 0;
							}
						}

						if (VarsComm.ExtTx.Timer >= FILETXTOUT)
						{
							*(VarsComm.pRetVal)  = FILETX_TIMEOUT;
							VarsComm.UpdateState = 8;
						}
						else
						{
							(VarsComm.ExtTx.Timer)++;
						}
					}
					break;
					case 8:
					{
						UBYTE  Handle2;
						Handle2 = (UBYTE)(VarsComm.ExtTx.SrcHandle);
						//pMapLoader->pFunc(CLOSE, &Handle2, NULL, NULL);
					 (VarsComm.UpdateState)++;
					}
					break;
					case 9:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;
					case 10:
					{
						SETBtStateIdle;
					}
					break;
				}
			}
			break;

			case UPD_EXTREAD:
			{
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						ULONG MsgLength;
						UWORD Status;

						MsgLength = (SIZE_OF_BTBUF - 8);
						Handle =(UBYTE)(VarsComm.ExtTx.SrcHandle);
						//Status = pMapLoader->pFunc(READ, &Handle, &(VarsComm.BtModuleOutBuf.Buf[6]), &MsgLength);
Status = 0;						
						VarsComm.BtModuleOutBuf.Buf[0] = (UBYTE) (REPLY_CMD);
						VarsComm.BtModuleOutBuf.Buf[1] = (UBYTE) (VarsComm.ExtTx.Cmd);
						VarsComm.BtModuleOutBuf.Buf[2] = LOADER_ERR_BYTE(Status);
						VarsComm.BtModuleOutBuf.Buf[3] = LOADER_HANDLE(Status);
						VarsComm.BtModuleOutBuf.Buf[4] = (UBYTE)VarsComm.ExtTx.RemMsgSize;
						VarsComm.BtModuleOutBuf.Buf[5] = (UBYTE)(VarsComm.ExtTx.RemMsgSize >> 8);
						call HplBc4.dBtSendMsg(VarsComm.BtModuleOutBuf.Buf, (UBYTE)(SIZE_OF_BTBUF - 2), (VarsComm.ExtTx.RemMsgSize + 6));

						VarsComm.ExtTx.RemMsgSize     -= (SIZE_OF_BTBUF - 8);
						VarsComm.UpdateState           = 1;
					}
					break;

					case 1:
					{

						ULONG Length;

						if(call HplBc4.dBtCheckForTxBuf())
						{
							if (VarsComm.ExtTx.RemMsgSize > (SIZE_OF_BTBUF))
							{

								/* Send max number of bytes  */
								VarsComm.ExtTx.RemMsgSize -= SIZE_OF_BTBUF;
								Length = SIZE_OF_BTBUF;
							}
							else
							{

								/* Buffer can hold the last part of the requested data */
								Length = VarsComm.ExtTx.RemMsgSize;
								VarsComm.ExtTx.RemMsgSize = 0;
								*(VarsComm.pRetVal)       = SUCCESS;
								SETBtStateIdle;
							}
							Handle =(UBYTE)(VarsComm.ExtTx.SrcHandle);
							//pMapLoader->pFunc(READ, &Handle, (VarsComm.BtModuleOutBuf.Buf), &Length);
							call HplBc4.dBtSend(VarsComm.BtModuleOutBuf.Buf, Length);
						}
					}
					break;
				}
			}
			break;

			case UPD_SEARCH:
			{
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;
					case 1:
					{
						cCommsCloseConn0(&(VarsComm.UpdateState));
					}
					break;
					case 2:
					{
						/* Now ready for the actual search */
						for (Tmp = 0; Tmp < SIZE_OF_BT_DEVICE_TABLE; Tmp++)
						{
							if ((IOMapComm.BtDeviceTable[Tmp].DeviceStatus) & BT_DEVICE_KNOWN)
							{
								(IOMapComm.BtDeviceTable[Tmp].DeviceStatus) = (BT_DEVICE_AWAY | BT_DEVICE_KNOWN);
							}
							else
							{
								IOMapComm.BtDeviceTable[Tmp].DeviceStatus = BT_DEVICE_EMPTY;
							}
						}
						call HplBc4.dBtSendBtCmd((UBYTE)MSG_BEGIN_INQUIRY, (UBYTE)BT_DEFAULT_INQUIRY_MAX,
														BT_DEFAULT_INQUIRY_TIMEOUT_LO, NULL, NULL, NULL, NULL);
						(VarsComm.UpdateState)++;
					}
					break;
					case 3:
					{

						/* this is the stop search flag                    */
						/*  - meaning that the search should be stopped    */
						if (1 == VarsComm.BtCmdData.ParamOne)
						{
							call HplBc4.dBtSendBtCmd((UBYTE)MSG_CANCEL_INQUIRY, 0, 0, NULL, NULL, NULL, NULL);
							(VarsComm.UpdateState) = 7;
						}
						else
						{


							/* when inquiry is running there is 2 alloable return answers */
							/* either inquiry result or inquiry stopped                   */
							if (MSG_INQUIRY_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
							{
								call HplBc4.dBtResetTimeOut(); /* reset the cmd timeout */
								Tmp = cCommInsertDevice(&(IOMapComm.BtInBuf.Buf[2]), &(IOMapComm.BtInBuf.Buf[9]),
																				&(IOMapComm.BtInBuf.Buf[25]), (UBYTE) BT_DEVICE_UNKNOWN, &Tmp2);
//No names 
//sprintf(lcdstr,"%x MI %x %d", IOMapComm.BtDeviceTable[Tmp].BdAddr[5], IOMapComm.BtDeviceTable[Tmp].Name[0], Tmp);
//call HalLCD.displayString(lcdstr,Tmp);

								if (SIZE_OF_BT_DEVICE_TABLE > Tmp)
								{

									/* Remember to check for already existing entry ....*/
									if (DEVICE_VERIFIED != Tmp2)
									{
										(IOMapComm.BtDeviceTable[Tmp].DeviceStatus) &= ~BT_DEVICE_AWAY;
										IOMapComm.BtDeviceCnt++;
									}
								}
								else
								{

									/* We will send a stop inquiry cmd as the table is full! */
									call HplBc4.dBtSendBtCmd((UBYTE)MSG_CANCEL_INQUIRY, 0, 0, NULL, NULL, NULL, NULL);
								}
							}

							if (MSG_INQUIRY_STOPPED == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
							{
								VarsComm.BtDeviceIndex = 0;      /* Start looking for found devices at index 0          */
								VarsComm.LookUpCnt     = 0;      /* how many times should we try to ask for the name    */
								(VarsComm.UpdateState)++;
//Other NXT found with index f0?
sprintf((char *)lcdstr,"MSG_INQ_STOP %d", IOMapComm.BtDeviceCnt);
call HalLCD.displayString(lcdstr,6);
//togglepin(0);		
							}
						}
						IOMapComm.BtInBuf.Buf[BT_CMD_BYTE] = 0;
					}
					break;

					case 4:
					{

						/* this is the stop search flag                   */
						/*  - meaning that the search should be stopped   */
						if (1 == VarsComm.BtCmdData.ParamOne)
						{
							(VarsComm.UpdateState) = 8;
						}
						else
						{

							/* Needs to run through the hole list as found devices can be placed anywhere */
							/* in the table                                                               */
							for (Tmp = (VarsComm.BtDeviceIndex); Tmp < SIZE_OF_BT_DEVICE_TABLE; Tmp++)
							{
								if ((BT_DEVICE_UNKNOWN == IOMapComm.BtDeviceTable[Tmp].DeviceStatus) ||
										(BT_DEVICE_KNOWN == IOMapComm.BtDeviceTable[Tmp].DeviceStatus))
								{
									VarsComm.BtDeviceIndex = (Tmp + 1);
									(VarsComm.UpdateState)++;
									call HplBc4.dBtSendBtCmd((UBYTE)MSG_LOOKUP_NAME, 0, 0, (IOMapComm.BtDeviceTable[Tmp].BdAddr),
																NULL, NULL, NULL);
									break;
								}
							}
							if (SIZE_OF_BT_DEVICE_TABLE == Tmp)
							{
								(VarsComm.LookUpCnt)++;
								if (((VarsComm.LookUpCnt) < LOOKUPNO) && ((IOMapComm.BtDeviceNameCnt) != (IOMapComm.BtDeviceCnt)))
								{
									VarsComm.BtDeviceIndex = 0;
								}
								else
								{

									// all done
									SETBtStateIdle;
									*(VarsComm.pRetVal) = SUCCESS;
								}
							}
						}
					}
					break;

					case 5:
					{

						if (MSG_LOOKUP_NAME_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							Tmp2 = FALSE;     /* Tmp2 used to indicate name change */
							(IOMapComm.BtDeviceNameCnt)++;

							/* Try look the most obvious place in the device table */
							Tmp = VarsComm.BtDeviceIndex - 1;
							if (TRUE != cCommCheckBdaddr((IOMapComm.BtDeviceTable[Tmp].BdAddr), &(IOMapComm.BtInBuf.Buf[2])))
							{

								/* there was no match - now look the complete table */
								for (Tmp = 0; Tmp < SIZE_OF_BT_DEVICE_TABLE; Tmp++)
								{
									if (TRUE == cCommCheckBdaddr((IOMapComm.BtDeviceTable[Tmp].BdAddr), &(IOMapComm.BtInBuf.Buf[2])))
									{
										break;
									}
								}
							}

							if (Tmp < SIZE_OF_BT_DEVICE_TABLE)
							{
if(0 == strcmp((char const*)IOMapComm.BtDeviceTable[Tmp].Name,(char const*)UI_NAME_DEFAULT))
{
sprintf((char *)lcdstr,"*%x MN %s %d", IOMapComm.BtDeviceTable[Tmp].BdAddr[5], IOMapComm.BtDeviceTable[Tmp].Name, Tmp);
nxtindex = Tmp;
}
else
{
sprintf((char *)lcdstr,"%x MN %s %d", IOMapComm.BtDeviceTable[Tmp].BdAddr[5], IOMapComm.BtDeviceTable[Tmp].Name, Tmp);
}
call HalLCD.displayString(lcdstr,Tmp);

								/* Valid index with matching device adress found */
								if (0 == IOMapComm.BtInBuf.Buf[9])
								{

									if (0 == IOMapComm.BtDeviceTable[Tmp].Name[0])
									{

										/* No valid name recvd and no valid name in table -> insert "No Name" */
										cCommInsertBtName(IOMapComm.BtDeviceTable[Tmp].Name, (UBYTE*)NoName);
									}
								}
								else
								{

									/* Valid Name - check it against the one allready stored in the device table */
									/* if it differs then update                                                 */
									if (0 != strcmp((char const*)IOMapComm.BtDeviceTable[Tmp].Name, (char const*)&(IOMapComm.BtInBuf.Buf[9])))
									{
										cCommInsertBtName(IOMapComm.BtDeviceTable[Tmp].Name, &(IOMapComm.BtInBuf.Buf[9]));
										Tmp2 = TRUE;
  								}
								}
								if ((BT_DEVICE_KNOWN == (IOMapComm.BtDeviceTable[Tmp].DeviceStatus)) && (TRUE == Tmp2))
								{
									call HplBc4.dBtSendBtCmd((UBYTE)MSG_ADD_DEVICE, 0, 0, (IOMapComm.BtDeviceTable[Tmp].BdAddr),
																(IOMapComm.BtDeviceTable[Tmp].Name), (IOMapComm.BtDeviceTable[Tmp].ClassOfDevice), NULL);
									(VarsComm.UpdateState)++;
								}
								else
								{
									(VarsComm.UpdateState)--;
								}
							}

							/* Update devicestatus (name found) so it doesn't look up the name anymore */
							IOMapComm.BtDeviceTable[Tmp].DeviceStatus |= BT_DEVICE_NAME;
						}

						if (MSG_LOOKUP_NAME_FAILURE == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{

							if ((LOOKUPNO - 1) == VarsComm.LookUpCnt)
							{

								/* This is the last time we ask this device -> we will not get a valid name */
								/* Try look the most obvious place in the device table                      */
								Tmp = VarsComm.BtDeviceIndex - 1;
								if (TRUE != cCommCheckBdaddr((IOMapComm.BtDeviceTable[Tmp].BdAddr), &(IOMapComm.BtInBuf.Buf[2])))
								{
									for (Tmp = 0; Tmp < SIZE_OF_BT_DEVICE_TABLE; Tmp++)
									{
										if (TRUE == cCommCheckBdaddr((IOMapComm.BtDeviceTable[Tmp].BdAddr), &(IOMapComm.BtInBuf.Buf[2])))
										{
											break;
										}
									}
									if ((Tmp < SIZE_OF_BT_DEVICE_TABLE) && (BT_DEVICE_UNKNOWN == (IOMapComm.BtDeviceTable[Tmp].DeviceStatus)))
									{
										cCommInsertBtName(IOMapComm.BtDeviceTable[Tmp].Name, (UBYTE*) NoName);
									}
								}
								(IOMapComm.BtDeviceNameCnt)++;
							}
							(VarsComm.UpdateState)--;
						}
						IOMapComm.BtInBuf.Buf[BT_CMD_BYTE] = 0;
					}
					break;

					case 6:
					{

						/* Waiting for reply on add device command - List result */
						if (MSG_LIST_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							if (LR_SUCCESS == IOMapComm.BtInBuf.Buf[2])
							{

								/* Return and go through the list*/
								(VarsComm.UpdateState) -= 2;
							}
							else
							{
								//pMapUi->Error           = (UBYTE)IOMapComm.BtInBuf.Buf[2];
								//pMapUi->BluetoothState |= BT_ERROR_ATTENTION;
							}
						}
					}
					break;
					case 7:
					{

						/* here because search has been stopped by user during inquiry */
						if (MSG_INQUIRY_STOPPED == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{

							/* table should be cleared as no names hes been inquired */
							for (Tmp = 0; Tmp < SIZE_OF_BT_DEVICE_TABLE; Tmp++)
							{
								if ((IOMapComm.BtDeviceTable[Tmp].DeviceStatus) & BT_DEVICE_KNOWN)
								{
									(IOMapComm.BtDeviceTable[Tmp].DeviceStatus) = BT_DEVICE_KNOWN;
								}
								else
								{
									(IOMapComm.BtDeviceTable[Tmp].DeviceStatus) = BT_DEVICE_EMPTY;
								}
								IOMapComm.BtDeviceCnt     = 0;
								IOMapComm.BtDeviceNameCnt = 0;
							}
							SETBtStateIdle;
							*(VarsComm.pRetVal) = SUCCESS;
						}
					}
					break;
					case 8:
					{
						for (Tmp = (VarsComm.BtDeviceIndex); Tmp < SIZE_OF_BT_DEVICE_TABLE; Tmp++)
						{
							if (BT_DEVICE_UNKNOWN == IOMapComm.BtDeviceTable[Tmp].DeviceStatus)
							{
								IOMapComm.BtDeviceTable[Tmp].DeviceStatus = BT_DEVICE_EMPTY;
							}
						}
						SETBtStateIdle;
						*(VarsComm.pRetVal) = SUCCESS;
					}
					break;
				}
			}
			break;

			case UPD_CONNECTREQ:
			{
				switch (VarsComm.UpdateState)
				{
sprintf((char *)lcdstr,"UPD_CONNECTREQ");
call HalLCD.displayString(lcdstr,1);

					case 0:
					{
						call HplBc4.dBtSendBtCmd((UBYTE)MSG_ACCEPT_CONNECTION, 1, 0, NULL, NULL, NULL, NULL);
						cCommCopyBdaddr((IOMapComm.BtConnectTable[0].BdAddr), &(IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 1]));
						(VarsComm.UpdateState)++;
sprintf((char *)lcdstr,"MSG_ACC_CONN->");
call HalLCD.displayString(lcdstr,4);
						
					}
					break;

					case 1:
					{
						if (MSG_CONNECT_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
sprintf((char *)lcdstr,"->MSG_CONN_RES %d",IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 1]);
call HalLCD.displayString(lcdstr,5);

							/* Check for successfull connection */
							if (1 == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 1])
							{

								/* Save the handle number and look up the name of the master */
								IOMapComm.BtConnectTable[0].HandleNr = IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 2];
								//pMapUi->BluetoothState              |= BT_STATE_CONNECTED;
								call HplBc4.dBtSendBtCmd((UBYTE)MSG_LOOKUP_NAME, 0, 0, (IOMapComm.BtConnectTable[0].BdAddr), NULL, NULL, NULL);
								(VarsComm.UpdateState)++;
							}
							else
							{

								/* Unsuccessful connection */
								SETBtStateIdle;
								*(VarsComm.pRetVal) = BTCONNECTFAIL;
							}
						}
					}
					break;

					case 2:
					{

						/* a close connection can happen during connection sequence - if this */
						/* occurs for connection 0 then abort the rest of the sequence - OxFF */
						/* is unused handle                                                   */
						if ((MSG_CLOSE_CONNECTION_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE]) &&
								(0xFF == IOMapComm.BtConnectTable[0].HandleNr))
						{
							SETBtStateIdle;
							*(VarsComm.pRetVal) = BTCONNECTFAIL;
						}
						else
						{

							if (MSG_LOOKUP_NAME_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
							{
								Tmp = cCommInsertDevice(&(IOMapComm.BtInBuf.Buf[2]), &(IOMapComm.BtInBuf.Buf[9]),
																					&(IOMapComm.BtInBuf.Buf[25]), (UBYTE) BT_DEVICE_KNOWN, &Tmp2);

								if (SIZE_OF_BT_DEVICE_TABLE > Tmp)
								{

									/* entry has been added or is allready existing in the devicetable */
									cCommInsertBtName(IOMapComm.BtConnectTable[0].Name, &(IOMapComm.BtInBuf.Buf[9]));
									cCommCopyBdaddr((IOMapComm.BtConnectTable[0].BdAddr), &(IOMapComm.BtInBuf.Buf[2]));
									memcpy(IOMapComm.BtConnectTable[0].ClassOfDevice,
												IOMapComm.BtDeviceTable[Tmp].ClassOfDevice, SIZE_OF_CLASS_OF_DEVICE);
									call HplBc4.dBtSendBtCmd((UBYTE)MSG_ADD_DEVICE, 0, 0, (IOMapComm.BtDeviceTable[Tmp].BdAddr),
																(IOMapComm.BtDeviceTable[Tmp].Name), (IOMapComm.BtDeviceTable[Tmp].ClassOfDevice), NULL);
									(VarsComm.UpdateState)++;
								}
								else
								{

									/* no room in the devicetable -> reject the request. Param2 is index in connect table */
									call HplBc4.dBtSendBtCmd((UBYTE)MSG_CLOSE_CONNECTION, IOMapComm.BtConnectTable[0].HandleNr,
																	0, NULL, NULL, NULL, NULL);
									SETBtStateIdle;
									*(VarsComm.pRetVal) = BTCONNECTFAIL;
								}
							}

							if (MSG_LOOKUP_NAME_FAILURE == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
							{

								/* not able to get the name - disconnect*/
								call HplBc4.dBtSendBtCmd((UBYTE)MSG_CLOSE_CONNECTION, IOMapComm.BtConnectTable[0].HandleNr,
																			0, NULL, NULL, NULL, NULL);
								*(VarsComm.pRetVal) = BTCONNECTFAIL;
								SETBtStateIdle;
							}
						}
					}
					break;

					case 3:
					{
						if (MSG_LIST_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							if (LR_SUCCESS == IOMapComm.BtInBuf.Buf[2])
							{

								/* All success - open stream (Data mode) */
								call HplBc4.dBtSendBtCmd((UBYTE)MSG_OPEN_STREAM, IOMapComm.BtConnectTable[0].HandleNr, 0, NULL, NULL, NULL, NULL);
								(VarsComm.UpdateState)++;
							}
							else
							{

								/* no room in the BC4 -> reject the request */
								call HplBc4.dBtSendBtCmd((UBYTE)MSG_CLOSE_CONNECTION, IOMapComm.BtConnectTable[0].HandleNr,
																			0, NULL, NULL, NULL, NULL);
								*(VarsComm.pRetVal) = BTCONNECTFAIL;
								SETBtStateIdle;
							}
						}
					}
					break;

					case 4:
					{
						if (VarsComm.BtBcPinLevel)
						{
							IOMapComm.BtConnectTable[0].StreamStatus = 1;
							*(VarsComm.pRetVal) = SUCCESS;
							SETBtDataState;
							SETBtStateIdle;
						}
					}
					break;
				}
			}
			break;

			case UPD_CONNECT:
			{
sprintf((char *)lcdstr,"UPD_CONNECT start");
call HalLCD.displayString(lcdstr,5);			
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;
					case 1:
					{
						cCommsCloseConn0(&(VarsComm.UpdateState));
					}
					break;
					case 2:
					{
						call HplBc4.dBtSendBtCmd((UBYTE)MSG_CONNECT, 0, 0,
													 IOMapComm.BtDeviceTable[VarsComm.BtCmdData.ParamOne].BdAddr, NULL, NULL, NULL);
						(VarsComm.UpdateState)++;
					}
					break;

					case 3:
					{
						if (MSG_CONNECT_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
sprintf((char *)lcdstr,"MSG_CONNECT res");
call HalLCD.displayString(lcdstr,4);			

							if (IOMapComm.BtInBuf.Buf[2] == 1)
							{

								IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].HandleNr = IOMapComm.BtInBuf.Buf[3];
								//pMapUi->BluetoothState |= BT_STATE_CONNECTED;

								//Now we need to copy the data to the connectiontable
								memcpy((IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].BdAddr), (IOMapComm.BtDeviceTable[VarsComm.BtCmdData.ParamOne].BdAddr), SIZE_OF_BDADDR);
								cCommInsertBtName(IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].Name, IOMapComm.BtDeviceTable[VarsComm.BtCmdData.ParamOne].Name);
								memcpy((IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].ClassOfDevice),
												(IOMapComm.BtDeviceTable[VarsComm.BtCmdData.ParamOne].ClassOfDevice), SIZE_OF_CLASS_OF_DEVICE);
								IOMapComm.BtDeviceTable[VarsComm.BtCmdData.ParamOne].DeviceStatus = BT_DEVICE_KNOWN;

								if (VarsComm.BtCmdData.ParamTwo == 1)
								{
									IOMapComm.BrickData.BtStateStatus |= BT_CONNECTION_1_ENABLE;
								}
								else
								{
									if (VarsComm.BtCmdData.ParamTwo == 2)
									{
										IOMapComm.BrickData.BtStateStatus |= BT_CONNECTION_2_ENABLE;
									}
									else
									{
										if (VarsComm.BtCmdData.ParamTwo == 3)
										{
											IOMapComm.BrickData.BtStateStatus |= BT_CONNECTION_3_ENABLE;
										}
									}
								}
								call HplBc4.dBtSendBtCmd((UBYTE)MSG_ADD_DEVICE, 0, 0, (IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].BdAddr),
															 (IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].Name),
															 (IOMapComm.BtDeviceTable[VarsComm.BtCmdData.ParamOne].ClassOfDevice), NULL);
							 (VarsComm.UpdateState)+=3; /* skip the pin code part */
							}
							else
							{

								/* Connect request denied */
								*(VarsComm.pRetVal) = BTCONNECTFAIL;
								SETBtStateIdle;
							}
						}
						if (MSG_REQUEST_PIN_CODE == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
sprintf((char *)lcdstr,"MSG_REQ_PIN res");
call HalLCD.displayString(lcdstr,3);						
							*(VarsComm.pRetVal)    = REQPIN;
							VarsComm.pValidPinCode = NULL;
							(VarsComm.UpdateState)++;
						}
					}
					break;

					case 4:
					{
						if (NULL != VarsComm.pValidPinCode)
						{

							memcpy((IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].PinCode),
											VarsComm.pValidPinCode, SIZE_OF_BT_PINCODE);

							call HplBc4.dBtSendBtCmd((UBYTE)MSG_PIN_CODE, 0, 0, IOMapComm.BtDeviceTable[VarsComm.BtCmdData.ParamOne].BdAddr,
															NULL, NULL, (VarsComm.pValidPinCode));
							(VarsComm.UpdateState)++;
						}
						if (MSG_CONNECT_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{

							/* if no pin code has been accepted then timeout indicated */
							/* by connect failiure - it can only be failiure here      */
							*(VarsComm.pRetVal) = BTCONNECTFAIL;
							SETBtStateIdle;
						}
					}
					break;

					case 5:
					{

						if (MSG_CONNECT_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{

							/* Connect failiure can happen at any time */
							*(VarsComm.pRetVal) = BTCONNECTFAIL;
							SETBtStateIdle;
						}
						if (MSG_PIN_CODE_ACK == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{

							/* return back and wait for connect ack */
							(VarsComm.UpdateState) = 3;
						}
					}
					break;
					case 6:
					{
						if (MSG_LIST_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							*(VarsComm.pRetVal) = SUCCESS;
							SETBtStateIdle;
						}
					}
					break;
				}
			}
			break;

			case UPD_DISCONNECT:
			{
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;

					case 1:
					{
						if (BLUETOOTH_HANDLE_UNDEFIEND != IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamOne].HandleNr)
						{
							VarsComm.BtCmdData.ParamOne = IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamOne].HandleNr;
							call HplBc4.dBtSendBtCmd((UBYTE)MSG_CLOSE_CONNECTION, VarsComm.BtCmdData.ParamOne, 0, NULL, NULL, NULL, NULL);
							(VarsComm.UpdateState)++;
						}
						else
						{
							*(VarsComm.pRetVal) = SUCCESS;
							SETBtStateIdle;
						}
					}
					break;

					case 2:
					{

						/* look for right message and right handle */
						if ((MSG_CLOSE_CONNECTION_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE]) &&
								(VarsComm.BtCmdData.ParamOne == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE + 2]))
						{
							*(VarsComm.pRetVal) = SUCCESS;
							SETBtStateIdle;
						}
					}
					break;
				}
			}
			break;
			case UPD_DISCONNECTALL:
			{
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;
					case 1:
					{
						cCommsDisconnectAll(&(VarsComm.UpdateState));
					}
					break;
					case 2:
					{
						*(VarsComm.pRetVal) = SUCCESS;
						SETBtStateIdle;
					}
					break;
				}
			}
			break;
			case UPD_REMOVEDEVICE:
			{
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;
					case 1:
					{
						cCommsCloseConn0(&(VarsComm.UpdateState));
					}
					break;
					case 2:
					{
						call HplBc4.dBtSendBtCmd((UBYTE)MSG_REMOVE_DEVICE, 0, 0,
														IOMapComm.BtDeviceTable[VarsComm.BtCmdData.ParamOne].BdAddr, NULL, NULL, NULL);
						IOMapComm.BtDeviceTable[VarsComm.BtCmdData.ParamOne].DeviceStatus = BT_DEVICE_EMPTY;
						(VarsComm.UpdateState)++;
					}
					break;
					case 3:
					{
						if (MSG_LIST_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							*(VarsComm.pRetVal) = SUCCESS;
							SETBtStateIdle;
						}
					}
					break;
				}
			}
			break;

			case UPD_PINREQ:
			{
sprintf((char *)lcdstr,"UPD_PINREQ");
call HalLCD.displayString(lcdstr,4);

				/* This is pincode request from the outside - always conn 0*/
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
					
						if (NULL != VarsComm.pValidPinCode)
						{
							memcpy((IOMapComm.BtConnectTable[0].PinCode),
											VarsComm.pValidPinCode, SIZE_OF_BT_PINCODE);
							call HplBc4.dBtSendBtCmd((UBYTE)MSG_PIN_CODE, 0, 0, (IOMapComm.BtConnectTable[0].BdAddr),
															NULL, NULL, (VarsComm.pValidPinCode));
							(VarsComm.UpdateState)++;
						}
					}
					break;
					case 1:
					{
						if (MSG_PIN_CODE_ACK == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							SETBtStateIdle;
						}
					}
					break;
				}
			}
			break;

			case UPD_VISIBILITY:
			{
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;
					case 1:
					{
						cCommsCloseConn0(&(VarsComm.UpdateState));
					}
					break;
					case 2:
					{
						call HplBc4.dBtSendBtCmd((UBYTE)MSG_SET_DISCOVERABLE, VarsComm.BtCmdData.ParamOne, 0, NULL, NULL, NULL, NULL);
						(VarsComm.UpdateState)++;
					}
					break;
					case 3:
					{
						if (MSG_DISCOVERABLE_ACK == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							if (VarsComm.BtCmdData.ParamOne == 1)
							{
								IOMapComm.BrickData.BtStateStatus |= BT_BRICK_VISIBILITY;
								//pMapUi->BluetoothState            |= BT_STATE_VISIBLE;
							}
							else
							{
								IOMapComm.BrickData.BtStateStatus &= ~BT_BRICK_VISIBILITY;
								//pMapUi->BluetoothState            &= ~BT_STATE_VISIBLE;
							}
							*(VarsComm.pRetVal) = SUCCESS;
							SETBtStateIdle;
						}
					}
					break;
				}
			}
			break;

			case UPD_OFF:
			{
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						cCommsSetCmdMode(&(VarsComm.UpdateState));
					}
					break;
					case 1:
					{
						cCommsDisconnectAll(&(VarsComm.UpdateState));
					}
					break;
					case 2:
					{
						call HplBc4.dBtSendBtCmd((UBYTE)MSG_SET_BRICK_STATUSBYTE, BT_DISABLE, 0, NULL, NULL, NULL, NULL);
						(VarsComm.UpdateState)++;
					}
					break;
					case 3:
					{
						if (MSG_SET_BRICK_STATUSBYTE_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
						{
							if (IOMapComm.BtInBuf.Buf[2] == LR_SUCCESS)
							{
								SETBtOff;
								//pMapUi->BluetoothState  = BT_STATE_OFF;
								//pMapUi->Flags          |= UI_REDRAW_STATUS;
							}
							*(VarsComm.pRetVal) = SUCCESS;
							SETBtStateIdle;
						}
					}
					break;
				}
			}
			break;
			case UPD_SENDDATA:
			{
				switch (VarsComm.UpdateState)
				{
					case 0:
					{
						if (1 == IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].StreamStatus)
						{

							/* Stream is allready open for the requested channel */
							(VarsComm.UpdateState) += 2;
						}
						else
						{

							/* Stream not open - try open it*/
							(VarsComm.UpdateState)++;
						}
					}
					break;
					case 1:
					{
						cCommsOpenStream(&(VarsComm.UpdateState));
					}
					break;
					case 2:
					{

						/* Stream is now opened now send the data */
						IOMapComm.BtInBuf.Buf[0] = 0;
						call HplBc4.dBtSendMsg((VarsComm.BtModuleOutBuf.Buf), VarsComm.BtCmdData.ParamOne, (UWORD)(VarsComm.BtCmdData.ParamOne));
						(VarsComm.UpdateState)++;
					}
					break;
					case 3:
					{
						if(call HplBc4.dBtCheckForTxBuf())
						{
							if (VarsComm.BtCmdData.ParamThree)
							{
								VarsComm.ExtTx.Timer = 0;
								(VarsComm.UpdateState)++;
							}
							else
							{
								*(VarsComm.pRetVal) = SUCCESS;
								SETBtStateIdle;
							}
						}
					}
					break;
					case 4:
					{
						if (0x02 == IOMapComm.BtInBuf.Buf[0])
						{

							/* a reply has been received now release the send sequence */
							*(VarsComm.pRetVal) = SUCCESS;
							SETBtStateIdle;
						}
						else
						{
							if (++VarsComm.ExtTx.Timer > BTSTREAMTOUT)
							{
								*(VarsComm.pRetVal) = BTTIMEOUT;
								SETBtStateIdle;
							}
						}
					}
					break;
				}
			}
			break;
			default:
			{

				/* This is idle */
				VarsComm.UpdateState = 0;
			}
			break;
		}
	}

	UWORD     cCommCopyBdaddr(UBYTE *pDst, UBYTE *pSrc)
	{
		memcpy(pDst, pSrc, SIZE_OF_BDADDR);
		return((UWORD) SIZE_OF_BDADDR);
	}

	UWORD     cCommCheckBdaddr(UBYTE *pAdr, UBYTE *pSrc)
	{
		UWORD   RetVal;

		RetVal = FALSE;
		if (0 == memcmp((UBYTE*)pAdr, pSrc, SIZE_OF_BDADDR))
		{
			RetVal = TRUE;
		}
		return(RetVal);
	}

	UWORD     cCommInsertBtName(UBYTE *pDst, UBYTE *pSrc)
	{
		UBYTE Cnt;

		Cnt = 0;

		/* Complete brick name */
		while ((pSrc[Cnt]) && (Cnt < (SIZE_OF_BT_NAME - 1)))
		{
			pDst[Cnt] = pSrc[Cnt];
			Cnt++;
		}

		/* Fill remaining up with zeros */
		while (Cnt < SIZE_OF_BT_NAME)
		{
			pDst[Cnt] = 0;
			Cnt++;
		}

		return((UWORD)SIZE_OF_BT_NAME);
	}


	UWORD     cCommInsertDevice(UBYTE *pBdaddr, UBYTE *pName, UBYTE *pCod, UBYTE DeviceStatus, UBYTE *pAddInfo)
	{
		UWORD   Tmp;
		UWORD   RtnVal;

		RtnVal    = FALSE;
		*pAddInfo = DEVICE_VERIFIED;
		for (Tmp = 0; Tmp < SIZE_OF_BT_DEVICE_TABLE; Tmp++)
		{
			if ((TRUE == cCommCheckBdaddr((IOMapComm.BtDeviceTable[Tmp].BdAddr), pBdaddr)) &&
					(IOMapComm.BtDeviceTable[Tmp].DeviceStatus != BT_DEVICE_EMPTY))
			{

				if ((IOMapComm.BtDeviceTable[Tmp].DeviceStatus) & BT_DEVICE_AWAY)
				{
					*pAddInfo = DEVICE_UPDATED;
					(IOMapComm.BtDeviceTable[Tmp].DeviceStatus) &= ~BT_DEVICE_AWAY;
				}

				if (BT_DEVICE_UNKNOWN == IOMapComm.BtDeviceTable[Tmp].DeviceStatus)
				{

					/* Former unknown adresses can be upgraded - downgrading is not possible */
					IOMapComm.BtDeviceTable[Tmp].DeviceStatus = DeviceStatus;
				}
				if (pCod != NULL)
				{

					/* Class of device can also upgraded - never downgraded to 0 */
					memcpy(&(IOMapComm.BtDeviceTable[Tmp].ClassOfDevice), pCod, SIZE_OF_CLASS_OF_DEVICE);
				}
				if ((*pName) != 0)
				{

					/* Only upgrade name if name is received */
					cCommInsertBtName(IOMapComm.BtDeviceTable[Tmp].Name, pName);
				}
				RtnVal = TRUE;

				/* Break out - entry can only be found once */
				break;
			}
		}

		if (FALSE == RtnVal)
		{
			for (Tmp = 0; Tmp < SIZE_OF_BT_DEVICE_TABLE; Tmp++)
			{
				if (IOMapComm.BtDeviceTable[Tmp].DeviceStatus == BT_DEVICE_EMPTY)
				{
					*pAddInfo = DEVICE_INSERTED;
					IOMapComm.BtDeviceTable[Tmp].DeviceStatus = DeviceStatus;
					cCommCopyBdaddr((IOMapComm.BtDeviceTable[Tmp].BdAddr), pBdaddr);
					cCommInsertBtName(IOMapComm.BtDeviceTable[Tmp].Name, pName);
					if (NULL != pCod)
					{
						memcpy((IOMapComm.BtDeviceTable[Tmp].ClassOfDevice), pCod, SIZE_OF_CLASS_OF_DEVICE);
					}
					else
					{
						memset((IOMapComm.BtDeviceTable[Tmp].ClassOfDevice), 0, SIZE_OF_CLASS_OF_DEVICE);
					}
					RtnVal = TRUE;
					break;
				}
			}
		}

		/* Function returns SIZE_OF_BT_DEVICE_TABLE if device is not in the list */
		return(Tmp);
	}

	void      cCommsSetCmdMode(UBYTE *pNextState)
	{
		switch(VarsComm.CmdSwitchCnt)
		{
			case 0:
			{
				if (BT_ARM_CMD_MODE != VarsComm.BtState)
				{
					cCommClearStreamStatus();
					VarsComm.BtCmdModeWaitCnt = 0;
					VarsComm.CmdSwitchCnt++;
				}
				else
				{

					/* allready in CMD mode - Exit */
					VarsComm.CmdSwitchCnt    = 0;
					(*pNextState)++;
				}
			}
			break;

			case 1:
			{

				/* stream status has been cleared now wait until buffers has been emptied */
				if (TRUE == call HplBc4.dBtTxEnd())
				{

					/* Wait 100 ms after last byte has been sent to BC4 - else BC4 can crash */
					if (++(VarsComm.BtCmdModeWaitCnt) > 100)
					{
						call HplBc4.dBtClearArm7CmdSignal();
						VarsComm.CmdSwitchCnt++;
					}
				}
			}
			break;

			case 2:
			{
				if (VarsComm.BtBcPinLevel == 0)
				{

					/* Bluecore has entered cmd mode */
					SETBtCmdState;
					VarsComm.CmdSwitchCnt = 0;
					(*pNextState)++;
				}
			}
			break;

			default:
			{
				VarsComm.CmdSwitchCnt = 0;
			}
			break;
		}
	}

	void      cCommsOpenStream(UBYTE *pNextState)
	{
		switch(VarsComm.StreamStateCnt)
		{
			case 0:
			{

				if (SIZE_OF_BT_CONNECT_TABLE > VarsComm.BtCmdData.ParamTwo)
				{

					/* first check if there is a connection on the requested channel */
					if ('\0' != IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].Name[0])
					{

						if (1 == IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].StreamStatus)
						{

							/* Stream is allready open - continue */
							(*pNextState)++;
						}
						else
						{

							/* There is a connection on requested channel proceed */
							VarsComm.StreamStateCnt = 1;
						}
					}
					else
					{

						/* Error - no connecteion on requested channel - exit */
						*(VarsComm.pRetVal)  = (UWORD)ERR_COMM_CHAN_NOT_READY;
						*(VarsComm.pRetVal) |= 0x8000;
						SETBtStateIdle;
					}
				}
				else
				{

					/* Error - Illegal channel no - exit */
					*(VarsComm.pRetVal)  = (UWORD)ERR_COMM_CHAN_INVALID;
					*(VarsComm.pRetVal) |= 0x8000;
					SETBtStateIdle;
				}
			}
			break;

			case 1:
			{
				cCommsSetCmdMode(&(VarsComm.StreamStateCnt));
			}
			break;

			case 2:
			{
				cCommsCloseConn0(&(VarsComm.StreamStateCnt));
			}
			break;

			case 3:
			{

				/* Open stream on the specified channel */
				VarsComm.StreamStateCnt = 4;
				call HplBc4.dBtSendBtCmd((UBYTE)MSG_OPEN_STREAM, IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].HandleNr,
												0, NULL, NULL, NULL, NULL);
			}
			break;

			case 4:
			{
				if (VarsComm.BtBcPinLevel)
				{
					SETBtDataState;
					IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].StreamStatus = 1;
					VarsComm.StreamStateCnt  = 0;
					(*pNextState)++;
				}
			}
			break;

			default:
			{
				VarsComm.StreamStateCnt = 0;
			}
			break;
		}
	}

	void      cCommsCloseConn0(UBYTE *pNextState)
	{
		switch(VarsComm.CloseConn0Cnt)
		{
			case 0:
			{
				if ('\0' != IOMapComm.BtConnectTable[0].Name[0])
				{

					/* now disconnect channel 0 */
					VarsComm.CloseConn0Cnt = 1;
					call HplBc4.dBtSendBtCmd((UBYTE)MSG_CLOSE_CONNECTION, IOMapComm.BtConnectTable[0].HandleNr, 0, NULL, NULL, NULL, NULL);
				}
				else
				{
					(*pNextState)++;
				}
			}
			break;
			case 1:
			{
				if (MSG_CLOSE_CONNECTION_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
				{
					VarsComm.CloseConn0Cnt = 0;
					(*pNextState)++;
				}
			}
			break;
			default:
			{
				VarsComm.CloseConn0Cnt = 0;
			}
			break;
		}
	}

	void      cCommsDisconnectAll(UBYTE *pNextState)
	{
		switch(VarsComm.DiscAllCnt)
		{
			case 0:
			{
				VarsComm.BtCmdData.ParamOne = 0;
				(VarsComm.DiscAllCnt)++;
			}
			break;
			case 1:
			{
				while (('\0' == IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamOne].Name[0]) &&
								(VarsComm.BtCmdData.ParamOne < 4))
				{
					VarsComm.BtCmdData.ParamOne++;
				}
				if (VarsComm.BtCmdData.ParamOne < 4)
				{

					/* now disconnect selected channel */
					call HplBc4.dBtSendBtCmd((UBYTE)MSG_CLOSE_CONNECTION, IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamOne].HandleNr,
													0, NULL, NULL, NULL, NULL);
					VarsComm.BtCmdData.ParamOne++;
					(VarsComm.DiscAllCnt)++;
				}
				else
				{

					/* no more connections - move on */
					(VarsComm.DiscAllCnt)   = 0;
					(*pNextState)++;
				}
			}
			break;
			case 2:
			{
				if (MSG_CLOSE_CONNECTION_RESULT == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE])
				{

					/* Go back and check for more connections to close */
					(VarsComm.DiscAllCnt)--;
				}
			}
			break;
		}
	}

	void      cCommsBtReset(UBYTE *pNextState)
	{
		switch(VarsComm.ResetBtCnt)
		{
			case 0:
			{

				/* Setup Reset sequence */
				VarsComm.BtResetTimeCnt = 0;
				VarsComm.ResetBtCnt     = 1;
				call HplBc4.dBtSetBcResetPinLow();
			}
			break;
			case 1:
			{

				/* Reset should be held low for a certain time "BLUECORE_RESET_TIME" */
				VarsComm.BtResetTimeCnt++;
				if (VarsComm.BtResetTimeCnt > BLUECORE_RESET_TIME)
				{
					call HplBc4.dBtSetBcResetPinHigh();
					VarsComm.BtWaitTimeCnt = 0;
					VarsComm.ResetBtCnt    = 2;
				}
			}
			break;
			case 2:
			{

				/* Wait after reset is released either wait a minimum time or wait for the reset indication telegram  */
				VarsComm.BtWaitTimeCnt++;
				if ((VarsComm.BtWaitTimeCnt > BLUECORE_WAIT_BEFORE_INIT) || (MSG_RESET_INDICATION == IOMapComm.BtInBuf.Buf[BT_CMD_BYTE]))
				{
					memset(&(IOMapComm.BtDeviceTable), 0, sizeof(IOMapComm.BtDeviceTable));
					cCommClrConnTable();
					VarsComm.ResetBtCnt = 3;
				}
			}
			break;

			case 3:
			{
				SETBtCmdState;
				VarsComm.ResetBtCnt = 0;
				(*pNextState)++;
			}
			break;
		}
	}

  // External API... and internal...
	command UWORD HalBt.cCommReq(UBYTE Cmd, UBYTE Param1, UBYTE Param2, UBYTE Param3, UBYTE *pName, UWORD *pRetVal)
	{
		ULONG   Length;
		UWORD   ReturnVal;

		ReturnVal = BTBUSY;
		*pRetVal  = BTBUSY;

		if ((UPD_IDLE == (VarsComm.ActiveUpdate)) || ((UPD_SEARCH == (VarsComm.ActiveUpdate)) && (STOPSEARCH == Cmd)))
		{

			ReturnVal = SUCCESS;
			*pRetVal  = INPROGRESS;
			VarsComm.pRetVal = pRetVal;
			switch(Cmd)
			{
				case SENDFILE:
				{
					ReturnVal = SUCCESS;

					/* No file is currently beeing send - Now open the file */
					//VarsComm.ExtTx.SrcHandle = pMapLoader->pFunc(OPENREAD, pName, NULL, &Length);
Length = 0;					
					VarsComm.ExtTx.RemFileSize   = Length;
					VarsComm.ExtTx.SlotNo        = Param1;
					VarsComm.BtCmdData.ParamTwo  = Param1; /* This is used to open the correct stream */

					if (0x8000 > VarsComm.ExtTx.SrcHandle)
					{

						/* Source file is ok - go ahead */
						VarsComm.ActiveUpdate = UPD_SENDFILE;
						VarsComm.ExtTx.Timer  = 0;
						VarsComm.ExtTx.Cmd    = WRITE;
						cCommCopyFileName(VarsComm.ExtTx.FileName, pName);
					}
					else
					{

						/* Error in opening source file for read - file do not exist */
						ReturnVal = FILETX_SRCMISSING;
					}
				}
				break;

				case CONNECT:
				{

					if (BLUETOOTH_HANDLE_UNDEFIEND == IOMapComm.BtConnectTable[Param2].HandleNr)
					{

						/* Connection not occupied */
						VarsComm.ActiveUpdate       = UPD_CONNECT;
						VarsComm.BtCmdData.ParamOne = Param1;
						VarsComm.BtCmdData.ParamTwo = Param2;
					}
					else
					{

						/* Connection occupied */
						ReturnVal = BTCONNECTFAIL;
						*pRetVal  = BTCONNECTFAIL;
					}
				}
				break;

				case DISCONNECT:
				{
					VarsComm.ActiveUpdate = UPD_DISCONNECT;
					VarsComm.BtCmdData.ParamOne = Param1;
				}
				break;

				case DISCONNECTALL:
				{
					VarsComm.ActiveUpdate = UPD_DISCONNECTALL;
				}
				break;

				case SEARCH:
				{
					VarsComm.ActiveUpdate       = UPD_SEARCH;
					IOMapComm.BtDeviceNameCnt   = 0;
					IOMapComm.BtDeviceCnt       = 0;
					VarsComm.BtCmdData.ParamOne = 0;
				}
				break;
				case STOPSEARCH:
				{
					if (UPD_SEARCH == (VarsComm.ActiveUpdate))
					{
						VarsComm.BtCmdData.ParamOne = 1;
					}
					else
					{
						*pRetVal = SUCCESS;
					}
				}
				break;
				case REMOVEDEVICE:
				{
					VarsComm.ActiveUpdate = UPD_REMOVEDEVICE;
					VarsComm.BtCmdData.ParamOne = Param1;
				}
				break;
				case VISIBILITY:
				{
					VarsComm.ActiveUpdate       = UPD_VISIBILITY;
					VarsComm.BtCmdData.ParamOne = Param1;
				}
				break;
				case SETCMDMODE:
				{
					VarsComm.ActiveUpdate = UPD_REQCMDMODE;
				}
				break;
				case FACTORYRESET:
				{
					VarsComm.ActiveUpdate = UPD_FACTORYRESET;
				}
				break;
				case BTON:
				{
					if (1) //BT_STATE_OFF & (pMapUi->BluetoothState)) //Should use UI as state as well? Now it loops
					{
						VarsComm.ActiveUpdate = UPD_RESET;
					}
					else
					{

						/* Device is already on*/
						*pRetVal = SUCCESS;
					}
				}
				break;
				case BTOFF:
				{
					VarsComm.ActiveUpdate = UPD_OFF;
				}
				break;
				case SENDDATA:
				{

					/* Param2 indicates the port that the data should be */
					/* be sent on - param1 indicates the number of data  */
					/* to be sent. pName is the pointer to the data      */
					if (Param1 <= sizeof(VarsComm.BtModuleOutBuf.Buf))
					{
						if ('\0' != IOMapComm.BtConnectTable[VarsComm.BtCmdData.ParamTwo].Name[0])
						{
							VarsComm.BtCmdData.ParamOne   = Param1;
							VarsComm.BtCmdData.ParamTwo   = Param2;
							VarsComm.BtCmdData.ParamThree = Param3;
							memcpy((VarsComm.BtModuleOutBuf.Buf), pName, Param1);
							VarsComm.ActiveUpdate = UPD_SENDDATA;
						}
						else
						{
							ReturnVal  = (UWORD)ERR_COMM_CHAN_NOT_READY;
							ReturnVal |= 0x8000;
						}
					}
					else
					{
						ReturnVal  = (UWORD)ERR_COMM_BUFFER_FULL;
						ReturnVal |= 0x8000;
					}
				}
				break;
				case OPENSTREAM:
				{
					VarsComm.BtCmdData.ParamTwo = Param2;
					VarsComm.ActiveUpdate       = UPD_OPENSTREAM;
				}
				break;
				case SETBTNAME:
				{
					VarsComm.ActiveUpdate = UPD_BRICKNAME;
				}
				break;
				case EXTREAD:
				{
					VarsComm.ActiveUpdate = UPD_EXTREAD;
				}
				break;
				case PINREQ:
				{

					/* This is an incomming pinrequest for connection on connection 0 because */
					/* ActiveUpdate is idle (if it was incomming it is not idle)              */
					cCommCopyBdaddr((IOMapComm.BtConnectTable[0].BdAddr), &(IOMapComm.BtInBuf.Buf[2]));
					//pMapUi->BluetoothState |= (BT_CONNECT_REQUEST | BT_PIN_REQUEST);
					VarsComm.pValidPinCode  = NULL;
					VarsComm.ActiveUpdate   = UPD_PINREQ;
sprintf((char *)lcdstr,"PINREQ");
call HalLCD.displayString(lcdstr,3);
//togglepin(0);					
				}
				break;
				case CONNECTREQ:
				{
					VarsComm.ActiveUpdate = UPD_CONNECTREQ;
				}
				break;
			}
		}
		return(ReturnVal);
	}

	void      cCommPinCode(UBYTE *pPinCode)
	{
		VarsComm.pValidPinCode = pPinCode;
		if (REQPIN == (*(VarsComm.pRetVal)))
		{
			*(VarsComm.pRetVal)    = INPROGRESS;
		}
	}

	void      cCommClrConnTable()
	{
		UBYTE   Tmp;

		for (Tmp = 0; Tmp < SIZE_OF_BT_CONNECT_TABLE; Tmp++)
		{
			CLEARConnEntry(Tmp);
		}
		IOMapComm.BrickData.BtStateStatus &= ~(BT_CONNECTION_0_ENABLE | BT_CONNECTION_1_ENABLE | BT_CONNECTION_2_ENABLE | BT_CONNECTION_3_ENABLE);
		//pMapUi->BluetoothState            &= ~BT_STATE_CONNECTED;
		//pMapUi->Flags                     |=  UI_REDRAW_STATUS;
	}
	
	//TMP
	command UBYTE HalBt.getNxtIndex(){
	  return nxtindex;
	}  
	
	task void dataReceivedTask(){
	  sprintf((char *)lcdstr,"d:%d,%p",IOMapComm.BtInBuf.InPtr, &IOMapComm);
    call HalLCD.displayString(lcdstr,5);	
	  signal HalBt.dataReceived();
	}

}
