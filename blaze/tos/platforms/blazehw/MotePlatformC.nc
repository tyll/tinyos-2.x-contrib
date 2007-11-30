#warning "using gma moteplatformC"

module MotePlatformC {
  provides interface Init;
}
implementation {

  inline void uwait(uint16_t u) { 
    uint16_t t0 = TAR;
    while((TAR - t0) <= u);
  } 

  inline void TOSH_wait() {
    nop(); nop();
  }

  // send a bit via bit-banging to the flash
  void TOSH_FLASH_M25P_DP_bit(bool set) {
    if (set)
      TOSH_SET_SIMO0_PIN();
    else
      TOSH_CLR_SIMO0_PIN();
    TOSH_SET_UCLK0_PIN();
    TOSH_CLR_UCLK0_PIN();
  }

  // put the flash into deep sleep mode
  // important to do this by default
  void TOSH_FLASH_M25P_DP() {
    //  SIMO0, UCLK0
    TOSH_MAKE_SIMO0_OUTPUT();
    TOSH_MAKE_UCLK0_OUTPUT();
    TOSH_MAKE_FLASH_HOLD_OUTPUT();
    TOSH_MAKE_FLASH_CS_OUTPUT();
    TOSH_SET_FLASH_HOLD_PIN();
    TOSH_SET_FLASH_CS_PIN();

    TOSH_wait();

    // initiate sequence;
    TOSH_CLR_FLASH_CS_PIN();
    TOSH_CLR_UCLK0_PIN();
  
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 0
    TOSH_FLASH_M25P_DP_bit(FALSE);  // 1
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 2
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 3
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 4
    TOSH_FLASH_M25P_DP_bit(FALSE);  // 5
    TOSH_FLASH_M25P_DP_bit(FALSE);  // 6
    TOSH_FLASH_M25P_DP_bit(TRUE);   // 7

    TOSH_SET_FLASH_CS_PIN();

    TOSH_SET_SIMO0_PIN();
    TOSH_MAKE_SIMO0_INPUT();
    TOSH_MAKE_UCLK0_INPUT();
    TOSH_CLR_FLASH_HOLD_PIN();
  }

  command error_t Init.init() {
    // reset all of the ports to be input and using i/o functionality
    atomic
      {
	// disable interrupts
	P1IE = 0;
	P2IE = 0;

	// set for rising edge trigger
	P1IES = 0;
	P2IES = 0;

	// set all to gpio function
	P1SEL = 0;
	P2SEL = 0;
	P3SEL = 0;
	P4SEL = 0;
	P5SEL = 0;
	P6SEL = 0;

	// All low, except TILT_SENSE, EXT_VCC_SENSE, BSL_TX
	P1DIR = 0x5d;
	P1OUT = 0x00;
 
        // All low, except ROSC, BSL_RX
	P2DIR = 0xdb;
	P2OUT = 0x00;

        // All low, except UART1_RX, SPI0_MISO
	P3DIR = 0x7b;
	P3OUT = 0x00;

        // All low, except flash CS, HOLD
	P4DIR = 0xff;
	P4OUT = 0x90;

        // All output low
	P5DIR = 0xff;
	P5OUT = 0x00;

        // All output low
	P6DIR = 0xff;
	P6OUT = 0x00;

        // Enable ROSC on P2.5
        P2SEL |= 0x20;

	// the commands above take care of the pin directions
	// there is no longer a need for explicit set pin
	// directions using the TOSH_SET/CLR macros

#if 1
#warning "Not resetting M25P80 Flash"
#else
	// wait 10ms for the flash to startup
	uwait(1024*10);
	// Put the flash in deep sleep state
	TOSH_FLASH_M25P_DP();
#endif

      }//atomic
    return SUCCESS;
  }
}
