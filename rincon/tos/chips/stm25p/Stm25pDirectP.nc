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
 * @author Jonathan Hui
 */

module Stm25pDirectP {
  provides {
    interface DirectStorage[uint8_t id];
    interface DirectModify[uint8_t id];
  }
  
  uses {
    interface Stm25pSector as Sector[uint8_t id];
    interface Resource as ClientResource[uint8_t id];
    interface VolumeSettings;
    interface Leds;
  }
}

implementation {

  enum {
    NUM_DIRECT = uniqueCount("Stm25p.Direct"),
  };
  
  typedef enum {
    S_IDLE,
    S_READ,
    S_WRITE,
    S_ERASE,
    S_FLUSH,
    S_CRC,
  } stm25p_direct_req_t;
  
  typedef struct stm25p_direct_state_t {
    storage_addr_t addr;
    void* buf;
    storage_len_t len;
    stm25p_direct_req_t req;
  } stm25p_direct_state_t;
  
  
  stm25p_direct_state_t m_direct_state[NUM_DIRECT];
  
  stm25p_direct_state_t m_req;
  
  
  /***************** Prototypes ****************/
  error_t newRequest(uint8_t client);
  void signalDone(uint8_t id, uint16_t crc, error_t error);
  
  
  /***************** DirectStorage Commands ****************/
  /** 
   * Read bytes from this volume
   * @param addr - the address to read from
   * @param *buf - the buffer to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  command error_t DirectStorage.read[uint8_t id](uint32_t addr, void *buf, 
      uint32_t len) {
      
    if(addr + len > call VolumeSettings.getVolumeSize()) {
      return EINVAL;
    }
    
    m_req.req = S_READ;
    m_req.addr = addr;
    m_req.buf = buf;
    m_req.len = len;
    return newRequest(id);
  }
   
  
  /** 
   * Write bytes to this volume
   * @param addr - the address to write to
   * @param *buf - the buffer to write from
   * @param len - the amount to write
   * @return SUCCESS if the bytes will be written
   */
  command error_t DirectStorage.write[uint8_t id](uint32_t addr, void *buf, 
      uint32_t len) {
      
    if(addr + len > call VolumeSettings.getVolumeSize()) {
      return EINVAL;
    }
    
    m_req.req = S_WRITE;
    m_req.addr = addr;
    m_req.buf = buf;
    m_req.len = len;
    return newRequest(id);
  }
  
  /**
   * Erase an erase unit in this volume
   * @param eraseUnitIndex - the erase unit to erase
   * @return SUCCESS if the erase unit will be erased
   */
  command error_t DirectStorage.erase[uint8_t id](uint16_t eraseUnitIndex) {
    if(eraseUnitIndex * call VolumeSettings.getEraseUnitSize() 
        > call VolumeSettings.getVolumeSize()) {
      return EINVAL;
    }
    
    m_req.req = S_ERASE;
    m_req.addr = eraseUnitIndex;
    return newRequest(id);
  }
  
  /**
   * Flush written data to this volume. This only applies to some flash
   * chips.
   * @return SUCCESS if the flash will be flushed
   */
  command error_t DirectStorage.flush[uint8_t id]() {
    signal DirectStorage.flushDone[id](SUCCESS);
    return SUCCESS;
  }
  
  /**
   * Obtain the CRC of a chunk of data sitting on this volume.
   * @param addr - the address to start the CRC computation
   * @param len - the amount of data to obtain the CRC for
   * @return SUCCESS if the CRC will be computed.
   */
  command error_t DirectStorage.crc[uint8_t id](uint32_t addr, uint32_t len, uint16_t baseCrc) {
    if(addr + len > call VolumeSettings.getVolumeSize()) {
      return EINVAL;
    }
    
    m_req.req = S_CRC;
    m_req.addr = addr;
    m_req.buf = (void *) baseCrc;
    m_req.len = len;
    return newRequest(id);
  }
  
  
  /***************** DirectModify Commands ****************/
  /**
   * Modify bytes at the given location on this volume
   * @param addr The address to modify
   * @param *buf Pointer to the buffer to write to flash
   * @param len The length of data to write
   * @return SUCCESS if the bytes will be modified
   */
  command error_t DirectModify.modify[uint8_t id](uint32_t addr, void *buf, 
      uint32_t len) {
    return FAIL;
  }
  
  /**
   * @return TRUE if modify is supported on the given storage device
   */
  command bool DirectModify.isSupported[uint8_t id]() {
    return FALSE;
  }
  
  command error_t DirectModify.read[uint8_t id](uint32_t addr, void *buf, 
      uint32_t len) {
    return FAIL;
  }

  command error_t DirectModify.flush[uint8_t id]() {
    return FAIL;
  }
  
  /***************** ClientResource Events ****************/
  event void ClientResource.granted[uint8_t id]() {
    
    switch(m_direct_state[id].req) {
    case S_READ:
      call Sector.read[id](m_direct_state[id].addr, 
			      m_direct_state[id].buf, 
			      m_direct_state[id].len);
      break;
      
    case S_CRC:
      call Sector.computeCrc[id]((uint16_t) m_direct_state[id].buf, 
				    m_direct_state[id].addr, 
				    m_direct_state[id].len);
      break;
      
    case S_WRITE:
      call Sector.write[id](m_direct_state[id].addr, 
			       m_direct_state[id].buf, 
			       m_direct_state[id].len);
      break;
      
    case S_ERASE:
      call Sector.erase[id](m_direct_state[id].addr, 1);
      break;
    
    default:
      break;
    }
  }
  
  /***************** Sector Events ***************/
  event void Sector.readDone[uint8_t id](stm25p_addr_t addr, uint8_t* buf, 
					    stm25p_len_t len, error_t error) {
    signalDone(id, 0, error);
  }
  
  event void Sector.writeDone[uint8_t id](stm25p_addr_t addr, uint8_t* buf, 
					     stm25p_len_t len, error_t error){
    signalDone(id, 0, error);
  }
  
  event void Sector.eraseDone[uint8_t id](uint8_t sector,
					     uint8_t num_sectors,
					     error_t error) {
    signalDone(id, 0, error);
  }
  
  event void Sector.computeCrcDone[uint8_t id](stm25p_addr_t addr, 
						  stm25p_len_t len,
						  uint16_t crc,
						  error_t error) {
    signalDone(id, crc, error);
  }
  
  
  /***************** Functions ****************/
  void signalDone(uint8_t id, uint16_t crc, error_t error) {
    stm25p_direct_req_t req = m_direct_state[id].req;    
    
    call ClientResource.release[id]();
    m_direct_state[id].req = S_IDLE;
    
    switch(req) {
    case S_READ:
      signal DirectStorage.readDone[id](m_direct_state[id].addr, 
				  m_direct_state[id].buf,
				  m_direct_state[id].len, error);  
      break;
    
    case S_CRC:
      signal DirectStorage.crcDone[id](crc, m_direct_state[id].addr, 
					m_direct_state[id].len, error);
      break;
   
    case S_WRITE:
      signal DirectStorage.writeDone[id](m_direct_state[id].addr, 
				    m_direct_state[id].buf,
				    m_direct_state[id].len, error);
      break;

    case S_ERASE:
      signal DirectStorage.eraseDone[id](m_direct_state[id].addr, error);
      break;
      
    default:
      break;
    }
    
  }
  
  error_t newRequest(uint8_t client) {
    if (m_direct_state[client].req != S_IDLE) {
      return EBUSY;
    }

    call ClientResource.request[client]();
    m_direct_state[client] = m_req;
    
    return SUCCESS;
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

  default event void DirectModify.modified[uint8_t id](uint32_t addr, void *buf,
      uint32_t len, error_t error) {
  }
  
  default event void DirectModify.flushDone[uint8_t id](error_t error) {
  }
  
  default event void DirectModify.readDone[uint8_t id](uint32_t addr, void *buf,
      uint32_t len, error_t error) {
  }
  
  
  default command storage_addr_t Sector.getPhysicalAddress[uint8_t id](
      storage_addr_t addr) { 
    return 0xffffffff; 
  }
  
  default command uint8_t Sector.getNumSectors[uint8_t id]() { 
    return 0; 
  }
  
  default command error_t Sector.read[uint8_t id](stm25p_addr_t addr,
      uint8_t* buf, stm25p_len_t len) { 
    return FAIL; 
  }
  
  default command error_t Sector.write[uint8_t id](stm25p_addr_t addr, 
      uint8_t* buf, stm25p_len_t len) { 
    return FAIL;
  }
  
  default command error_t Sector.erase[uint8_t id](uint8_t sector, 
      uint8_t num_sectors) { 
    return FAIL; 
  }
  
  default command error_t Sector.computeCrc[uint8_t id](uint16_t crc, 
      storage_addr_t addr, storage_len_t len) { 
    return FAIL; 
  }
  
  default async command error_t ClientResource.request[uint8_t id]() { 
    return FAIL; 
  }
  
  default async command error_t ClientResource.release[uint8_t id]() {
    return FAIL;
  }
  
  
}

