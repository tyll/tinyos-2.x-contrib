/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * This code funded by TX State San Marcos University.   BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 *
 * Test if GPIOs are wired as planned on new MSP430 platform. 
 * Show green LED only when user switch down, 
 * increment number of IO pin to be read,
 * display HI/LO as on/off on all LEDs at 1/2 Hz alternating
 * with display of count.  In other words, 3 bit count is displayed,
 * then binary from input pin is displayed as all LEDs on or all off.
 * by John Griessen <john@ecosensory.com>
 * wiring configuration TestMSP430platfIOC.nc  Rev 1.0 12aug07
 */
  
configuration TestMSP430platfIOC {
// provides no interfaces 
// uses  interface GeneralIO, but not directly..
// uses HplMsp430GeneralIO, which uses GeneralIO
}

implementation {

  components TestMSP430platfIOP;
  
  components MainC;
  TestMSP430platfIOP.Boot -> MainC;

  components HplUserSwitchC;
 
  components UserSwitchC; //instance exports Notify.
  TestMSP430platfIOP.Get -> UserSwitchC;
  TestMSP430platfIOP.Notify -> UserSwitchC.Notify;
  components LedsC;
  TestMSP430platfIOP.Leds -> LedsC;

  components new TimerMilliC(); //use here once -- no rename.
  TestMSP430platfIOP.Timer -> TimerMilliC;

  components HplMsp430GeneralIOC;
  TestMSP430platfIOP.Pin0 ->  HplMsp430GeneralIOC.Port60;
  TestMSP430platfIOP.Pin1 ->  HplMsp430GeneralIOC.Port61;
  TestMSP430platfIOP.Pin2 ->  HplMsp430GeneralIOC.Port62;
  TestMSP430platfIOP.Pin3 ->  HplMsp430GeneralIOC.Port63;
  TestMSP430platfIOP.Pin4 ->  HplMsp430GeneralIOC.Port64;
  TestMSP430platfIOP.Pin5 ->  HplMsp430GeneralIOC.Port65;
  TestMSP430platfIOP.Pin6 ->  HplMsp430GeneralIOC.Port66;
  TestMSP430platfIOP.Pin7 ->  HplMsp430GeneralIOC.Port67;
}
