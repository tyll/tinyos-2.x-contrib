


module DS2770C
{
  provides interface DS2770;
}
implementation
{


  async command result_t DS2770.init ()
  {
    //initialize pins
    TOSH_SEL_ADC2_IOFUNC ();
    TOSH_MAKE_ADC2_INPUT ();
    TOSH_SEL_GIO1_IOFUNC ();

    //TODO: add status configuration here
    writeAddr (0x31, 0x83);
    refresh ();
    return SUCCESS;
  }

  async command result_t DS2770.getData (int16_t * voltage,
					 int32_t * current,
					 int16_t * acr, int16_t * temp)
  {
    uint32_t data;
    uint8_t lsb, msb;

    atomic
    {

      msb = readAddr (0x0c);
      lsb = readAddr (0x0d);
      data = ((uint32_t) (msb << 8)) + lsb;
      *voltage = ((data >> 5) * 1500) / 307;

      msb = readAddr (0x0e);
      lsb = readAddr (0x0f);
      data = ((uint32_t) (msb << 8)) + lsb;
      *current = data * 625;

      msb = readAddr (0x10);
      lsb = readAddr (0x11);
      data = ((uint32_t) (msb << 8)) + lsb;
      *acr = data;

      msb = readAddr (0x18);
      lsb = readAddr (0x19);
      data = ((uint32_t) (msb << 8)) + lsb;
      *temp = ((data >> 5) * 125) / 100;

    }

    return SUCCESS;
  }



}
