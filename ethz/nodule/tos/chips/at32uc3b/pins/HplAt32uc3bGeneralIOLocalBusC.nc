/* $Id$ */

/**
 * HPL for the Atmel AT32UC3B microcontroller. This provides an
 * abstraction for general-purpose I/O.
 *
 * Mapping registers on the local bus allows cycle-deterministic
 * toggling of GPIO  pins since the CPU and GPIO are the only
 * modules connected to this bus. Also, since the local bus runs
 * at CPU speed, one write or read operation can be performed
 * per clock cycle to the local busmapped GPIO registers.
 *
 * @author Mustafa Yuecel <mustafa.yuecel@alumni.ethz.ch>
 */

#include "at32uc3b.h"

configuration HplAt32uc3bGeneralIOLocalBusC
{
  provides {
//    interface Init;
    interface GeneralIO as Gpio0;
    interface GeneralIO as Gpio1;
    interface GeneralIO as Gpio2;
    interface GeneralIO as Gpio3;
    interface GeneralIO as Gpio4;
    interface GeneralIO as Gpio5;
    interface GeneralIO as Gpio6;
    interface GeneralIO as Gpio7;
    interface GeneralIO as Gpio8;
    interface GeneralIO as Gpio9;
    interface GeneralIO as Gpio10;
    interface GeneralIO as Gpio11;
    interface GeneralIO as Gpio12;
    interface GeneralIO as Gpio13;
    interface GeneralIO as Gpio14;
    interface GeneralIO as Gpio15;
    interface GeneralIO as Gpio16;
    interface GeneralIO as Gpio17;
    interface GeneralIO as Gpio18;
    interface GeneralIO as Gpio19;
    interface GeneralIO as Gpio20;
    interface GeneralIO as Gpio21;
    interface GeneralIO as Gpio22;
    interface GeneralIO as Gpio23;
    interface GeneralIO as Gpio24;
    interface GeneralIO as Gpio25;
    interface GeneralIO as Gpio26;
    interface GeneralIO as Gpio27;
    interface GeneralIO as Gpio28;
    interface GeneralIO as Gpio29;
    interface GeneralIO as Gpio30;
    interface GeneralIO as Gpio31;
    interface GeneralIO as Gpio32;
    interface GeneralIO as Gpio33;
    interface GeneralIO as Gpio34;
    interface GeneralIO as Gpio35;
    interface GeneralIO as Gpio36;
    interface GeneralIO as Gpio37;
    interface GeneralIO as Gpio38;
    interface GeneralIO as Gpio39;
    interface GeneralIO as Gpio40;
    interface GeneralIO as Gpio41;
    interface GeneralIO as Gpio42;
    interface GeneralIO as Gpio43;
  }
}
implementation
{
//  command error_t Init.init()
//  {
//    // TODO: enable local bus
//    return SUCCESS;
//  }

  components
    new HplAt32uc3bGeneralIOLocalBusP(0) as PA00,
    new HplAt32uc3bGeneralIOLocalBusP(1) as PA01,
    new HplAt32uc3bGeneralIOLocalBusP(2) as PA02,
    new HplAt32uc3bGeneralIOLocalBusP(3) as PA03,
    new HplAt32uc3bGeneralIOLocalBusP(4) as PA04,
    new HplAt32uc3bGeneralIOLocalBusP(5) as PA05,
    new HplAt32uc3bGeneralIOLocalBusP(6) as PA06,
    new HplAt32uc3bGeneralIOLocalBusP(7) as PA07,
    new HplAt32uc3bGeneralIOLocalBusP(8) as PA08,
    new HplAt32uc3bGeneralIOLocalBusP(9) as PA09,
    new HplAt32uc3bGeneralIOLocalBusP(10) as PA10,
    new HplAt32uc3bGeneralIOLocalBusP(11) as PA11,
    new HplAt32uc3bGeneralIOLocalBusP(12) as PA12,
    new HplAt32uc3bGeneralIOLocalBusP(13) as PA13,
    new HplAt32uc3bGeneralIOLocalBusP(14) as PA14,
    new HplAt32uc3bGeneralIOLocalBusP(15) as PA15,
    new HplAt32uc3bGeneralIOLocalBusP(16) as PA16,
    new HplAt32uc3bGeneralIOLocalBusP(17) as PA17,
    new HplAt32uc3bGeneralIOLocalBusP(18) as PA18,
    new HplAt32uc3bGeneralIOLocalBusP(19) as PA19,
    new HplAt32uc3bGeneralIOLocalBusP(20) as PA20,
    new HplAt32uc3bGeneralIOLocalBusP(21) as PA21,
    new HplAt32uc3bGeneralIOLocalBusP(22) as PA22,
    new HplAt32uc3bGeneralIOLocalBusP(23) as PA23,
    new HplAt32uc3bGeneralIOLocalBusP(24) as PA24,
    new HplAt32uc3bGeneralIOLocalBusP(25) as PA25,
    new HplAt32uc3bGeneralIOLocalBusP(26) as PA26,
    new HplAt32uc3bGeneralIOLocalBusP(27) as PA27,
    new HplAt32uc3bGeneralIOLocalBusP(28) as PA28,
    new HplAt32uc3bGeneralIOLocalBusP(29) as PA29,
    new HplAt32uc3bGeneralIOLocalBusP(30) as PA30,
    new HplAt32uc3bGeneralIOLocalBusP(31) as PA31,
    new HplAt32uc3bGeneralIOLocalBusP(32) as PB00,
    new HplAt32uc3bGeneralIOLocalBusP(34) as PB01,
    new HplAt32uc3bGeneralIOLocalBusP(35) as PB02,
    new HplAt32uc3bGeneralIOLocalBusP(36) as PB03,
    new HplAt32uc3bGeneralIOLocalBusP(37) as PB04,
    new HplAt32uc3bGeneralIOLocalBusP(38) as PB05,
    new HplAt32uc3bGeneralIOLocalBusP(39) as PB06,
    new HplAt32uc3bGeneralIOLocalBusP(40) as PB07,
    new HplAt32uc3bGeneralIOLocalBusP(41) as PB08,
    new HplAt32uc3bGeneralIOLocalBusP(42) as PB09,
    new HplAt32uc3bGeneralIOLocalBusP(43) as PB10,
    new HplAt32uc3bGeneralIOLocalBusP(44) as PB11;

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
