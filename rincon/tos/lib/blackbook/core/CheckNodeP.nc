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
 * Check the node on flash to see if it has been written to since the last time it was saved
 *
 * @author Jared Hill - jch@rincon.com
 */
 
#include "Blackbook.h"
#include "BlackbookConst.h"

module CheckNodeP {
  provides {
    interface CheckNode;
  }
  
  uses {
    interface Boot;
    interface GenericCrc; 
    interface DirectStorage;
    interface VolumeSettings;
    
    ////interface JDebug;
  }
}

implementation {
  
  /** The currently allocated flashnode_t from the NodeBooter */
  flashnode_t *currentNode;
  
  /** if the module is currently busy, cannot check another node */
  bool busy = TRUE;
  
  /** The buffer to fill **/
  uint8_t check_buffer[MAX_CHECK_BYTES];
  
  /***************** Prototypes ****************/
  task void checkNodeCorruption();
  
  /*****************CheckNode Commands*********************/
  
  command error_t CheckNode.checkNode(flashnode_t *focusedNode){
    
    if(busy){
      return FAIL;
    }
    busy = TRUE;
    currentNode = focusedNode;
    post checkNodeCorruption();
    return SUCCESS;
  }
    
  /***************** DirectStorage Events ****************/
  /**
   * Signaled when the flash is ready to be used
   * @param error - SUCCESS if we can use the flash.
   */
  event void Boot.booted() {
    busy = FALSE;  
  }
  
  /**
   * Read is complete
   * @param addr - the address to read from
   * @param *buf - the buffer to read into
   * @param len - the amount to read
   * @return SUCCESS if the bytes will be read
   */
  event void DirectStorage.readDone(uint32_t addr, void *buf, uint32_t len, 
      error_t error) {
      
    uint8_t i;  
    if(error){
      post checkNodeCorruption();
      return;
    }  
    for(i = 0; i < len; i++){
      if(check_buffer[i] != 0xFF){
        ////call JDebug.jdbg("BBP.checkCorr: NODE LOCKED, found: %xs\n", 0, 0, check_buffer[i]);
        busy = FALSE;
        signal CheckNode.nodeChecked(currentNode, FALSE);
        return;
      }
    }
    busy = FALSE;
    signal CheckNode.nodeChecked(currentNode, TRUE);
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
  event void DirectStorage.eraseDone(uint16_t sector, error_t error) {
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
  event void DirectStorage.crcDone(uint16_t calculatedCrc, uint32_t addr, 
      uint32_t len, error_t error) {
  }

/***************** Tasks ****************/
  
  task void checkNodeCorruption(){
    
    uint16_t diff = currentNode->reserveLength - currentNode->dataLength;
    ////call JDebug.jdbg("BBP.checkCorr: resLen: %xl", 
    ////  		currentNode->reserveLength,0, 0); 
    ////call JDebug.jdbg("BBP.checkCorr: dataLen: %xl\n", 
    //// 		currentNode->dataLength, 0, 0);
    if(diff <= 0){
      //nothing to check
      busy = FALSE;
      signal CheckNode.nodeChecked(currentNode, TRUE);
      return; 
    }  		
    //only check the first 20 bytes
    if(diff > MAX_CHECK_BYTES){
      diff = MAX_CHECK_BYTES;
    }
    if(currentNode->fileElement == 0){
      //if it is the first file, need to add the size of filemeta_t to read address
      if(call DirectStorage.read(currentNode->flashAddress + sizeof(nodemeta_t)+ sizeof(filemeta_t)
          + currentNode->dataLength, &check_buffer, diff) != SUCCESS){
        post checkNodeCorruption();
      }
    }
    else{
      //otherwise, use this address
      if(call DirectStorage.read(currentNode->flashAddress + sizeof(nodemeta_t)
          + currentNode->dataLength, &check_buffer, diff) != SUCCESS){
        post checkNodeCorruption();
      }
    }
    
  }

}



