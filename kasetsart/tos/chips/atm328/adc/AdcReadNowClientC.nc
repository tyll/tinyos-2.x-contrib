#include "Atm328Adc.h"

/**
 * Provide access via the ReadNow interface to the ATmega328 ADC.  Users of
 * this component must first acquire the resource via the provided Resource
 * interface and link it to an implementation of AdcConfigure which provides
 * the ADC parameters.
 *
 * @todo
 * Implement a default owner of the ADC resource so that it can check whether
 * there is still any client using the resource.  The ADC circuitry should be
 * kept active as long as there is at least one client to allow voltage input
 * to stabilize in certain cases (i.e., bandgap reference voltage).
 * 
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

generic configuration AdcReadNowClientC() 
{
  provides
  {
	interface Resource;
	interface ReadNow<uint16_t>;
	interface ResourceRequested;
	interface ArbiterInfo;
  }
  uses
  {
	interface ResourceConfigure;
	interface AdcConfigure<const Atm328Adc_config_t*>;
  }
}
implementation 
{
  enum
  {
	CLIENT_ID = unique(UQ_ATM328ADC_RESOURCE)
  };
  components HplAtm328AdcC;
  components AdcReadNowClientP;
  components Atm328AdcArbiterC as Arbiter;

  Resource          = Arbiter.Resource[CLIENT_ID];
  ResourceConfigure = Arbiter.ResourceConfigure[CLIENT_ID];
  ResourceRequested = Arbiter.ResourceRequested[CLIENT_ID];
  ArbiterInfo       = Arbiter.ArbiterInfo;

  ReadNow      = AdcReadNowClientP;
  AdcConfigure = AdcReadNowClientP;

  AdcReadNowClientP.HplAtm328Adc -> HplAtm328AdcC;
  AdcReadNowClientP.Resource -> Arbiter.Resource[CLIENT_ID];
}

