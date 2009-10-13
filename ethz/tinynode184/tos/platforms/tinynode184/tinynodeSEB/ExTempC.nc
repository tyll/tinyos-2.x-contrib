
generic configuration ExTempC() {

    provides {
	interface Read<uint16_t>;
	interface ReadStream<uint16_t>;
    }
}

implementation {

    components new AdcReadClientC();
    components new AdcReadStreamClientC();
    
    components new ExTempP();
    Read = ExTempP;
    ReadStream = ExTempP;

    ExTempP.ADCRead -> AdcReadClientC;
    ExTempP.ADCReadStream -> AdcReadStreamClientC;
    components new TimerMilliC() as Timer;
    ExTempP.Timer -> Timer;
    
    components new ExTempAdcP();
    AdcReadClientC.AdcConfigure -> ExTempAdcP;
    AdcReadStreamClientC.AdcConfigure -> ExTempAdcP;
    
    components MainC;
    MainC.SoftwareInit -> ExTempP;
    
}
