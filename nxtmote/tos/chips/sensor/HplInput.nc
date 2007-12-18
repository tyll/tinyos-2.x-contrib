interface HplInput {
	command void dInputInit();
	command void dInputExit();

	command void dInputGetRawAd(UWORD *pValues, UBYTE No);
	command void dInputSetActive(UBYTE Port);
	command void dInputSet9v(UBYTE Port);
	command void dInputSetInactive(UBYTE Port);

	command void dInputSetDirOutDigi0(UBYTE Port);
	command void dInputSetDirOutDigi1(UBYTE Port);
	command void dInputSetDirInDigi0(UBYTE Port);
	command void dInputSetDirInDigi1(UBYTE Port);
	command void dInputClearDigi0(UBYTE Port);
	command void dInputClearDigi1(UBYTE Port);
	command void dInputSetDigi0(UBYTE Port);
	command void dInputSetDigi1(UBYTE Port);
	command void dInputRead0(UBYTE Port, UBYTE *pData);
	command void dInputRead1(UBYTE Port, UBYTE *pData);
}
