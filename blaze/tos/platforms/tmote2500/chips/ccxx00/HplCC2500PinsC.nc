
/**
 * View of the 6- and 10-pin headers from the TOP of the tmote:
 *
 *              ------
 *              o1  2o
 *       GDO0 - o3  4o - GDO2
 *              o5  6o
 *              ------
 *              ------
 *        VCC - o1  2o              >> VCC is always on
 *        CSN - o3  4o
 *      Power - o5  6o - CLK        >> Power toggling is not connected
 *              o7  8o - SI
 *        GND - o9 10o
 *              ------
 *
 *
 * Finally, pull the SO line from the STM25P flash since it's not brought out
 * on a header:
 *
 *             ________
 *           =|O       |=   
 *      SO - =|  STM   |=
 *           =| 25P80  |=
 *           =|________|=
 *            
 *
 * @author David Moss
 */
 
configuration HplCC2500PinsC {

  provides interface GeneralIO as Power;
  provides interface GeneralIO as Csn;
  provides interface GeneralIO as Gdo0_io;
  provides interface GeneralIO as Gdo2_io;
  
  provides interface GpioInterrupt as Gdo2_int;
  provides interface GpioInterrupt as Gdo0_int;
  
}

implementation {
  
  components HplMsp430InterruptP;
  components new Msp430InterruptC() as CC2500GDO0;
  components new Msp430InterruptC() as CC2500GDO2;
  CC2500GDO2.HplInterrupt -> HplMsp430InterruptP.Port26;
  CC2500GDO0.HplInterrupt -> HplMsp430InterruptP.Port23;
  Gdo2_int = CC2500GDO2;
  Gdo0_int = CC2500GDO0;
  
  components HplMsp430GeneralIOC as GeneralIOC;
  components new Msp430GpioC() as CSNM;
  CSNM -> GeneralIOC.Port60;
  Csn = CSNM;
  
  components new Msp430GpioC() as CC2500GDO0_IO;
  CC2500GDO0_IO -> GeneralIOC.Port23;
  Gdo0_io = CC2500GDO0_IO;
  
  components new Msp430GpioC() as CC2500GDO2_IO;
  CC2500GDO2_IO -> GeneralIOC.Port26;
  Gdo2_io = CC2500GDO2_IO;
  
  // No power pin available on tmote blaze
  components DummyIoP;
  Power = DummyIoP;
  
  components HplCC2500PinsP;
  HplCC2500PinsP.Gdo2_int -> CC2500GDO2;
  HplCC2500PinsP.Gdo0_int -> CC2500GDO0;
  HplCC2500PinsP.Gdo2_io -> CC2500GDO2_IO;
  HplCC2500PinsP.Gdo0_io -> CC2500GDO0_IO;
  HplCC2500PinsP.Csn -> CSNM;
  HplCC2500PinsP.Power -> DummyIoP;
  
  components RealMainP;
  RealMainP.PlatformInit -> HplCC2500PinsP;
  
}

