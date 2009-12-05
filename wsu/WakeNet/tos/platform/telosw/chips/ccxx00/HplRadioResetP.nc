
/**
 * See the comments in HplRadioResetC
 * @author Jared Hill
 * @author David Moss
 */
 
#include "Blaze.h"

module HplRadioResetP {

  provides {
    interface RadioReset[ radio_id_t radioId ];
  }
  
  uses {
    interface HplMsp430GeneralIO as MISO;
    interface GeneralIO as Csn[ radio_id_t radioId ];
  }
}

implementation{

  async command void RadioReset.blockUntilPowered[ radio_id_t radioId ]() {
    
    atomic{
      ME1 &= ~USPIE0;
      call MISO.selectIOFunc();
      call MISO.makeInput();
      call Csn.set[radioId]();
      call Csn.clr[radioId]();
      while(call MISO.get());
      call Csn.set[radioId]();
      call MISO.selectModuleFunc();
      ME1 |= USPIE0;
    }
    
    return;
  }
  
  /***************** Defaults ****************/
  default async command void Csn.set[ radio_id_t id ](){}
  default async command void Csn.clr[ radio_id_t id ](){}
  default async command void Csn.toggle[ radio_id_t id ](){}
  default async command void Csn.makeInput[ radio_id_t id ](){}
  default async command void Csn.makeOutput[ radio_id_t id ](){}
}

