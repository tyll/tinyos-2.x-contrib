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
 * Conserve RAM by sharing one DirectStorage instance with the entire
 * Blackbook system
 * @author David Moss
 */

module BlackbookDirectStorageP {
  provides {
    interface DirectStorage[uint8_t id];
  }
  
  uses {
    interface DirectStorage as SubStorage;
    interface State;
  }
}

implementation {

  uint8_t currentClient;
  
  enum {
    S_IDLE,
    S_BUSY,
  };
  
  /***************** DirectStorage ****************/
  /** 
   * Read bytes from flash
   * @param addr - the address to read from
   * @param *buf - the buffer to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  command error_t DirectStorage.read[uint8_t id](uint32_t addr, void *buf, 
      uint32_t len) {
    error_t error;
    if(call State.requestState(S_BUSY) != SUCCESS) {
      return EBUSY;
    }
    
    currentClient = id;
    if((error = call SubStorage.read(addr, buf, len)) != SUCCESS) {
      call State.toIdle();
    }
    return error;
  }
  
  /** 
   * Write bytes to flash
   * @param addr - the address to write to
   * @param *buf - the buffer to write from
   * @param len - the amount to write
   * @return SUCCESS if the bytes will be written
   */
  command error_t DirectStorage.write[uint8_t id](uint32_t addr, void *buf, 
      uint32_t len) {
    error_t error;
    if(call State.requestState(S_BUSY) != SUCCESS) {
      return EBUSY;
    }
    
    currentClient = id;
    if((error = call SubStorage.write(addr, buf, len)) != SUCCESS) {
      call State.toIdle();
    }
    return error;
  }
  
  /**
   * Erase an erase unit in flash
   * @param eraseUnitIndex - the erase unit to erase
   * @return SUCCESS if the erase unit will be erased
   */
  command error_t DirectStorage.erase[uint8_t id](uint16_t eraseUnitIndex) {
    error_t error;
    if(call State.requestState(S_BUSY) != SUCCESS) {
      return EBUSY;
    }
    
    currentClient = id;
    if((error = call SubStorage.erase(eraseUnitIndex)) != SUCCESS) {
      call State.toIdle();
    }
    return error;
  }
  
  /**
   * Flush written data to flash. This only applies to some flash
   * chips.
   * @return SUCCESS if the flash will be flushed
   */
  command error_t DirectStorage.flush[uint8_t id]() {
    error_t error;
    if(call State.requestState(S_BUSY) != SUCCESS) {
      return EBUSY;
    }
    
    currentClient = id;
    if((error = call SubStorage.flush()) != SUCCESS) {
      call State.toIdle();
    }
    
    return error;
  }
  
  /**
   * Obtain the CRC of a chunk of data sitting on flash.
   * @param addr - the address to start the CRC computation
   * @param len - the amount of data to obtain the CRC for
   * @param baseCrc - the initial crc
   * @return SUCCESS if the CRC will be computed.
   */
  command error_t DirectStorage.crc[uint8_t id](uint32_t addr, uint32_t len, 
      uint16_t baseCrc) {
    error_t error;
    if(call State.requestState(S_BUSY) != SUCCESS) {
      return EBUSY;
    }
    
    currentClient = id;
    if((error = call SubStorage.crc(addr, len, baseCrc)) != SUCCESS) {
      call State.toIdle();
    }
    return error;
  }
  
  /***************** SubStorage Events ****************/
  /**
   * Read is complete
   * @param addr - the address to read from
   * @param *buf - the buffer to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  event void SubStorage.readDone(uint32_t addr, void *buf, uint32_t len, 
      error_t error) {
    call State.toIdle();
    signal DirectStorage.readDone[currentClient](addr, buf, len, error);
  }
  
  /**
   * Write is complete
   * @param addr - the address to write to
   * @param *buf - the buffer to write from
   * @param len - the amount to write
   * @return SUCCESS if the bytes will be written
   */
  event void SubStorage.writeDone(uint32_t addr, void *buf, uint32_t len, 
      error_t error) {
    call State.toIdle();
    signal DirectStorage.writeDone[currentClient](addr, buf, len, error);
  }
  
  /**
   * Erase is complete
   * @param eraseUnitIndex - the erase unit id to erase
   * @return SUCCESS if the erase unit will be erased
   */
  event void SubStorage.eraseDone(uint16_t eraseUnitIndex, error_t error) {
    call State.toIdle();
    signal DirectStorage.eraseDone[currentClient](eraseUnitIndex, error);
  }
  
  /**
   * Flush is complete
   * @param error - SUCCESS if the flash was flushed
   */
  event void SubStorage.flushDone(error_t error) {
    call State.toIdle();
    signal DirectStorage.flushDone[currentClient](error);
  }
  
  /**
   * CRC-16 is computed
   * @param crc - the computed CRC.
   * @param addr - the address to start the CRC computation
   * @param len - the amount of data to obtain the CRC for
   * @return SUCCESS if the CRC will be computed.
   */
  event void SubStorage.crcDone(uint16_t calculatedCrc, uint32_t addr, 
      uint32_t len, error_t error) {
    call State.toIdle();
    signal DirectStorage.crcDone[currentClient](calculatedCrc, addr, len, 
        error);
  }
  
  /***************** Defaults ****************/
  default event void DirectStorage.readDone[uint8_t id](uint32_t addr, 
      void *buf, uint32_t len, error_t error) {
  }
  
  default event void DirectStorage.writeDone[uint8_t id](uint32_t addr, 
      void *buf, uint32_t len, error_t error) {
  }
  
  default event void DirectStorage.eraseDone[uint8_t id](
      uint16_t eraseUnitIndex, error_t error) {
  }
  
  default event void DirectStorage.flushDone[uint8_t id](error_t error) {
  }
  
  default event void DirectStorage.crcDone[uint8_t id](uint16_t calculatedCrc, 
      uint32_t addr, uint32_t len, error_t error) {
  }
}

