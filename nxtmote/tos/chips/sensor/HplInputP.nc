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
