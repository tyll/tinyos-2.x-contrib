
#include "TestCase.h"

/**
 * TWO REGISTERS DO NOT MATCH WITH THE DATASHEET:
 *  MDMCFG0: Default value is 0x0 (datasheet says 0xF8)
 *  FREND1: Default value is 0x56 (datasheet says 0xA6)
 *
 * @author David Moss
 */
module TestP {
  uses {
    interface TestControl as SetUpOneTime;
    interface BlazeStrobe as SRES;
    interface GeneralIO as CSN;
    interface Resource;
    interface BlazePower;
    interface Leds;
    
    /***************** Register Interfaces ****************/
    interface BlazeRegister as IOCFG2;
    
    /***************** Test Interfaces ****************/
    interface TestCase as ResetRadioTest;
  }
}

implementation {

  uint8_t readBuffer;
  
  event void SetUpOneTime.run() {
    call CSN.set();
    call Resource.request();
  }
  
  event void Resource.granted() {
    // Keep the resource and keep the CSN pin low so we can access registers
    call CSN.set();
    call CSN.clr();
    call SetUpOneTime.done();
  }
  
  
  /***************** TestCases ****************/
  event void ResetRadioTest.run() {
    call IOCFG2.write(0x29);
    call IOCFG2.read(&readBuffer);
    assertEquals("Wrong value", 0x29, readBuffer);
    
    call IOCFG2.write(0x0);
    call IOCFG2.read(&readBuffer);
    assertEquals("Couldn't write", 0x0, readBuffer);
    
    // RESET
    call BlazePower.reset();
    assertTrue("Csn is low after reset", call CSN.get());
    
    call CSN.clr();
    call IOCFG2.read(&readBuffer);
    assertEquals("Wrong value", 0x29, readBuffer);
    
    call CSN.set();
    call ResetRadioTest.done();
  }
  
  
}


