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
 * On the msp, the flash must first be erased before a value
 * can be written. However, the msp can only erase the flash at a
 * segment granularity (128 bytes for the information section). This
 * module allows transparent read/write of individual bytes to the
 * information section by dynamically switching between the two
 * provided segments in the information section.
 *
 * Valid address range is 0x1000 - 0x107E (0x107F is used to store the
 * version number of the information segment).
 *
 * @author Jonathan Hui <jhui@archrock.com>
 * @author David Moss
 */


module Msp430StorageModifyP {
  provides {
    interface DirectModify[uint8_t id];
    interface VolumeSettings;
  }
}

implementation {

  enum {
    IFLASH_BOUND_HIGH = 0x7E,
    IFLASH_OFFSET     = 0x1000,
    IFLASH_SIZE       = 128,
    IFLASH_SEG0_VNUM_ADDR = 0x107F,
    IFLASH_SEG1_VNUM_ADDR = 0x10FF,
    IFLASH_INVALID_VNUM = -1,
  };

  /***************** Prototypes ****************/
  uint8_t chooseSegment();
  
  /***************** DirectModify Commands ****************/
  /**
   * @return TRUE if modify is supported on the given storage device
   */
  command bool DirectModify.isSupported[uint8_t id]() {
    return TRUE;
  }
  
 
  /**
   * Modify bytes at the given location on flash
   * @param addr The address to modify
   * @param *buf Pointer to the buffer to write to flash
   * @param len The length of data to write
   * @return SUCCESS if the bytes will be modified
   */
  command error_t DirectModify.modify[uint8_t id](uint32_t addr, void *buf, uint32_t len) {

    volatile int8_t *newPtr;
    int8_t *oldPtr;
    int8_t *bufPtr = (int8_t*)buf;
    int8_t version;
    uint16_t i;

    if (IFLASH_BOUND_HIGH + 2 < (uint16_t)addr + len) {
      return FAIL;
    }

    addr += IFLASH_OFFSET;
    newPtr = oldPtr = (int8_t*) IFLASH_OFFSET;
    if (chooseSegment()) {
      oldPtr += IFLASH_SIZE;
    } else {
      addr += IFLASH_SIZE;
      newPtr += IFLASH_SIZE;
    }
    
    atomic {                         // Disable interrupts
      FCTL2 = FWKEY + FSSEL1 + FN2;  // SMCLK/2
      FCTL3 = FWKEY;                 // Clear LOCK
      FCTL1 = FWKEY + ERASE;         // Enable segment erase
      *newPtr = 0;                   // Dummy write, erase the selected segment
      FCTL1 = FWKEY + WRT;           // Enable write

      for ( i = 0; i < IFLASH_SIZE-1; i++, newPtr++, oldPtr++ ) {
        if ((uint16_t)newPtr < (uint16_t)addr || (uint16_t)addr + len <= (uint16_t)newPtr) {
          *newPtr = *oldPtr;
        } else {
          *newPtr = *bufPtr++;
        }
      }
      
      version = *oldPtr + 1;
      if (version == IFLASH_INVALID_VNUM) {
        version++;
      }
      
      *newPtr = version;

      FCTL1 = FWKEY;
      FCTL3 = FWKEY + LOCK;
    }

    signal DirectModify.modified[id](addr, buf, len, SUCCESS);
    return SUCCESS;

  }
  
  /**
   * Ensure all recent changes are made to flash
   */
  command error_t DirectModify.flush[uint8_t id]() {
    signal DirectModify.flushDone[id](SUCCESS);
    return SUCCESS;
  }
  

  command error_t DirectModify.read[uint8_t id](uint32_t addr, void *buf, uint32_t len) {
    void *address = (uint16_t *) ((uint16_t) addr);
    address += IFLASH_OFFSET;
    if (chooseSegment()) {
      address += IFLASH_SIZE;
    }

    memcpy(buf, address, len);

    signal DirectModify.readDone[id](addr, buf, len, SUCCESS);
    return SUCCESS;
  }


  /***************** VolumeSettings Commands ****************/
  /**
   * @return the total size of the flash
   */
  command uint32_t VolumeSettings.getVolumeSize() {
    return 127;
  }
  
  /**
   * @return the total number of erase units on the flash
   */
  command uint32_t VolumeSettings.getTotalEraseUnits() {
    return 1;
  }
  
  /**
   * @return the erase unit size
   */
  command uint32_t VolumeSettings.getEraseUnitSize() {
    return 127;
  }
  
  /**
   * @return the total write units on flash
   */
  command uint32_t VolumeSettings.getTotalWriteUnits() {
    return 127;
  }
  
  /**
   * @return the total write unit size
   */
  command uint32_t VolumeSettings.getWriteUnitSize() {
    return 1;
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
  
  /***************** Functions ****************/
  uint8_t chooseSegment() {
    int8_t vnum0 = *(int8_t*)IFLASH_SEG0_VNUM_ADDR;
    int8_t vnum1 = *(int8_t*)IFLASH_SEG1_VNUM_ADDR;
    
    if (vnum0 == IFLASH_INVALID_VNUM) {
      return 1;
      
    } else if (vnum1 == IFLASH_INVALID_VNUM) {
      return 0;
      
    } else {
      return ( (int8_t)(vnum0 - vnum1) < 0 );
    }
  }
  
  /***************** Defaults ****************/
  default event void DirectModify.modified[uint8_t id](uint32_t addr, void *buf, uint32_t len, error_t error) {
  }
  
  default event void DirectModify.flushDone[uint8_t id](error_t error) {
  }
  
  default event void DirectModify.readDone[uint8_t id](uint32_t addr, void *buf, uint32_t len, error_t error) {
  }
  
}
