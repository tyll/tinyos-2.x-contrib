includes sunlog;

configuration sunlogC {
}
implementation {
	components Main, ByteEEPROM, TimerC, DS2770C, sunlogM;

	Main.StdControl -> ByteEEPROM;
	Main.StdControl -> sunlogM;
	Main.StdControl -> TimerC;
	
	sunlogM.Timer -> TimerC.Timer[unique("Timer")];
	sunlogM.DS2770 -> DS2770C;
	sunlogM.AllocationReq -> ByteEEPROM.AllocationReq[MY_FLASH_REGION_ID];
	sunlogM.WriteData -> ByteEEPROM.WriteData[MY_FLASH_REGION_ID];
}

