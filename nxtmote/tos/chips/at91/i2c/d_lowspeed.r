#ifndef D_LOWSPEED_R
#define D_LOWSPEED_R

#define   CHANNEL_ONE_CLK				AT91C_PIO_PA23 /* PA23 is Clk */
#define   CHANNEL_ONE_DATA				AT91C_PIO_PA18 /* PA18 is Data */

#define   CHANNEL_TWO_CLK				AT91C_PIO_PA28 /* PA28 is Clk */
#define   CHANNEL_TWO_DATA				AT91C_PIO_PA19 /* PA19 is Data */

#define   CHANNEL_THREE_CLK				AT91C_PIO_PA29 /* PA29 is Clk */
#define   CHANNEL_THREE_DATA			AT91C_PIO_PA20 /* PA20 is Data */

#define   CHANNEL_FOUR_CLK				AT91C_PIO_PA30 /* PA30 is Clk */
#define   CHANNEL_FOUR_DATA				AT91C_PIO_PA2 /* PA2 is Data */

typedef   struct
{
  UWORD MaskBit;
  UBYTE ChannelState;
  UBYTE TxState;
  UBYTE RxState;
  UBYTE ReStartState;
  UBYTE TxByteCnt;
  UBYTE RxByteCnt;
  UBYTE *pComOutBuffer;
  UBYTE *pComInBuffer;
  UBYTE AckStatus;
  UBYTE RxBitCnt;
  UBYTE ReStartBit;
  UBYTE ComDeviceAddress;
  UBYTE RxWaitCnt;
}LOWSPEEDPARAMETERS;

static LOWSPEEDPARAMETERS LowSpeedData[4];

ULONG DATA_PINS[4] = {CHANNEL_ONE_DATA, CHANNEL_TWO_DATA, CHANNEL_THREE_DATA, CHANNEL_FOUR_DATA};
ULONG CLK_PINS[4] = {CHANNEL_ONE_CLK, CHANNEL_TWO_CLK, CHANNEL_THREE_CLK, CHANNEL_FOUR_CLK};

#define   LOWSPEED_CHANNEL1	 0
#define   LOWSPEED_CHANNEL2	 1
#define   LOWSPEED_CHANNEL3	 2
#define   LOWSPEED_CHANNEL4	 3
#define   NO_OF_LOWSPEED_COM_CHANNEL	4

#define   MASK_BIT_8		 0x80

#define   PIO_INQ            0x04

//Used for variable ChannelState
#define   LOWSPEED_IDLE		         0x00
#define   LOWSPEED_TX_STOP_BIT		 0x01
#define   LOWSPEED_TRANSMITTING      0x02
#define   LOWSPEED_RECEIVING		 0x04
#define   LOWSPEED_TEST_WAIT_STATE   0x08
#define   LOWSPEED_RESTART_CONDITION 0x10
#define   LOWSPEED_WAIT_BEFORE_RX    0x20

//Used for variable TxState
#define   TX_IDLE					 0x00
#define   TX_DATA_MORE_DATA			 0x01
#define   TX_DATA_CLK_HIGH           0x02
#define   TX_EVALUATE_ACK_CLK_HIGH   0x03
#define   TX_DATA_READ_ACK_CLK_LOW   0x04
#define   TX_DATA_CLK_LOW            0x05
#define   TX_ACK_EVALUATED_CLK_LOW   0x06

//Used for variable RxState
#define   RX_IDLE					 0x00
#define   RX_START_BIT_CLK_HIGH		 0x01
#define   RX_DATA_CLK_HIGH           0x02
#define   RX_ACK_TX_CLK_HIGH         0x03
#define   RX_DATA_CLK_LOW			 0x04
#define   RX_DONE_OR_NOT_CLK_LOW     0x05

//Used for variable ReStart
#define   RESTART_STATE_IDLE		 0x00
#define   RESTART_STATE_ONE			 0x01
#define   RESTART_STATE_TWO			 0x02
#define   RESTART_STATE_THREE   	 0x03
#define   RESTART_STATE_FOUR		 0x04
#define   RESTART_STATE_FIVE		 0x05
#define   RESTART_STATE_SIX 		 0x06
#define   RESTART_STATE_SEVEN		 0x07

#define   LOWSpeedTxInit                {\
                                          LowSpeedData[LOWSPEED_CHANNEL1].ChannelState = 0;\
                                          LowSpeedData[LOWSPEED_CHANNEL2].ChannelState = 0;\
                                          LowSpeedData[LOWSPEED_CHANNEL3].ChannelState = 0;\
                                          LowSpeedData[LOWSPEED_CHANNEL4].ChannelState = 0;\
                                        }

