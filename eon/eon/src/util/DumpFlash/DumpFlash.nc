
configuration DumpFlash {
}
implementation {
  components Main, DumpFlashM, SingleTimer, LedsC;
  components PageEEPROMC, GenericComm as Comm;
  components InternalFlashC as IFlash;
  
  
  
  Main.StdControl -> SingleTimer.StdControl;
  Main.StdControl -> DumpFlashM.StdControl;
  Main.StdControl -> PageEEPROMC.StdControl;
  Main.StdControl -> Comm;
  
  
  DumpFlashM.Timer -> SingleTimer.Timer;
  DumpFlashM.Leds -> LedsC;
  
  DumpFlashM.PageEEPROM -> PageEEPROMC.PageEEPROM[unique("PageEEPROM")];
  DumpFlashM.SendMsg -> Comm.SendMsg[1];
  DumpFlashM.InternalFlash -> IFlash.InternalFlash;
}

