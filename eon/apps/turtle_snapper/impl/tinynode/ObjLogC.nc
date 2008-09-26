
configuration ObjLogC {
	provides 
	{
		interface ObjLog[uint8_t id];
	}
}
implementation {
  components ObjLogM, Main;
  components PageEEPROMC;
  components InternalFlashC as IFlash;
   
  ObjLog = ObjLogM.ObjLog;
 	
  Main.StdControl -> ObjLogM.StdControl;
  Main.StdControl -> PageEEPROMC.StdControl;
  
  ObjLogM.PageEEPROM -> PageEEPROMC.PageEEPROM[unique("PageEEPROM")];
  ObjLogM.InternalFlash -> IFlash.InternalFlash;
}

