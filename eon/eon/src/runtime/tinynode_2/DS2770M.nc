


module DS2770M
{
  provides interface DS2770;
  uses
  {
  	interface Timer<TMilli> as Timer0;
  	interface BusyWait<TMicro, uint16_t> as BusyWait0;
	interface GeneralIO as OneWireBus;
  }
}
implementation
{

#define TIMER_RESET_INTERVAL	60L
#define TIMER_RESET_COUNT		30L

  bool refreshed = FALSE;
  int timer_count;


uint8_t ds2770_init ()
{
  uint8_t presence;
  
  
  	call OneWireBus.makeOutput();
  	call OneWireBus.clr();
  	call BusyWait0.wait (300);		// Keep low for about 600 us
  	call OneWireBus.makeInput ();	// Set pin as input
  	call BusyWait0.wait (40);		// Wait for presence pulse
  	presence = call OneWireBus.get ();	// Read the bit on pin for presence
  	call BusyWait0.wait (250);		// Wait for end of timeslot
  
  return !presence;		// 1 = presence, 0 = no presence
}

int
ds2770_readBit ()
     // It reads one bit from the one-wire interface */
{
  int result;
  
  atomic 
  {
  	call OneWireBus.makeOutput();	// Set pin as output
  	call OneWireBus.clr();		// Set the line low
  	call BusyWait0.wait (1);		// Hold the line low for at least one us
  	call OneWireBus.makeInput ();	// Set pin as input
  	call BusyWait0.wait (7);		// Wait 14 us before reading bit value
  	result = call OneWireBus.get ();	// Store bit value
  	call BusyWait0.wait (50);
  }
  return result;
}

void
ds2770_writeBit (int bit)
     // It writes out a bit
{
  if (bit)
    {
		atomic 
		{
      		call OneWireBus.makeOutput();	// Set pin as output
      		call OneWireBus.clr();	// Set the line low
      		call BusyWait0.wait (4);		// Hold line low for 2 us
      		call OneWireBus.makeInput ();	// Set pin as input
      		call BusyWait0.wait (50);		// Write slot is at least 60 us
		}
    }
  else
    {
		atomic
		{
      		call OneWireBus.makeOutput();	// Set pin as output
      		call OneWireBus.clr();	// Set the line low
      		call BusyWait0.wait (50);		// Hold line low for at least 60 us
      		call OneWireBus.makeInput ();	// Release the line
      		call BusyWait0.wait (8);
		}
    }

}


void
ds2770_writeByte (int hexNum)
     // It sends one byte via the one-wire that corresponds to the binary representation
     // of hexNum.  The variable next is used when the number is broken down into its
     // binary code and it holds the current value of the variable.  curBit holds the
     // value of the bit to be written to the line.
{
  int i;

  for (i = 0; i < 8; i++)	// Convert to binary code
    {
      ds2770_writeBit (hexNum & 0x01);

      // shift the data byte for the next bit 
      hexNum >>= 1;

    }
}

int
ds2770_readByte ()
     // It reads a byte from the one-wire and stores it in the array byteArray,
     // which will contain the information of the one byte read
{
  int loop, result = 0;

  for (loop = 0; loop < 8; loop++)
    {
      // shift the result to get it ready for the next bit 
      result >>= 1;

      // if result is one, then set MS bit 
      if (ds2770_readBit ())
			result |= 0x80;
    }
  return result;
}




void
ds2770_skipROM ()
     // Skip ROM command, when only one DS2438 is being used on the line
{
  ds2770_writeByte (0xcc);		// Request skip ROM to be executed
}



uint8_t
ds2770_readAddr (uint8_t addr)
{
  uint8_t data;
  uint8_t p;

  p = ds2770_init ();
  if (p)
    {
      ds2770_skipROM ();
      ds2770_writeByte (0x69);
      ds2770_writeByte (addr);
      data = ds2770_readByte ();
    }
  else
    {
      data = 0xeb;
    }
  return data;
}

uint8_t
ds2770_readAddrRange (uint8_t addr, int bytes, uint8_t* buffer)
{
  
  uint8_t p;
  int i;

  p = ds2770_init ();
  if (p)
    {
      ds2770_skipROM ();
      ds2770_writeByte (0x69);
      ds2770_writeByte (addr);
	  for (i=0; i < bytes; i++)
	  	{
      		*(buffer+i) = ds2770_readByte();
		}
    }
  return p;
}




void
ds2770_writeAddr (uint8_t addr, uint8_t val)
{
  ds2770_init ();
  ds2770_skipROM ();
  ds2770_writeByte (0x6C);
  ds2770_writeByte (addr);
  ds2770_writeByte (val);
}

void
ds2770_refresh ()
{
  ds2770_init ();
  ds2770_skipROM ();
  ds2770_writeByte (0x63);
}

void
ds2770_copyAddr(uint8_t addr)
{
  ds2770_init();
  ds2770_skipROM();
  ds2770_writeByte(0x48);
  ds2770_writeByte(addr);
  
}




  task void timerStart()
  {
  	call Timer0.startPeriodic(TIMER_RESET_INTERVAL * 1024L);
  }
  
  command error_t DS2770.init ()
  {
    //initialize pins
   
    //set status register
    ds2770_writeAddr(0x31, 0x82);
    ds2770_writeAddr(0x34, 0xFF);
    ds2770_copyAddr(0x30);
    refreshed = FALSE;
    
    timer_count = 0;
    return post timerStart();
  }
  
  event void Timer0.fired()
  {
  	timer_count++;
	if (timer_count >= TIMER_RESET_COUNT)
	{
		timer_count = 0;
		//write 0xFF to Charge Time Register
		ds2770_writeAddr(0x06,0xFF);
		//clear charge completion status -- if applicable
		ds2770_writeAddr(0x01,0x82);
	}
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
