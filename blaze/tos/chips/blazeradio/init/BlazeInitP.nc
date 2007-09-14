

/**
 * Due to hardware design and battery considerations, we can only have one radio
 * on at a time.  BlazeInit will protect this rule by storing and checking
 * the enabled radio's ID.
 *
 * Also, some platforms might support the Power pin, which controls a FET
 * switch that turns off the radio.  For platforms that don't have a Power pin,
 * the radio should go into a deep sleep mode.  On platforms that do have a 
 * power pin, the radio will enter deep sleep then turn off completely.
 * 
 * @author Jared Hill 
 * @author David Moss
 */
 
#include "Blaze.h"
#include "BlazeInit.h"

module BlazeInitP {

  provides {
    interface Init;
    interface SplitControl[ radio_id_t id ];
    interface BlazePower[ radio_id_t id ];
    interface BlazeCommit;
  }
  
  uses {
    interface Resource as ResetResource;
    interface Resource as DeepSleepResource;
   
    interface GeneralIO as Power[ radio_id_t id ];
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GeneralIO as Gdo0_io[ radio_id_t id ];
    interface GeneralIO as Gdo2_io[ radio_id_t id ];
    
    interface BlazeRegSettings[ radio_id_t id ];
    interface RadioStatus;
    
    interface RadioInit as RadioInit;
    interface BlazeStrobe as Idle;
    interface BlazeStrobe as SRES;
    interface BlazeStrobe as SXOFF;
    interface BlazeStrobe as SFRX;
    interface BlazeStrobe as SFTX;
    interface BlazeStrobe as SRX;
    
    interface CheckRadio;
    interface Leds;
  }
}