#define   LOWSpeedTimerInit             {\
                                          *AT91C_PMC_PCER       = 0x400;					/* Enable clock for PWM, PID10*/\
										  *AT91C_PWMC_MR	    = 0x01;						/* CLKA is output from prescaler */\
										  *AT91C_PWMC_MR	   |= 0x600;					/* Prescaler MCK divided with 64 */\
										  *AT91C_PWMC_CH0_CMR   = 0x06;						/* Channel 0 uses MCK divided by 64 */\
										  *AT91C_PWMC_CH0_CMR  &= 0xFFFFFEFF;				/* Left alignment on periode */\
										  *AT91C_PWMC_CH0_CPRDR = 0x20;						/* Set to 39 => 52uSecondes interrupt */\
										  *AT91C_PWMC_IDR	    = AT91C_PWMC_CHID0;			/* Disable interrupt for PWM output channel 0 */\
										  *AT91C_AIC_IDCR       = 0x400;					/* Disable AIC intterupt on ID10 PWM */\
                                           AT91C_AIC_SVR[10]    = (unsigned int)LowSpeedPwmIrqHandler;\
                                           AT91C_AIC_SMR[10]    = 0x01;						/* Enable trigger on level */\
                                          *AT91C_AIC_ICCR       = 0x400;					/* Clear interrupt register PID10*/\
										  *AT91C_PWMC_IER		= AT91C_PWMC_CHID0;			/* Enable interrupt for PWM output channel 0 */\
										  *AT91C_AIC_IECR       = 0x400;					/* Enable interrupt from PWM */\
										}

#define   LOWSpeedExit

//rup
//#define   ENABLEDebugOutput				{\
//                                          *AT91C_PIOA_PER   = AT91C_PIO_PA29; /* Enable PIO on PA029 */\
//                                          *AT91C_PIOA_OER   = AT91C_PIO_PA29; /* PA029 set to Output  */\
//                                          *AT91C_PIOA_CODR	= 0x20000000;\
//                                        }

#define   SETDebugOutputHigh			*AT91C_PIOA_SODR	= 0x20000000

#define   SETDebugOutputLow				*AT91C_PIOA_CODR	= 0x20000000


#define	  SETClkComOneHigh				*AT91C_PIOA_SODR	= CHANNEL_ONE_CLK

#define	  SETClkComOneLow				*AT91C_PIOA_CODR	= CHANNEL_ONE_CLK

#define   GetClkComOnePinLevel			*AT91C_PIOA_PDSR	& CHANNEL_ONE_CLK

#define	  SETClkComTwoHigh				*AT91C_PIOA_SODR	= CHANNEL_TWO_CLK

#define	  SETClkComTwoLow				*AT91C_PIOA_CODR	= CHANNEL_TWO_CLK

#define   GetClkComTwoPinLevel			*AT91C_PIOA_PDSR	& CHANNEL_TWO_CLK

#define	  SETClkComThreeHigh			*AT91C_PIOA_SODR	= CHANNEL_THREE_CLK

#define	  SETClkComThreeLow				*AT91C_PIOA_CODR	= CHANNEL_THREE_CLK

#define   GetClkComThreePinLevel		*AT91C_PIOA_PDSR	& CHANNEL_THREE_CLK

#define	  SETClkComFourHigh				*AT91C_PIOA_SODR	= CHANNEL_FOUR_CLK

#define	  SETClkComFourLow				*AT91C_PIOA_CODR	= CHANNEL_FOUR_CLK

#define   GetClkComFourPinLevel			*AT91C_PIOA_PDSR	& CHANNEL_FOUR_CLK


#define	  SETDataComOneHigh				*AT91C_PIOA_SODR	= CHANNEL_ONE_DATA

#define   SETDataComOneLow				*AT91C_PIOA_CODR	= CHANNEL_ONE_DATA

#define   GetDataComOnePinLevel			*AT91C_PIOA_PDSR	& CHANNEL_ONE_DATA

#define   GETDataComOnePinDirection		*AT91C_PIOA_OSR     & CHANNEL_ONE_DATA

#define	  SETDataComTwoHigh				*AT91C_PIOA_SODR	= CHANNEL_TWO_DATA

#define   SETDataComTwoLow				*AT91C_PIOA_CODR	= CHANNEL_TWO_DATA

#define   GetDataComTwoPinLevel			*AT91C_PIOA_PDSR	& CHANNEL_TWO_DATA

#define   GETDataComTwoPinDirection		*AT91C_PIOA_OSR     & CHANNEL_TWO_DATA

#define	  SETDataComThreeHigh			*AT91C_PIOA_SODR	= CHANNEL_THREE_DATA

#define   SETDataComThreeLow			*AT91C_PIOA_CODR	= CHANNEL_THREE_DATA

#define   GetDataComThreePinLevel		*AT91C_PIOA_PDSR	& CHANNEL_THREE_DATA

#define   GETDataComThreePinDirection	*AT91C_PIOA_OSR     & CHANNEL_THREE_DATA

#define	  SETDataComFourHigh			*AT91C_PIOA_SODR	= CHANNEL_FOUR_DATA

#define   SETDataComFourLow				*AT91C_PIOA_CODR	= CHANNEL_FOUR_DATA

#define   GetDataComFourPinLevel		*AT91C_PIOA_PDSR	& CHANNEL_FOUR_DATA

