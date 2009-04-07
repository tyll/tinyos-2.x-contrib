/**
 * Configuration of the RV-8564-C2 chip.
 * 
 * @author Henrik Makitaavola
 */

configuration RV8564C
{
  provides interface RV8564 as RTC;
  uses interface GeneralIO;
  uses interface GpioInterrupt;
}
implementation
{
  components RV8564P as RTCP;
  components new SoftI2CMasterC() as I2C;
  RTC = RTCP;
  RTCP = GeneralIO;
  RTCP = GpioInterrupt;
  RTCP.I2C -> I2C;
  RTCP.I2CResource -> I2C;
}
