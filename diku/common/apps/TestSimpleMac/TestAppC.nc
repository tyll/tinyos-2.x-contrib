configuration TestAppC {

}
implementation {
    components MainC, TestAppP;

    MainC.SoftwareInit -> TestAppP.Init;
    MainC.Boot <- TestAppP;

    components LedsC;
    TestAppP.Leds -> LedsC;
    
    components new TimerMilliC() as TimerC;
    TestAppP.Timer -> TimerC;
   
    components SimpleMacC;
    TestAppP.SimpleMacControl -> SimpleMacC.StdControl;
    TestAppP.SimpleMac -> SimpleMacC.SimpleMac;

    components new CounterToLocalTimeC(TMicro) as LocalTimeC;
    TestAppP.LocalTime -> LocalTimeC;

    components StdOutC;
    TestAppP.StdOut -> StdOutC;
}

