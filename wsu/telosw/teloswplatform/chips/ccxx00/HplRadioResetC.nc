

/**
 * Found in the CC2500 Datasheet page 36: 
 * 
 * Automatic power-on reset functionality requires us to sample the
 * SO line to see when it goes low.  This line in TinyOS is being used
 * by the SPI bus, so we have to tell the microcontroller to turn it into
 * a GPIO so we can sample it.  When we're done sampling it, turn it back
 * into a SPI bus.
 *
 * Because of the microcontroller specific nature of this operation, this
 * interface needs to be implemented on a per-platform basis. This particular
 * implementation assumes dual radios are on the same SPI bus.
 * 
 * @author Jared Hill
 * @author David Moss
 */
 
#include "Blaze.h"

configuration HplRadioResetC {
  provides {
    interface RadioReset[ radio_id_t radioId ];
  }
}

implementation {
  

  components BlazeCentralWiringC;
  components HplRadioResetP;
  components HplMsp430GeneralIOC;

  RadioReset = HplRadioResetP;
  
  HplRadioResetP.MISO -> HplMsp430GeneralIOC.SOMI0;
  HplRadioResetP.Csn -> BlazeCentralWiringC.Csn;

}
