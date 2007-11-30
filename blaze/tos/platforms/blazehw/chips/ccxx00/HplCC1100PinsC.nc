
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
 
configuration HplCC1100PinsC {

  provides interface GeneralIO as Power;
  provides interface GeneralIO as Csn;
  provides interface GeneralIO as Gdo0_io;
  provides interface GeneralIO as Gdo2_io;
  
  provides interface GpioInterrupt as Gdo2_int;
  provides interface GpioInterrupt as Gdo0_int;
  
}

implementation {
  
  components HplMsp430InterruptP;
  components new Msp430InterruptC() as CC1100GDO0;
  components new Msp430InterruptC() as CC1100GDO2;
  CC1100GDO2.HplInterrupt -> HplMsp430InterruptP.Port12;
  CC1100GDO0.HplInterrupt -> HplMsp430InterruptP.Port10;
  Gdo2_int = CC1100GDO2;
  Gdo0_int = CC1100GDO0;
  
  components HplCC1100PinsP;
  HplCC1100PinsP.Gdo2_int -> CC1100GDO2;
  HplCC1100PinsP.Gdo0_int -> CC1100GDO0;
  
  components HplMsp430GeneralIOC as GeneralIOC;
  components new Msp430GpioC() as CSNM;
  CSNM -> GeneralIOC.Port30;
  Csn = CSNM;
  HplCC1100PinsP.CSn -> CSNM;
  
  components new Msp430GpioC() as CC1100GDO0_IO;
  CC1100GDO0_IO -> GeneralIOC.Port10;
  Gdo0_io = CC1100GDO0_IO;
  
  components new Msp430GpioC() as CC1100GDO2_IO;
  CC1100GDO2_IO -> GeneralIOC.Port12;
  Gdo2_io = CC1100GDO2_IO;
  
  components new Msp430GpioC() as power_io;
  power_io -> GeneralIOC.Port55;
  //Power = power_io;
  HplCC1100PinsP.PowerIn -> power_io;
  Power = HplCC1100PinsP.PowerOut;
  
  components MainC;
  MainC.SoftwareInit -> HplCC1100PinsP;
  
  
}

