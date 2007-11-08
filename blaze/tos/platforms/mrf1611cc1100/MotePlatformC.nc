module MotePlatformC {
  provides interface Init;
}
implementation {
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

	// see pages 114 and 115 of eng. notebook
	P1DIR = 0x0f;
	P1OUT = 0x00;
 
	P2DIR = 0xfc;
	P2OUT = 0x00;

	P3DIR = 0xff;
	P3OUT = 0x00;

	P4DIR = 0xff;
	P4OUT = 0x00;

	P5DIR = 0xfb;
	P5OUT = 0x01;

	P6DIR = 0xff;
	P6OUT = 0x00;

	// the commands above take care of the pin directions
	// there is no longer a need for explicit set pin
	// directions using the TOSH_SET/CLR macros

      }//atomic
    return SUCCESS;
  }
}
