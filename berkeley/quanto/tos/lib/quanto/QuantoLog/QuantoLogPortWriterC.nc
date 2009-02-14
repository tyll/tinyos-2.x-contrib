configuration QuantoLogPortWriterC {
}
implementation {
    components MainC;
    components QuantoLogPortWriterP as QLog;
    components TinySchedulerC;

    QLog.Boot -> MainC;
    QLog.PrepareWriteTask -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];

    components PortWriterC;
   
    QLog.PortWriter -> PortWriterC;    
    

    components SingleContextTrackC;
    components MultiContextTrackC;
    components PowerStateTrackC;

    QLog.SingleContextTrack -> SingleContextTrackC;
    QLog.MultiContextTrack -> MultiContextTrackC;
    QLog.PowerStateTrack -> PowerStateTrackC;

    components Counter32khz32C as Counter;
    QLog.Counter -> Counter;

    components EnergyMeterC;
    QLog.EnergyMeter -> EnergyMeterC;

}
