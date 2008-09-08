configuration McuSleepC {
    provides {
        interface McuSleep;
        interface McuPowerState;
    }
  uses {
    interface McuPowerOverride;
  }
}
implementation {
    components McuSleepP, ResourceContextsC;

    McuSleep = McuSleepP;
    McuPowerState = McuSleepP;
    McuPowerOverride = McuSleepP;
        
    McuSleepP.CPUPowerState -> ResourceContextsC.CPUPowerState;

}
