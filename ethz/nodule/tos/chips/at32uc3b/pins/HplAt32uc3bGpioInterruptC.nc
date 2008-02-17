/* $Id$ */

/**
 * HPL for the Atmel AT32UC3B microcontroller. This provides an
 * abstraction for general-purpose I/O.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

#include "at32uc3b.h"

configuration HplAt32uc3bGpioInterruptC
{
  provides interface HplAt32uc3bGpioInterrupt as Gpio0;
  provides interface HplAt32uc3bGpioInterrupt as Gpio1;
  provides interface HplAt32uc3bGpioInterrupt as Gpio2;
  provides interface HplAt32uc3bGpioInterrupt as Gpio3;
  provides interface HplAt32uc3bGpioInterrupt as Gpio4;
  provides interface HplAt32uc3bGpioInterrupt as Gpio5;
  provides interface HplAt32uc3bGpioInterrupt as Gpio6;
  provides interface HplAt32uc3bGpioInterrupt as Gpio7;
  provides interface HplAt32uc3bGpioInterrupt as Gpio8;
  provides interface HplAt32uc3bGpioInterrupt as Gpio9;
  provides interface HplAt32uc3bGpioInterrupt as Gpio10;
  provides interface HplAt32uc3bGpioInterrupt as Gpio11;
  provides interface HplAt32uc3bGpioInterrupt as Gpio12;
  provides interface HplAt32uc3bGpioInterrupt as Gpio13;
  provides interface HplAt32uc3bGpioInterrupt as Gpio14;
  provides interface HplAt32uc3bGpioInterrupt as Gpio15;
  provides interface HplAt32uc3bGpioInterrupt as Gpio16;
  provides interface HplAt32uc3bGpioInterrupt as Gpio17;
  provides interface HplAt32uc3bGpioInterrupt as Gpio18;
  provides interface HplAt32uc3bGpioInterrupt as Gpio19;
  provides interface HplAt32uc3bGpioInterrupt as Gpio20;
  provides interface HplAt32uc3bGpioInterrupt as Gpio21;
  provides interface HplAt32uc3bGpioInterrupt as Gpio22;
  provides interface HplAt32uc3bGpioInterrupt as Gpio23;
  provides interface HplAt32uc3bGpioInterrupt as Gpio24;
  provides interface HplAt32uc3bGpioInterrupt as Gpio25;
  provides interface HplAt32uc3bGpioInterrupt as Gpio26;
  provides interface HplAt32uc3bGpioInterrupt as Gpio27;
  provides interface HplAt32uc3bGpioInterrupt as Gpio28;
  provides interface HplAt32uc3bGpioInterrupt as Gpio29;
  provides interface HplAt32uc3bGpioInterrupt as Gpio30;
  provides interface HplAt32uc3bGpioInterrupt as Gpio31;
  provides interface HplAt32uc3bGpioInterrupt as Gpio32;
  provides interface HplAt32uc3bGpioInterrupt as Gpio33;
  provides interface HplAt32uc3bGpioInterrupt as Gpio34;
  provides interface HplAt32uc3bGpioInterrupt as Gpio35;
  provides interface HplAt32uc3bGpioInterrupt as Gpio36;
  provides interface HplAt32uc3bGpioInterrupt as Gpio37;
  provides interface HplAt32uc3bGpioInterrupt as Gpio38;
  provides interface HplAt32uc3bGpioInterrupt as Gpio39;
  provides interface HplAt32uc3bGpioInterrupt as Gpio40;
  provides interface HplAt32uc3bGpioInterrupt as Gpio41;
  provides interface HplAt32uc3bGpioInterrupt as Gpio42;
  provides interface HplAt32uc3bGpioInterrupt as Gpio43;
}
implementation
{
  components InterruptControllerC, 
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 0, 0) as PA00,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 1, 1) as PA01,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 2, 2) as PA02,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 3, 3) as PA03,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 4, 4) as PA04,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 5, 5) as PA05,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 6, 6) as PA06,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 7, 7) as PA07,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 8, 8) as PA08,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 9, 9) as PA09,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 10, 10) as PA10,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 11, 11) as PA11,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 12, 12) as PA12,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 13, 13) as PA13,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 14, 14) as PA14,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 15, 15) as PA15,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 16, 16) as PA16,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 17, 17) as PA17,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 18, 18) as PA18,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 19, 19) as PA19,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 20, 20) as PA20,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 21, 21) as PA21,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 22, 22) as PA22,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 23, 23) as PA23,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 24, 24) as PA24,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 25, 25) as PA25,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 26, 26) as PA26,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 27, 27) as PA27,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 28, 28) as PA28,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 29, 29) as PA29,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 30, 30) as PA30,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTA_BASEADDRESS, 31, 31) as PA31,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 0, 32) as PB00,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 1, 33) as PB01,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 2, 34) as PB02,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 3, 35) as PB03,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 4, 36) as PB04,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 5, 37) as PB05,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 6, 38) as PB06,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 7, 39) as PB07,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 8, 40) as PB08,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 9, 41) as PB09,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 10, 42) as PB10,
    new HplAt32uc3bGpioInterruptP(AVR32_GPIO_PORTB_BASEADDRESS, 11, 43) as PB11;

  Gpio0 = PA00;
  PA00.InterruptController -> InterruptControllerC;
  Gpio1 = PA01;
  PA01.InterruptController -> InterruptControllerC;
  Gpio2 = PA02;
  PA02.InterruptController -> InterruptControllerC;
  Gpio3 = PA03;
  PA03.InterruptController -> InterruptControllerC;
  Gpio4 = PA04;
  PA04.InterruptController -> InterruptControllerC;
  Gpio5 = PA05;
  PA05.InterruptController -> InterruptControllerC;
  Gpio6 = PA06;
  PA06.InterruptController -> InterruptControllerC;
  Gpio7 = PA07;
  PA07.InterruptController -> InterruptControllerC;
  Gpio8 = PA08;
  PA08.InterruptController -> InterruptControllerC;
  Gpio9 = PA09;
  PA09.InterruptController -> InterruptControllerC;
  Gpio10 = PA10;
  PA10.InterruptController -> InterruptControllerC;
  Gpio11 = PA11;
  PA11.InterruptController -> InterruptControllerC;
  Gpio12 = PA12;
  PA12.InterruptController -> InterruptControllerC;
  Gpio13 = PA13;
  PA13.InterruptController -> InterruptControllerC;
  Gpio14 = PA14;
  PA14.InterruptController -> InterruptControllerC;
  Gpio15 = PA15;
  PA15.InterruptController -> InterruptControllerC;
  Gpio16 = PA16;
  PA16.InterruptController -> InterruptControllerC;
  Gpio17 = PA17;
  PA17.InterruptController -> InterruptControllerC;
  Gpio18 = PA18;
  PA18.InterruptController -> InterruptControllerC;
  Gpio19 = PA19;
  PA19.InterruptController -> InterruptControllerC;
  Gpio20 = PA20;
  PA20.InterruptController -> InterruptControllerC;
  Gpio21 = PA21;
  PA21.InterruptController -> InterruptControllerC;
  Gpio22 = PA22;
  PA22.InterruptController -> InterruptControllerC;
  Gpio23 = PA23;
  PA23.InterruptController -> InterruptControllerC;
  Gpio24 = PA24;
  PA24.InterruptController -> InterruptControllerC;
  Gpio25 = PA25;
  PA25.InterruptController -> InterruptControllerC;
  Gpio26 = PA26;
  PA26.InterruptController -> InterruptControllerC;
  Gpio27 = PA27;
  PA27.InterruptController -> InterruptControllerC;
  Gpio28 = PA28;
  PA28.InterruptController -> InterruptControllerC;
  Gpio29 = PA29;
  PA29.InterruptController -> InterruptControllerC;
  Gpio30 = PA30;
  PA30.InterruptController -> InterruptControllerC;
  Gpio31 = PA31;
  PA31.InterruptController -> InterruptControllerC;
  Gpio32 = PB00;  
  PB00.InterruptController -> InterruptControllerC;
  Gpio33 = PB01;
  PB01.InterruptController -> InterruptControllerC;
  Gpio34 = PB02;
  PB02.InterruptController -> InterruptControllerC;
  Gpio35 = PB03;
  PB03.InterruptController -> InterruptControllerC;
  Gpio36 = PB04;
  PB04.InterruptController -> InterruptControllerC;
  Gpio37 = PB05;
  PB05.InterruptController -> InterruptControllerC;
  Gpio38 = PB06;
  PB06.InterruptController -> InterruptControllerC;
  Gpio39 = PB07;
  PB07.InterruptController -> InterruptControllerC;
  Gpio40 = PB08;
  PB08.InterruptController -> InterruptControllerC;
  Gpio41 = PB09;
  PB09.InterruptController -> InterruptControllerC;
  Gpio42 = PB10;
  PB10.InterruptController -> InterruptControllerC;
  Gpio43 = PB11;
  PB11.InterruptController -> InterruptControllerC;
}
