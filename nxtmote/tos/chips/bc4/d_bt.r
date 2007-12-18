//
// Date init       14.12.2004
//
// Revision date   $Date$
//
// Filename        $Workfile:: d_bt.r                                        $
//
// Version         $Revision$
//
// Archive         $Archive:: /LMS2006/Sys01/Main/Firmware/Source/d_bt.r     $
//
// Platform        C
//

#ifndef   D_BT_R
#define   D_BT_R

//#ifdef    SAM7S256

//#if       defined (PROTOTYPE_PCB_3) || (PROTOTYPE_PCB_4)

#define   BT_RX_PIN                     AT91C_PIO_PA21
#define   BT_TX_PIN                     AT91C_PIO_PA22

#define   BT_RTS_PIN                    AT91C_PIO_PA24
#define   BT_CTS_PIN                    AT91C_PIO_PA25

#define   BT_RST_PIN                    AT91C_PIO_PA11
#define   BT_ARM7_CMD_PIN               AT91C_PIO_PA27

// SPI
#define   BT_CS_PIN                     AT91C_PIO_PA31
#define   BT_SCK_PIN                    AT91C_PIO_PA23

//#else

//#endif

#define   BAUD_RATE                     460800L

#define   SIZE_OF_INBUF                 128
#define   NO_OF_INBUFFERS               2
#define   NO_OF_DMA_OUTBUFFERS          2
#define   SIZE_OF_OUTBUF                256

#define   PER_ID7_UART_1                0x80
#define   UART1_INQ                     0x80
#define   EXT_LEN_MSG_BIT               0x80

static    UBYTE  InBuf[NO_OF_INBUFFERS][SIZE_OF_INBUF];
static    ULONG  InBufPtrs[NO_OF_INBUFFERS];
static    UBYTE  InBufInPtr;
static    UBYTE  LengthSize;

static    UBYTE  OutDma[NO_OF_DMA_OUTBUFFERS][SIZE_OF_OUTBUF];
static    UBYTE  DmaBufPtr;
static    UBYTE  *pBuffer;

static    UBYTE  MsgIn;
static    UBYTE  InBufOutCnt;
static    UWORD  FullRxLength;
static    UWORD  RemainingLength;


#define   ENABLEDebugOutput             {\
                                          *AT91C_PIOA_PER = 0x20000000;                /* Enable PIO on PA029 */\
                                          *AT91C_PIOA_OER = 0x20000000;                /* PA029 set to Output  */\
                                        }

#define   SETDebugOutputHigh            *AT91C_PIOA_SODR  = 0x20000000

#define   SETDebugOutputLow             *AT91C_PIOA_CODR  = 0x20000000

