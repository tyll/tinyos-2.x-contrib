


module DS2770SIMM
{
  provides interface DS2770;
  uses
  {
  	interface Timer<TMilli> as Timer0;
  	
  }
}
implementation
{

#define TIMER_RESET_INTERVAL	60L
#define TIMER_RESET_COUNT		30L

  bool refreshed = FALSE;
  int timer_count;



  task void timerStart()
  {
  	call Timer0.startPeriodic(TIMER_RESET_INTERVAL * 1024L);
  }
  
  command error_t DS2770.init ()
  {
    return SUCCESS;
  }
  
  command error_t DS2770.getData (int16_t * voltage,
					 int32_t * current,
					 int16_t * acr, int16_t * temp)
  {
    uint32_t data;
	int32_t sdata;
    
	uint8_t buf[6];
    

	//atomic 
	{
    	if (!refreshed)
    	  {
		ds2770_refresh();
		refreshed = TRUE;
    	  }
	}

    
    {
		//added to speed things up.
      if (!ds2770_readAddrRange(0x0c, 6, buf))
	  {
	  	return FAIL;
	  }
      
	  //msb = ds2770_readAddr (0x0c);
      //lsb = ds2770_readAddr (0x0d);
	  data = ((uint32_t) (buf[0] << 8)) + buf[1];
      *voltage = ((data >> 5) * 1500) / 307;
      //*voltage = stat;

      //msb = ds2770_readAddr (0x0e);
      //lsb = ds2770_readAddr (0x0f);
      data = ((uint32_t) (buf[2] << 8)) + buf[3];
      //*current = (data * 625) / 10; //to uA
	  sdata = (int32_t)data;
	  *current = (sdata * 625) /10;
      //*current = tim;

      //msb = ds2770_readAddr (0x10);
      //lsb = ds2770_readAddr (0x11);
      //data = ((uint32_t) (buf[4] << 8)) + buf[5];
      *acr = (buf[4] << 8) | buf[5];

	  if (!ds2770_readAddrRange(0x18, 2, buf))
	  {
	  	return FAIL;
	  }
      //msb = ds2770_readAddr (0x18);
      //lsb = ds2770_readAddr (0x19);
      data = ((uint32_t) (buf[0] << 8)) + buf[1];
      *temp = ((data >> 5) * 125) / 100;

    }

    return SUCCESS;
  }



}