#define   GETDataComFourPinDirection	*AT91C_PIOA_OSR     & CHANNEL_FOUR_DATA

#define   SETDataComOneToInput          *AT91C_PIOA_ODR     = CHANNEL_ONE_DATA;

#define   SETDataComOneToOutput			*AT91C_PIOA_OER     = CHANNEL_ONE_DATA;

#define   SETDataComTwoToInput          *AT91C_PIOA_ODR     = CHANNEL_TWO_DATA;

#define   SETDataComTwoToOutput			*AT91C_PIOA_OER     = CHANNEL_TWO_DATA;

#define   SETDataComThreeToInput        *AT91C_PIOA_ODR     = CHANNEL_THREE_DATA;

#define   SETDataComThreeToOutput		*AT91C_PIOA_OER     = CHANNEL_THREE_DATA;

#define   SETDataComFourToInput         *AT91C_PIOA_ODR     = CHANNEL_FOUR_DATA;

#define   SETDataComFourToOutput		*AT91C_PIOA_OER     = CHANNEL_FOUR_DATA;

#define   DISABLEPullupDataComOne		*AT91C_PIOA_PPUDR   = CHANNEL_ONE_DATA;

#define   DISABLEPullupClkComOne		*AT91C_PIOA_PPUDR   = CHANNEL_ONE_CLK;

#define   DISABLEPullupDataComTwo		*AT91C_PIOA_PPUDR   = CHANNEL_TWO_DATA;

#define   DISABLEPullupClkComTwo		*AT91C_PIOA_PPUDR   = CHANNEL_TWO_CLK;

#define   DISABLEPullupDataComThree		*AT91C_PIOA_PPUDR   = CHANNEL_THREE_DATA;

#define   DISABLEPullupClkComThree		*AT91C_PIOA_PPUDR   = CHANNEL_THREE_CLK;

#define   DISABLEPullupDataComFour		*AT91C_PIOA_PPUDR   = CHANNEL_FOUR_DATA;

#define   DISABLEPullupClkComFour		*AT91C_PIOA_PPUDR   = CHANNEL_FOUR_CLK;

#define   ENABLEPullupDataComOne		*AT91C_PIOA_PPUER   = CHANNEL_ONE_DATA;

#define   ENABLEPullupClkComOne 		*AT91C_PIOA_PPUER   = CHANNEL_ONE_CLK;

#define   ENABLEPullupDataComTwo		*AT91C_PIOA_PPUER   = CHANNEL_TWO_DATA;

#define   ENABLEPullupClkComTwo 		*AT91C_PIOA_PPUER   = CHANNEL_TWO_CLK;

#define   ENABLEPullupDataComThree		*AT91C_PIOA_PPUER   = CHANNEL_THREE_DATA;

#define   ENABLEPullupClkComThree		*AT91C_PIOA_PPUER   = CHANNEL_THREE_CLK;

#define   ENABLEPullupDataComFour		*AT91C_PIOA_PPUER   = CHANNEL_FOUR_DATA;

#define   ENABLEPullupClkComFour		*AT91C_PIOA_PPUER   = CHANNEL_FOUR_CLK;

#define SETClkLow(ChannelNr)             {\
										   if (ChannelNr == 0)\
										   {\
										     SETClkComOneLow;\
										   }\
										   else\
										   {\
										     if (ChannelNr == 1)\
										     {\
										       SETClkComTwoLow;\
										     }\
										     else\
										     {\
										       if (ChannelNr == 2)\
										       {\
										         SETClkComThreeLow;\
										       }\
										       else\
										       {\
										         if (ChannelNr == 3)\
										         {\
										           SETClkComFourLow;\
										         }\
										       }\
										     }\
										   }\
                                         }


#define SETClkHigh(ChannelNr)            {\
										   if (ChannelNr == 0)\
										   {\
										     SETClkComOneHigh;\
										   }\
										   else\
										   {\
										     if (ChannelNr == 1)\
										     {\
										       SETClkComTwoHigh;\
										     }\
										     else\
										     {\
										       if (ChannelNr == 2)\
										       {\
										         SETClkComThreeHigh;\
										       }\
										       else\
										       {\
										         if (ChannelNr == 3)\
										         {\
										           SETClkComFourHigh;\
										         }\
										       }\
										     }\
										   }\
                                         }

#define SETDataLow(ChannelNr)            {\
										   if (ChannelNr == 0)\
										   {\
										     SETDataComOneLow;\
										   }\
										   else\
										   {\
										     if (ChannelNr == 1)\
										     {\
										       SETDataComTwoLow;\
										     }\
										     else\
										     {\
										       if (ChannelNr == 2)\
										       {\
										         SETDataComThreeLow;\
										       }\
										       else\
										       {\
										         if (ChannelNr == 3)\
										         {\
										           SETDataComFourLow;\
										         }\
										       }\
										     }\
										   }\
                                         }

