
#include "TestCase.h"

module TestSpiP {
  uses {
    interface TestCase as SpiTest;
    interface BlazeRegister as PARTNUM;
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
    call CSN.set();
    call CSN.clr();
    assertEquals("CC1100 is not IDLE [6:4]!=0", 0, ((call PARTNUM.read(&readBuffer)) & 0x70));
    assertEquals("CC1100 didn't ID itself", 0x0, readBuffer);
    call CSN.set();
    call Resource.release();
    call Leds.led1On();
    call SpiTest.done();
  }
}


