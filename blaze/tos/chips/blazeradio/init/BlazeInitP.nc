

/**
 * This module assumes it already owns the SPI bus
 * 
 * Due to hardware design and battery considerations, we can only have one radio
 * on at a time.  BlazeInit will protect this rule by storing the enabled
 * radio's ID.
 *
 * Also, some platforms might support the Power pin, which controls a FET
 * switch that turns off the radio.  For platforms that don't have a Power pin,
 * the radio should go into a deep sleep mode.  On platforms that do have a 
 * power pin, the radio will turn off completely after entering deep sleep.
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
  }
  
  uses {
    interface GeneralIO as Power[ radio_id_t id ];
    interface GeneralIO as Csn[ radio_id_t id ];
    interface GeneralIO as Gdo0_io[ radio_id_t id ];
    interface GeneralIO as Gdo2_io[ radio_id_t id ];
    
    interface BlazeRegSettings[ radio_id_t id ];
    interface RadioInit;
    interface BlazeStrobe as Idle;
    interface BlazeStrobe as SRES;
    interface BlazeStrobe as SXOFF;
    interface CheckRadio;
    interface Leds;
  }
}

implementation {

  enum {
    NO_RADIO = 0xFF,
  };

  uint8_t m_id = NO_RADIO;
  
  /***************** Prototypes ****************/
  void sleep(uint8_t id);
  void shutdown(uint8_t id);
  task void init();  

  /************** SoftwareInit Commands *****************/
  command error_t Init.init() {
    uint8_t i;
    for(i = 0; i < uniqueCount(UQ_BLAZE_RADIO); i++) {
      call BlazePower.shutdown[i]();
    }
    return SUCCESS;
  }
    
  /************** SplitControl Commands**************/
  /**
   * Upper layers implement TEP 117 compliance. This layer simply prevents
   * two radios from being on simulatenously
   */
  command error_t SplitControl.start[ radio_id_t id ](){
   
    if(m_id != NO_RADIO) {
      return EBUSY;
      
    } else if (m_id == id) {
      return EALREADY;
    }
    
    m_id = id;
    
    call Power.set[ m_id ]();
    call Csn.clr[ m_id ]();
    call CheckRadio.waitForWakeup();
    
    post init();
    
    return SUCCESS;
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
  
  /***************** BlazePower Commands ****************/

  /**
   * Restart the chip.  All registers come up in their default settings.
   */
  async command void BlazePower.reset[ radio_id_t id ]() {
    call Csn.set[id]();
    call Csn.clr[id]();
    call Idle.strobe();
    call SRES.strobe();
    call Csn.set[id]();
  }
  
  /**
   * Stop the oscillator.
   */
  async command void BlazePower.deepSleep[ radio_id_t id ]() {
    call Csn.set[id]();
    call Csn.clr[id]();
    call Idle.strobe();
    call SXOFF.strobe();
    call Csn.set[id]();
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
    call Csn.set[ m_id ]();
    call Csn.clr[ m_id ]();
        
    call Gdo0_io.makeInput[ m_id ]();
    call Gdo2_io.makeInput[ m_id ]();
    
    call Csn.set[ m_id ]();
    signal SplitControl.startDone[ m_id ](SUCCESS);
  }
  
  /***************** Functions ****************/
  
  /**
   * Proper shutdown procedure. GDO's become output and cleared so lines don't
   * float when the chip is physically off.
   */
  void shutdown(uint8_t id) {

  }
  
  /***************** Tasks ****************/
  task void init() {
    call Csn.set[m_id]();
    call Csn.clr[m_id]();
    call Idle.strobe();
    
    if(call RadioInit.init(BLAZE_IOCFG2, 
        call BlazeRegSettings.getDefaultRegisters[ m_id ](), 
            BLAZE_TOTAL_INIT_REGISTERS) != SUCCESS) {
      post init();
    }
  }
  
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
  
  default event void SplitControl.startDone[ radio_id_t id ](error_t error){}
  default event void SplitControl.stopDone[ radio_id_t id ](error_t error){}
  
  default command blaze_init_t *BlazeRegSettings.getDefaultRegisters[ radio_id_t id ]() { return NULL; }
  
}