#define SETDataHigh(ChannelNr)           {\
										   if (ChannelNr == 0)\
										   {\
										     SETDataComOneHigh;\
										   }\
										   else\
										   {\
										     if (ChannelNr == 1)\
										     {\
										       SETDataComTwoHigh;\
										     }\
										     else\
										     {\
										       if (ChannelNr == 2)\
										       {\
										         SETDataComThreeHigh;\
										       }\
										       else\
										       {\
										         if (ChannelNr == 3)\
										         {\
										           SETDataComFourHigh;\
										         }\
										       }\
										     }\
										   }\
                                         }

#define SETDataToInput(ChannelNr)		 {\
										   if (ChannelNr == 0)\
										   {\
										     SETDataComOneToInput;\
										   }\
										   else\
										   {\
										     if (ChannelNr == 1)\
										     {\
										       SETDataComTwoToInput;\
										     }\
										     else\
										     {\
										       if (ChannelNr == 2)\
										       {\
										         SETDataComThreeToInput;\
										       }\
										       else\
										       {\
										         if (ChannelNr == 3)\
										         {\
										           SETDataComFourToInput;\
										         }\
										       }\
										     }\
										   }\
                                         }


#define SETDataToOutput(ChannelNr)		 {\
										   if (ChannelNr == 0)\
										   {\
										     SETDataComOneToOutput;\
										   }\
										   else\
										   {\
										     if (ChannelNr == 1)\
										     {\
										       SETDataComTwoToOutput;\
										     }\
										     else\
										     {\
										       if (ChannelNr == 2)\
										       {\
										         SETDataComThreeToOutput;\
										       }\
										       else\
										       {\
										         if (ChannelNr == 3)\
										         {\
										           SETDataComFourToOutput;\
										         }\
										       }\
										     }\
										   }\
                                         }


#define   ENABLEPWMTimerForLowCom       {\
                                          *AT91C_PWMC_ENA		= AT91C_PWMC_CHID0;			/* Enable PWM output channel 0 */\
										}

#define    DISABLEPWMTimerForLowCom		{\
                                          *AT91C_PWMC_DIS	 = AT91C_PWMC_CHID0;			/* Disable PWM output channel 0 */\
										}
										
#define    OLD_DISABLEPWMTimerForLowCom	{\
										  *AT91C_PWMC_DIS	 = AT91C_PWMC_CHID0;			/* Disable PWM output channel 0 */\
                                          *AT91C_PWMC_IDR	 = AT91C_PWMC_CHID0;			/* Disable interrupt from PWM output channel 0 */\
										  *AT91C_AIC_IDCR    = 0x400;						/* Disable Irq from PID10 */\
                                          *AT91C_AIC_ICCR    = 0x400;						/* Clear interrupt register PID10*/\
                                          *AT91C_PMC_PCDR    = 0x400;						/* Disable clock for PWM, PID10*/\
										}

