
//This code is a modified version of code from the Heliomote project



unsigned char
ds2770_init (void)
{
  unsigned char presence;
  TOSH_SEL_ADC2_IOFUNC ();
  TOSH_MAKE_ADC2_INPUT ();
  TOSH_SEL_GIO1_IOFUNC ();
  TOSH_MAKE_GIO1_OUTPUT ();
  TOSH_CLR_GIO1_PIN ();
  TOSH_uwait (300);		// Keep low for about 600 us
  //TOSH_SET_GIO1_PIN();
  //TOSH_uwait(100);
  //TOSH_CLR_GIO1_PIN();
  TOSH_MAKE_GIO1_INPUT ();	// Set pin as input
  TOSH_uwait (40);		// Wait for presence pulse
  presence = TOSH_READ_GIO1_PIN ();	// Read the bit on pin for presence
  TOSH_uwait (250);		// Wait for end of timeslot

  return !presence;		// 1 = presence, 0 = no presence
}

int
readBit ()
     // It reads one bit from the one-wire interface */
{
  int result;
  TOSH_MAKE_GIO1_OUTPUT ();	// Set pin as output
  TOSH_CLR_GIO1_PIN ();		// Set the line low
  TOSH_uwait (1);		// Hold the line low for at least one us
  TOSH_MAKE_GIO1_INPUT ();	// Set pin as input
  TOSH_uwait (7);		// Wait 14 us before reading bit value
  result = TOSH_READ_GIO1_PIN ();	// Store bit value
  TOSH_uwait (50);
  return result;
}

void
writeBit (int bit)
     // It writes out a bit
{
  if (bit)
    {
      TOSH_MAKE_GIO1_OUTPUT ();	// Set pin as output
      TOSH_CLR_GIO1_PIN ();	// Set the line low
      TOSH_uwait (4);		// Hold line low for 2 us
      TOSH_MAKE_GIO1_INPUT ();	// Set pin as input
      TOSH_uwait (50);		// Write slot is at least 60 us
    }
  else
    {
      TOSH_MAKE_GIO1_OUTPUT ();	// Set pin as output
      TOSH_CLR_GIO1_PIN ();	// Set the line low
      TOSH_uwait (50);		// Hold line low for at least 60 us
      TOSH_MAKE_GIO1_INPUT ();	// Release the line
      TOSH_uwait (8);
    }

}


void
writeByte (int hexNum)
     // It sends one byte via the one-wire that corresponds to the binary representation
     // of hexNum.  The variable next is used when the number is broken down into its
     // binary code and it holds the current value of the variable.  curBit holds the
     // value of the bit to be written to the line.
{
  int i;

  for (i = 0; i < 8; i++)	// Convert to binary code
    {
      writeBit (hexNum & 0x01);

      // shift the data byte for the next bit 
      hexNum >>= 1;

    }
}

int
readByte ()
     // It reads a byte from the one-wire and stores it in the array byteArray,
     // which will contain the information of the one byte read
{
  int loop, result = 0;

  for (loop = 0; loop < 8; loop++)
    {
      // shift the result to get it ready for the next bit 
      result >>= 1;

      // if result is one, then set MS bit 
      if (readBit ())
	result |= 0x80;
    }
  return result;
}




void
skipROM ()
     // Skip ROM command, when only one DS2438 is being used on the line
{
  writeByte (0xcc);		// Request skip ROM to be executed
}



uint8_t
readAddr (uint8_t addr)
{
  uint8_t data;
  uint8_t p;

  p = ds2770_init ();
  if (p)
    {
      skipROM ();
      writeByte (0x69);
      writeByte (addr);
      data = readByte ();
    }
  else
    {
      data = 0xeb;
    }
  return data;
}

void
writeAddr (uint8_t addr, uint8_t val)
{
  ds2770_init ();
  skipROM ();
  writeByte (0x6C);
  writeByte (addr);
  writeByte (val);
}

void
refresh ()
{
  ds2770_init ();
  skipROM ();
  writeByte (0x63);
}
