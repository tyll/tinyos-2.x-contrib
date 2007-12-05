/* $Id$ */

/**
 * HPL for the Atmel AT32UC3B microcontroller. This provides an
 * abstraction for general-purpose I/O.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

#include <avr32/io.h>

configuration HplAt32uc3bGeneralIOC
{
  provides interface HplAt32uc3bGeneralIO as Gpio0;
  provides interface HplAt32uc3bGeneralIO as Gpio1;
  provides interface HplAt32uc3bGeneralIO as Gpio2;
  provides interface HplAt32uc3bGeneralIO as Gpio3;
  provides interface HplAt32uc3bGeneralIO as Gpio4;
  provides interface HplAt32uc3bGeneralIO as Gpio5;
  provides interface HplAt32uc3bGeneralIO as Gpio6;
  provides interface HplAt32uc3bGeneralIO as Gpio7;
  provides interface HplAt32uc3bGeneralIO as Gpio8;
  provides interface HplAt32uc3bGeneralIO as Gpio9;
  provides interface HplAt32uc3bGeneralIO as Gpio10;
  provides interface HplAt32uc3bGeneralIO as Gpio11;
  provides interface HplAt32uc3bGeneralIO as Gpio12;
  provides interface HplAt32uc3bGeneralIO as Gpio13;
  provides interface HplAt32uc3bGeneralIO as Gpio14;
  provides interface HplAt32uc3bGeneralIO as Gpio15;
  provides interface HplAt32uc3bGeneralIO as Gpio16;
  provides interface HplAt32uc3bGeneralIO as Gpio17;
  provides interface HplAt32uc3bGeneralIO as Gpio18;
  provides interface HplAt32uc3bGeneralIO as Gpio19;
  provides interface HplAt32uc3bGeneralIO as Gpio20;
  provides interface HplAt32uc3bGeneralIO as Gpio21;
  provides interface HplAt32uc3bGeneralIO as Gpio22;
  provides interface HplAt32uc3bGeneralIO as Gpio23;
  provides interface HplAt32uc3bGeneralIO as Gpio24;
  provides interface HplAt32uc3bGeneralIO as Gpio25;
  provides interface HplAt32uc3bGeneralIO as Gpio26;
  provides interface HplAt32uc3bGeneralIO as Gpio27;
  provides interface HplAt32uc3bGeneralIO as Gpio28;
  provides interface HplAt32uc3bGeneralIO as Gpio29;
  provides interface HplAt32uc3bGeneralIO as Gpio30;
  provides interface HplAt32uc3bGeneralIO as Gpio31;
  provides interface HplAt32uc3bGeneralIO as Gpio32;
  provides interface HplAt32uc3bGeneralIO as Gpio33;
  provides interface HplAt32uc3bGeneralIO as Gpio34;
  provides interface HplAt32uc3bGeneralIO as Gpio35;
  provides interface HplAt32uc3bGeneralIO as Gpio36;
  provides interface HplAt32uc3bGeneralIO as Gpio37;
  provides interface HplAt32uc3bGeneralIO as Gpio38;
  provides interface HplAt32uc3bGeneralIO as Gpio39;
  provides interface HplAt32uc3bGeneralIO as Gpio40;
  provides interface HplAt32uc3bGeneralIO as Gpio41;
  provides interface HplAt32uc3bGeneralIO as Gpio42;
  provides interface HplAt32uc3bGeneralIO as Gpio43;
}
implementation
{
#define PORTA     (AVR32_GPIO_ADDRESS)
#define PORTB     (AVR32_GPIO_ADDRESS + AVR32_GPIO_GPER1)

  components
    new HplAt32uc3bGeneralIOP(PORTA, 0) as PA00,
    new HplAt32uc3bGeneralIOP(PORTA, 1) as PA01,
    new HplAt32uc3bGeneralIOP(PORTA, 2) as PA02,
    new HplAt32uc3bGeneralIOP(PORTA, 3) as PA03,
    new HplAt32uc3bGeneralIOP(PORTA, 4) as PA04,
    new HplAt32uc3bGeneralIOP(PORTA, 5) as PA05,
    new HplAt32uc3bGeneralIOP(PORTA, 6) as PA06,
    new HplAt32uc3bGeneralIOP(PORTA, 7) as PA07,
    new HplAt32uc3bGeneralIOP(PORTA, 8) as PA08,
    new HplAt32uc3bGeneralIOP(PORTA, 9) as PA09,
    new HplAt32uc3bGeneralIOP(PORTA, 10) as PA10,
    new HplAt32uc3bGeneralIOP(PORTA, 11) as PA11,
    new HplAt32uc3bGeneralIOP(PORTA, 12) as PA12,
    new HplAt32uc3bGeneralIOP(PORTA, 13) as PA13,
    new HplAt32uc3bGeneralIOP(PORTA, 14) as PA14,
    new HplAt32uc3bGeneralIOP(PORTA, 15) as PA15,
    new HplAt32uc3bGeneralIOP(PORTA, 16) as PA16,
    new HplAt32uc3bGeneralIOP(PORTA, 17) as PA17,
    new HplAt32uc3bGeneralIOP(PORTA, 18) as PA18,
    new HplAt32uc3bGeneralIOP(PORTA, 19) as PA19,
    new HplAt32uc3bGeneralIOP(PORTA, 20) as PA20,
    new HplAt32uc3bGeneralIOP(PORTA, 21) as PA21,
    new HplAt32uc3bGeneralIOP(PORTA, 22) as PA22,
    new HplAt32uc3bGeneralIOP(PORTA, 23) as PA23,
    new HplAt32uc3bGeneralIOP(PORTA, 24) as PA24,
    new HplAt32uc3bGeneralIOP(PORTA, 25) as PA25,
    new HplAt32uc3bGeneralIOP(PORTA, 26) as PA26,
    new HplAt32uc3bGeneralIOP(PORTA, 27) as PA27,
    new HplAt32uc3bGeneralIOP(PORTA, 28) as PA28,
    new HplAt32uc3bGeneralIOP(PORTA, 29) as PA29,
    new HplAt32uc3bGeneralIOP(PORTA, 30) as PA30,
    new HplAt32uc3bGeneralIOP(PORTA, 31) as PA31,
    new HplAt32uc3bGeneralIOP(PORTB, 0) as PB00,
    new HplAt32uc3bGeneralIOP(PORTB, 1) as PB01,
    new HplAt32uc3bGeneralIOP(PORTB, 2) as PB02,
    new HplAt32uc3bGeneralIOP(PORTB, 3) as PB03,
    new HplAt32uc3bGeneralIOP(PORTB, 4) as PB04,
    new HplAt32uc3bGeneralIOP(PORTB, 5) as PB05,
    new HplAt32uc3bGeneralIOP(PORTB, 6) as PB06,
    new HplAt32uc3bGeneralIOP(PORTB, 7) as PB07,
    new HplAt32uc3bGeneralIOP(PORTB, 8) as PB08,
    new HplAt32uc3bGeneralIOP(PORTB, 9) as PB09,
    new HplAt32uc3bGeneralIOP(PORTB, 10) as PB10,
    new HplAt32uc3bGeneralIOP(PORTB, 11) as PB11
    ;

  Gpio0 = PA00;
  Gpio1 = PA01;
  Gpio2 = PA02;
  Gpio3 = PA03;
  Gpio4 = PA04;
  Gpio5 = PA05;
  Gpio6 = PA06;
  Gpio7 = PA07;
  Gpio8 = PA08;
  Gpio9 = PA09;
  Gpio10 = PA10;
  Gpio11 = PA11;
  Gpio12 = PA12;
  Gpio13 = PA13;
  Gpio14 = PA14;
  Gpio15 = PA15;
  Gpio16 = PA16;
  Gpio17 = PA17;
  Gpio18 = PA18;
  Gpio19 = PA19;
  Gpio20 = PA20;
  Gpio21 = PA21;
  Gpio22 = PA22;
  Gpio23 = PA23;
  Gpio24 = PA24;
  Gpio25 = PA25;
  Gpio26 = PA26;
  Gpio27 = PA27;
  Gpio28 = PA28;
  Gpio29 = PA29;
  Gpio30 = PA30;
  Gpio31 = PA31;
  Gpio32 = PB00;  
  Gpio33 = PB01;
  Gpio34 = PB02;
  Gpio35 = PB03;
  Gpio36 = PB04;
  Gpio37 = PB05;
  Gpio38 = PB06;
  Gpio39 = PB07;
  Gpio40 = PB08;
  Gpio41 = PB09;
  Gpio42 = PB10;
  Gpio43 = PB11;
}
