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
 * NO FAULT TOLERANCE!
 * Modify bytes on flash with the ability to cleanly overwrite
 * bytes that have already been written
 *
 * Users should use the DirectStorage to know when the flash is
 * ready to be written.
 * 
 * We know from the Msp430DirectStorage implementation that Msp430 
 * flash transactions are not split-phase.  We use this fact
 * in this particular implementation to do some sneaky stuff
 * that you wouldn't normally do without a global originalContents, complex 
 * state machine, and proper event handling.
 * 
 * The modify process here is a standard read-modify-write:
 *   1: Read the segment of the msp430 flash into RAM.
 *   2: Erase the segment of flash.
 *   3: Write the data back to flash with modifications in place.
 * 
 * @author David Moss
 */

#include "Msp430VolumeSettings.h"

module Msp430StorageModifyP {
  provides {
    interface DirectModify[uint8_t id]; 
  }
  
  uses {
    interface VolumeSettings;
    interface DirectStorage;
    interface State;
  }
}

implementation {
  
  /** The current client we're working with */
  uint8_t currentClient;
  
  /** The contents of a segment (erase unit) on our msp430's internal flash */
  uint8_t originalContents[MSP430_ERASE_UNIT_LENGTH];
  
  /**
   * States
   */
  enum {
    S_IDLE,
    S_BUSY,
  };
  
  /***************** Prototypes ****************/
  error_t modify(uint32_t addr, uint8_t *buf, uint32_t len);
  
  /***************** DirectModify Commands ****************/
  /**
   * Modify bytes at the given location on flash
   * @param addr The address to modify
   * @param *buf Pointer to the originalContents to write to flash
   * @param len The length of data to write
   * @return SUCCESS if the bytes will be modified
   */
  command error_t DirectModify.modify[uint8_t id](uint32_t addr, void *buf, uint32_t len) {
    if(call State.requestState(S_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    if(addr + len > call VolumeSettings.getVolumeSize()) {
      call State.toIdle();
      return FAIL;
    }
    
    currentClient = id;
    
    // modify() clears the State and signals the modified event
    return modify(addr, buf, len);
  }
  
  /**
   * @return TRUE if modify is supported on the given storage device
   */
  command bool DirectModify.isSupported[uint8_t id]() {
    return TRUE;
  }
  
  
  /***************** DirectStorage Events ****************/
  /**
   * Read is complete
   * @param addr - the address to read from
   * @param *buf - the originalContents to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  event void DirectStorage.readDone(uint32_t addr, void *buf, uint32_t len, error_t error) {
  }
  
  /**
   * Write is complete
   * @param addr - the address to write to
   * @param *buf - the originalContents to write from
   * @param len - the amount to write
   * @return SUCCESS if the bytes will be written
   */
  event void DirectStorage.writeDone(uint32_t addr, void *buf, uint32_t len, error_t error) {
  }
  
  /**
   * Erase is complete
   * @param eraseUnitIndex - the erase unit id to erase
   * @return SUCCESS if the erase unit will be erased
   */
  event void DirectStorage.eraseDone(uint16_t eraseUnitIndex, error_t error) {
  }
  
  /**
   * Flush is complete
   * @param error - SUCCESS if the flash was flushed
   */
  event void DirectStorage.flushDone(error_t error) {
  }
  
  /**
   * CRC-16 is computed
   * @param crc - the computed CRC.
   * @param addr - the address to start the CRC computation
   * @param len - the amount of data to obtain the CRC for
   * @return SUCCESS if the CRC will be computed.
   */
  event void DirectStorage.crcDone(uint16_t calculatedCrc, uint32_t addr, uint32_t len, error_t error) {
  }

  /***************** Functions ****************/
  /**
   * This function can probably be applied to flash chips many small
   * erase units.  But it won't work for huge erase units.
   */
  error_t modify(uint32_t addr, uint8_t *buf, uint32_t len) {
    uint8_t eraseUnit;
    uint32_t eraseUnitAddress;
    uint8_t *contentsPtr;
    int i;
    
    for(eraseUnit = 0; eraseUnit < call VolumeSettings.getTotalEraseUnits(); eraseUnit++) {
      eraseUnitAddress = eraseUnit * call VolumeSettings.getEraseUnitSize();
      
      // Find out if the modified memory is within the current erase unit bounds
      if(((addr + len > eraseUnitAddress) && (addr < (eraseUnitAddress + call VolumeSettings.getEraseUnitSize())))
          || ((addr < eraseUnitAddress) && (addr + len > eraseUnitAddress + call VolumeSettings.getEraseUnitSize()))
          || ((addr + len > eraseUnitAddress) && (addr + len < eraseUnitAddress + call VolumeSettings.getEraseUnitSize()))) {
          
        // The modified bytes are within this erase unit
        call DirectStorage.read(eraseUnitAddress, originalContents, call VolumeSettings.getEraseUnitSize());
        call DirectStorage.erase(eraseUnit);        
        contentsPtr = originalContents;
        
        for(i = eraseUnitAddress; i < eraseUnitAddress + call VolumeSettings.getEraseUnitSize(); i++) {
          if(i < addr || i >= addr + len) {
            call DirectStorage.write(i, contentsPtr, 1);
          } else {
            call DirectStorage.write(i, buf, 1);
            *buf++;
          }
          *contentsPtr++;
        }
      }
    }
    
    call State.toIdle();
    signal DirectModify.modified[currentClient](addr, buf, len, SUCCESS);
    return SUCCESS;
  }
  
  
  /***************** Defaults ****************/
  default event void DirectModify.modified[uint8_t id](uint32_t addr, void *buf, uint32_t len, error_t error) {
  }
    
}