/*__ramfunc*/ void LowSpeedPwmIrqHandler(void)
{
  ULONG TestVar;
  ULONG PinStatus;
  UBYTE ChannelNr;

  TestVar = *AT91C_PWMC_ISR;
  TestVar = TestVar;
  PinStatus = *AT91C_PIOA_PDSR;

  for (ChannelNr = 0; ChannelNr < NO_OF_LOWSPEED_COM_CHANNEL; ChannelNr++)
  {
    switch(LowSpeedData[ChannelNr].ChannelState)
    {
      case LOWSPEED_IDLE:
      {
      }
      break;

      case LOWSPEED_TX_STOP_BIT:
      {
        SETDataHigh(ChannelNr);
        LowSpeedData[ChannelNr].ChannelState = LOWSPEED_IDLE;                                     //Now we have send a STOP sequence, disable this channel
      }
      break;

      case LOWSPEED_TRANSMITTING:
      {
        switch(LowSpeedData[ChannelNr].TxState)
        {
          case TX_DATA_MORE_DATA:
          {
            PinStatus |= CLK_PINS[ChannelNr];
            LowSpeedData[ChannelNr].TxState = TX_DATA_CLK_HIGH;
          }
          break;

          case TX_DATA_CLK_HIGH:
          {
            SETClkLow(ChannelNr);
            if (LowSpeedData[ChannelNr].MaskBit == 0)     				                           //Is Byte Done, then we need a ack from receiver
            {
              SETDataToInput(ChannelNr);                                                             //Set datapin to input
              LowSpeedData[ChannelNr].TxState = TX_DATA_READ_ACK_CLK_LOW;
            }
            else
            {
              if (*LowSpeedData[ChannelNr].pComOutBuffer & LowSpeedData[ChannelNr].MaskBit)          //Setup data pin in relation to the data
              {
	            SETDataHigh(ChannelNr);       						                               //Set data output high
              }
	          else
              {
	            SETDataLow(ChannelNr);                                                               //Set data output low
              }
              LowSpeedData[ChannelNr].TxState = TX_DATA_CLK_LOW;
            }
          }
          break;

          case TX_EVALUATE_ACK_CLK_HIGH:
          {
            SETClkLow(ChannelNr);
            if (LowSpeedData[ChannelNr].AckStatus == 1)	
	        {
	          LowSpeedData[ChannelNr].TxByteCnt--;
	          if (LowSpeedData[ChannelNr].TxByteCnt > 0)	        		    			   //Here initialise to send next byte
	          {
	            LowSpeedData[ChannelNr].MaskBit = MASK_BIT_8;
	            LowSpeedData[ChannelNr].pComOutBuffer++;
	          }
	          LowSpeedData[ChannelNr].TxState = TX_ACK_EVALUATED_CLK_LOW;                    //Received ack, now make a stop sequence or send next byte
	        }
	        else
	        { //Data communication error !
	          LowSpeedData[ChannelNr].TxByteCnt = 0;
	          SETClkHigh(ChannelNr);
              LowSpeedData[ChannelNr].ChannelState = LOWSPEED_TX_STOP_BIT;                     //Received ack, now make a stop sequence or send next byte.
	        }
          }
          break;

          case TX_DATA_READ_ACK_CLK_LOW:
          {
            if (!(PinStatus & DATA_PINS[ChannelNr]))
	        {
	          LowSpeedData[ChannelNr].AckStatus = 1;										//Read ack signal from receiver
	        }	        	        	
	        SETDataToOutput(ChannelNr);
	        SETDataLow(ChannelNr);
	        LowSpeedData[ChannelNr].TxState = TX_EVALUATE_ACK_CLK_HIGH;
	        SETClkHigh(ChannelNr);
          }
          break;

          case TX_DATA_CLK_LOW:
          {
            LowSpeedData[ChannelNr].MaskBit = LowSpeedData[ChannelNr].MaskBit >> 1;			//Get ready for the next bit which should be clk out next time
            SETClkHigh(ChannelNr);															//Clk goes high = The reciever reads the data
            LowSpeedData[ChannelNr].TxState = TX_DATA_CLK_HIGH;
          }
          break;

          case TX_ACK_EVALUATED_CLK_LOW:
          {
            if (LowSpeedData[ChannelNr].MaskBit != 0)
            {
              LowSpeedData[ChannelNr].TxState = TX_DATA_MORE_DATA;
            }
            else
            {
              if (LowSpeedData[ChannelNr].ReStartBit != 0)
              {
                LowSpeedData[ChannelNr].ChannelState = LOWSPEED_RESTART_CONDITION;
                LowSpeedData[ChannelNr].ReStartState = RESTART_STATE_ONE;
                SETDataLow(ChannelNr);
                SETClkHigh(ChannelNr);                                                         //Clk goes high = The reciever reads the data
              }
              else
              {
                if (LowSpeedData[ChannelNr].RxByteCnt != 0)
                {
                  LowSpeedData[ChannelNr].ChannelState = LOWSPEED_WAIT_BEFORE_RX;
                }
                else
                {
                  LowSpeedData[ChannelNr].ChannelState = LOWSPEED_TX_STOP_BIT;
                  SETClkHigh(ChannelNr);                                                         //Clk goes high = The reciever reads the data
                }
              }
              LowSpeedData[ChannelNr].TxState = TX_IDLE;
            }
          }
          break;
        }
      }
      break;

      case LOWSPEED_RESTART_CONDITION:
      {
        switch(LowSpeedData[ChannelNr].ReStartState)
        {
          case RESTART_STATE_ONE:
          {
            LowSpeedData[ChannelNr].ReStartState = RESTART_STATE_TWO;
          }
          break;

          case RESTART_STATE_TWO:
          {
            SETDataHigh(ChannelNr);
            LowSpeedData[ChannelNr].ReStartState = RESTART_STATE_THREE;
          }
          break;

          case RESTART_STATE_THREE:
          {
            SETClkLow(ChannelNr);
            LowSpeedData[ChannelNr].ReStartState = RESTART_STATE_FOUR;
          }
          break;

          case RESTART_STATE_FOUR:
          {
            SETClkHigh(ChannelNr);
            LowSpeedData[ChannelNr].ReStartState = RESTART_STATE_FIVE;
          }
          break;

          case RESTART_STATE_FIVE:
          {
            SETDataLow(ChannelNr);
            LowSpeedData[ChannelNr].ReStartState = RESTART_STATE_SIX;
          }
          break;

          case RESTART_STATE_SIX:
          {
            LowSpeedData[ChannelNr].ReStartState = RESTART_STATE_SEVEN;
          }
          break;

          case RESTART_STATE_SEVEN:
          {
            SETClkLow(ChannelNr);
            LowSpeedData[ChannelNr].ReStartState = RESTART_STATE_IDLE;
            LowSpeedData[ChannelNr].ReStartBit = 0;
            LowSpeedData[ChannelNr].pComOutBuffer = &LowSpeedData[ChannelNr].ComDeviceAddress;
            *LowSpeedData[ChannelNr].pComOutBuffer += 0x01;
			LowSpeedData[ChannelNr].ChannelState = LOWSPEED_TRANSMITTING;
			LowSpeedData[ChannelNr].MaskBit = MASK_BIT_8;
			LowSpeedData[ChannelNr].TxByteCnt = 0x01;
			LowSpeedData[ChannelNr].TxState = TX_DATA_CLK_HIGH;
			LowSpeedData[ChannelNr].AckStatus = 0;
          }
          break;
        }
      }
      break;

      case LOWSPEED_WAIT_BEFORE_RX:
      {
        LowSpeedData[ChannelNr].RxWaitCnt++;
        if (LowSpeedData[ChannelNr].RxWaitCnt > 5)
        {
          LowSpeedData[ChannelNr].ChannelState = LOWSPEED_RECEIVING;
          SETDataToInput(ChannelNr);
        }
      }
      break;

      case LOWSPEED_RECEIVING:
      {
        switch(LowSpeedData[ChannelNr].RxState)
        {
          case RX_START_BIT_CLK_HIGH:
          {
            SETClkLow(ChannelNr);
            LowSpeedData[ChannelNr].RxState = RX_DATA_CLK_LOW;
          }
          break;

          case RX_DATA_CLK_HIGH:
          {
            LowSpeedData[ChannelNr].RxBitCnt++;
            if(PinStatus & DATA_PINS[ChannelNr])
            {
              *LowSpeedData[ChannelNr].pComInBuffer |= 0x01;
            }
            SETClkLow(ChannelNr);
            if (LowSpeedData[ChannelNr].RxBitCnt < 8)
            {
              *LowSpeedData[ChannelNr].pComInBuffer = *LowSpeedData[ChannelNr].pComInBuffer << 1;
            }
            else
            {
              if (LowSpeedData[ChannelNr].RxByteCnt > 1)
              {
                SETDataToOutput(ChannelNr);
                SETDataLow(ChannelNr);
              }
            }
            LowSpeedData[ChannelNr].RxState = RX_DATA_CLK_LOW;
          }
          break;

          case RX_ACK_TX_CLK_HIGH:
          {
            SETClkLow(ChannelNr);
            SETDataToInput(ChannelNr);
            LowSpeedData[ChannelNr].pComInBuffer++;
		    LowSpeedData[ChannelNr].RxByteCnt--;
		    LowSpeedData[ChannelNr].RxBitCnt = 0;
	        LowSpeedData[ChannelNr].RxState = RX_DONE_OR_NOT_CLK_LOW;
          }
          break;

          case RX_DATA_CLK_LOW:
          {
            SETClkHigh(ChannelNr);
            if (LowSpeedData[ChannelNr].RxBitCnt == 8)
            {
              LowSpeedData[ChannelNr].RxState = RX_ACK_TX_CLK_HIGH;
            }
            else
            {
              LowSpeedData[ChannelNr].RxState = RX_DATA_CLK_HIGH;
            }
          }
          break;

          case RX_DONE_OR_NOT_CLK_LOW:
          {
            if (LowSpeedData[ChannelNr].RxByteCnt == 0)
            {
              LowSpeedData[ChannelNr].ChannelState = LOWSPEED_IDLE;
              LowSpeedData[ChannelNr].RxState = RX_IDLE;
              SETClkHigh(ChannelNr);
            }
            else
            {
              LowSpeedData[ChannelNr].RxState = RX_START_BIT_CLK_HIGH;
            }
          }
          break;
        }
      }
      break;

      default:
      break;
    }
  }
}


