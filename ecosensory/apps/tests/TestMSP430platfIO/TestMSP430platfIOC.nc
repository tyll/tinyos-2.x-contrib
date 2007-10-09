/* Copyright (c) 2007 Ecosensory  MIT license
*
* Test if GPIOs are wired as planned on new MSP430 platform. 
* Show green LED only when user switch down, 
* increment number of IO pin to be read,
* display HI/LO as on/off on all LEDs at 1/2 Hz alternating
* with display of count.  In other words, 3 bit count is displayed,
* then binary from input pin is displayed as all LEDs on or all off.
* by John Griessen <john@ecosensory.com>
* wiring configuration TestMSP430platfIOC.nc  Rev 1.0 12aug07
* 
*/
  
configuration TestMSP430platfIOC {
// provides no interfaces 
// uses  interface GeneralIO, but not directly..
// uses HplNew8IOsC.Pin0, which uses GeneralIO
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

  components  HplNew8IOsC;
  TestMSP430platfIOP.Pin0 ->  HplNew8IOsC.Pin0;
  TestMSP430platfIOP.Pin1 ->  HplNew8IOsC.Pin1;
  TestMSP430platfIOP.Pin2 ->  HplNew8IOsC.Pin2;
  TestMSP430platfIOP.Pin3 ->  HplNew8IOsC.Pin3;
  TestMSP430platfIOP.Pin4 ->  HplNew8IOsC.Pin4;
  TestMSP430platfIOP.Pin5 ->  HplNew8IOsC.Pin5;
  TestMSP430platfIOP.Pin6 ->  HplNew8IOsC.Pin6;
  TestMSP430platfIOP.Pin7 ->  HplNew8IOsC.Pin7;
}
