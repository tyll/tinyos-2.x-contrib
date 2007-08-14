module MotePlatformC {
  provides interface Init;
}
implementation {
  command error_t Init.init() {

  atomic
  {
    P1SEL = 0x00;
    P2SEL = 0x00;
    P3SEL = 0x00;
    P4SEL = 0x00;
    P5SEL = 0x00;
    // P6SEL = 0x00;

    P4OUT = P4IN;  /* This makes the P4x macros show up later */
    P4DIR = 0;  /*parport input mode*/
    P3DIR &= ~0x3F; /*bus pins input*/
    P2DIR |= 0xF0;
    P2OUT |= 0xF0; /*module select none*/

    P3SEL |= (BIT6|BIT7);
    P3DIR |= BIT6;                  /* Use P3.6 as TX */
    P3DIR &= ~BIT7;                 /* Use P3.7 as RX */

    P5DIR &= ~(BIT2|BIT1);  /* SPI pins are hooked into these on micro.4*/
  }


    return SUCCESS;
  }
}
