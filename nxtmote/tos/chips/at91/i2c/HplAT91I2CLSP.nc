#include  "d_lowspeed.r"

module HplAT91I2CLSP {
  provides {
    interface HplAT91I2CLS as I2CLS;
  }
}
implementation {


	command void I2CLS.dLowSpeedInit()
	{
		LOWSpeedTxInit;
		LOWSpeedTimerInit;
		//ENABLEDebugOutput; 
	}

	command void I2CLS.dLowSpeedStartTimer()
	{
		ENABLEPWMTimerForLowCom;
	}

	command void I2CLS.dLowSpeedStopTimer()
	{
		DISABLEPWMTimerForLowCom; 
	}

	command void I2CLS.dLowSpeedInitPins(UBYTE ChannelNumber)
	{
		ENABLETxPins(ChannelNumber);  
	}

	command UBYTE I2CLS.dLowSpeedSendData(UBYTE ChannelNumber, UBYTE *DataOutBuffer, UBYTE NumberOfTxByte)
	{  
		UBYTE Status;

		TxData(ChannelNumber, Status, DataOutBuffer, NumberOfTxByte);
		return(Status);
	}

	command void I2CLS.dLowSpeedReceiveData(UBYTE ChannelNumber, UBYTE *DataInBuffer, UBYTE ByteToRx)
	{	
		RxData(ChannelNumber, DataInBuffer, ByteToRx); 
	}

	command UBYTE I2CLS.dLowSpeedComTxStatus(UBYTE ChannelNumber)
	{
		UBYTE Status; 

		STATUSTxCom(ChannelNumber, Status)

		return(Status);
	}

	command UBYTE I2CLS.dLowSpeedComRxStatus(UBYTE ChannelNumber)
	{
		UBYTE Status; 

		STATUSRxCom(ChannelNumber, Status)

		return(Status);
	}

	command void I2CLS.dLowSpeedExit()
	{
		LOWSpeedExit;
	}

}
