

#include "Blaze.h"

/**
 * @author Jared Hill
 * @author David Moss
 */
configuration BlazeSpiWireC {

  provides interface Resource;
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
  Resource = HplRadioSpiC;
  BlazeSpiP.SpiByte -> HplRadioSpiC;
  BlazeSpiP.SpiPacket -> HplRadioSpiC;
  
  components new StateC();
  BlazeSpiP.State -> StateC;
  
  components LedsC;
  BlazeSpiP.Leds -> LedsC;
  
  
  

}
