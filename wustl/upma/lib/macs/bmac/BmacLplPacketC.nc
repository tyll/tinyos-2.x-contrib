configuration BmacLplPacketC
{
	provides interface LowPowerListening;
	provides interface AsyncSend as Send;
	
	uses interface ChannelPoller;
	uses interface AsyncSend as SubSend;
}
implementation
{
#ifdef CC2420_DEF_CHANNEL
	components BmacLplPacketCC2420P as LplP;
	components CC2420PacketC;
	LplP.CC2420PacketBody -> CC2420PacketC;
	Send = SubSend;
#else
	components BmacLplPacketP as LplP;
	components ActiveMessageC;
	Send = LplP;
	SubSend = LplP;
	LplP.Packet -> ActiveMessageC;
#endif

	LowPowerListening = LplP;
	ChannelPoller = LplP;
}