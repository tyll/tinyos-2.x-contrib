/**
 * Internal implementation of AdcReadNowClientC
 * 
 * @author
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */

module AdcReadNowClientP
{
  provides 
  {
    interface ReadNow<uint16_t>;
  }
  uses 
  {
    interface Resource;
    interface HplAtm328Adc;
    interface AdcConfigure<const Atm328Adc_config_t*>;
  }
}
implementation
{
  //////////////////////////////////////////
  // ReadNow
  //////////////////////////////////////////
  async command error_t ReadNow.read()
  {
    const Atm328Adc_config_t* config;
    Atm328_ADMUX_t mux;

    // Make sure the client already owns the resource
    if (!call Resource.isOwner()) return FAIL;

    // Read ADC paramters from client
    config = call AdcConfigure.getConfiguration();

    // Configure ADC hardware
    mux.bits.mux  = config->channel;
    mux.bits.refs = config->ref_voltage;
    call HplAtm328Adc.setAdmux(mux);
    call HplAtm328Adc.setPrescaler(config->prescaler);
    call HplAtm328Adc.setSingle();
    call HplAtm328Adc.enableInterrupt();
    call HplAtm328Adc.enableAdc();

    // Start conversion
    call HplAtm328Adc.startConversion();

    return SUCCESS;
  }

  //////////////////////////////////////////
  // Resource
  //////////////////////////////////////////
  event void Resource.granted() { }

  //////////////////////////////////////////
  // HplAtm328Adc
  //////////////////////////////////////////
  async event void HplAtm328Adc.dataReady(uint16_t data)
  {
    // Disable ADC hardware and release the resource
    call HplAtm328Adc.disableInterrupt();
    //call HplAtm328Adc.disableAdc();

    // Inform the client
    atomic signal ReadNow.readDone(SUCCESS, data);
  }
}
