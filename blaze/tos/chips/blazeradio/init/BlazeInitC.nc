
/**
 * Initialize a CC1100 or CC2500 radio
 * @author David Moss
 */

configuration BlazeInitC {
  provides {
    interface SplitControl[ radio_id_t id ];
    interface BlazePower[ radio_id_t id ];
    interface BlazeCommit[ radio_id_t id ];
  }
  
  uses {
    interface GeneralIO as Power[ radio_id_t id ];
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GeneralIO as Gdo0_io[ radio_id_t id ];
    interface GeneralIO as Gdo2_io[ radio_id_t id ];
    interface GpioInterrupt as Gdo0_int[ radio_id_t id ];
    interface GpioInterrupt as Gdo2_int[ radio_id_t id ];
    interface BlazeRegSettings[ radio_id_t id ];
  }
}

implementation {

  components MainC,
      BlazeInitP,
      BlazeSpiC,
      new BlazeSpiResourceC() as ResetResourceC,
      new BlazeSpiResourceC() as DeepSleepResourceC;
      
  
  MainC.SoftwareInit -> BlazeInitP;
  
  Power = BlazeInitP.Power;
  Csn = BlazeInitP.Csn;
  SplitControl = BlazeInitP;
  BlazePower = BlazeInitP;
  BlazeRegSettings = BlazeInitP;
  BlazeCommit = BlazeInitP;
  
  Gdo0_io = BlazeInitP.Gdo0_io;
  Gdo0_int = BlazeInitP.Gdo0_int;
  
  Gdo2_io = BlazeInitP.Gdo2_io;
  Gdo2_int = BlazeInitP.Gdo2_int;
  
  BlazeInitP.ResetResource -> ResetResourceC;
  BlazeInitP.DeepSleepResource -> DeepSleepResourceC;
  
  BlazeInitP.Idle -> BlazeSpiC.SIDLE;
  BlazeInitP.SRES -> BlazeSpiC.SRES;
  BlazeInitP.SXOFF -> BlazeSpiC.SXOFF;
  BlazeInitP.SFRX -> BlazeSpiC.SFRX;
  BlazeInitP.SFTX -> BlazeSpiC.SFTX;
  BlazeInitP.SRX -> BlazeSpiC.SRX;
  BlazeInitP.RadioStatus -> BlazeSpiC.RadioStatus;
  
  BlazeInitP.RadioInit -> BlazeSpiC;
  
  components LedsC;
  BlazeInitP.Leds -> LedsC;
}

