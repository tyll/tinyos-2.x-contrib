
#include "TestCase.h"

module TestSpiP {
  uses {
    interface TestCase as SpiTest;
    interface BlazeRegister as PARTNUM;
    interface BlazeStrobe as Idle;
    interface BlazeStrobe as SNOP;
    interface GeneralIO as CSN;
    interface Resource;
    interface Leds;
  }
}

implementation {

  uint8_t readBuffer;
  
  
  event void SpiTest.run() {
    call CSN.set();
    call Resource.request();
  }
  
  event void Resource.granted() {
    call CSN.clr();
    while((call Idle.strobe() & 0x80) != 0);
    call CSN.set();
    
    call CSN.clr();
    call Idle.strobe();
    assertEquals("CC2500 is not IDLE [6:4]!=0", 0, ((call PARTNUM.read(&readBuffer)) & 0x70));
    assertEquals("CC2500 didn't ID itself", 0x80, readBuffer);
    call CSN.set();
    call Resource.release();
    call Leds.led1On();
    call SpiTest.done();
  }
}


