
/**
 * Initialize a CC1100 or CC2500 radio
 * @author David Moss
 */

configuration BlazeInitC {
  provides {
    interface SplitControl[ radio_id_t id ];
    interface BlazePower[ radio_id_t id ];
    interface BlazeCommit;
  }
  
  uses {
    interface GeneralIO as Power[ radio_id_t id ];
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GeneralIO as Gdo0_io[ radio_id_t id ];
    interface GeneralIO as Gdo2_io[ radio_id_t id ];
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
  Gdo2_io = BlazeInitP.Gdo2_io;
  
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
  BlazeInitP.CheckRadio -> BlazeSpiC;
  
  components LedsC;
  BlazeInitP.Leds -> LedsC;
}

