
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
    interface Resource as Resource2;
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
    call SetUpOneTime.done();
  }
  
  
  /***************** TestCases ****************/
  event void ResetRadioTest.run() {
    call Resource.request();
  }
  
  event void Resource.granted() {
    call CSN.clr();
    call IOCFG2.write(0x29);
    call IOCFG2.read(&readBuffer);
    assertEquals("Wrong init value", 0x29, readBuffer);
    
    call IOCFG2.write(0x0);
    call IOCFG2.read(&readBuffer);
    assertEquals("Couldn't write over init", 0x0, readBuffer);
    
    call CSN.set();
    call Resource.release();
    
    // RESET
    assertEquals("reset() failed", SUCCESS, call BlazePower.reset());
    
  }
  
  
  event void BlazePower.resetComplete() {
    assertTrue("Csn is low after reset", call CSN.get());
    
    call Resource2.request();
  }
  
  event void Resource2.granted() {
    call CSN.clr();
    call IOCFG2.read(&readBuffer);
    assertEquals("Wrong reset value", 0x29, readBuffer);
    
    call CSN.set();
    call Resource2.release();
    call ResetRadioTest.done();
  }
  
  
  event void BlazePower.deepSleepComplete() {
  }
  
  
  
}


