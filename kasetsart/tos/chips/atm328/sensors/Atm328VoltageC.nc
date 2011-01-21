/**
 * Provides internal voltage probe for ATmega328 microcontroller.  It is
 * implemented by measuring the 1.1V bandgap reference voltage with AVCC as
 * the reference.  The AVCC voltage can then be computed using the formula:
 * AVCC = 1024*1.1/ADC_VAL = 11264/(10*ADC_VAL)
 *
 * @notes
 * Currently the voltage readings from this component are not accurate as the
 * bandgap reference voltage requires certain time to stabilize.
 *
 * @author 
 * Chaiporn Jaikaeo (chaiporn.j@ku.ac.th)
 */
generic configuration Atm328VoltageC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  components new AdcReadClientC();
  components Atm328VoltageP;

  Read = AdcReadClientC;

  AdcReadClientC.AdcConfigure -> Atm328VoltageP;
}
