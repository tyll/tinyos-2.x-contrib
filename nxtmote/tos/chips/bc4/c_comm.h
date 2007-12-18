//
// Date init       14.12.2004
//
// Revision date   $Date$
//
// Filename        $Workfile:: c_comm.h                                      $
//
// Version         $Revision$
//
// Archive         $Archive:: /LMS2006/Sys01/Main/Firmware/Source/c_comm.h   $
//
// Platform        C
//

#ifndef   C_COMM
#define   C_COMM


#define   BLUECORE_RESET_TIME           100     // Time in mS
#define   BLUECORE_WAIT_BEFORE_INIT     5000    // Time in mS
#define   BLUETOOTH_HANDLE_UNDEFIEND    0xFF

/* Constants related to BtAdrStatus*/
enum
{
  COLDBOOT,
  INITIALIZED,
  BTADRERROR
};


enum
{
  USB_CH,
  BT_CH,
  HISPEED_CH,
  NO_OF_CHANNELS
};


/* enum reffering to BT update */
enum
{
  UPD_BRICKNAME,
  UPD_FACTORYRESET,
  UPD_OPENSTREAM,
  UPD_REQCMDMODE,
  UPD_CONNECT,
  UPD_CONNECTREQ,
  UPD_PINREQ,
  UPD_DISCONNECT,
  UPD_DISCONNECTALL,
  UPD_REMOVEDEVICE,
  UPD_SEARCH,
  UPD_RESET,
  UPD_EXTREAD,
  UPD_SENDFILE,
  UPD_OFF,
  UPD_VISIBILITY,
  UPD_SENDDATA,
  UPD_IDLE
};

/* Constants reffering to Protocol */
enum
{
  DIRECT_CMD    = 0x00,
  SYSTEM_CMD    = 0x01,
  REPLY_CMD     = 0x02,
  NO_REPLY_BIT  = 0x80
};

typedef   struct
{
  ULONG   RemFileSize;
  UWORD   RemMsgSize;
  UWORD   SrcHandle;
  UWORD   DstHandle;
  UWORD   Timer;
  UBYTE   FileName[FILENAME_LENGTH + 1];
  UBYTE   Cmd;
  UBYTE   SlotNo;
}EXTTX;

typedef   struct
{
  UBYTE   Buf[256];
  UWORD   InPtr;
  UWORD   OutPtr;
}BTDATA;

typedef   struct
{
  UBYTE   Buf[256];
  UWORD   InPtr;
  UWORD   OutPtr;
}HSDATA;

typedef   struct
{
  UBYTE   Status;
  UBYTE   Type;
  UBYTE   Handle;
  UBYTE   Cmd;
}EXTMODE;

typedef   struct
{
  UBYTE   ParamOne;
  UBYTE   ParamTwo;
  UBYTE   ParamThree;
}BTCMD;

typedef   struct
{
  UBYTE     BtUpdateDataConnectNr;
  UBYTE     BtBcPinLevel;
  UBYTE     BtResetTimeCnt;
  UWORD     BtWaitTimeCnt;
  BTDATA    BtModuleInBuf;
  BTDATA    BtModuleOutBuf;
  BTCMD     BtCmdData;
  UBYTE     HsState;
  HSDATA    HsModuleInBuf;
  HSDATA    HsModuleOutBuf;
  EXTTX     ExtTx;
  EXTMODE   ExtMode[NO_OF_CHANNELS];
  UBYTE     ActiveUpdate;
  UBYTE     UpdateState;
  UBYTE     BtDeviceIndex;
  UBYTE     CmdSwitchCnt;
  UBYTE     StreamStateCnt;
  UBYTE     CloseConn0Cnt;
  UBYTE     DiscAllCnt;
  UBYTE     ResetBtCnt;
  UBYTE     BtState;
  UWORD     *pRetVal;
  UWORD     RetVal;
  UBYTE     *pValidPinCode;
  UBYTE     LookUpCnt;
  UBYTE     BtAdrStatus;
  UBYTE     BtCmdModeWaitCnt;
}VARSCOMM;

void      cCommInit(void* pHeader);
void      cCommCtrl();
void      cCommExit();

//extern    const HEADER cComm;

#endif
