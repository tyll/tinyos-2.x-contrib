
/**
 * @author Morten Tranberg Hansen <mth at cs dot au dot dk>
 * @date   June 6 2010
 */

generic configuration TimePeriodicProtocolC(am_id_t id, uint32_t period) {

} implementation {

	components 
		MainC,
		LedsC,
		new TimePeriodicProtocolP(period),
		new TimerMilliC(), 
		TimeSyncMessageC,
		LocalTimeMilliC;

	TimePeriodicProtocolP.Boot -> MainC;
	TimePeriodicProtocolP.Leds -> LedsC;
	TimePeriodicProtocolP.Timer -> TimerMilliC;
	TimePeriodicProtocolP.TimeSyncAMSend -> TimeSyncMessageC.TimeSyncAMSendMilli[id];
	TimePeriodicProtocolP.TimeSyncPacket -> TimeSyncMessageC.TimeSyncPacketMilli;
	TimePeriodicProtocolP.Receive -> TimeSyncMessageC.Receive[id];
	TimePeriodicProtocolP.LocalTime -> LocalTimeMilliC;

}
