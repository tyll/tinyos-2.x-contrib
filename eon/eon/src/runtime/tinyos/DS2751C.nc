


module DS2751C
{
  provides interface DS2751;
}
implementation
{

//#include "DS2751.h"  


unsigned char
ds2751_init (void)
{
  unsigned char presence;
  //TOSH_SEL_ADC2_IOFUNC ();
  TOSH_MAKE_ADC5_OUTPUT ();
  //TOSH_SEL_GIO1_IOFUNC ();
  //TOSH_MAKE_GIO1_OUTPUT ();
  TOSH_CLR_ADC5_PIN ();
  TOSH_uwait (300);		// Keep low for about 600 us
  //TOSH_SET_GIO1_PIN();
  //TOSH_uwait(100);
  //TOSH_CLR_GIO1_PIN();
  TOSH_MAKE_ADC5_INPUT ();	// Set pin as input
  TOSH_uwait (40);		// Wait for presence pulse
  presence = TOSH_READ_ADC5_PIN ();	// Read the bit on pin for presence
  TOSH_uwait (250);		// Wait for end of timeslot

  return !presence;		// 1 = presence, 0 = no presence
}

int
ds2751_readBit ()
     // It reads one bit from the one-wire interface */
{
  int result;
  TOSH_MAKE_ADC5_OUTPUT ();	// Set pin as output
  TOSH_CLR_ADC5_PIN ();		// Set the line low
  TOSH_uwait (1);		// Hold the line low for at least one us
  TOSH_MAKE_ADC5_INPUT ();	// Set pin as input
  TOSH_uwait (7);		// Wait 14 us before reading bit value
  result = TOSH_READ_ADC5_PIN ();	// Store bit value
  TOSH_uwait (50);
  return result;
}

void
ds2751_writeBit (int bit)
     // It writes out a bit
{
	atomic
	{
  		if (bit)
    	{
    	  TOSH_MAKE_ADC5_OUTPUT ();	// Set pin as output
    	  TOSH_CLR_ADC5_PIN ();	// Set the line low
    	  TOSH_uwait (4);		// Hold line low for 2 us
    	  TOSH_MAKE_ADC5_INPUT ();	// Set pin as input
    	  TOSH_uwait (50);		// Write slot is at least 60 us
    	}
  		else
    	{
    	  TOSH_MAKE_ADC5_OUTPUT ();	// Set pin as output
    	  TOSH_CLR_ADC5_PIN ();	// Set the line low
    	  TOSH_uwait (50);		// Hold line low for at least 60 us
    	  TOSH_MAKE_ADC5_INPUT ();	// Release the line
    	  TOSH_uwait (8);
    	}
	} //atomic

}


void
ds2751_writeByte (int hexNum)
     // It sends one byte via the one-wire that corresponds to the
     // binary representation of hexNum.  The variable next is used
     // when the number is broken down into its binary code and it
     // holds the current value of the variable.  curBit holds the
     // value of the bit to be written to the line.
{
  int i;

  for (i = 0; i < 8; i++)	// Convert to binary code
    {
      ds2751_writeBit (hexNum & 0x01);

      // shift the data byte for the next bit 
      hexNum >>= 1;

    }
}

int
ds2751_readByte ()
     // It reads a byte from the one-wire and stores it in the array byteArray,
     // which will contain the information of the one byte read
{
  int loop, result = 0;

  for (loop = 0; loop < 8; loop++)
    {
      // shift the result to get it ready for the next bit 
      result >>= 1;

      // if result is one, then set MS bit 
      if (ds2751_readBit ())
	result |= 0x80;
    }
  return result;
}




void
ds2751_skipROM ()
     // Skip ROM command, when only one DS2438 is being used on the line
{
  ds2751_writeByte (0xcc);		// Request skip ROM to be executed
}

uint8_t
ds2751_readAddr (uint8_t addr, int8_t *error)
{
  uint8_t data;
  uint8_t p;

  p = ds2751_init ();
  if (p)
    {
      ds2751_skipROM ();
      ds2751_writeByte (0x69);
      ds2751_writeByte (addr);
      data = ds2751_readByte ();
    }
  else
    {
      data = 0xeb;
    }
  if (error != NULL)
    {
      *error = !p;
    }
  return data;
}


uint8_t
ds2751_readAddrRange (uint8_t addr, int bytes, uint8_t* buffer)
{
  
  uint8_t p;
  int i;

  p = ds2751_init ();
  if (p)
    {
      ds2751_skipROM ();
      ds2751_writeByte (0x69);
      ds2751_writeByte (addr);
	  for (i=0; i < bytes; i++)
	  	{
      		*(buffer+i) = ds2751_readByte();
		}
    }
 return p;
}



uint8_t
ds2751_writeAddr (uint8_t addr, uint8_t val)
{
  uint8_t error = 0;
  
  error = !ds2751_init ();

  ds2751_skipROM ();
  ds2751_writeByte (0x6C);
  ds2751_writeByte (addr);
  ds2751_writeByte (val);

  return error;
}

uint8_t
ds2751_refresh ()
{
  uint8_t error;
  
  error = !(ds2751_init ());
  ds2751_skipROM ();
  ds2751_writeByte (0x63);

  return error;
}

uint8_t
ds2751_copyAddr(uint8_t addr)
{
  uint8_t error;

  error = !ds2751_init();
  ds2751_skipROM();
  ds2751_writeByte(0x48);
  ds2751_writeByte(addr);
  //TOSH_uwait(3000);
  return error;
}


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

    

    //tomic
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
