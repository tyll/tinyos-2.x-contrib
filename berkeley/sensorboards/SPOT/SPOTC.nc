//SPOT Energy Meter using FM3116
//@author Fred Jiang <fxjiang@eecs.berkeley.edu>

configuration SPOTC {
	provides {
		interface SPOT;
		interface Boot as RealBoot; 
	}
	uses {
		interface Boot;
	}
}

implementation {
	components SPOTM, FM3116C, HplAtm128GeneralIOC;
	components new TimerMilliC() as TimerC;

	SPOTM.Boot = Boot;
	RealBoot = SPOTM.RealBoot;
	SPOT = SPOTM.SPOT;
	
	FM3116C.Boot = Boot;
	SPOTM.Boot = Boot;
	
	SPOTM.Timer -> TimerC;
	// 0x68 is the address for Measurement chip
	SPOTM.Measure -> FM3116C.FM3116[0x68];
	// 0x69 is the address for Timestamp / crystal counter
	SPOTM.Base -> FM3116C.FM3116[0x69];
	SPOTM.RW -> HplAtm128GeneralIOC.PortG1;
	SPOTM.EN -> HplAtm128GeneralIOC.PortG0;
	SPOTM.CAL -> HplAtm128GeneralIOC.PortG2;

	// Disable storage
	SPOTM.CEN -> HplAtm128GeneralIOC.PortF7;
	SPOTM.CE2N -> HplAtm128GeneralIOC.PortF6;
	SPOTM.CLE -> HplAtm128GeneralIOC.PortF5;
	SPOTM.ALE -> HplAtm128GeneralIOC.PortF4;
	SPOTM.REN -> HplAtm128GeneralIOC.PortF3;
	SPOTM.WEN -> HplAtm128GeneralIOC.PortF2;
	SPOTM.WPN -> HplAtm128GeneralIOC.PortF1;
	SPOTM.RBN -> HplAtm128GeneralIOC.PortE4;
	SPOTM.RB2N -> HplAtm128GeneralIOC.PortE5;
}