#define ENABLETxPins(ChannelNumber)			   {\
											     if (ChannelNumber == LOWSPEED_CHANNEL1)\
											     {\
											       *AT91C_PIOA_PER   = CHANNEL_ONE_CLK | CHANNEL_ONE_DATA; /* Enable PIO on PA20 & PA28 */\
												   *AT91C_PIOA_PPUDR = CHANNEL_ONE_CLK | CHANNEL_ONE_DATA; /* Disable Pull-up resistor  */\
												   *AT91C_PIOA_ODR   = CHANNEL_ONE_CLK | CHANNEL_ONE_DATA; /* PA20 & PA28 set to Input  */\
												 }\
											     if (ChannelNumber == LOWSPEED_CHANNEL2)\
											     {\
												   *AT91C_PIOA_PER   = CHANNEL_TWO_CLK | CHANNEL_TWO_DATA; /* Enable PIO on PA20 & PA28 */\
												   *AT91C_PIOA_PPUDR = CHANNEL_TWO_CLK | CHANNEL_TWO_DATA; /* Disable Pull-up resistor */\
												   *AT91C_PIOA_ODR   = CHANNEL_TWO_CLK | CHANNEL_TWO_DATA; /* PA20 & PA28 set to Input */\
											     }\
											     if (ChannelNumber == LOWSPEED_CHANNEL3)\
											     {\
											       *AT91C_PIOA_PER   = CHANNEL_THREE_CLK | CHANNEL_THREE_DATA; /* */\
												   *AT91C_PIOA_PPUDR = CHANNEL_THREE_CLK | CHANNEL_THREE_DATA; /* */\
												   *AT91C_PIOA_ODR   = CHANNEL_THREE_CLK | CHANNEL_THREE_DATA; /* */\
											     }\
											     if (ChannelNumber == LOWSPEED_CHANNEL4)\
											     {\
											       *AT91C_PIOA_PER   = CHANNEL_FOUR_CLK | CHANNEL_FOUR_DATA; /* */\
												   *AT91C_PIOA_PPUDR = CHANNEL_FOUR_CLK | CHANNEL_FOUR_DATA; /* */\
												   *AT91C_PIOA_ODR   = CHANNEL_FOUR_CLK | CHANNEL_FOUR_DATA; /* */\
											     }\
                                               }

