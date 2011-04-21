
/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

generic configuration PeriodicProtocolC(am_id_t id, uint32_t period, bool sendFullPacket, bool isUrgent) {

} implementation {

	components 
		MainC,
		LedsC,
		new PeriodicProtocolP(period, sendFullPacket, isUrgent),
		new TimerMilliC(), 
		new AMSenderC(id),
		new AMReceiverC(id),
		LocalTimeMilliC;

	PeriodicProtocolP.Boot -> MainC;
	PeriodicProtocolP.Leds -> LedsC;
	PeriodicProtocolP.Timer -> TimerMilliC;
	PeriodicProtocolP.AMSend -> AMSenderC;
    PeriodicProtocolP.AMPacket -> AMSenderC;
    PeriodicProtocolP.Packet -> AMSenderC;
	PeriodicProtocolP.Receive -> AMReceiverC;
	PeriodicProtocolP.UnifiedBroadcast -> AMSenderC;
	PeriodicProtocolP.LocalTime -> LocalTimeMilliC;

}
