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
 * Blackbook BClean Module
 * This is the garbage collector.
 * @author David Moss - dmm@rincon.com
 */

module BCleanP {
  provides {
    interface BClean;
  }
  
  uses {
    interface DirectStorage;
    interface VolumeSettings;
    interface EraseUnitMap;
    interface State as BlackbookState;
  }
}

implementation {

  /** The current sector index we're looking at */
  uint8_t currentEraseBlockIndex;
  
  /** TRUE if we erased one sector on the last run */
  bool erased = FALSE;
  
  /** The focused erase unit in our erase block to erase */
  uint8_t focusedEraseUnit;
  
  /** SUCCESS if atleast one sector was erased **/
  error_t sectorErased;
  
  /***************** Prototypes *****************/
  /** Loop to search and destroy erasable sectors */
  task void garbageLoop();
  
  /** Erase an individual erase unit in the focused erase block */
  task void erase();
  
  /***************** BClean Commands ****************/
  /**
   * If the free space on the file system is over a threshold
   * then we should go ahead and defrag and garbage collect.
   * This should be run when the mote has some time and energy
   * to spare in its application.
   * @return SUCCESS if the file system will defrag and gc itself
   */
  command error_t BClean.performCheckup() {
    if(call EraseUnitMap.getFreeSpace() < call VolumeSettings.getVolumeSize() 
        * 0.75) {
      return call BClean.gc();
    }
    return FAIL;
  }
  
  /**  
   * Run the garbage collector, erasing any sectors that 
   * contain any data with 0 valid nodes.
   * @return SUCCESS if the garbage collector is run
   */
  command error_t BClean.gc() {
    // We don't force BlackbookState to be busy, because it may already be busy
    call BlackbookState.requestState(S_GC_BUSY);
    currentEraseBlockIndex = 0;
    erased = FALSE;
    post garbageLoop();
    return SUCCESS;
  }
  
  /***************** DirectStorage Events ****************/
  /**
   * Read is complete
   * @param addr - the address to read from
   * @param *buf - the buffer to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  event void DirectStorage.readDone(uint32_t addr, void *buf, uint32_t len,
      error_t error) {
  }
  
  /**
   * Write is complete
   * @param addr - the address to write to
   * @param *buf - the buffer to write from
   * @param len - the amount to write
   * @return SUCCESS if the bytes will be written
   */
  event void DirectStorage.writeDone(uint32_t addr, void *buf, uint32_t len, 
      error_t error) {
  }
  
  /**
   * Erase is complete
   * @param sector - the sector id to erase
   * @return SUCCESS if the sector will be erased
   */
  event void DirectStorage.eraseDone(uint16_t eraseUnit, error_t error) {
    focusedEraseUnit++;
    erased = TRUE;
    if(focusedEraseUnit < call EraseUnitMap.getTotalEraseUnits(call EraseUnitMap.getEraseBlock(currentEraseBlockIndex))) {
      post erase();
    
    } else {
      call EraseUnitMap.eraseComplete(currentEraseBlockIndex);
      currentEraseBlockIndex++;
      post garbageLoop();
    }
  }
  
  /**
   * Flush is complete
   * @param error - SUCCESS if the flash was flushed
   */
  event void DirectStorage.flushDone(error_t error) {
    if(call BlackbookState.getState() == S_GC_BUSY) {
      call BlackbookState.toIdle();
    }
    
    if(erased){
      sectorErased = SUCCESS;
    }
    else{
      sectorErased = FAIL;
    }
    
    signal BClean.gcDone(sectorErased);
  }
  
  /**
   * CRC-16 is computed
   * @param crc - the computed CRC.
   * @param addr - the address to start the CRC computation
   * @param len - the amount of data to obtain the CRC for
   * @return SUCCESS if the CRC will be computed.
   */
  event void DirectStorage.crcDone(uint16_t calculatedCrc, uint32_t addr, 
      uint32_t len, error_t error) {
  }

  
  /***************** Tasks ****************/
  /** 
   * When entering the garbageLoop for the first time,
   * make sure the currentEraseBlockIndex = 0
   */
  task void garbageLoop() {
    if(currentEraseBlockIndex < call EraseUnitMap.getTotalEraseBlocks()) {
      if(call EraseUnitMap.canErase(call EraseUnitMap.getEraseBlock(
          currentEraseBlockIndex))) {
        signal BClean.erasing();
        focusedEraseUnit = 0;
        post erase();
        
      } else {
        currentEraseBlockIndex++;
        post garbageLoop();
        return;
      }
      
    } else {
      call DirectStorage.flush();
    }
  }
  
  /** 
   * Erase an individual erase unit in the focused erase block 
   */
  task void erase() {
    if(call DirectStorage.erase(call EraseUnitMap.getBaseEraseUnit(call EraseUnitMap.getEraseBlock(currentEraseBlockIndex)) + focusedEraseUnit) != SUCCESS) {
      post erase();
    }
  }
}


