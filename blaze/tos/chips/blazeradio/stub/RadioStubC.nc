#include "Blaze.h"
#include "IEEE802154.h"

/**
 * This component can be wired in inside of BlazeC to stub out one of the radios. 
 * Without this component wired in, the DemoApp compiled to 6032 bytes ROM, 256 bytes RAM.
 * With this component wired in, the DemoApp compiled to 6032 bytes ROM and 256 bytes RAM.
  */
configuration RadioStubC {

  provides interface SplitControl;
  provides interface GpioInterrupt as Interrupt;  
  provides interface AsyncReceive;
  provides interface AsyncSend;
}

implementation {
  
  components RadioStubP;
  SplitControl = RadioStubP;
  Interrupt = RadioStubP.Interrupt;
  AsyncReceive = RadioStubP;
  AsyncSend = RadioStubP;
}

