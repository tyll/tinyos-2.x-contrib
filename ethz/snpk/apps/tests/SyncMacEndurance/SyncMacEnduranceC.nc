configuration SyncMacEnduranceC {
}
implementation {
	components
		SyncMacEnduranceP,
		MainC,
		new TimerMilliC() as UnicastTimer,
		new TimerMilliC() as StartTimer,
		ActiveMessageC,CC2420ActiveMessageC,CC2420ControlC,
		new AMSenderC(1),
		new AMReceiverC(1),
		LedsC,
		DSNC,
		RandomC,
		CC2420PacketC,
		NeighbourSyncC;
	
	SyncMacEnduranceP.Boot-> MainC;
	SyncMacEnduranceP.UnicastTimer-> UnicastTimer;
	SyncMacEnduranceP.StartTimer->StartTimer;
	SyncMacEnduranceP.AMPacket-> ActiveMessageC;
	SyncMacEnduranceP.Packet-> ActiveMessageC;
	SyncMacEnduranceP.Leds-> LedsC;
	SyncMacEnduranceP.DsnSend-> DSNC;
	SyncMacEnduranceP.Receive-> AMReceiverC;
	SyncMacEnduranceP.AMSend-> AMSenderC;
	SyncMacEnduranceP.RadioControl-> ActiveMessageC;
	SyncMacEnduranceP.Random -> RandomC;
	SyncMacEnduranceP.LowPowerListening -> CC2420ActiveMessageC;
	SyncMacEnduranceP.PacketAcknowledgements-> ActiveMessageC;
	SyncMacEnduranceP.CC2420Config -> CC2420ControlC;
	SyncMacEnduranceP.LinkPacketMetadata -> CC2420PacketC;
	
	SyncMacEnduranceP.NeighbourSyncRequest->NeighbourSyncC;
}