#define   BTInit                        {\
                                          UBYTE Tmp;\
                                          LengthSize  = 1;\
                                          InBufInPtr = 0;\
                                          for(Tmp = 0; Tmp < NO_OF_INBUFFERS; Tmp++)\
                                          {\
                                            InBufPtrs[Tmp]   = (ULONG)&(InBuf[Tmp][0]);\
                                          }\
                                          *AT91C_PMC_PCER = PER_ID7_UART_1;                        /* Enable PMC clock for UART 1 */\
                                          *AT91C_PIOA_PDR = BT_RX_PIN | BT_TX_PIN | BT_SCK_PIN | BT_RTS_PIN | BT_CTS_PIN; /* Disable Per. A on PA21, PA22, PA23, PA24 & PA25 */\
                                          *AT91C_PIOA_ASR = BT_RX_PIN | BT_TX_PIN | BT_SCK_PIN | BT_RTS_PIN | BT_CTS_PIN; /* Enable Per. A on PA21, PA22, PA23, PA24 & PA25 */\
                                          *AT91C_US1_CR   = AT91C_US_RSTSTA;                       /* Resets pins on UART1 */\
                                          *AT91C_US1_CR   = AT91C_US_STTTO;                        /* Start timeout functionality after 1 byte */\
                                          *AT91C_US1_RTOR = 10000;                                 /* Approxitely 20 mS,x times bit time with 115200 bit pr s */\
                                          *AT91C_US1_IDR  = AT91C_US_TIMEOUT;                      /* Disable interrupt on timeout */\
                                          *AT91C_AIC_IDCR = UART1_INQ;                             /* Disable UART1 interrupt */\
                                          *AT91C_AIC_ICCR = UART1_INQ;                             /* Clear interrupt register */\
                                          *AT91C_US1_MR   = AT91C_US_USMODE_HWHSH;                 /* Set UART with HW handshake */\
                                          *AT91C_US1_MR  &= ~AT91C_US_SYNC;                        /* Set UART in asynchronous mode */\
                                          *AT91C_US1_MR  |= AT91C_US_CLKS_CLOCK;                   /* Clock setup MCK*/\
                                          *AT91C_US1_MR  |= AT91C_US_CHRL_8_BITS;                  /* UART using 8-bit */\
                                          *AT91C_US1_MR  |= AT91C_US_PAR_NONE;                     /* UART using none parity bit */\
                                          *AT91C_US1_MR  |= AT91C_US_NBSTOP_1_BIT;                 /* UART using 1 stop bit */\
                                          *AT91C_US1_MR  |= AT91C_US_OVER;                         /* UART is using 8-bit sampling */\
                                          *AT91C_US1_BRGR = ((OSC/8/BAUD_RATE) | (((OSC/8) - ((OSC/8/BAUD_RATE) * BAUD_RATE)) / ((BAUD_RATE + 4)/8)) << 16);\
                                          *AT91C_US1_PTCR = (AT91C_PDC_RXTDIS | AT91C_PDC_TXTDIS); /* Disable of TX & RX with DMA */\
                                          *AT91C_US1_RCR  = 0;                                     /* Receive Counter Register */\
                                          *AT91C_US1_TCR  = 0;                                     /* Transmit Counter Register */\
                                          *AT91C_US1_RNPR = 0;\
                                          *AT91C_US1_TNPR = 0;\
                                          Tmp             = *AT91C_US1_RHR;\
                                          Tmp             = *AT91C_US1_CSR;\
                                          *AT91C_US1_RPR  = (unsigned int)&(InBuf[InBufInPtr][0]);     /* Initialise receiver buffer using DMA */\
                                          *AT91C_US1_RCR  = SIZE_OF_INBUF;\
                                          *AT91C_US1_RNPR = (unsigned int)&(InBuf[(InBufInPtr + 1)%NO_OF_INBUFFERS][0]);\
                                          *AT91C_US1_RNCR = SIZE_OF_INBUF;\
                                          MsgIn           = 0;\
                                          InBufOutCnt     = 0;\
                                          FullRxLength    = 0;\
                                          RemainingLength = 0;\
                                          *AT91C_US1_CR   = AT91C_US_RXEN | AT91C_US_TXEN;         /* Enable Tx & Rx on UART 1*/\
                                          *AT91C_US1_PTCR = (AT91C_PDC_RXTEN | AT91C_PDC_TXTEN);   /* Enable of TX & RX with DMA */\
                                        }


#define   BTInitPIOPins                 {\
                                          *AT91C_PIOA_PER   = BT_CS_PIN | BT_RST_PIN;    /* Enable PIO on PA11 & PA31 */\
                                          *AT91C_PIOA_OER   = BT_CS_PIN | BT_RST_PIN;    /* PA11 & PA31 set to output */\
                                          *AT91C_PIOA_SODR  = BT_CS_PIN | BT_RST_PIN;    /* PA31 & PA11 set output high */\
                                          *AT91C_PIOA_PPUDR = BT_ARM7_CMD_PIN;           /* Disable PULL-UP resistor on PA27 */\
                                          *AT91C_PIOA_PER   = BT_ARM7_CMD_PIN;           /* Enable PIO on PA27 */\
                                          *AT91C_PIOA_CODR  = BT_ARM7_CMD_PIN;           /* PA27 set output low */\
                                          *AT91C_PIOA_OER   = BT_ARM7_CMD_PIN;           /* PA27 set to output */\
                                        }

#define   BTInitADC                     {\
                                          *AT91C_ADC_MR    = 0;                             /* Reset register plus setting only software trigger */\
                                          *AT91C_ADC_MR   |= 0x00003F00;                    /* ADC-clock set to approximatly 375 kHz */\
                                          *AT91C_ADC_MR   |= 0x00020000;                    /* Startup set to approximatly 84uS */\
                                          *AT91C_ADC_MR   |= 0x09000000;                    /* Sample & Hold set to approximatly 20uS */\
                                          *AT91C_ADC_CHER  = AT91C_ADC_CH6 | AT91C_ADC_CH4; /* Enable channel 6 and 4*/\
                                        }

#define   BTStartADConverter            *AT91C_ADC_CR      = AT91C_ADC_START;           /* Start the ADC converter */\

#define   BTReadADCValue(ADValue)       ADValue            = *AT91C_ADC_CDR6;

