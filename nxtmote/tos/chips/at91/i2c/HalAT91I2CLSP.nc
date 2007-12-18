#include "c_lowspeed.h"
#include "c_lowspeed.iom"

module HalAT91I2CLSP {
  provides {
    interface HalAT91I2CLS;
  }
  uses {
    interface HplAT91I2CLS;
    interface Boot;
  }
}
implementation {
	IOMAPLOWSPEED   IOMapLowSpeed;
	VARSLOWSPEED    VarsLowSpeed;
	
	//static    HEADER          **pHeaders;

  void cLowSpeedInit();
  //void      cLowSpeedCtrl();
  //void      cLowSpeedExit();
  
	const UBYTE LOWSPEED_CH_NUMBER[4] = {0x01, 0x02, 0x04, 0x08};
/*
	const     HEADER          cLowSpeed =
	{
		0x000B0001L,
		"Low Speed",
		cLowSpeedInit,
		cLowSpeedCtrl,
		cLowSpeedExit,
		(void *)&IOMapLowSpeed,
		(void *)&VarsLowSpeed,
		(UWORD)sizeof(IOMapLowSpeed),
		(UWORD)sizeof(VarsLowSpeed),
		0x0000                      //Code size - not used so far
	};
*/
  
  command void HalAT91I2CLS.notning(){};
  
  event void Boot.booted() {
		  cLowSpeedInit();
  }

	void      cLowSpeedInit()//void* pHeader)
	{
		//pHeaders        = pHeader;

		call HplAT91I2CLS.dLowSpeedInit();
		IOMapLowSpeed.State = COM_CHANNEL_NONE_ACTIVE;
		VarsLowSpeed.TimerState = TIMER_STOPPED;
	}

	void      cLowSpeedCtrl()
	{
		UBYTE Temp;
		UBYTE ChannelNumber = 0;

		if (IOMapLowSpeed.State != 0)
		{
			for (ChannelNumber = 0; ChannelNumber < NO_OF_LOWSPEED_COM_CHANNEL; ChannelNumber++)
			{
				//Lowspeed com is activated
				switch (IOMapLowSpeed.ChannelState[ChannelNumber])			
				{
					case LOWSPEED_IDLE:
					{
					}
					break;

					case LOWSPEED_INIT:
					{
						//if ((pMapInput->Inputs[ChannelNumber].SensorType == LOWSPEED) || (pMapInput->Inputs[ChannelNumber].SensorType == LOWSPEED_9V))
						if(TRUE)
						{
							if (VarsLowSpeed.TimerState == TIMER_STOPPED)
							{
								call HplAT91I2CLS.dLowSpeedStartTimer();
								VarsLowSpeed.TimerState = TIMER_RUNNING;
							}
							IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_LOAD_BUFFER;
							IOMapLowSpeed.ErrorType[ChannelNumber] = LOWSPEED_NO_ERROR;
							VarsLowSpeed.ErrorCount[ChannelNumber] = 0;
							call HplAT91I2CLS.dLowSpeedInitPins(ChannelNumber);			
						}
						else
						{
							IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_ERROR;
							IOMapLowSpeed.ErrorType[ChannelNumber] = LOWSPEED_CH_NOT_READY;
						}
					}
					break;

					case LOWSPEED_LOAD_BUFFER:
					{
						//if ((pMapInput->Inputs[ChannelNumber].SensorType == LOWSPEED) || (pMapInput->Inputs[ChannelNumber].SensorType == LOWSPEED_9V))
						if(TRUE)
						{
							VarsLowSpeed.OutputBuf[ChannelNumber].OutPtr = 0;
							for (VarsLowSpeed.OutputBuf[ChannelNumber].InPtr = 0; VarsLowSpeed.OutputBuf[ChannelNumber].InPtr < IOMapLowSpeed.OutBuf[ChannelNumber].InPtr; VarsLowSpeed.OutputBuf[ChannelNumber].InPtr++)
							{
								VarsLowSpeed.OutputBuf[ChannelNumber].Buf[VarsLowSpeed.OutputBuf[ChannelNumber].InPtr] = IOMapLowSpeed.OutBuf[ChannelNumber].Buf[IOMapLowSpeed.OutBuf[ChannelNumber].OutPtr];
								IOMapLowSpeed.OutBuf[ChannelNumber].OutPtr++;
							}
							if (call HplAT91I2CLS.dLowSpeedSendData(ChannelNumber, &VarsLowSpeed.OutputBuf[ChannelNumber].Buf[0], (VarsLowSpeed.OutputBuf[ChannelNumber].InPtr - VarsLowSpeed.OutputBuf[ChannelNumber].OutPtr)))
							{
								if (IOMapLowSpeed.InBuf[ChannelNumber].BytesToRx != 0)
								{
									call HplAT91I2CLS.dLowSpeedReceiveData(ChannelNumber, &VarsLowSpeed.InputBuf[ChannelNumber].Buf[0], IOMapLowSpeed.InBuf[ChannelNumber].BytesToRx);
									VarsLowSpeed.RxTimeCnt[ChannelNumber] = 0;
								}
								IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_COMMUNICATING;
								IOMapLowSpeed.Mode[ChannelNumber] = LOWSPEED_TRANSMITTING;
							}
							else
							{
								IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_ERROR;
								IOMapLowSpeed.ErrorType[ChannelNumber] = LOWSPEED_CH_NOT_READY;
							}
						}
						else
						{
							IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_ERROR;
							IOMapLowSpeed.ErrorType[ChannelNumber] = LOWSPEED_CH_NOT_READY;
						}
					}
					break;

					case LOWSPEED_COMMUNICATING:
					{
						//if ((pMapInput->Inputs[ChannelNumber].SensorType == LOWSPEED) || (pMapInput->Inputs[ChannelNumber].SensorType == LOWSPEED_9V))
						if(TRUE)
						{
							if (IOMapLowSpeed.Mode[ChannelNumber] == LOWSPEED_TRANSMITTING)
							{
								Temp = call HplAT91I2CLS.dLowSpeedComTxStatus(ChannelNumber);			// Returns 0x00 if not done, 0x01 if success, 0xFF if error

								if (Temp == LOWSPEED_COMMUNICATION_SUCCESS)
								{
									if (IOMapLowSpeed.InBuf[ChannelNumber].BytesToRx != 0)
									{
										IOMapLowSpeed.Mode[ChannelNumber] = LOWSPEED_RECEIVING;							    			
									}
									else
									{
										IOMapLowSpeed.Mode[ChannelNumber] = LOWSPEED_DATA_RECEIVED;
										IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_DONE;
									}
								}
								if (Temp == LOWSPEED_COMMUNICATION_ERROR)
								{
									//ERROR in Communication, No ACK received from SLAVE, retry send data 3 times!
									VarsLowSpeed.ErrorCount[ChannelNumber]++;
									if (VarsLowSpeed.ErrorCount[ChannelNumber] > MAX_RETRY_TX_COUNT)
									{
										IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_ERROR;
										IOMapLowSpeed.ErrorType[ChannelNumber] = LOWSPEED_TX_ERROR;
									}
									else
									{
										IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_LOAD_BUFFER;
									}
								}			
							}
							if (IOMapLowSpeed.Mode[ChannelNumber] == LOWSPEED_RECEIVING)
							{
								VarsLowSpeed.RxTimeCnt[ChannelNumber]++;
								if (VarsLowSpeed.RxTimeCnt[ChannelNumber] > LOWSPEED_RX_TIMEOUT)
								{
									IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_ERROR;
									IOMapLowSpeed.ErrorType[ChannelNumber] = LOWSPEED_RX_ERROR;
								}
								Temp = call HplAT91I2CLS.dLowSpeedComRxStatus(ChannelNumber);
								if (Temp == LOWSPEED_COMMUNICATION_SUCCESS)
								{
									for (VarsLowSpeed.InputBuf[ChannelNumber].OutPtr = 0; VarsLowSpeed.InputBuf[ChannelNumber].OutPtr < IOMapLowSpeed.InBuf[ChannelNumber].BytesToRx; VarsLowSpeed.InputBuf[ChannelNumber].OutPtr++)
									{
										IOMapLowSpeed.InBuf[ChannelNumber].Buf[IOMapLowSpeed.InBuf[ChannelNumber].InPtr] = VarsLowSpeed.InputBuf[ChannelNumber].Buf[VarsLowSpeed.InputBuf[ChannelNumber].OutPtr];
										IOMapLowSpeed.InBuf[ChannelNumber].InPtr++;
										if (IOMapLowSpeed.InBuf[ChannelNumber].InPtr >= SIZE_OF_LSBUF)
										{
											IOMapLowSpeed.InBuf[ChannelNumber].InPtr = 0;
										}
										VarsLowSpeed.InputBuf[ChannelNumber].Buf[VarsLowSpeed.InputBuf[ChannelNumber].OutPtr] = 0;
									}
									IOMapLowSpeed.Mode[ChannelNumber] = LOWSPEED_DATA_RECEIVED;
									IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_DONE;
								}
								if (Temp == LOWSPEED_COMMUNICATION_ERROR)
								{
									//There was and error in receiving data from the device
									for (VarsLowSpeed.InputBuf[ChannelNumber].OutPtr = 0; VarsLowSpeed.InputBuf[ChannelNumber].OutPtr < IOMapLowSpeed.InBuf[ChannelNumber].BytesToRx; VarsLowSpeed.InputBuf[ChannelNumber].OutPtr++)
									{
										VarsLowSpeed.InputBuf[ChannelNumber].Buf[VarsLowSpeed.InputBuf[ChannelNumber].OutPtr] = 0;
									}
									IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_ERROR;
									IOMapLowSpeed.ErrorType[ChannelNumber] = LOWSPEED_RX_ERROR;
								}              
							}		        			
						}
						else
						{
							IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_ERROR;
							IOMapLowSpeed.ErrorType[ChannelNumber] = LOWSPEED_CH_NOT_READY;
						}          
					}
					break;	

					case LOWSPEED_ERROR:
					{
						IOMapLowSpeed.State = IOMapLowSpeed.State & ~LOWSPEED_CH_NUMBER[ChannelNumber];			
						if (IOMapLowSpeed.State == 0)
						{
							call HplAT91I2CLS.dLowSpeedStopTimer();
							VarsLowSpeed.TimerState = TIMER_STOPPED;
						}
					}
					break;

					case LOWSPEED_DONE:
					{
						IOMapLowSpeed.State = IOMapLowSpeed.State & ~LOWSPEED_CH_NUMBER[ChannelNumber];			
						IOMapLowSpeed.ChannelState[ChannelNumber] = LOWSPEED_IDLE;
						if (IOMapLowSpeed.State == 0)
						{
							call HplAT91I2CLS.dLowSpeedStopTimer();
							VarsLowSpeed.TimerState = TIMER_STOPPED;
						}			
					}
					break;

					default:
						break;
				}
			}
		}	
	}

	void      cLowSpeedExit()
	{
		call HplAT91I2CLS.dLowSpeedExit();
	}

}
