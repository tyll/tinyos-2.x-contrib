/* Copyright (c) 2007, Ecosensory Austin Texas All rights reserved. 
 * This code funded by TX State San Marcos University.   BSD license full text at: 
 * http://tinyos.cvs.sourceforge.net/tinyos/tinyos-2.x-contrib/ecosensory/license.txt
 * TestMSP430platfIOP.nc <john@ecosensory.com>  Rev 1.0 12aug07
 * by John Griessen <john@ecosensory.com>
*/
#include <Timer.h>
typedef enum { UP = 1, DOWN = 0 } state_t; //switch position definitions.
module TestMSP430platfIOP {
  uses {
    interface Boot;
    interface Get<state_t>;
    interface Notify<state_t>;
    interface Leds;
    interface Timer<TMilli>;
    interface HplMsp430GeneralIO as Pin0;
    interface HplMsp430GeneralIO as Pin1;
    interface HplMsp430GeneralIO as Pin2;
    interface HplMsp430GeneralIO as Pin3;
    interface HplMsp430GeneralIO as Pin4;
    interface HplMsp430GeneralIO as Pin5;
    interface HplMsp430GeneralIO as Pin6;
    interface HplMsp430GeneralIO as Pin7;
  }
}
implementation {
uint8_t counter = 0xf;  //starting value doesn't match a port. 
 //Starting value so LEDs on at first.
 //Next switch press gives 0x0, Pin0 is input.
bool periodhalf = 0; //global for display change timing.
bool pinHi = 0;  //global for Pin val.
//bool switchstate = 0;

  event void Boot.booted() {
    call Notify.enable();
    call Timer.startPeriodic( 1096 );
    call Pin0.makeInput();
    call Pin1.makeInput();
    call Pin2.makeInput();
    call Pin3.makeInput();
    call Pin4.makeInput();
    call Pin5.makeInput();
    call Pin6.makeInput();
    call Pin7.makeInput();
  }

  void display8bits (uint8_t val) {
    if (val & 0x1) {
      call Leds.led0On();
    }
    else {
      call Leds.led0Off();
    }
    if (val & 0x2) {
      call Leds.led1On();
    }
    else {
      call Leds.led1Off();
    }
    if (val & 0x4) {
      call Leds.led2On();
    }
    else {
      call Leds.led2Off();
    }
    
  }
  void displayPin( bool val)  {
      if (periodhalf == 1) {
        if (pinHi == 1) {
          display8bits(0x7);
        } else {
          display8bits(0x0);
        } 
      } 
      else {
        display8bits(counter);
      }
  
  }

  event void Notify.notify( state_t switchstate ) {
    if ( switchstate == DOWN ) {
      counter++;
      counter &= 0x7; //zero higher bits, count modulo 8. 
//count rolls over at 3 bits
      call Leds.led0Off();
      call Leds.led1On();
      call Leds.led2Off();
    } else if ( switchstate == UP ) {
//      display8bits(counter);
    }
  }

  event void Timer.fired() {    
    periodhalf = !periodhalf; //every other time period get a pin value.
    if (counter == 0x0)  { pinHi = call Pin0.get();
    }
    if (counter == 0x1)  { pinHi = call Pin1.get();
    }
    if (counter == 0x2)  { pinHi = call Pin2.get();
    }
    if (counter == 0x3)  { pinHi = call Pin3.get();
    }
    if (counter == 0x4)  { pinHi = call Pin4.get();
    } 
    if (counter == 0x5)  { pinHi = call Pin5.get();
    }
    if (counter == 0x6)  { pinHi = call Pin6.get();
    }
    if (counter == 0x7)  { pinHi = call Pin7.get();
    }
    displayPin(pinHi);
  }
}