implementation {

  enum {
    NO_RADIO = 0xFF,
  };

  uint8_t m_id;
  
  uint8_t blazePowerClient;
  
  uint8_t state;
  
  enum {
    S_IDLE,
    S_STARTING,
    S_COMMITTING,
  };
  
  /***************** Prototypes ****************/

  /************** SoftwareInit Commands *****************/
  command error_t Init.init() {
    uint8_t i;
    for(i = 0; i < uniqueCount(UQ_BLAZE_RADIO); i++) {
      call BlazePower.shutdown[i]();
    }
    m_id = NO_RADIO;
    state = S_IDLE;
    return SUCCESS;
  }
    
  /************** SplitControl Commands**************/
  /**
   * This layer prevents two radios from being on simulatenously
   * When doing a SplitControl.start(), the radio is reset before bursting
   * in register values.  Tests show that not restarting the radio
   * somehow, even with different applications loaded on, will prevent
   * SplitControl.start from completing properly.  
   * 
   * It may have something to do with the corrupted register writes on burst.
   */
  command error_t SplitControl.start[ radio_id_t id ]() {
    if(m_id != NO_RADIO) {
      return EBUSY;
      
    } else if (m_id == id) {
      return EALREADY;
    }
    
    atomic m_id = id;

    call Power.set[ m_id ]();
    call Csn.clr[ m_id ]();
    call CheckRadio.waitForWakeup();
    
    state = S_STARTING;
    
    // Since we're in control of BlazeSpiP, we know this next command will only
    // return SUCCESS. Therefore, there is no need to create code to undo above.
    return call BlazePower.reset[id]();
  }
  
  command error_t SplitControl.stop[ radio_id_t id ](){
    if(id != m_id) {
      return FAIL;
    }
    
    call BlazePower.deepSleep[id]();
    call BlazePower.shutdown[id]();
    m_id = NO_RADIO;
    signal SplitControl.stopDone[ id ](SUCCESS);
    
    return SUCCESS;
  }
  
  /***************** BlazeCommit Commands ****************/
  /** 
   * Commit register changes in RAM to hardware.
   * Note that this is not parameterized by radio to save footprint.  
   * The only radio we can commit changes to is the one that's currently 
   * turned on, indicated by m_id.
   *
   * It is up to higher layers to make sure we aren't trying to commit
   * registers to a different radio than the one currently turned on
   */
  command void BlazeCommit.commit() {
    state = S_COMMITTING;
    call BlazePower.reset[m_id]();
  }
  
  
  /***************** BlazePower Commands ****************/

  /**
   * Restart the chip.  All registers come up in their default settings.
   * We don't confirm the radio ID, so be careful.  This is because
   * we may want to call BlazePower.reset() on some radio, and then call
   * SplitControl.start() afterwards.
   */
  async command error_t BlazePower.reset[ radio_id_t id ]() {
    atomic blazePowerClient = id;
    return call ResetResource.request();
  }
  
  /**
   * Stop the oscillator.
   * We don't confirm the radio ID, so be careful
   */
  async command error_t BlazePower.deepSleep[ radio_id_t id ]() {
    atomic blazePowerClient = id;
    return call DeepSleepResource.request();
  }

  /**
   * Completely power down radios on platforms that have a power pin
   */
  async command void BlazePower.shutdown[ radio_id_t id ]() {
    call Gdo0_io.makeOutput[ id ]();
    call Gdo2_io.makeOutput[ id ]();
    
    call Gdo0_io.clr[ id ]();
    call Gdo2_io.clr[ id ]();
    
    call Power.clr[ id ]();
  }

  
  /***************** RadioInit Events ****************/
  event void RadioInit.initDone() { 
  
    call Gdo0_io.makeInput[ m_id ]();
    call Gdo2_io.makeInput[ m_id ]();
    
    call Csn.set[ m_id ]();
    call Csn.clr[ m_id ]();
    
    // Startup the radio in Rx mode by default
    call SFRX.strobe();
    call SFTX.strobe();
    call Idle.strobe();
    while (call RadioStatus.getRadioStatus() != BLAZE_S_IDLE);
    
    call SRX.strobe();
    while (call RadioStatus.getRadioStatus() != BLAZE_S_RX);
    
    call Csn.set[ m_id ]();
    
    call ResetResource.release();
    
    if(state == S_STARTING) {
      signal SplitControl.startDone[ m_id ](SUCCESS);
    
    } else {
      signal BlazeCommit.commitDone();
    }
  }
  
  /***************** Resource Events ****************/
  event void ResetResource.granted() {
    uint8_t id;
    atomic id = blazePowerClient;
    call Csn.set[id]();
    call Csn.clr[id]();
    call Idle.strobe();
    call SRES.strobe();
    call Csn.set[id]();

    if(state == S_STARTING || state == S_COMMITTING) {
      call Csn.set[id]();
      call Csn.clr[id]();
      call Idle.strobe();
    
      // TODO Is it safe to assume this will always succeed?
      call RadioInit.init(BLAZE_IOCFG2, 
          call BlazeRegSettings.getDefaultRegisters[ id ](), 
              BLAZE_TOTAL_INIT_REGISTERS);
              
      // Hang onto the ResetResource until RadioInit has completed
              
    } else {
      call ResetResource.release();
      signal BlazePower.resetComplete[id]();
    }
  }
  
  event void DeepSleepResource.granted() {
    uint8_t id;
    atomic id = blazePowerClient;
    call Csn.set[id]();
    call Csn.clr[id]();
    call Idle.strobe();
    call SXOFF.strobe();
    call Csn.set[id]();
    call DeepSleepResource.release();
    signal BlazePower.deepSleepComplete[id]();
  }
  
  
  /***************** Functions ****************/
    
  /***************** Tasks ****************/

  
  /***************** Defaults ******************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command bool Csn.get[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command bool Csn.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
  default async command bool Csn.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command void Power.set[ radio_id_t id ](){}
  default async command void Power.clr[ radio_id_t id ](){}
  default async command void Power.toggle[ radio_id_t id ](){}
  default async command bool Power.get[ radio_id_t id ](){return FALSE;}
  default async command void Power.makeInput[ radio_id_t id ](){}
  default async command bool Power.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Power.makeOutput[ radio_id_t id ](){}
  default async command bool Power.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command void Gdo0_io.set[ radio_id_t id ](){}
  default async command void Gdo0_io.clr[ radio_id_t id ](){}
  default async command void Gdo0_io.toggle[ radio_id_t id ](){}
  default async command bool Gdo0_io.get[ radio_id_t id ](){return FALSE;}
  default async command void Gdo0_io.makeInput[ radio_id_t id ](){}
  default async command bool Gdo0_io.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Gdo0_io.makeOutput[ radio_id_t id ](){}
  default async command bool Gdo0_io.isOutput[ radio_id_t id ](){return FALSE;}
  
  default async command void Gdo2_io.set[ radio_id_t id ](){}
  default async command void Gdo2_io.clr[ radio_id_t id ](){}
  default async command void Gdo2_io.toggle[ radio_id_t id ](){}
  default async command bool Gdo2_io.get[ radio_id_t id ](){return FALSE;}
  default async command void Gdo2_io.makeInput[ radio_id_t id ](){}
  default async command bool Gdo2_io.isInput[ radio_id_t id ](){return FALSE;}
  default async command void Gdo2_io.makeOutput[ radio_id_t id ](){}
  default async command bool Gdo2_io.isOutput[ radio_id_t id ](){return FALSE;}
  
  default event void BlazePower.resetComplete[ radio_id_t id ]() {}
  default event void BlazePower.deepSleepComplete[ radio_id_t id ]() {}
  
  default event void SplitControl.startDone[ radio_id_t id ](error_t error){}
  default event void SplitControl.stopDone[ radio_id_t id ](error_t error){}
  
  default command blaze_init_t *BlazeRegSettings.getDefaultRegisters[ radio_id_t id ]() { return NULL; }
  
  default event void BlazeCommit.commitDone() {}
}
