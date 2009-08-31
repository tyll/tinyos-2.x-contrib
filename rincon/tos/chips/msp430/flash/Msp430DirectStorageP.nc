/*
 * Copyright (c) 2005-2006 Rincon Research Corporation
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Rincon Research Corporation nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * ARCHED ROCK OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */

/**
 * DirectStorage implementation for the MSP430 internal flash
 * Start address is 0x0
 * End address is 0xFF
 *
 * @author David Moss
 */

#include "Msp430VolumeSettings.h"
#include "crc.h"

module Msp430DirectStorageP {
  provides {
    interface DirectStorage[uint8_t id];
    interface VolumeSettings;
  }
}

implementation {

#ifndef FLASH_TIMING
#warning "Flash timing generator presumes 4MHz MCLK"
  // 1<<22 MCLK divided by 12 -> 350 kHz
  // FCTL2 gets divisor minus one -> 11
#define FLASH_TIMING (FSSEL0 | FN3 | FN1 | FN0)
#endif

  enum {
    FLASH_OFFSET = 0x1000,
  };

  
  /***************** DirectStorage Commands ****************/
  /** 
   * Read bytes from flash
   * @param addr - the address to read from
   * @param *buf - the buffer to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  command error_t DirectStorage.read[uint8_t id](uint32_t addr, void *buf, uint32_t len) {
    void *addressPtr = (uint16_t *) ((uint16_t) addr); 
     
    if(addr + len > call VolumeSettings.getVolumeSize()) {
      return FAIL;
    }
    
    addressPtr += FLASH_OFFSET;
 
    memcpy(buf, addressPtr, len);
    signal DirectStorage.readDone[id](addr, buf, len, SUCCESS);
    return SUCCESS;   
  }
  
  /** 
   * Write bytes to flash
   * @param addr - the address to write to
   * @param *buf - the buffer to write from
   * @param len - the amount to write
   * @return SUCCESS if the bytes will be written
   */
  command error_t DirectStorage.write[uint8_t id](uint32_t addr, void *buf, uint32_t len) {
    void *addressPtr = (uint16_t *) ((uint16_t) addr); 
    
    if(addr + len > call VolumeSettings.getVolumeSize()) {
      return FAIL;
    }
    
    addressPtr += FLASH_OFFSET;

    atomic {
      FCTL2 = FWKEY + FLASH_TIMING;
      FCTL3 = FWKEY;      
      FCTL1 = FWKEY + WRT;
      memcpy(addressPtr, buf, len);
      FCTL3 = FWKEY + LOCK;
    }
    
    signal DirectStorage.writeDone[id](addr, buf, len, SUCCESS);
    return SUCCESS;
  }
  
  /**
   * Erase a eraseUnitIndex in internal flash
   *
   * @param eraseUnitIndex - the eraseUnitIndex to erase, starting at 0
   * @return SUCCESS if the eraseUnitIndex will be erased
   */
  command error_t DirectStorage.erase[uint8_t id](uint16_t eraseUnitIndex) {
    uint16_t *addressPtr;
    if(eraseUnitIndex > call VolumeSettings.getTotalEraseUnits()) {
      return FAIL;
    }
    
    addressPtr = (uint16_t *) (FLASH_OFFSET + ((uint16_t) call VolumeSettings.getEraseUnitSize() * (uint16_t) eraseUnitIndex));

    atomic {
      FCTL2 = FWKEY + FLASH_TIMING;
      FCTL3 = FWKEY;
      FCTL1 = FWKEY + ERASE;
      *addressPtr = 0;
      FCTL3 = FWKEY + LOCK;
    }
    
    signal DirectStorage.eraseDone[id](eraseUnitIndex, SUCCESS);
    return SUCCESS;
  }
  
  /**
   * Flush written data to flash. This only applies to some flash
   * chips.
   * @return SUCCESS if the flash will be flushed
   */
  command error_t DirectStorage.flush[uint8_t id]() {
    signal DirectStorage.flushDone[id](SUCCESS);
    return SUCCESS;
  }
  
  /**
   * Obtain the CRC of a chunk of data sitting on flash.
   * @param addr - the address to start the CRC computation
   * @param len - the amount of data to obtain the CRC for
   * @param runningCrc - the initial CRC
   * @return SUCCESS if the CRC will be computed.
   */
  command error_t DirectStorage.crc[uint8_t id](uint32_t addr, uint32_t len, uint16_t runningCrc) {
    uint8_t *addressPtr = (uint8_t *) ((uint16_t) addr);
    int i;
    
    if(addr + len > call VolumeSettings.getVolumeSize()) {
      return FAIL;
    }
    
    addressPtr += FLASH_OFFSET;
    
    for(i = 0; i < len; i++) {
      runningCrc = crcByte(runningCrc, (uint8_t) *addressPtr++);
    }
    
    signal DirectStorage.crcDone[id](runningCrc, addr, len, SUCCESS);
    return SUCCESS;
  }
  
  
  /***************** VolumeSettings Commands ****************/
  /**
   * @return the total size of the flash
   */
  command uint32_t VolumeSettings.getVolumeSize() {
    return MSP430_ERASE_UNIT_LENGTH * MSP430_ERASE_UNITS;
  }
  
  /**
   * @return the total number of erase units on the flash
   */
  command uint32_t VolumeSettings.getTotalEraseUnits() {
    return MSP430_ERASE_UNITS;
  }
  
  /**
   * @return the erase unit size
   */
  command uint32_t VolumeSettings.getEraseUnitSize() {
    return MSP430_ERASE_UNIT_LENGTH;
  }
  
  /**
   * @return the total write units on flash
   */
  command uint32_t VolumeSettings.getTotalWriteUnits() {
    return MSP430_WRITE_UNITS;
  }
  
  /**
   * @return the total write unit size
   */
  command uint32_t VolumeSettings.getWriteUnitSize() {
    return MSP430_WRITE_UNIT_LENGTH;
  }
  
  /**
   * @return the fill byte used on this flash when the flash is empty
   */
  command uint8_t VolumeSettings.getFillByte() {
    return MSP430_FILL_BYTE;
  }
  
  /**
   * We can use the Log base-2 value to calculate
   * the erase unit number by taking an address and
   * shifting it right by the log2 size of the erase units.
   *
   * Here's an example. If erase units are size 0x10000
   * then that means that the log base-2 value is
   * 16. If we want to know which erase unit index address
   * 0x12345 exists within, we take (0x12345 >> 16) == 1.
   * Erase unit index number 1. Simple enough.
   *
   * @return the erase unit size in Log base-2 format
   */
  command uint8_t VolumeSettings.getEraseUnitSizeLog2() {
    return MSP430_ERASE_UNIT_LENGTH_LOG2;
  }
  
  /**
   * We can use the Log base-2 value to calculate
   * the write unit number by taking an address and
   * shifting it right by the log2 size of the write units.
   *
   * Here's an example. If erase units are size 0x100
   * then that means that the log base-2 value is
   * 8. If we want to know which erase unit index address
   * 0x123 exists within, we take (0x123 >> 8) == 1.
   * Write unit index number 1. Simple enough.
   *
   * @return the write unit size in Log2 base-2 format
   */
  command uint8_t VolumeSettings.getWriteUnitSizeLog2() {
    return MSP430_WRITE_UNIT_LENGTH_LOG2;
  }
  
  /***************** Defaults ****************/
  default event void DirectStorage.readDone[uint8_t id](uint32_t addr, void *buf, uint32_t len, error_t error) {
  }
  
  default event void DirectStorage.writeDone[uint8_t id](uint32_t addr, void *buf, uint32_t len, error_t error) {
  }
  
  default event void DirectStorage.eraseDone[uint8_t id](uint16_t sector, error_t error) {
  }
  
  default event void DirectStorage.flushDone[uint8_t id](error_t error) {
  }
  
  default event void DirectStorage.crcDone[uint8_t id](uint16_t calculatedCrc, uint32_t addr, uint32_t len, error_t error) {
  }
  
}

