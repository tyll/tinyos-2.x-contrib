


module DS2751C
{
  provides interface DS2751;
}
implementation
{

  


  async command result_t DS2751.init ()
  {
    ds2751_writeAddr(0x33, 0xfe); //offset by 4 bits
	ds2751_copyAddr(0x33);
    return SUCCESS;
  }
  

  async command result_t DS2751.getData (int16_t * voltage,
					 int32_t * current,
					 int16_t * acr, int16_t * temp)
  {
    int32_t data;
    //uint8_t lsb, msb;
    uint8_t buf[6];

    

    atomic
    {
		//added to speed things up.
      ds2751_readAddrRange(0x0c, 6, buf);
      
	  //msb = ds2751_readAddr (0x0c);
      //lsb = ds2751_readAddr (0x0d);
	  data = ((uint32_t) (buf[0] << 8)) + buf[1];
      *voltage = ((data >> 5) * 1500) / 307;
      //*voltage = stat;

      //msb = ds2751_readAddr (0x0e);
      //lsb = ds2751_readAddr (0x0f);
      data = ((uint32_t) (buf[2] << 8)) + buf[3];
      *current = (data >> 3) * 625; //to uA
      //*current = tim;

      //msb = ds2751_readAddr (0x10);
      //lsb = ds2751_readAddr (0x11);
      data = ((uint32_t) (buf[4] << 8)) + buf[5];
      *acr = data;

	  ds2751_readAddrRange(0x18, 2, buf);
      //msb = ds2751_readAddr (0x18);
      //lsb = ds2751_readAddr (0x19);
      data = ((uint32_t) (buf[0] << 8)) + buf[1];
      *temp = ((data >> 5) * 125) / 100;

      
      /*msb = ds2751_readAddr (0x0c, NULL);
      lsb = ds2751_readAddr (0x0d, NULL);
      data = ((uint32_t) (msb << 8)) + lsb;
      *voltage = ((data >> 5) * 1500) / 307;
      

      msb = ds2751_readAddr (0x0e, NULL);
      lsb = ds2751_readAddr (0x0f, NULL);
      data = ((uint32_t) (msb << 8)) + lsb;
      *current = data >> 3;
      

      msb = ds2751_readAddr (0x10, NULL);
      lsb = ds2751_readAddr (0x11, NULL);
      data = ((uint32_t) (msb << 8)) + lsb;
      *acr = data;

      msb = ds2751_readAddr (0x18, NULL);
      lsb = ds2751_readAddr (0x19, NULL);
      data = ((uint32_t) (msb << 8)) + lsb;
      *temp = ((data >> 5) * 125) / 100;
*/
    }

    return SUCCESS;
  }



}
