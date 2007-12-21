configuration SyncMacC {
}
implementation {
	components
		SyncMacP,
		MainC,
		new TimerMilliC() as BeaconTimer,
		new TimerMilliC() as UnicastTimer,
		new TimerMilliC() as StartTimer,
		ActiveMessageC,CC2420ActiveMessageC,CC2420ControlC,
		new AMSenderC(1) as BroadcastSender,
		new AMSenderC(2) as UnicastSender,
		new AMReceiverC(1) as BroadcastReceiver,
		new AMReceiverC(2) as UnicastRecevier,
		LedsC,
		DSNC,
		RandomC,
		CC2420PacketC;
	
	SyncMacP.Boot-> MainC;
	SyncMacP.BeaconTimer-> BeaconTimer;
	SyncMacP.UnicastTimer-> UnicastTimer;
	SyncMacP.StartTimer->StartTimer;
	SyncMacP.AMPacket-> ActiveMessageC;
	SyncMacP.Packet-> ActiveMessageC;
	SyncMacP.Leds-> LedsC;
	SyncMacP.DsnSend-> DSNC;
	SyncMacP.BeaconReceive-> BroadcastReceiver;
	SyncMacP.UnicastReceive-> UnicastRecevier;
	SyncMacP.BeaconSend-> BroadcastSender;
	SyncMacP.UnicastSend-> UnicastSender;
	SyncMacP.RadioControl-> ActiveMessageC;
	SyncMacP.Random -> RandomC;
	SyncMacP.LowPowerListening -> CC2420ActiveMessageC;
	SyncMacP.PacketAcknowledgements-> ActiveMessageC;
	SyncMacP.CC2420Config -> CC2420ControlC;
	SyncMacP.LinkPacketMetadata -> CC2420PacketC;
}
