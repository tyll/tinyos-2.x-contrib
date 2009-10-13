
generic configuration ExBattC() {

    provides {
	interface Read<uint16_t>;
//	interface ReadStream<uint16_t>;
    }
}

implementation {

    components new AdcReadClientC();
  //  components new AdcReadStreamClientC();

    components new ExBattP();
    Read = ExBattP;
//    ReadStream = ExBattP;

    ExBattP.ADCRead -> AdcReadClientC;
//    ExBattP.ADCReadStream -> AdcReadStreamClientC;
    
    components new TimerMilliC() as Timer;
    ExBattP.Timer -> Timer;

    components new ExBattAdcP();
    AdcReadClientC.AdcConfigure -> ExBattAdcP;
//    AdcReadStreamClientC.AdcConfigure -> ExBattAdcP;

    components MainC;
    MainC.SoftwareInit -> ExBattP;

}
