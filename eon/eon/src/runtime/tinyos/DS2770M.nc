
#include "DS2770.h"

module DS2770M
{
  provides interface DS2770;
  uses
  {
  	interface Timer;
  }
}
implementation
{


#define TIMER_RESET_INTERVAL	60L
#define TIMER_RESET_COUNT		30L

  norace bool refreshed = FALSE;
  int timer_count;

  task void timerStart()
  {
  	call Timer.start(TIMER_REPEAT, TIMER_RESET_INTERVAL * 1024L);
  }
  
  async command result_t DS2770.init ()
  {
    //initialize pins
    //TOSH_SEL_ADC2_IOFUNC ();
    //TOSH_MAKE_ADC4_T ();
    //TOSH_SEL_GIO1_IOFUNC ();

    //set status register
    ds2770_writeAddr (0x31, 0x82);
    ds2770_writeAddr (0x34, 0xFF);
    ds2770_copyAddr(0x30);
    atomic refreshed = FALSE;
    //TOSH_uwait(5000);
    //writeAddr (0x01, 0x82);
    //    refresh();
	atomic timer_count = 0;
    return post timerStart();
  }
  
  event result_t Timer.fired()
  {
  	atomic 
	{
		timer_count++;
		if (timer_count >= TIMER_RESET_COUNT)
		{
			atomic timer_count = 0;
			//write 0xFF to Charge Time Register
			ds2770_writeAddr(0x06,0xFF);
			//clear charge completion status -- if applicable
			ds2770_writeAddr(0x01,0x82);
		}
  	}
	return SUCCESS;
  }

  async command result_t DS2770.getData (int16_t * voltage,
					 int32_t * current,
					 int16_t * acr, int16_t * temp)
  {
    uint32_t data;
	int32_t sdata;
    //uint8_t lsb, msb;
	uint8_t buf[6];
	
    //uint8_t stat, tim;

	//tomic 
	{
    	if (!refreshed)
    	  {
		ds2770_refresh();
		refreshed = TRUE;
    	  }
	}

    //tomic
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
