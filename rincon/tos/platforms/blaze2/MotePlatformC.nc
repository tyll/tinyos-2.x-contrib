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

  // send a SPI bit via bit-banging
  void TOSH_SPI_bit(bool set) {
    if (set) {
      TOSH_SET_SIMO0_PIN();
    } else {
      TOSH_CLR_SIMO0_PIN();
    }
    
    TOSH_SET_UCLK0_PIN();
    TOSH_wait();
    TOSH_CLR_UCLK0_PIN();
  }

  void TOSH_SPI_byte(uint8_t byte) {
    uint8_t i;

    TOSH_CLR_UCLK0_PIN();
    for (i = 0; i < 8; i++) {
      TOSH_SPI_bit((byte & 0x80) ? TRUE : FALSE); byte <<= 1;
    }
  }

  void TOSH_WAIT_SOMI() {
    uint16_t n = 0;

    while (++n) {
      if (!TOSH_READ_SOMI0_PIN())
	break;
    }
  }

  void TOSH_RADIO_RST() {
  }

  void TOSH_RADIO_DP() {
    TOSH_wait();
    // reset the radio
    TOSH_WAIT_SOMI();
    TOSH_SPI_byte(0x30);
    TOSH_WAIT_SOMI();
    // put it to sleep
    TOSH_SPI_byte(0x39);
    TOSH_wait();
  }

  // put the flash into deep sleep mode
  // important to do this by default
  void TOSH_FLASH_M25P_DP() {
    TOSH_MAKE_FLASH_HOLD_OUTPUT();
    TOSH_MAKE_FLASH_CS_OUTPUT();
    TOSH_SET_FLASH_HOLD_PIN();
    TOSH_SET_FLASH_CS_PIN();
    TOSH_wait();

    // initiate sequence;
    TOSH_CLR_FLASH_CS_PIN();

    // 0xb9
    TOSH_SPI_byte(0xb9);

    TOSH_SET_FLASH_CS_PIN();
    TOSH_CLR_FLASH_HOLD_PIN();
  }

  void TOSH_RADIO_setup() {
    TOSH_SET_UCLK0_PIN();
    TOSH_CLR_SIMO0_PIN();
  }

  // put CC1101 into deep sleep
  void TOSH_CC1101_DP() {
#ifdef BLAZE1
#warning "Using BlazeI FET controls"
    TOSH_MAKE_CTRL_P55_OUTPUT();
    TOSH_SET_CTRL_P55_PIN();
#endif
    TOSH_MAKE_CC1101_CS_OUTPUT();
    TOSH_SET_CC1101_CS_PIN();
#ifdef BLAZE1
    uwait(10 * 1024);
#else
    TOSH_wait();
#endif

    // p.43 setup
    TOSH_RADIO_setup();
    // p.43 cs ->h->l
    TOSH_CLR_CC1101_CS_PIN();
    TOSH_wait();
    TOSH_SET_CC1101_CS_PIN();
    uwait(10 * 1024);
    TOSH_CLR_CC1101_CS_PIN();
    // reset and put into deep sleep
    TOSH_RADIO_DP();
    TOSH_SET_CC1101_CS_PIN();
  }

  // put CC2500 into deep sleep
  void TOSH_CC2500_DP() {
#ifdef BLAZE1
    TOSH_MAKE_CTRL_P46_OUTPUT();
    TOSH_SET_CTRL_P46_PIN();
#endif
    TOSH_MAKE_CC2500_CS_OUTPUT();
    TOSH_SET_CC2500_CS_PIN();
#ifdef BLAZE1
    uwait(10 * 1024);
#else
    TOSH_wait();
#endif

    TOSH_RADIO_setup();
    TOSH_CLR_CC2500_CS_PIN();
    TOSH_wait();
    TOSH_SET_CC2500_CS_PIN();
    uwait(10 * 1024);
    TOSH_CLR_CC2500_CS_PIN();
    TOSH_RADIO_DP();
    TOSH_SET_CC2500_CS_PIN();
  }

  // put NBD into deep sleep
  void TOSH_NBD_DP() {
#ifdef BLAZE1
    TOSH_MAKE_CTRL_P56_OUTPUT();
    TOSH_SET_CTRL_P56_PIN();
#endif
    TOSH_MAKE_NBD_CC1101_CS_OUTPUT();
    TOSH_SET_NBD_CC1101_CS_PIN();
#ifdef BLAZE1
    uwait(10 * 1024);
#else
    TOSH_wait();
#endif

    TOSH_RADIO_setup();
    TOSH_CLR_NBD_CC1101_CS_PIN();
    TOSH_wait();
    TOSH_SET_NBD_CC1101_CS_PIN();
    uwait(10 * 1024);
    TOSH_CLR_NBD_CC1101_CS_PIN();
    TOSH_RADIO_DP();
    TOSH_SET_NBD_CC1101_CS_PIN();
  }

  command error_t Init.init() {
  
    // reset all of the ports to be input and using i/o functionality
    atomic {

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

      // P1
      //   7 [i] xxx_SENSE
      //   6 [L] EXT_INT4
      //   5 [i] EXT_VCC_SENSE/FT_UART_DISABLE
      //   4 [i] CC2500_GDO2
      //   3 [i] CC2500_GDO0
      //   2 [i] CC1101_GDO2
      //   1 [i] BSL_TX
      //   0 [i] CC1101_GDO0
      //
      //       7654 3210
      //   dir 0100 0000
      //   out 0000 0000
      P1DIR = 0x40; 
      P1OUT = 0x00;
 
      // P2
      //   7 [L] LNAPA_CC1101_MODE
      //   6 [L] EXT_INT3
      //   5 [i] ROSC
      //   4 [i] NBD_CC1101_GDO2
      //   3 [i] NBD_CC1101_GDO0
      //   2 [i] BSL_RX
      //   1 [L] AUX_ENABLE
      //   0 [L] EXT_INT5
      //
      //       7654 3210
      //   dir 1100 0011
      //   out 0000 0000
      P2DIR = 0xc3;
      P2OUT = 0x00;

      // P3
      //   7 [i] UART1_RX
      //   6 [H] UART1_TX
      //   5 [H] NBD_CC1101_CS
      //   4 [H] GPS_CS
      //   3 [H] SPI0_CLK
      //   2 [i] SPI0_MISO
      //   1 [L] SPI0_MOSI
      //   0 [H] CC1101_CS
      //
      //       7654 3210
      //   dir 0111 1011
      //   out 0111 1001
      P3DIR = 0x7b;
      P3OUT = 0x79;

      // P4
      //   7 [H] FLASH_HOLD
      //   6 [L] CTRL_P4.6
      //   5 [L] PA_ENABLE
      //   4 [H] FLASH_CS
      //   3 [L] LNA_ENABLE
      //   2 [L] ACCEL_ENABLE
      //   1 [L] RS232_ENABLE
      //   0 [i] SDIO_CLK
      //
      //       7654 3210
      //   dir 1111 1110
      //   out 1001 0000
      P4DIR = 0xfe;
      P4OUT = 0x90;

      // P5
      //   7 [H] CC2500_CS
      //   6 [L] CTRL_P5.6
      //   5 [L] CTRL_P5.5
      //   4 [L] LNAPA_CC2500_MODE
      //   3 [i] SPI1_CLK
      //   2 [i] SPI1_MISO
      //   1 [i] SPI1_MOSI
      //   0 [i] SPI1_STE
      //
      //       7654 3210
      //   dir 1111 0000
      //   out 1000 0000
      P5DIR = 0xf0;
      P5OUT = 0x80;

      // P6
      //   7 [i] SDIO_DAT3
      //   6 [i] SDIO_DAT2
      //   5 [i] SDIO_DAT1
      //   4 [L] GPS_ENABLE
      //   3 [L] xxx_ENABLE
      //   2 [L] FET_ENABLE
      //   1 [L] N/C
      //   0 [L] N/C
      //
      //       7654 3210
      //   dir 0001 1111
      //   out 0000 0000
      P6DIR = 0x1f;
      P6OUT = 0x00;

      // Enable ROSC on P2.5
      P2SEL |= 0x20;

      // the commands above take care of the pin directions
      // there is no longer a need for explicit set pin
      // directions using the TOSH_SET/CLR macros

#if 0
#warning "Not resetting M25P80 Flash"
#else
      // wait 10ms for the flash to startup
      uwait(1024*10);
      // Put the flash in deep sleep state
      TOSH_FLASH_M25P_DP();
#endif
#if 0
#warning "Putting Blaze2 radios to sleep"
      TOSH_CC1101_DP();
      TOSH_CC2500_DP();
      TOSH_NBD_DP();
#endif
      TOSH_SET_UCLK0_PIN();
      TOSH_CLR_SIMO0_PIN();

      }//atomic
    return SUCCESS;
  }
}

