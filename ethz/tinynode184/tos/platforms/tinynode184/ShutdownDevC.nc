
module ShutdownDevC {

    provides interface ShutdownDev;
    provides interface Init;
    uses interface Resource;
    uses interface SpiByte;
}

implementation {


  uint8_t SPIByte(uint8_t out) {

    uint8_t in = 0;
    uint8_t i;
    for ( i = 0; i < 8; i++, out <<= 1 ) {
      // write bit
      if (out & 0x80)
        TOSH_SET_SIMO0_PIN();
      else
        TOSH_CLR_SIMO0_PIN();
      // clock
      TOSH_SET_UCLK0_PIN();
      // read bit
      in <<= 1;
      if (TOSH_READ_SOMI0_PIN())
        in |= 1;
      // clock
      TOSH_CLR_UCLK0_PIN();
    }
    return in;

  }

    void stm25Sleep() {

	TOSH_CLR_NFL_EN_PIN();
	if (call Resource.immediateRequest()==SUCCESS) {
		atomic {
	    TOSH_CLR_FLASH_CS_PIN();
	    call SpiByte.write(0xb9);
	    TOSH_SET_FLASH_CS_PIN();
		}
	    call Resource.release();
	}
	TOSH_SET_NFL_EN_PIN();
	return;

    }

    command error_t Init.init() {

	
    }

    command void ShutdownDev.flashSleep() {
	stm25Sleep();

	TOSH_MAKE_FLASH_CS_OUTPUT();
	TOSH_CLR_FLASH_CS_PIN();
	TOSH_MAKE_UCLK0_OUTPUT();
	TOSH_CLR_UCLK0_PIN();
	TOSH_MAKE_SIMO0_OUTPUT();
	TOSH_CLR_SIMO0_PIN();
	TOSH_MAKE_SOMI0_INPUT();
	TOSH_CLR_SOMI0_PIN();
	TOSH_MAKE_NFL_RST_OUTPUT();
	TOSH_CLR_NFL_RST_PIN();
    }

    command void ShutdownDev.sleep()  {

	call ShutdownDev.flashSleep();
	return;

    }
    
    event void Resource.granted() {}
}