#define   BTSetResetHigh                {\
                                          *AT91C_PIOA_SODR = BT_RST_PIN;              /* PA11 set output high */\
                                        }

#define   BTSetResetLow                 {\
                                          *AT91C_PIOA_CODR = BT_RST_PIN;              /* PA11 set output low */\
                                        }

#define   BTInitReceiver(InputBuffer, Mode)\
                                       {\
                                          pBuffer         = InputBuffer;\
                                          MsgIn           = 0;\
                                          FullRxLength    = 0;\
                                          if (STREAM_MODE == Mode)\
                                          {\
                                            LengthSize = 2;\
                                          }\
                                          else\
                                          {\
                                            LengthSize = 1;\
                                          }\
                                        }

#define   BT_SetArm7CmdPin              *AT91C_PIOA_SODR = BT_ARM7_CMD_PIN

#define   BT_ClearArm7CmdPin            *AT91C_PIOA_CODR = BT_ARM7_CMD_PIN

#define   BT_GetBc4CmdPin               *AT91C_PIOA_PDSR & BT_BC4_CMD_PIN 

#define   REQTxEnd(TxEnd)               TxEnd = FALSE;\
                                        if ((!(*AT91C_US1_TNCR)) && (!(*AT91C_US1_TCR)))\
                                        {\
                                          TxEnd = TRUE;\
                                        }

#define   AVAILOutBuf(Avail)            if (!(*AT91C_US1_TNCR))\
                                        {\
                                          Avail = SIZE_OF_OUTBUF;\
                                        }\
                                        else\
                                        {\
                                          Avail = 0;\
                                        }


#define   BTSend(OutputBuffer, BytesToSend)\
                                        {\
                                          UWORD Avail;\
                                          AVAILOutBuf(Avail);\
                                          if (BytesToSend < (Avail - 1))\
                                          {\
                                            memcpy(&(OutDma[DmaBufPtr][0]), OutputBuffer, BytesToSend);\
                                            *AT91C_US1_TNPR = (unsigned int)&(OutDma[DmaBufPtr][0]);\
                                            *AT91C_US1_TNCR = BytesToSend;\
                                            DmaBufPtr = (DmaBufPtr + 1) % NO_OF_DMA_OUTBUFFERS;\
                                          }\
                                        }


#define   BTSendMsg(OutputBuffer, BytesToSend, MsgSize)\
                                        {\
                                          UWORD Avail;\
                                          AVAILOutBuf(Avail);\
                                          if (BytesToSend < (Avail - 1))\
                                          {\
                                            if (2 == LengthSize)\
                                            {\
                                              OutDma[DmaBufPtr][0] = (UBYTE)MsgSize;\
                                              OutDma[DmaBufPtr][1] = (UBYTE)(MsgSize>>8);\
                                            }\
                                            else\
                                            {\
                                              OutDma[DmaBufPtr][0] = (UBYTE)MsgSize;\
                                            }\
                                            memcpy(&(OutDma[DmaBufPtr][LengthSize]), OutputBuffer, BytesToSend);\
                                            *AT91C_US1_TNPR = (unsigned int)&(OutDma[DmaBufPtr][0]);\
                                            *AT91C_US1_TNCR = BytesToSend + LengthSize;\
                                            DmaBufPtr = (DmaBufPtr + 1) % NO_OF_DMA_OUTBUFFERS;\
                                          }\
                                        }


