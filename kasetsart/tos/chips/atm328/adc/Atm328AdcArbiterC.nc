#include "Atm328Adc.h"

/**
 * Controls users of ATmega328's ADC subsystem via a round-robin resource
 * arbiter.
 * 
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

configuration Atm328AdcArbiterC
{
  provides 
  {
	interface Resource[uint8_t clientId];
    interface ResourceRequested[uint8_t clientId];
    interface ResourceDefaultOwner;
    interface ArbiterInfo;
  }
  uses
  {
	interface ResourceConfigure[uint8_t clientId];
  }
}
implementation
{
  components new RoundRobinArbiterC(UQ_ATM328ADC_RESOURCE) as Arbiter;

  Resource             = Arbiter;
  ResourceRequested    = Arbiter;
  ResourceConfigure    = Arbiter;
  ResourceDefaultOwner = Arbiter;
  ArbiterInfo          = Arbiter;
}
