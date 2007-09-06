/**
 * Display module.
 * @author Rasmus Pedersen
 */

configuration HalLCDC {
  provides {
    interface HalLCD;
  }
}

implementation {
  components PlatformP, HalLCDM, HplUC1601LCDC;
  
  HalLCD = HalLCDM.HalLCD;
  
  HalLCDM.HplLCD -> HplUC1601LCDC.HplUC1601LCD;
  
  HalLCDM.Init <- PlatformP.InitL3;
  
}
