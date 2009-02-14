configuration QuantoLogMyUARTWriterC {
}
implementation {
    components MainC;
    components QuantoLogMyUARTWriterP as QLog;
    components TinySchedulerC;

    QLog.Boot -> MainC;
    QLog.PrepareWriteTask -> TinySchedulerC.TaskQuanto[unique("TinySchedulerC.TaskQuanto")];

    //components PortWriterC;
    components MySerialWriterC;
   
    QLog.PortWriter -> MySerialWriterC;    
    QLog.WriterInit -> MySerialWriterC;
    QLog.WriterControl -> MySerialWriterC;
    

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
