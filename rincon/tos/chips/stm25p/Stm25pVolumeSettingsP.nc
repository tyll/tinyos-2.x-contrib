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
 * Volume settings for the ST M25P80 flash
 * @author David Moss
 */
 
#include "Stm25p.h"

module Stm25pVolumeSettingsP {
  provides {
    interface VolumeSettings[uint8_t id];
  }
  
  uses {
    interface Stm25pSector as Sector[uint8_t id];
  }
}

implementation {

  /***************** VolumeSettings Commands ***************/
  /**
   * @return the total size of the volume
   */
  command uint32_t VolumeSettings.getVolumeSize[uint8_t id]() {
    return ((uint32_t) call Sector.getNumSectors[id]() 
        << STM25P_SECTOR_SIZE_LOG2);
  }
  
  /**
   * @return the total number of erase units on the volume
   */
  command uint32_t VolumeSettings.getTotalEraseUnits[uint8_t id]() {
    return (uint32_t) call Sector.getNumSectors[id]();
  }
  
  /**
   * @return the erase unit size
   */
  command uint32_t VolumeSettings.getEraseUnitSize[uint8_t id]() {
    return (uint32_t) STM25P_SECTOR_SIZE;
  }
  
  /**
   * @return the total write units on the volume
   */
  command uint32_t VolumeSettings.getTotalWriteUnits[uint8_t id]() {
    return call VolumeSettings.getVolumeSize[id]() / STM25P_PAGE_SIZE;
  }
  
  /**
   * @return the total write unit size
   */
  command uint32_t VolumeSettings.getWriteUnitSize[uint8_t id]() {
    return (uint32_t) STM25P_PAGE_SIZE;
  }
  
  /**
   * @return the fill byte used on this volume when the volume is empty
   */
  command uint8_t VolumeSettings.getFillByte[uint8_t id]() {
    return 0xFF;
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
  command uint8_t VolumeSettings.getEraseUnitSizeLog2[uint8_t id]() {
    return STM25P_SECTOR_SIZE_LOG2;
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
  command uint8_t VolumeSettings.getWriteUnitSizeLog2[uint8_t id]() {
    return STM25P_PAGE_SIZE_LOG2;
  }
  
  /****************** Sector Events ***************/
  event void Sector.readDone[uint8_t id](stm25p_addr_t addr, uint8_t* buf, 
					    stm25p_len_t len, error_t error) {
  }
  
  event void Sector.writeDone[uint8_t id](stm25p_addr_t addr, uint8_t* buf, 
					     stm25p_len_t len, error_t error){
  }
  
  event void Sector.eraseDone[uint8_t id](uint8_t sector,
					     uint8_t num_sectors,
					     error_t error) {
  }
  
  event void Sector.computeCrcDone[uint8_t id](stm25p_addr_t addr, 
						  stm25p_len_t len,
						  uint16_t crc,
						  error_t error) {
  }
  
  
  /***************** Defaults ****************/
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
  
}