#define TxData(ChannelNumber, Status, DataOutBuffer, NumberOfByte) {\
											     if (ChannelNumber == LOWSPEED_CHANNEL1)\
											     {\
											       if (GetDataComOnePinLevel && GetClkComOnePinLevel)\
										           {\
									                 *AT91C_PIOA_PER   = CHANNEL_ONE_CLK | CHANNEL_ONE_DATA; /* Enable PIO on PA20 & PA28 */\
												     *AT91C_PIOA_OER   = CHANNEL_ONE_CLK | CHANNEL_ONE_DATA; /* PA20 & PA28 set to Output  */\
												     *AT91C_PIOA_PPUDR = CHANNEL_ONE_CLK | CHANNEL_ONE_DATA; /* Disable Pull-up resistor  */\
												     SETClkComOneHigh;\
									                 LowSpeedData[LOWSPEED_CHANNEL1].pComOutBuffer = DataOutBuffer;\
									                 LowSpeedData[LOWSPEED_CHANNEL1].ComDeviceAddress = *LowSpeedData[LOWSPEED_CHANNEL1].pComOutBuffer;\
									                 LowSpeedData[LOWSPEED_CHANNEL1].MaskBit = MASK_BIT_8;\
										             LowSpeedData[LOWSPEED_CHANNEL1].TxByteCnt = NumberOfByte;\
										             LowSpeedData[LOWSPEED_CHANNEL1].ChannelState = LOWSPEED_TRANSMITTING;\
									                 LowSpeedData[LOWSPEED_CHANNEL1].TxState = TX_DATA_CLK_HIGH;\
										             SETDataComOneLow;\
										             LowSpeedData[LOWSPEED_CHANNEL1].AckStatus = 0;\
									                 Status = 1;\
									               }\
									               else\
									               {\
									                 Status = 0;\
									               }\
											     }\
											     if (ChannelNumber == LOWSPEED_CHANNEL2)\
											     {\
											       if (GetDataComTwoPinLevel && GetClkComTwoPinLevel)\
										           {\
									                 *AT91C_PIOA_PER   = CHANNEL_TWO_CLK | CHANNEL_TWO_DATA; /* Enable PIO on PA20 & PA28 */\
												     *AT91C_PIOA_OER   = CHANNEL_TWO_CLK | CHANNEL_TWO_DATA; /* PA20 & PA28 set to Output  */\
												     *AT91C_PIOA_PPUDR = CHANNEL_TWO_CLK | CHANNEL_TWO_DATA; /* Disable Pull-up resistor  */\
												     SETClkComTwoHigh;\
									                 LowSpeedData[LOWSPEED_CHANNEL2].pComOutBuffer = DataOutBuffer;\
									                 LowSpeedData[LOWSPEED_CHANNEL2].ComDeviceAddress = *LowSpeedData[LOWSPEED_CHANNEL2].pComOutBuffer;\
									                 LowSpeedData[LOWSPEED_CHANNEL2].MaskBit = MASK_BIT_8;\
										             LowSpeedData[LOWSPEED_CHANNEL2].TxByteCnt = NumberOfByte;\
										             LowSpeedData[LOWSPEED_CHANNEL2].ChannelState = LOWSPEED_TRANSMITTING;\
									                 LowSpeedData[LOWSPEED_CHANNEL2].TxState = TX_DATA_CLK_HIGH;\
										             SETDataComTwoLow;\
										             LowSpeedData[LOWSPEED_CHANNEL2].AckStatus = 0;\
									                 Status = 1;\
									               }\
									               else\
									               {\
									                 Status = 0;\
									               }\
											     }\
											     if (ChannelNumber == LOWSPEED_CHANNEL3)\
											     {\
											       if (GetDataComThreePinLevel && GetClkComThreePinLevel)\
										           {\
									                 *AT91C_PIOA_PER   = CHANNEL_THREE_CLK | CHANNEL_THREE_DATA; /* */\
												     *AT91C_PIOA_OER   = CHANNEL_THREE_CLK | CHANNEL_THREE_DATA; /* */\
												     *AT91C_PIOA_PPUDR = CHANNEL_THREE_CLK | CHANNEL_THREE_DATA; /* */\
												     SETClkComThreeHigh;\
									                 LowSpeedData[LOWSPEED_CHANNEL3].pComOutBuffer = DataOutBuffer;\
									                 LowSpeedData[LOWSPEED_CHANNEL3].ComDeviceAddress = *LowSpeedData[LOWSPEED_CHANNEL3].pComOutBuffer;\
									                 LowSpeedData[LOWSPEED_CHANNEL3].MaskBit = MASK_BIT_8;\
										             LowSpeedData[LOWSPEED_CHANNEL3].TxByteCnt = NumberOfByte;\
										             LowSpeedData[LOWSPEED_CHANNEL3].ChannelState = LOWSPEED_TRANSMITTING;\
									                 LowSpeedData[LOWSPEED_CHANNEL3].TxState = TX_DATA_CLK_HIGH;\
										             SETDataComThreeLow;\
										             LowSpeedData[LOWSPEED_CHANNEL3].AckStatus = 0;\
									                 Status = 1;\
									               }\
									               else\
									               {\
									                 Status = 0;\
									               }\
											     }\
											     if (ChannelNumber == LOWSPEED_CHANNEL4)\
											     {\
											       if (GetDataComFourPinLevel && GetClkComFourPinLevel)\
										           {\
									                 *AT91C_PIOA_PER   = CHANNEL_FOUR_CLK | CHANNEL_FOUR_DATA; /* */\
												     *AT91C_PIOA_OER   = CHANNEL_FOUR_CLK | CHANNEL_FOUR_DATA; /* */\
												     *AT91C_PIOA_PPUDR = CHANNEL_FOUR_CLK | CHANNEL_FOUR_DATA; /* */\
												     SETClkComFourHigh;\
									                 LowSpeedData[LOWSPEED_CHANNEL4].pComOutBuffer = DataOutBuffer;\
									                 LowSpeedData[LOWSPEED_CHANNEL4].ComDeviceAddress = *LowSpeedData[LOWSPEED_CHANNEL4].pComOutBuffer;\
									                 LowSpeedData[LOWSPEED_CHANNEL4].MaskBit = MASK_BIT_8;\
										             LowSpeedData[LOWSPEED_CHANNEL4].TxByteCnt = NumberOfByte;\
										             LowSpeedData[LOWSPEED_CHANNEL4].ChannelState = LOWSPEED_TRANSMITTING;\
									                 LowSpeedData[LOWSPEED_CHANNEL4].TxState = TX_DATA_CLK_HIGH;\
										             SETDataComFourLow;\
										             LowSpeedData[LOWSPEED_CHANNEL4].AckStatus = 0;\
									                 Status = 1;\
									               }\
									               else\
									               {\
									                 Status = 0;\
									               }\
											     }\
											   }

