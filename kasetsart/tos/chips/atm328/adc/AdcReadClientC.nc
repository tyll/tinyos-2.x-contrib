#include "Atm328Adc.h"

/**
 * Provide arbitrated access via the Read interface to the ATmega328 ADC.
 * Users of this component must link it to an implementation of AdcConfigure
 * which provides the ADC parameters.
 * 
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

generic configuration AdcReadClientC() 
{
  provides interface Read<uint16_t>;
  uses 
  {
	interface ResourceConfigure;
	interface AdcConfigure<const Atm328Adc_config_t*>;
  }
}
implementation 
{
  components new AdcReadNowClientC();
  components AdcReadClientP;

  AdcConfigure      = AdcReadNowClientC;
  ResourceConfigure = AdcReadNowClientC;

  Read = AdcReadClientP;

  AdcReadClientP.Resource -> AdcReadNowClientC;
  AdcReadClientP.ReadNow  -> AdcReadNowClientC;
}
