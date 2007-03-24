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
 * @author David Moss
 */

#include "Storage.h"

module DirectStorageP {
  provides {
    interface DirectStorage[uint8_t id];
    interface DirectModify[uint8_t id];
  }
  
  uses {
    interface At45db;
    interface At45dbVolume[uint8_t id];
    interface Resource[uint8_t id];
    interface VolumeSettings;
  }
}

implementation {

  enum {
    S_IDLE,
    S_WRITE,
    S_ERASE,
    S_READ,
    S_READ_MODIFY,
    S_FLUSH,
    S_CRC,
  };

  enum {
    N = uniqueCount(UQ_BLOCK_STORAGE) + uniqueCount(UQ_CONFIG_STORAGE),
    NO_CLIENT = 0xff
  };

  uint8_t currentClient = NO_CLIENT;
  
  uint8_t metaState;
  
  storage_addr_t bytesRemaining;
  
  at45page_t lastWritePage;
  
  nx_struct {
    nx_uint16_t crc;
    nx_uint32_t maxAddr;
  } sig;

  struct {
    /* The latest request made for this currentClient, and it's arguments */
    uint8_t request; /* automatically initialised to S_IDLE */
    uint8_t *buf;
    storage_addr_t addr;
    storage_len_t len;

    /* Maximum address written in this block */
    storage_addr_t maxAddr;
  } s[N];


  /***************** Prototypes ****************/
  void eraseStart();

  void multipageStart(storage_len_t len, uint16_t crc);

  void endRequest(error_t error, uint16_t crc);

  error_t newRequest(uint8_t newState, uint8_t id, storage_addr_t addr, 
      uint8_t* buf, storage_len_t len);

  at45page_t pageRemap(at45page_t p);

  void multipageOpDone(error_t error, uint16_t crc);
  
  
  /***************** DirectStorage Commands ****************/
  /** 
   * Read bytes from flash
   * @param addr - the address to read from
   * @param *buf - the buffer to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  command error_t DirectStorage.read[uint8_t id](uint32_t addr, void *buf, 
      uint32_t len) {
    return newRequest(S_READ, id, addr, buf, len);
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
    return newRequest(S_WRITE, id, addr, buf, len);
  }
  
  /**
   * Erase an erase unit in flash
   * @param eraseUnitIndex - the erase unit to erase
   * @return SUCCESS if the erase unit will be erased
   */
  command error_t DirectStorage.erase[uint8_t id](uint16_t eraseUnitIndex) {
    return newRequest(S_ERASE, id, eraseUnitIndex, NULL, 0);
  }
  
  /**
   * Flush written data to flash. This only applies to some flash
   * chips.
   * @return SUCCESS if the flash will be flushed
   */
  command error_t DirectStorage.flush[uint8_t id]() {
    return newRequest(S_FLUSH, id, 0, NULL, 0);
  }
  
  /**
   * Obtain the CRC of a chunk of data sitting on flash.
   * @param addr - the address to start the CRC computation
   * @param len - the amount of data to obtain the CRC for
   * @param baseCrc - the initial CRC
   * @return SUCCESS if the CRC will be computed.
   */
  command error_t DirectStorage.crc[uint8_t id](uint32_t addr, uint32_t len, 
      uint16_t baseCrc) {
    return newRequest(S_CRC, id, addr, (void *) baseCrc, len);   
  }
  
  /***************** DirectModify Commands ****************/
  /**
   * Modify bytes at the given location on flash
   * @param addr The address to modify
   * @param *buf Pointer to the buffer to write to flash
   * @param len The length of data to write
   * @return SUCCESS if the bytes will be modified
   */
  command error_t DirectModify.modify[uint8_t id](uint32_t addr, void *buf, 
      uint32_t len) {
    return newRequest(S_WRITE, id, addr, buf, len);
  }
  
  command error_t DirectModify.flush[uint8_t id]() {
    signal DirectModify.flushDone[id](SUCCESS);
    return SUCCESS;
  }
  
  command error_t DirectModify.read[uint8_t id](uint32_t addr, void *buf, 
      uint32_t len) {
    return newRequest(S_READ_MODIFY, id, addr, buf, len);
  }
  
  /**
   * @return TRUE if modify is supported on the given storage device
   */
  command bool DirectModify.isSupported[uint8_t id]() {
    return TRUE;
  }

  /***************** Resource Events ****************/
  event void Resource.granted[uint8_t id]() {
    currentClient = id;

    switch(s[currentClient].request) {
      case S_ERASE:
        call At45db.erase(pageRemap(s[currentClient].addr), AT45_ERASE);
        break;
    
      case S_FLUSH:
        call At45db.sync(lastWritePage);
        break;
        
      default:
        multipageStart(s[currentClient].len, (uint16_t) s[currentClient].buf);
        break;
    }
  }


  /***************** At45db Events ****************/
  event void At45db.writeDone(error_t error) {
    if (currentClient != NO_CLIENT) {
      multipageOpDone(error, 0);
    }
  }

  event void At45db.readDone(error_t error) {
    if (currentClient != NO_CLIENT) {
      multipageOpDone(error, 0);
    }
  }

  event void At45db.computeCrcDone(error_t error, uint16_t newCrc) {
    if (currentClient != NO_CLIENT) {
      multipageOpDone(error, newCrc);
    }
  }

  event void At45db.eraseDone(error_t error) {
    if (currentClient != NO_CLIENT) {
      endRequest(error, 0);
    }
  }

  event void At45db.syncDone(error_t error) {
    if (currentClient != NO_CLIENT) {
      if(error) {
        call At45db.sync(lastWritePage);
        
      } else {
        endRequest(error, 0); 
      }
    }
  }

  event void At45db.flushDone(error_t error) {
    if (currentClient != NO_CLIENT) {
      endRequest(error, 0);
    }
  }
  
  event void At45db.copyPageDone(error_t error) { 
  }
  
  
  /***************** Functions ****************/
  error_t newRequest(uint8_t newState, uint8_t id, storage_addr_t addr, 
      uint8_t* buf, storage_len_t len) {

    if (s[id].request != S_IDLE) {
      return EBUSY;
    }

    if (addr + len > call VolumeSettings.getVolumeSize()) {
      return EINVAL;
    }

    atomic {
      s[id].request = newState;
      s[id].addr = addr;
      s[id].buf = buf;
      s[id].len = len;
    }

    call Resource.request[id]();

    return SUCCESS;
  }
  
  void endRequest(error_t error, uint16_t crc) {
    uint8_t c = currentClient;
    uint8_t tmpState = s[c].request;
    storage_addr_t actualLength = s[c].len - bytesRemaining;
    storage_addr_t addr = s[c].addr - actualLength;
    void *ptr = s[c].buf - actualLength;
    
    currentClient = NO_CLIENT;
    s[c].request = S_IDLE;
    call Resource.release[c]();

    switch(tmpState) {
      case S_READ:
        signal DirectStorage.readDone[c](addr, ptr, actualLength, error);
        break;
      
      case S_READ_MODIFY:
        signal DirectModify.readDone[c](addr, ptr, actualLength, error);
        break;
        
      case S_WRITE:
        signal DirectStorage.writeDone[c](addr, ptr, actualLength, error);
        break;
     
      case S_ERASE:
        signal DirectStorage.eraseDone[c](s[c].addr, error);
        break;
      
      case S_CRC:
        signal DirectStorage.crcDone[c](crc, addr, actualLength, error);
        break;
      
      case S_FLUSH:
        signal DirectStorage.flushDone[c](error);
        
      default:
        break;
    }
  }

  void calcRequest(storage_addr_t addr, at45page_t *page,
               at45pageoffset_t *offset, at45pageoffset_t *count) {
    
    *page = pageRemap(addr >> AT45_PAGE_SIZE_LOG2);
    *offset = addr & ((1 << AT45_PAGE_SIZE_LOG2) - 1);
    
    if (bytesRemaining < (1 << AT45_PAGE_SIZE_LOG2) - *offset) {
      *count = bytesRemaining;
    } else {
      *count = (1 << AT45_PAGE_SIZE_LOG2) - *offset;
    }
  }

  void multipageContinue(uint16_t crc) {
    at45page_t page;
    at45pageoffset_t offset, count;
    uint8_t *buf = s[currentClient].buf;

    if (bytesRemaining == 0) {
      endRequest(SUCCESS, crc);
      return;
    }

    calcRequest(s[currentClient].addr, &page, &offset, &count);
    bytesRemaining -= count;
    s[currentClient].addr += count;
    s[currentClient].buf = buf + count;

    switch (s[currentClient].request) {
      case S_WRITE:
        lastWritePage = page;
        call At45db.write(page, offset, buf, count);
        break;
      
      case S_READ:
      case S_READ_MODIFY:
        call At45db.read(page, offset, buf, count);
        break;
     
      default:
        call At45db.computeCrc(page, offset, count, crc);
        break;
    }
  }

  void multipageStart(storage_len_t len, uint16_t crc) {
    bytesRemaining = len;
    multipageContinue(crc);
  }

  void multipageOpDone(error_t error, uint16_t crc) {
    if (error != SUCCESS) {
      endRequest(error, 0);
    } else {
      multipageContinue(crc);
    }
  } 
  
  at45page_t pageRemap(at45page_t p) {
    return call At45dbVolume.remap[currentClient](p);
  }
  
  /***************** Defaults ****************/
  default event void DirectStorage.readDone[uint8_t id](uint32_t addr, 
      void *buf, uint32_t len, error_t error) {
  }

  default event void DirectStorage.writeDone[uint8_t id](uint32_t addr, 
      void *buf, uint32_t len, error_t error) {
  }
  
  default event void DirectStorage.eraseDone[uint8_t id](uint16_t euIndex, 
      error_t error) {
  }

  default event void DirectStorage.flushDone[uint8_t id](error_t error) {
  }
  
  default event void DirectStorage.crcDone[uint8_t id](uint16_t calculatedCrc, 
      uint32_t addr, uint32_t len, error_t error) {
  }
  
  default event void DirectModify.modified[uint8_t id](uint32_t addr, 
      void *buf, uint32_t len, error_t error) {
  }

  default event void DirectModify.flushDone[uint8_t id](error_t error) {
  }

  default event void DirectModify.readDone[uint8_t id](uint32_t addr, 
      void *buf, uint32_t len, error_t error) {
  }
  
  
  default command at45page_t At45dbVolume.remap[uint8_t id](
      at45page_t volumePage) { 
    return 0; 
  }
  
  default command at45page_t At45dbVolume.volumeSize[uint8_t id]() { 
    return 0; 
  }
  
  default async command error_t Resource.request[uint8_t id]() { 
    return FAIL; 
  }
  
  default async command error_t Resource.release[uint8_t id]() {
    return FAIL;
  }
}