#define RxData(ChannelNumber, DataInBuffer, RxBytes) {\
											           LowSpeedData[ChannelNumber].pComInBuffer = DataInBuffer;\
									                   LowSpeedData[ChannelNumber].RxBitCnt = 0;\
												       LowSpeedData[ChannelNumber].RxByteCnt = RxBytes;\
									                   LowSpeedData[ChannelNumber].RxState = RX_DATA_CLK_LOW;\
									                   LowSpeedData[ChannelNumber].ReStartBit = 1;\
									                   LowSpeedData[ChannelNumber].RxWaitCnt = 0;\
											         }
											
											
#define STATUSTxCom(ChannelNumber, Status)     {\
											     if (LowSpeedData[ChannelNumber].ChannelState != 0)\
											     {\
											       if (LowSpeedData[ChannelNumber].TxByteCnt == 0)\
											       {\
											         if (LowSpeedData[ChannelNumber].MaskBit == 0)\
											         {\
											           if (LowSpeedData[ChannelNumber].AckStatus == 1)\
											           {\
													     Status = 0x01;  /* TX SUCCESS  */\
											           }\
											           else\
											           {\
											             Status = 0xFF; /* TX ERROR */\
											           }\
											         }\
											         else\
											         {\
											           Status = 0;\
											         }\
											       }\
											       else\
											       {\
											         Status = 0;\
											       }\
											     }\
											     else\
											     {\
											       if (LowSpeedData[ChannelNumber].RxByteCnt == 0)\
											       {\
											         if (LowSpeedData[ChannelNumber].AckStatus == 1)\
											         {\
													   Status = 0x01;  /* TX SUCCESS  */\
											         }\
											         else\
											         {\
											           Status = 0xFF; /* TX ERROR */\
											         }\
											       }\
											       else\
											       {\
											         Status = 0xFF; /* TX ERROR */\
											       }\
											     }\
											   }
											
#define STATUSRxCom(ChannelNumber, Status)     {\
                                                 if (LowSpeedData[ChannelNumber].ChannelState == LOWSPEED_IDLE)\
											     {\
											       if (LowSpeedData[ChannelNumber].RxByteCnt == 0)\
											       {\
											         Status = 0x01;  /* RX SUCCESS  */\
											       }\
											       else\
											       {\
											         Status = 0xFF; /* RX ERROR */\
											       }\
											     }\
											     else\
											     {\
											       Status = 0;\
											     }\
                                               }


#endif
