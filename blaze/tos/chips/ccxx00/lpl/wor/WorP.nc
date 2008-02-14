
/**
 * This is sort of the hardware presentation layer of Wake-on-Radio
 * @author David Moss
 */

#include "Wor.h"
#include "Blaze.h"

module WorP {
  provides {
    interface Init;
    interface Wor[radio_id_t radioId];
    
  }
  
  uses {
    interface Resource;
    interface BlazeRegister as MCSM2;
    interface BlazeRegister as WOREVT1;
    interface BlazeRegister as WOREVT0;
    interface BlazeRegister as WORCTRL;
    interface BlazeStrobe as SWOR;
    interface BlazeStrobe as SIDLE;
    interface BlazeStrobe as SRX;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SFTX;
    interface RadioStatus;
    
    interface GeneralIO as Csn[radio_id_t radioId];
    
    interface Leds;
  }
}

implementation {

  radio_id_t focusedRadio;
  bool enabling;
  uint8_t state;
  
  struct {
    uint8_t mcsm2;
    bool worEnabled;
    uint16_t event0;
    uint8_t event1;
  } worSettings[uniqueCount(UQ_BLAZE_RADIO)];
  
  enum {
    S_IDLE,
    S_TOGGLING,
  };
  
  /***************** Prototypes ****************/
  void setupWor();
  void verifyRxMode();
  
  
  /***************** Init Commands ****************/
  /**
   * Testing demonstrates that event1=0x7 is actually more energy efficient 
   * than event1=0x0
   */
  command error_t Init.init() {
    int i;
    for(i = 0; i < uniqueCount(UQ_BLAZE_RADIO); i++) {
      worSettings[i].mcsm2 = 0xFE;
      worSettings[i].worEnabled = FALSE;
      worSettings[i].event0 = 0x876B;  
      worSettings[i].event1 = 0x7;
    }
    return SUCCESS;
  }
  
  
  /***************** Wor Commands ****************/
  /**
   * Enable Wake-on-Radio by turning on the RC oscillator, sleeping if no
   * carrier sense, and strobing WOR.
   *
   * Disable Wake-on-Radio by disabling the RC oscillator, staying awake 
   * regardless of carrier sense, and strobing into RX mode.
   * @param on Turn WoR on or off
   */
  command void Wor.enableWor[radio_id_t radioId](bool on) {
    if(state != S_IDLE) {
      return;
    }
    
    state = S_TOGGLING;
    
    focusedRadio = radioId;
    enabling = on;
    
    if(call Resource.immediateRequest() == SUCCESS) {
      setupWor();
      
    } else {
      call Resource.request();
    }
  }
  
  command void Wor.synchronizeSettings[radio_id_t radioId]() {
    worSettings[radioId].worEnabled = FALSE;
    call Wor.enableWor[radioId](TRUE);
  }
  
  command uint16_t Wor.getEvent0Ms[radio_id_t radioId]() {
    return (((uint32_t) 750) * ((uint32_t) worSettings[radioId].event0)) / CCXX00_CRYSTAL_KHZ;
  }
  
  
  /**
   * @return TRUE if WoR is enabled for the given parameterized radio id
   */
  command bool Wor.isEnabled[radio_id_t radioId]() {
    return worSettings[radioId].worEnabled;
  }
  
  /** 
   * Calculate the EVENT0 register based on the number of milliseconds you'd
   * like to have between sleep intervals.  This is dependent upon the
   * CCXX00_CRYSTAL_KHZ preprocessor variable.
   * @param evt0_ms The desired duration between rx checks, in exact ms
   */
  command void Wor.calculateAndSetEvent0[radio_id_t radioId](uint16_t evt0_ms) {
    // Assumes WOR_RES = 0
    worSettings[radioId].event0 = ((uint32_t) evt0_ms * (uint32_t) CCXX00_CRYSTAL_KHZ) / 750;
  }
  
  
  
  /**
   * Set EVENT0 directly.
   * @param evt0 The register settings for the EVENT0 word
   */
  command void Wor.setEvent0[radio_id_t radioId](uint16_t evt0) {
    worSettings[radioId].event0 = evt0;
  }
  
  /**
   * Set the RX_TIME field in MCSM2. This sets the duty cycle percentage.
   * The default is 0.195% duty cycle (6)
   * @param rxTime The RX_TIME field value in MCSM2
   */
  command void Wor.setRxTime[radio_id_t radioId](uint8_t rxTime) {
    worSettings[radioId].mcsm2 = 
        (worSettings[radioId].mcsm2 & CCXX00_MCSM2_RX_TIME_MASK)
            | (rxTime << CCXX00_MCSM2_RX_TIME);
  }
  
  /**
   * Default is TRUE
   * @param sleepOnNoCarrier If a carrier is not detected within the first 8
   *     symbol periods, go back to sleep.
   */
  command void Wor.setRxTimeRssi[radio_id_t radioId](bool sleepOnNoCarrier) {
    worSettings[radioId].mcsm2 = 
        (worSettings[radioId].mcsm2 & CCXX00_MCSM2_RX_TIME_RSSI_MASK)
            | (sleepOnNoCarrier << CCXX00_MCSM2_RX_TIME);
  }
  
  /**
   * Default is FALSE
   * @param enablePqi Extend the on-time of the radio during an Rx check if
   *     a valid preamble has been detected.
   */
  command void Wor.setRxTimeQual[radio_id_t radioId](bool enablePqi) {
    worSettings[radioId].mcsm2 = 
      (worSettings[radioId].mcsm2 & CCXX00_MCSM2_RX_TIME_QUAL_MASK)
          | (enablePqi << CCXX00_MCSM2_RX_TIME_QUAL);
  }
  
  /**
   * Set the EVENT1 field in the WORCTRL register. This is how long it
   * takes to warm up and calibrate the oscillator before going into
   * Rx mode. The default is 1.38 ms startup (7).
   * @param evt1 The EVENT1 field value in WORCTRL
   */
  command void Wor.setEvent1[radio_id_t radioId](uint8_t evt1) {
    worSettings[radioId].event1 = evt1;
  }
  
  
  /***************** Resource Events ****************/
  event void Resource.granted() {
    setupWor();
  }
  
  
  /***************** Functions ****************/
  void setupWor() {
  
    call Csn.set[focusedRadio]();
    call Csn.clr[focusedRadio]();
    
    if(enabling) {
      // Enable WoR
      call SIDLE.strobe();
      
      if(worSettings[focusedRadio].worEnabled) {
        // WoR was previously setup. Give it a kick.
        call SWOR.strobe();
        
      } else {
        // Setup RX_TIME_RSSI, RX_TIME_QUAL, and RX_TIME        
        call MCSM2.write(worSettings[focusedRadio].mcsm2);
        
        // Setup EVENT0, the time between receive checks.
        call WOREVT1.write(worSettings[focusedRadio].event0 >> 8);
        call WOREVT0.write(worSettings[focusedRadio].event0);
        
        // Power up the RC Oscillator
        call WORCTRL.write(
            (0 << CCXX00_WORCTRL_RC_PD) |
            (worSettings[focusedRadio].event1 << CCXX00_WORCTRL_EVENT1) |
            (1 << CCXX00_WORCTRL_RC_CAL) |
            (0 << CCXX00_WORCTRL_WOR_RES));
         
        worSettings[focusedRadio].worEnabled = TRUE;
        call SWOR.strobe();
      }
      
    } else {
      // Disable WoR
      call SIDLE.strobe();

      // Disable RX_TIME_RSSI
      call MCSM2.write(0x0E);
      
      // Power down the RC oscillator
      call WORCTRL.write(
            (1 << CCXX00_WORCTRL_RC_PD) |
            (worSettings[focusedRadio].event1 << CCXX00_WORCTRL_EVENT1) |
            (1 << CCXX00_WORCTRL_RC_CAL) |
            (0 << CCXX00_WORCTRL_WOR_RES));
      
      call SRX.strobe();
      verifyRxMode();
    }
    
    call Csn.set[focusedRadio]();
    call Resource.release();
    state = S_IDLE;
    signal Wor.stateChange[focusedRadio](enabling);
  }
  
  
  void verifyRxMode() {
    uint8_t status;
    
    while((status = call RadioStatus.getRadioStatus()) != BLAZE_S_RX) {
      call Csn.set[focusedRadio]();
      call Csn.clr[focusedRadio]();
      
      if (status == BLAZE_S_RXFIFO_OVERFLOW) {
        call SFRX.strobe();
        call SRX.strobe();
        
      } else if (status == BLAZE_S_TXFIFO_UNDERFLOW) {
        call SFTX.strobe();
        call SRX.strobe();
        
     } else if (status == BLAZE_S_CALIBRATE) {
        // do nothing but don't quit the loop
        
      } else {
        call SIDLE.strobe();
        call SRX.strobe();
      }
    }
  }
  
  /***************** Defaults *****************/
  default event void Wor.stateChange[radio_id_t radioId](bool enabled) {
  }
  
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command bool Csn.get[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command bool Csn.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  default async command bool Csn.isOutput[ radio_id_t id ](){return FALSE;}
  
}

