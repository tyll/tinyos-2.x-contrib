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
 * Modify bytes on flash with the ability to cleanly overwrite
 * bytes that have already been written.  Do not attempt to use the
 * flash until InternalFlashC.DirectStorage.ready() is signaled
 *
 * @author David Moss
 */
 
module AvrStorageModifyP {
  provides {
    interface DirectModify[uint8_t id]; 
  }
  
  uses {
    interface State;
    interface DirectStorage; 
  }
}

implementation {
  
  /** The current client we're working with */
  uint8_t currentClient;
  
  /**
   * States
   */
  enum {
    S_IDLE,
    S_BUSY,
  };
  
  /***************** DirectModify Commands ****************/
  /**
   * Modify bytes at the given location on flash
   * @param addr The address to modify
   * @param *buf Pointer to the buffer to write to flash
   * @param len The length of data to write
   * @return SUCCESS if the bytes will be modified
   */
  command error_t DirectModify.modify[uint8_t id](uint32_t addr, void *buf, uint32_t len) {
    if(call State.requestState(S_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    currentClient = id;
    
    if(call DirectStorage.write(addr, buf, len) != SUCCESS) {
      call State.toIdle();
      return FAIL;
    }
    
    return SUCCESS;
  }
  
  /**
   * @return TRUE if modify is supported on the given storage device
   */
  command bool DirectModify.isSupported[uint8_t id]() { 
    return TRUE;
  }
  
  command error_t DirectModify.flush[uint8_t id]() {
    signal DirectModify.flushDone[id](SUCCESS);
    return SUCCESS;
  }
  
  command error_t DirectModify.read[uint8_t id](uint32_t addr, void *buf, uint32_t len) {
    if(call State.requestState(S_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    currentClient = id;
    
    if(call DirectStorage.read(addr, buf, len) != SUCCESS) {
      call State.toIdle();
      return FAIL;
    }
    
    return SUCCESS;
  }
  
  
  /***************** DirectFlash Events ****************/
  /**
   * Read is complete
   * @param addr - the address to read from
   * @param *buf - the buffer to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  event void DirectStorage.readDone(uint32_t addr, void *buf, uint32_t len, error_t error) {
    call State.toIdle();
    signal DirectModify.readDone[currentClient](addr, buf, len, error);
  }
  
  /**
   * Write is complete
   * @param addr - the address to write to
   * @param *buf - the buffer to write from
   * @param len - the amount to write
   * @return SUCCESS if the bytes will be written
   */
  event void DirectStorage.writeDone(uint32_t addr, void *buf, uint32_t len, error_t error) {
    call State.toIdle();
    signal DirectModify.modified[currentClient](addr, buf, len, error);
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
  
  /***************** Defaults ****************/
  default event void DirectModify.modified[uint8_t id](uint32_t addr, void *buf, uint32_t len, error_t error) {
  }
  
  default event void DirectModify.flushDone[uint8_t id](error_t error) {
  }
  
  default event void DirectModify.readDone[uint8_t id](uint32_t addr, void *buf, uint32_t len, error_t error) {
  }
  
}

 
