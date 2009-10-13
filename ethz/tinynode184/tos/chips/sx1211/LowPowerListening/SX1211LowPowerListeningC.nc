

configuration SX1211LowPowerListeningC {
    provides {
	interface SplitControl;
	interface Send;
	interface Receive;
	interface LowPowerListening;
	//	interface CsmaBackoff[am_id_t amId];
    }
}
implementation {
    components MainC,
	SX1211ActiveMessageC,
	SX1211LowPowerListeningP,
	/*SX1211CsmaP as*/ SX1211CsmaRadioC,
	RandomC;
    components new TimerMilliC() as SendTimeoutC;
    components new TimerMilliC() as OnTimerC;
    components new TimerMilliC() as OffTimerC;
    
    Send = SX1211LowPowerListeningP;
    Receive = SX1211LowPowerListeningP;
    SplitControl = SX1211LowPowerListeningP;
    LowPowerListening = SX1211LowPowerListeningP;
    //    CsmaBackoff = SX1211LowPowerListeningP;

    MainC.SoftwareInit -> SX1211LowPowerListeningP;
    
    //SX1211LowPowerListeningP.LowPowerListening -> SX1211CsmaRadioC;    
    SX1211LowPowerListeningP.SubControl -> SX1211CsmaRadioC;
    SX1211LowPowerListeningP.CsmaControl -> SX1211CsmaRadioC;
    //  SX1211LowPowerListeningP.SubBackoff -> SX1211CsmaRadioC;
    SX1211LowPowerListeningP.SubSend -> SX1211CsmaRadioC.Send;
    SX1211LowPowerListeningP.SubReceive -> SX1211CsmaRadioC.Receive;
    SX1211LowPowerListeningP.AMPacket -> SX1211ActiveMessageC;
    SX1211LowPowerListeningP.PacketAcknowledgements -> SX1211ActiveMessageC;// SX1211CsmaRadioC;
    SX1211LowPowerListeningP.SendTimeout -> SendTimeoutC;
    SX1211LowPowerListeningP.OnTimer -> OnTimerC;
    SX1211LowPowerListeningP.OffTimer -> OffTimerC;
    SX1211LowPowerListeningP.Random -> RandomC;
    SX1211LowPowerListeningP.LPLControl -> SX1211CsmaRadioC.LPLControl;

}
