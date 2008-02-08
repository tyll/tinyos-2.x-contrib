// Energy Meter using FM3116
// @ Fred Jiang

configuration BlinkSPOT {}

implementation {
	components MainC, BlinkSPOTM, SPOTC, LedsC;
	components new TimerMilliC() as TimerC;
	components new SerialAMSenderC(AM_ENERGYMSG);
	components SerialActiveMessageC;

	SPOTC.Boot -> MainC.Boot;
	BlinkSPOTM.Boot -> SPOTC.RealBoot;
	
	BlinkSPOTM.Timer -> TimerC;
	BlinkSPOTM.Leds -> LedsC;
	BlinkSPOTM.SPOT -> SPOTC;

	BlinkSPOTM.AMSend -> SerialAMSenderC;
	BlinkSPOTM.AMControl -> SerialActiveMessageC;
	BlinkSPOTM.Packet -> SerialAMSenderC;
}

