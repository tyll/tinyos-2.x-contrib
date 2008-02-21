configuration CCAScanC {
}
implementation {
	components
		CCAScanP,
		MainC,
		ActiveMessageC,CC2420ActiveMessageC,CC2420ControlC,
		LedsC,
		DSNC,
		CC2420TransmitC,
	    CC2420ReceiveC,
	    new TimerMilliC() as OffTimer,
	    new DsnCommandC("set channel", uint8_t , 1) as SetChannelCommand;
	
	CCAScanP.Boot-> MainC;
	CCAScanP.Leds-> LedsC;
	CCAScanP.DsnSend-> DSNC;
	CCAScanP.RadioControl-> ActiveMessageC;
	CCAScanP.LowPowerListening -> CC2420ActiveMessageC;
	CCAScanP.CC2420Config -> CC2420ControlC;
	CCAScanP.EnergyIndicator -> CC2420TransmitC.EnergyIndicator;
	CCAScanP.ByteIndicator -> CC2420TransmitC.ByteIndicator;
	CCAScanP.PacketIndicator -> CC2420ReceiveC.PacketIndicator;
	CCAScanP.Timer -> OffTimer;
	CCAScanP.SetChannelCommand->SetChannelCommand;
	
	
}
