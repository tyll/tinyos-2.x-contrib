
/**
 * SPI bus to GPIO input flipping
 * @author Jared Hill
 * @author David Moss
 */
 
module CheckRadioP {

  provides {
    interface CheckRadio;
  }
  
  uses {
    interface HplMsp430GeneralIO as MISO;
  }

}

implementation{

  /****************CheckRadio Commands *********************/
  
  /**
   * Turn the MISO pin normally used on the SPI bus into an input,
   * wait for the line to go low, then turn the line back into the
   * SPI bus.
   */
  async command void CheckRadio.waitForWakeup(){

    atomic{
      ME1 &= ~USPIE0;
      call MISO.selectIOFunc();
      call MISO.makeInput();
      while(call MISO.get());
      call MISO.selectModuleFunc();
      ME1 |= USPIE0;
    }
    
    return;
    
  }

}


