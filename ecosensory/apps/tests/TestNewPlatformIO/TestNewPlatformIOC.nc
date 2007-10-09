/* Copyright (c) 2007 Ecosensory  MIT license
*
* Test GPIOs are wired as wanted on new platforms. 
* Show green LED only when user switch down, 
* increment number of IO pin to be read,
* display HI/LO as on/off on all LEDs at 1/2 Hz alternating
* with display of count.  In other words, count is displayed,
* then value read from pin is displayed as all on or all off.
* by John Griessen <john@ecosensory.com>
* wiring configuration TestNewPlatformIOC.nc  Rev 1.0 13aug07
* 
*/
  
configuration TestNewPlatformIOC {
// provides no interfaces 
// uses  interface GeneralIO, but not directly..
// uses HplNew8IOsC.Pin0, which uses GeneralIO
}

implementation {

  components MainC;
  TestNewPlatformIOP.Boot -> MainC;
  
  components UserButtonC; //The telos user button
  TestNewPlatformIOP.Get -> UserButtonC;
  TestNewPlatformIOP.Notify -> UserButtonC;

  components LedsC;
  TestNewPlatformIOP.Leds -> LedsC;

  components new TimerMilliC(); //use here once -- no rename.
  TestNewPlatformIOP.Timer -> TimerMilliC;

  components TestNewPlatformIOP;
  
  components  HplNew8IOsC;
  TestNewPlatformIOP.Pin0 ->  HplNew8IOsC.Pin0;
  TestNewPlatformIOP.Pin1 ->  HplNew8IOsC.Pin1;
  TestNewPlatformIOP.Pin2 ->  HplNew8IOsC.Pin2;
  TestNewPlatformIOP.Pin3 ->  HplNew8IOsC.Pin3;
  TestNewPlatformIOP.Pin4 ->  HplNew8IOsC.Pin4;
  TestNewPlatformIOP.Pin5 ->  HplNew8IOsC.Pin5;
  TestNewPlatformIOP.Pin6 ->  HplNew8IOsC.Pin6;
  TestNewPlatformIOP.Pin7 ->  HplNew8IOsC.Pin7;
}
