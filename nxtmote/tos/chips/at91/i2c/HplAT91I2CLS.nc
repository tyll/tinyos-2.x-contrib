interface HplAT91I2CLS {
	command void   dLowSpeedInit();
	command void   dLowSpeedStartTimer();
	command void   dLowSpeedStopTimer();
	command void   dLowSpeedInitPins(UBYTE ChannelNumber);
	command UBYTE  dLowSpeedSendData(UBYTE ChannelNumber, UBYTE *DataOutBuffer, UBYTE NumberOfTxByte);
	command void   dLowSpeedReceiveData(UBYTE ChannelNumber, UBYTE *DataInBuffer, UBYTE ByteToRx);
	command UBYTE  dLowSpeedComTxStatus(UBYTE ChannelNumber);
	command UBYTE  dLowSpeedComRxStatus(UBYTE ChannelNumber);
	command void   dLowSpeedExit();
}
