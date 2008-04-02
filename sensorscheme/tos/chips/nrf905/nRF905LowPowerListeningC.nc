

configuration nRF905LowPowerListeningC {
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
	nRF905ActiveMessageC,
	nRF905LowPowerListeningP,
	/*nRF905CsmaP as*/ nRF905CsmaRadioC,
	RandomC;
    components new TimerMilliC() as SendTimeoutC;
    components new TimerMilliC() as OnTimerC;
    components new TimerMilliC() as OffTimerC;
    
    Send = nRF905LowPowerListeningP;
    Receive = nRF905LowPowerListeningP;
    SplitControl = nRF905LowPowerListeningP;
    LowPowerListening = nRF905LowPowerListeningP;
    //    CsmaBackoff = nRF905LowPowerListeningP;

    MainC.SoftwareInit -> nRF905LowPowerListeningP;
    
    //nRF905LowPowerListeningP.LowPowerListening -> nRF905CsmaRadioC;    
    nRF905LowPowerListeningP.SubControl -> nRF905CsmaRadioC;
    nRF905LowPowerListeningP.CsmaControl -> nRF905CsmaRadioC;
    //  nRF905LowPowerListeningP.SubBackoff -> nRF905CsmaRadioC;
    nRF905LowPowerListeningP.SubSend -> nRF905CsmaRadioC.Send;
    nRF905LowPowerListeningP.SubReceive -> nRF905CsmaRadioC.Receive;
    nRF905LowPowerListeningP.AMPacket -> nRF905ActiveMessageC;
    nRF905LowPowerListeningP.PacketAcknowledgements -> nRF905ActiveMessageC;// nRF905CsmaRadioC;
    nRF905LowPowerListeningP.SendTimeout -> SendTimeoutC;
    nRF905LowPowerListeningP.OnTimer -> OnTimerC;
    nRF905LowPowerListeningP.OffTimer -> OffTimerC;
    nRF905LowPowerListeningP.Random -> RandomC;
    nRF905LowPowerListeningP.LPLControl -> nRF905CsmaRadioC.LPLControl;

}
