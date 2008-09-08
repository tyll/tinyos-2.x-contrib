configuration BurstAppC {
}
implementation {
    components
            MainC,
            BurstC,
            LedsC,
            UserButtonC,
            QuantoLogRawUARTC as CLog,
            ResourceContextsC;

    BurstC.Boot -> MainC.Boot;
    BurstC.Leds -> LedsC;
    BurstC.CPUContext -> ResourceContextsC.CPUContext;
    BurstC.UserButtonNotify -> UserButtonC;
    BurstC.QuantoLog -> CLog;
}
