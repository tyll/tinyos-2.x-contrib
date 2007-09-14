

#include "Blaze.h"

/**
 * TODO
 * Originally, BlazeSpiC was generic because of Resource so we had to have this
 * Consider folding this back into the BlazeSpiC configuration.
 * 
 * @author Jared Hill
 * @author David Moss
 */
configuration BlazeSpiWireC {

  provides interface BlazeFifo as Fifo[ uint8_t id ];
  provides interface BlazeRegister as Reg[ uint8_t id ];
  provides interface BlazeStrobe as Strobe[ uint8_t id ];
  provides interface RadioInit;
  provides interface CheckRadio;
  provides interface RadioStatus;
  
}

implementation {

  components BlazeSpiP;

  Fifo = BlazeSpiP;
  Reg = BlazeSpiP;
  Strobe = BlazeSpiP;
  RadioInit = BlazeSpiP;
  RadioStatus = BlazeSpiP;
  
  components CheckRadioC;
  CheckRadio = CheckRadioC.CheckRadio;
  
  components HplRadioSpiC;
  BlazeSpiP.SpiResource -> HplRadioSpiC;
  BlazeSpiP.SpiByte -> HplRadioSpiC;
  BlazeSpiP.SpiPacket -> HplRadioSpiC;
  
  components new StateC(),
      new StateC() as SpiResourceStateC;
  BlazeSpiP.State -> StateC;
  BlazeSpiP.SpiResourceState -> SpiResourceStateC;
  
  components LedsC;
  BlazeSpiP.Leds -> LedsC;
  
}
