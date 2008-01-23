
/**
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
  components HplMsp430GeneralIOC as GeneralIOC;
  components new HplCCxx00PinsP();
  
  components new Msp430InterruptC() as CC1100GDO0;
  components new Msp430InterruptC() as CC1100GDO2;
  CC1100GDO2.HplInterrupt -> HplMsp430InterruptP.Port12;
  CC1100GDO0.HplInterrupt -> HplMsp430InterruptP.Port10;
  Gdo2_int = CC1100GDO2;
  Gdo0_int = CC1100GDO0;
  
  HplCCxx00PinsP.Gdo2_int -> CC1100GDO2;
  HplCCxx00PinsP.Gdo0_int -> CC1100GDO0;
  
  components new Msp430GpioC() as CSNM;
  CSNM -> GeneralIOC.Port30;
  Csn = HplCCxx00PinsP.CsnOut;
  HplCCxx00PinsP.Csn -> CSNM;
  
  components new Msp430GpioC() as CC1100GDO0_IO;
  CC1100GDO0_IO -> GeneralIOC.Port10;
  Gdo0_io = CC1100GDO0_IO;
  
  components new Msp430GpioC() as CC1100GDO2_IO;
  CC1100GDO2_IO -> GeneralIOC.Port12;
  Gdo2_io = CC1100GDO2_IO;
  
  components new Msp430GpioC() as PowerPin;
  PowerPin -> GeneralIOC.Port55;
  HplCCxx00PinsP.PowerIn -> PowerPin;
  Power = HplCCxx00PinsP.PowerOut;
  
  components MainC;
  MainC.SoftwareInit -> HplCCxx00PinsP;
  
}

