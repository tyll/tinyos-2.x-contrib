
#include "TestCase.h"

/**
 * This will test out the direct storage interface with the flash
 * which also tests out the SPI access and the physical integrity of the
 * flash chip.
 * 
 * @author David Moss
 */
 
module TestDirectStorageP {
  uses {
    interface DirectStorage;
    interface VolumeSettings;
    interface Leds;
    interface State;
    
    interface TestControl as SetUp;
    
    interface TestCase as TestErase1;
    interface TestCase as TestWrite;
    interface TestCase as TestRead;
    interface TestCase as TestErase2;
  }
}

implementation {

  enum {
    S_ERASE1,
    S_WRITE,
    S_READ,
    S_ERASE2,
  };
  
  uint32_t currentAddress;
  
  uint8_t page[256];
  
  uint8_t expected[256];
  
  /***************** TestControl ****************/
  event void SetUp.run() {
    currentAddress = 0;
    call SetUp.done();
  }
  
  /***************** Tests ****************/
  event void TestErase1.run() {
    error_t error;
    call State.forceState(S_ERASE1);
    
    if((error = call DirectStorage.erase(currentAddress)) != SUCCESS) {
      assertEquals("erase() error", SUCCESS, error);
      call TestErase1.done();
    }
  }
  
  event void TestWrite.run() {
    error_t error;
    
    call State.forceState(S_WRITE);
    memset(&page, 0x0, sizeof(page));
    
    if((error = call DirectStorage.write(currentAddress, &page, sizeof(page))) != SUCCESS) {
      assertEquals("write() error", SUCCESS, error);
      call TestWrite.done();
    }
  }
  
  event void TestRead.run() {
    error_t error;
    
    call State.forceState(S_READ);
    memset(&page, 0x0, sizeof(page));
    memset(&expected, 0x0, sizeof(expected));
    
    if((error = call DirectStorage.read(currentAddress, &page, sizeof(page))) != SUCCESS) {
      assertEquals("read() error", SUCCESS, error);
      call TestRead.done();
    }
  }
  
  event void TestErase2.run() {
    error_t error;
    call State.forceState(S_ERASE1);
    
    if((error = call DirectStorage.erase(currentAddress)) != SUCCESS) {
      assertEquals("erase() error", SUCCESS, error);
      call TestErase2.done();
    }
  }
  

  /***************** DirectStorage Events ****************/
  event void DirectStorage.readDone(uint32_t addr, void *buf, uint32_t len, error_t error) {
    error_t commandError;
    call Leds.led0Off();
    call Leds.led1Off();
    call Leds.led2Toggle();
    
    currentAddress += sizeof(page);
    
    if(call State.isState(S_ERASE1)) {
      
      if(memcmp(&page, &expected, len) != 0) {
        assertEquals("Failure at address", -1, currentAddress);
      }
      
      if(currentAddress < call VolumeSettings.getVolumeSize()) {
        if((commandError = call DirectStorage.read(currentAddress, &page, sizeof(page))) != SUCCESS) {
          assertEquals("Sub-read error", SUCCESS, commandError);
        }
        
      } else {
        assertSuccess();
        call TestErase1.done();
      }
      
    } else if(call State.isState(S_READ)) {
    
      if(memcmp(&page, &expected, len) != 0) {
        assertEquals("Failure at address", -1, currentAddress);
      }
      
      if(currentAddress < call VolumeSettings.getVolumeSize()) {
        if((commandError = call DirectStorage.read(currentAddress, &page, sizeof(page))) != SUCCESS) {
          assertEquals("Sub-read error", SUCCESS, commandError);
          call TestRead.done();
        }
        
      } else {
        assertSuccess();
        call TestRead.done();
      }
      
    } else if(call State.isState(S_ERASE2)) {
      if(memcmp(&page, &expected, len) != 0) {
        assertEquals("Failure at address", -1, currentAddress);
      }
      
      if(currentAddress < call VolumeSettings.getVolumeSize()) {
        if((commandError = call DirectStorage.read(currentAddress, &page, sizeof(page))) != SUCCESS) {
          assertEquals("Sub-read error", SUCCESS, commandError);
        }
        
      } else {
        assertSuccess();
        call TestErase2.done();
      }
      
    } else {
      assertFail("Wrong time for readDone()");
    }
  }
  
  event void DirectStorage.writeDone(uint32_t addr, void *buf, uint32_t len, error_t error) {
    error_t commandError;
    
    call Leds.led0Off();
    call Leds.led1Toggle();
    call Leds.led2Off();

    currentAddress += sizeof(page);

    if(call State.isState(S_WRITE)) {
      if(currentAddress < call VolumeSettings.getVolumeSize()) {
        if((commandError = call DirectStorage.write(currentAddress, &page, sizeof(page))) != SUCCESS) {
          assertEquals("Sub-write error", SUCCESS, commandError);
          assertEquals("Write failed at address", -1, currentAddress);
          call TestWrite.done();
        }
      
      } else {
        assertSuccess();
        call TestWrite.done();
      }
      
    } else {
      assertFail("Wrong time for writeDone()");
    }
  }
  
  event void DirectStorage.eraseDone(uint16_t eraseUnitIndex, error_t error) {
    error_t commandError;
    call Leds.led0Toggle();
    call Leds.led1Off();
    call Leds.led2Off();
    
    if(error) {
      assertEquals("eraseDone() error", SUCCESS, error);
    }
    
    currentAddress++;
    if(currentAddress < call VolumeSettings.getTotalEraseUnits()) {
      // Keep erasing
      if((commandError = call DirectStorage.erase(currentAddress)) != SUCCESS) {
        assertEquals("Sub-erase() error", SUCCESS, commandError);
      }
      
    } else {
      // Read everything back and make sure we're all 0xFF's (fill byte).
      memset(&expected, call VolumeSettings.getFillByte(), sizeof(expected));
      
      currentAddress = 0;
      if((commandError = call DirectStorage.read(currentAddress, &page, sizeof(page))) != SUCCESS) {
        assertEquals("Erase/read() error", SUCCESS, commandError);
      }
    }
  }
  
  event void DirectStorage.flushDone(error_t error) {
  }
  
  event void DirectStorage.crcDone(uint16_t calculatedCrc, uint32_t addr, uint32_t len, error_t error) {
  }
  
}