#define   BTReceivedData(pByteCnt, pToGo)\
                                        {\
                                          UWORD InCnt, Cnt;\
                                          *pByteCnt = 0;\
                                          *pToGo    = 0;\
                                          InCnt = (SIZE_OF_INBUF - *AT91C_US1_RCR);\
                                          if (*AT91C_US1_RNCR == 0)\
                                          {\
                                            InCnt = SIZE_OF_INBUF;\
                                          }\
                                          InCnt -= InBufOutCnt; /* Remove already read bytes */\
                                          if (InCnt)\
                                          {\
                                            if (0 == FullRxLength)  /* FullRxLength still to be calculated */\
                                            {\
                                              while((MsgIn < LengthSize) && (InCnt > 0))\
                                              {\
                                                pBuffer[MsgIn] = InBuf[InBufInPtr][InBufOutCnt];\
                                                MsgIn++;\
                                                InBufOutCnt++;\
                                                InCnt--;\
                                              }\
                                              if (LengthSize == MsgIn)\
                                              {\
                                                if (2 == LengthSize)\
                                                {\
                                                  FullRxLength   = pBuffer[1];\
                                                  FullRxLength <<= 8;\
                                                  FullRxLength  |= pBuffer[0];\
                                                  /* Remove Length when in strean mode */\
                                                  MsgIn          = 0;\
                                                }\
                                                else\
                                                {\
                                                  FullRxLength = pBuffer[0];\
                                                }\
                                                RemainingLength = FullRxLength;\
                                              }\
                                              else\
                                              {\
                                                /* Length still not received */\
                                                FullRxLength = 0;\
                                              }\
                                            }\
                                            if (FullRxLength)\
                                            {\
                                              /* Incomming msg in progress */\
                                              /* room for bytes? */\
                                              if (InCnt >= RemainingLength)\
                                              {\
                                                /* Remaining msg bytes are in the buffer   */\
                                                /* Can remaining byte be stored in buffer? */\
                                                if ((MsgIn + RemainingLength) <= SIZE_OF_INBUF)\
                                                {\
                                                  /* All bytes can be stored */\
                                                  for (Cnt = 0; Cnt < RemainingLength; Cnt++)\
                                                  {\
                                                    pBuffer[MsgIn] = InBuf[InBufInPtr][InBufOutCnt];\
                                                    MsgIn++;\
                                                    InBufOutCnt++;\
                                                  }\
                                                  *pByteCnt       = MsgIn;\
                                                  *pToGo          = 0;\
                                                  FullRxLength    = 0;\
                                                  RemainingLength = 0;\
                                                  MsgIn           = 0;\
                                                }\
                                                else\
                                                {\
                                                  for (Cnt = 0; MsgIn < SIZE_OF_INBUF; Cnt++)\
                                                  {\
                                                    pBuffer[MsgIn] = InBuf[InBufInPtr][InBufOutCnt];\
                                                    MsgIn++;\
                                                    InBufOutCnt++;\
                                                  }\
                                                  *pByteCnt        = SIZE_OF_INBUF;\
                                                  RemainingLength -= Cnt;\
                                                  *pToGo           = RemainingLength;\
                                                  MsgIn            = 0;\
                                                }\
                                              }\
                                              else\
                                              {\
                                                if ((InCnt + MsgIn) < SIZE_OF_INBUF)\
                                                {\
                                                  /* Received bytes do not fill up the buffer */\
                                                  for (Cnt = 0; Cnt < InCnt; Cnt++)\
                                                  {\
                                                    pBuffer[MsgIn] = InBuf[InBufInPtr][InBufOutCnt];\
                                                    MsgIn++;\
                                                    InBufOutCnt++;\
                                                  }\
                                                  RemainingLength -= InCnt;\
                                                }\
                                                else\
                                                {\
                                                  /* Received bytes fill up the buffer */\
                                                  for (Cnt = 0; MsgIn < SIZE_OF_INBUF; Cnt++)\
                                                  {\
                                                    pBuffer[MsgIn] = InBuf[InBufInPtr][InBufOutCnt];\
                                                    MsgIn++;\
                                                    InBufOutCnt++;\
                                                  }\
                                                  *pByteCnt        = SIZE_OF_INBUF;\
                                                  RemainingLength -= Cnt; /* Only substract no removed */\
                                                  *pToGo           = RemainingLength;\
                                                  MsgIn            = 0;\
                                                }\
                                              }\
                                            }\
                                          }\
                                          if ((*AT91C_US1_RNCR == 0) && (SIZE_OF_INBUF == InBufOutCnt))\
                                          {\
                                            InBufOutCnt     = 0;\
                                            *AT91C_US1_RNPR = (unsigned int)InBufPtrs[InBufInPtr];\
                                            *AT91C_US1_RNCR = SIZE_OF_INBUF;\
                                            InBufInPtr      = (InBufInPtr + 1) % NO_OF_INBUFFERS;\
                                          }\
                                        }

#define BTExit                          {\
                                          *AT91C_PMC_PCDR = PER_ID7_UART_1;        /* Disable PMC clock for UART 1*/\
                                          *AT91C_US1_IDR  = AT91C_US_TIMEOUT;      /* Disable interrupt on timeout */\
                                          *AT91C_AIC_IDCR = UART1_INQ;             /* Disable PIO interrupt */\
                                          *AT91C_AIC_ICCR = UART1_INQ;             /* Clear interrupt register */\
                                        }


#endif //D_BT_R


//#endif

//#ifdef    PCWIN

//#endif
