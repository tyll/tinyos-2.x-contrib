#define AM_CONTEXT_LOG 55
configuration QuantoLogRawUARTC {
    provides interface QuantoLog;
}
implementation {
    components MainC;
    components QuantoLogRawUARTP as CLog;
    QuantoLog =  CLog; 

    CLog.Boot -> MainC;

    components SingleContextTrackC;
    components MultiContextTrackC;
    components PowerStateTrackC;

    CLog.SingleContextTrack -> SingleContextTrackC;
    CLog.MultiContextTrack -> MultiContextTrackC;
    CLog.PowerStateTrack -> PowerStateTrackC;

    components Counter32khz32C as Counter;
    CLog.Counter -> Counter;
    
    components SerialActiveMessageC as Serial;
    components new SerialAMSenderC(AM_CONTEXT_LOG) as UARTSender;
    CLog.SerialControl -> Serial;
    CLog.UARTSend -> UARTSender;

    components EnergyMeterC;
    CLog.EnergyMeter -> EnergyMeterC;
}
