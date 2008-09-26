
configuration Eraser {
}
implementation {
  components Main, EraserM, SingleTimer, LedsC;
  components PageEEPROMC, GenericComm as Comm;
  components InternalFlashC as IFlash;
  
  
  
  Main.StdControl -> SingleTimer.StdControl;
  Main.StdControl -> EraserM.StdControl;
  Main.StdControl -> PageEEPROMC.StdControl;
  Main.StdControl -> Comm;
  
  
  EraserM.Timer -> SingleTimer.Timer;
  EraserM.Leds -> LedsC;
  
  EraserM.PageEEPROM -> PageEEPROMC.PageEEPROM[unique("PageEEPROM")];
  EraserM.SendMsg -> Comm.SendMsg[1];
  EraserM.InternalFlash -> IFlash.InternalFlash;
}

