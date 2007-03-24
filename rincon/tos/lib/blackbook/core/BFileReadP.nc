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
 * Blackbook BFileRead Configuration
 * Open, Read, Close Blackbook files.
 * Use unique("BFileRead") when connecting to a parameterized
 * interface.
 * @author David Moss - dmm@rincon.com
 */

#include "Blackbook.h"

module BFileReadP {
  provides {
    interface BFileRead[uint8_t id];
    interface Init;
  }
  
  uses {
    interface State as BlackbookState;
    interface Fileio;
    interface NodeMap;
    interface BlackbookUtil;
    ///interface PrintfFlush;
    ////interface JDebug;
  }
}

implementation {

  /**Each client's current read information */
  struct filereader {

    /** The current file_t open for writing, NULL if no file_t is open */
    file_t *openFile;
    
    /** The position to read from in the current open flashnode */
    uint32_t readAddress;
  
  } readers[uniqueCount(UQ_BFILEREAD)];


  /** The current client we're working with */
  uint8_t currentClient;
  
  /***************** Prototypes ****************/  

  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;
    for(i = 0; i < uniqueCount(UQ_BFILEREAD); i++) {
      readers[i].openFile = NULL;
    }
    return SUCCESS;
  }
  
  
  /***************** BFileRead Commands ****************/
  /**
   * Open a file_t for reading
   * @param fileName - name of the file_t to open
   * @return SUCCESS if the attempt to open for reading proceeds
   */ 
  command error_t BFileRead.open[uint8_t id](char *fileName) {
    filename_t currentFilename;
    
    if(call BlackbookState.requestState(S_READ_BUSY) != SUCCESS) {
      return FAIL;
    }

    currentClient = id;
    call BlackbookUtil.filenameCpy(&currentFilename, fileName);
    
    if(readers[currentClient].openFile == NULL) {
      if((readers[currentClient].openFile = 
          call NodeMap.getFile(&currentFilename)) != NULL) {
        if(readers[currentClient].openFile->filestate == FILE_IDLE) {
          // We set it to READING only to prevent this file_t from being deleted
          readers[currentClient].openFile->filestate = FILE_READING;
        }
        else if(readers[currentClient].openFile->filestate == FILE_WRITING) {
          readers[currentClient].openFile->filestate = FILE_READING_AND_WRITING;
        }
        readers[currentClient].readAddress = 0;
        call BlackbookState.toIdle();    
        ////call JDebug.jdbg("BFR.open, nodeAddr: %xl\n", (readers[currentClient].openFile)->firstNode, 0, 0);
        ////call JDebug.jdbg("BFR.open, dataAddr: %xl\n", (uint32_t)&(((readers[currentClient].openFile)->firstNode)->dataLength), 0, 0);
        ////call JDebug.jdbg("BFR.open, dataVal: %xl\n", (uint32_t)(((readers[currentClient].openFile)->firstNode)->dataLength), 0, 0);
     
        signal BFileRead.opened[currentClient](call NodeMap.getDataLength(
            (readers[currentClient].openFile)), SUCCESS);
        return SUCCESS;
      }
      
    } else {
      // There's a file open already
      call BlackbookState.toIdle();
      if(call BlackbookUtil.filenameCrc((filename_t *) fileName) ==
          readers[currentClient].openFile->filenameCrc) {
        // It's the same file
        signal BFileRead.opened[currentClient](call NodeMap.getDataLength(
            readers[currentClient].openFile), SUCCESS);
        return SUCCESS;
      }
      
      // It's a different file
      return FAIL;
    }
    
    call BlackbookState.toIdle();
    return FAIL;
  }
  
  /**
   * @return TRUE if the given parameterized interface has a file_t open
   */
  command bool BFileRead.isOpen[uint8_t id]() {
    return (readers[id].openFile != NULL);
  }

  /**
   * Close any currently opened file
   */
  command error_t BFileRead.close[uint8_t id]() {
    currentClient = id;
    if(readers[currentClient].openFile != NULL) {
      // Set the file_t to IDLE only if it was IDLE to begin with.
      if(readers[currentClient].openFile->filestate == FILE_READING) {
        readers[currentClient].openFile->filestate = FILE_IDLE;
        
      } else if(readers[currentClient].openFile->filestate == FILE_READING_AND_WRITING){
        readers[currentClient].openFile->filestate = FILE_WRITING;
      }
    }
    
    readers[currentClient].openFile = NULL;
    signal BFileRead.closed[id](SUCCESS);
    return SUCCESS;
  }

  /**
   * Read a specified amount of data from the open
   * file_t into the given buffer
   * @param *dataBuffer - the buffer to read data into
   * @param amount - the amount of data to read
   * @return SUCCESS if the command goes through
   */
  command error_t BFileRead.read[uint8_t id](void *dataBuffer, 
      uint16_t amount) {
    if(call BlackbookState.requestState(S_READ_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    currentClient = id;

    if((readers[currentClient].openFile == NULL) 
        || call Fileio.readData(readers[currentClient].openFile, 
            readers[currentClient].readAddress, 
                dataBuffer, amount) != SUCCESS) {
      call BlackbookState.toIdle();
      return FAIL;
    }
    
    return SUCCESS;
  }

  /**
   * Seek a given address to read from in the file.
   *
   * @param fileAddress - the address to seek
   * @return SUCCESS if the read pointer is adjusted,
   *         FAIL if the read pointer didn't change
   */
  command error_t BFileRead.seek[uint8_t id](uint32_t fileAddress) {
    readers[id].readAddress = fileAddress;
    return SUCCESS;
  }

  /**
   * Skip the specified number of bytes in the file
   * @param skipLength - number of bytes to skip
   * @return SUCCESS if the internal read pointer was adjusted
   */
  command error_t BFileRead.skip[uint8_t id](uint16_t skipLength) {
    readers[id].readAddress += skipLength;
    return SUCCESS;
  }

  /**
   * Get the remaining bytes available to read from this file.
   * This is the total size of the file_t minus your current position.
   * @return the number of remaining bytes in this file_t 
   */
  command uint32_t BFileRead.getRemaining[uint8_t id]() {
    if(readers[id].openFile == NULL) {
      return 0;
    } 
    
    return (call NodeMap.getDataLength(readers[id].openFile)) 
        - readers[id].readAddress;
  }

  /***************** Fileio Events ****************/
  /**
   * Data was read from the file
   * @param *readBuffer - pointer to the location where the data was stored
   * @param amountRead - the amount of data actually read
   * @param error - SUCCESS if the data was successfully read
   */
  event void Fileio.readDone(void *readBuffer, uint32_t amountRead, 
      error_t error) {
    if(call BlackbookState.getState() == S_READ_BUSY) {
      readers[currentClient].readAddress += amountRead;
      call BlackbookState.toIdle();
      signal BFileRead.readDone[currentClient](readBuffer, amountRead, error);
    }
  }
  
  /**
   * Data was appended to the flashnode in the flash.
   * @param writeBuffer - pointer to the buffer containing the data written
   * @param amountWritten - the amount of data appended to the node.
   * @param error - SUCCESS if the data was successfully written
   */
  event void Fileio.writeDone(void *writeBuffer, uint32_t amountWritten, 
      error_t error) {
  }

  /**
   * Data was flushed to flash
   * @param error - SUCCESS if the data was flushed
   */
  event void Fileio.flushDone(error_t error) {
  }
    
  /***************** Defaults ****************/
  default event void BFileRead.opened[uint8_t id](uint32_t amount, 
      error_t error) {
  }

  default event void BFileRead.closed[uint8_t id](error_t error) {
  }

  default event void BFileRead.readDone[uint8_t id](void *buf, uint16_t amount, 
      error_t error) {
  }
  
}



