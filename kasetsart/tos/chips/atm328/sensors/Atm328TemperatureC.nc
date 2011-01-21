/**
 * Provides internal temperature probe for ATmega328 microcontroller.
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
generic configuration Atm328TemperatureC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  components new AdcReadClientC();
  components Atm328TemperatureP;

  Read = AdcReadClientC;

  AdcReadClientC.AdcConfigure -> Atm328TemperatureP;
}
