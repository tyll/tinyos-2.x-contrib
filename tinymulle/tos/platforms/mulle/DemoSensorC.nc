/**
 * A dumb demo sensor used for testing.
 *
 * @author Henrik Makitaavola
 */
generic module DemoSensorC()
{
  provides interface Read<uint16_t>;
}
implementation
{
  command error_t Read.read()
  {
    signal Read.readDone(SUCCESS, 0x0001);
    return SUCCESS;
  }
  default event void Read.readDone( error_t result, uint16_t val ) {}
}
