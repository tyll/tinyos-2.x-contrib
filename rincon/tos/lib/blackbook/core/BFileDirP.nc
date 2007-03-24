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
 * Blackbook File Dir Configuration
 * Allows the application to find out information about the
 * file_t system and flash usage.
 * @author David Moss - dmm@rincon.com
 */

#include "Blackbook.h"

module BFileDirP {
  provides { 
    interface BFileDir[uint8_t id];
  }
  
  uses {
    interface State as BlackbookState;
    interface NodeMap;
    interface EraseUnitMap;
    interface NodeShop;
    interface BDictionary;
    interface InternalDictionary;
    interface BlackbookUtil;
  }
}

implementation {

  /** The current flashnode_t to verify the CRC for */
  flashnode_t *crcNode;
  
  /** The current file_t to verify the CRC for */
  file_t *crcFile;
  
  /** The current client we're working with */
  uint8_t currentClient;
  
  /** Storage for a filename_t */  
  filename_t filenameBuffer;

  /***************** Prototypes ****************/
  /** Get the CRC of the current crcNode */
  task void getCrc();
  
  
  /***************** BFileDir Commands ****************/
  /**
   * @return the total number of files in the file_t system
   */
  command uint8_t BFileDir.getTotalFiles[uint8_t id]() {
    return call NodeMap.getTotalFiles();
  }
  
  /**
   * @return the total number of nodes in the file_t system
   */
  command uint16_t BFileDir.getTotalNodes[uint8_t id]() {
    return call NodeMap.getTotalNodes();
  }

  /**
   * @return the approximate free space on the flash 
   */
  command uint32_t BFileDir.getFreeSpace[uint8_t id]() {
    return call EraseUnitMap.getFreeSpace();
  }
  
  /**
   * Returns TRUE if the file_t exists, FALSE if it doesn't
   */
  command error_t BFileDir.checkExists[uint8_t id](char *fileName) {
    file_t *currentFile;
    
    call BlackbookUtil.filenameCpy(&filenameBuffer, fileName);
    currentFile = call NodeMap.getFile(&filenameBuffer);
    
    signal BFileDir.existsCheckDone[id]((char *) &filenameBuffer, 
        currentFile != NULL, SUCCESS);
    return SUCCESS;
  }

  /**
   * An optional way to read the first filename_t of
   * the system. This is exactly the same as calling
   * BFileDir.readNext(NULL).
   */ 
  command error_t BFileDir.readFirst[uint8_t id]() {
    return call BFileDir.readNext[id](NULL);
  }
 
  /**
   * Read the next file_t in the file_t system, based on the
   * current filename.  If you want to find the first
   * file_t in the file_t system, pass in NULL.
   *
   * If the next file_t exists, it will be returned in the
   * nextFile event with error SUCCESS
   *
   * If there is no next file, the nextFile event will
   * signal with the filename_t passed in and FAIL.
   *
   * If the present filename_t passed in doesn't exist,
   * then this command returns FAIL and no signal is given.
   *
   * @param presentFilename - the name of the current file,
   *     of which you want to find the next valid file_t after.
   */
  command error_t BFileDir.readNext[uint8_t id](char *presentFilename) {
    int i;
    uint16_t targetCrc;

    if(call BlackbookState.requestState(S_DIR_BUSY) != SUCCESS) {
      return FAIL;
    }

    currentClient = id;
 
    if(presentFilename != NULL) {
      call BlackbookUtil.filenameCpy(&filenameBuffer, presentFilename);
      targetCrc = call BlackbookUtil.filenameCrc(&filenameBuffer);
      
      for(i = 0; i < call NodeMap.getMaxFiles(); i++) {
        if(((call NodeMap.getFileAtIndex(i))->filenameCrc == targetCrc) &&
          ((call NodeMap.getFileAtIndex(i))->filestate != FILE_EMPTY)) {
          // The index of the present filename_t was found
          for(i += 1; i < call NodeMap.getMaxFiles(); i++) {
            if((call NodeMap.getFileAtIndex(i))->filestate != FILE_EMPTY) {
              // This is the next file_t after the index of the present file
              call NodeShop.getFilename(call NodeMap.getFileAtIndex(i), 
                  &filenameBuffer);
              return SUCCESS;
            }
          }
          
          // Here, we know there is no next file.
        }
      }
      
      // Here, we know the file passed in doesn't exist
      call BlackbookState.toIdle();
      signal BFileDir.nextFile[id](presentFilename, FAIL);
      return SUCCESS;
      
    } else {
      for(i = 0 ; i < call NodeMap.getMaxFiles(); i++) {
        if((call NodeMap.getFileAtIndex(i))->filestate != FILE_EMPTY) {
          // This is the first file
          call NodeShop.getFilename(call NodeMap.getFileAtIndex(i), 
              &filenameBuffer);
          return SUCCESS;
        }
      }
      
      // There are no files on this file_t system
      call BlackbookState.toIdle();
      signal BFileDir.nextFile[id](presentFilename, FAIL);
      return SUCCESS;
    }
  }

  /**
   * Get the total reserved bytes of an existing file
   * @param fileName - the name of the file_t to pull the reservedLength from.
   * @return the reservedLength of the file, 0 if it doesn't exist
   */
  command uint32_t BFileDir.getReservedLength[uint8_t id](char *fileName) {
    filename_t currentFilename;
    file_t *currentFile;
    
    call BlackbookUtil.filenameCpy(&currentFilename, fileName);
    if((currentFile = call NodeMap.getFile(&currentFilename)) == NULL) {
      return 0;
    }
    
    return call NodeMap.getReserveLength(currentFile);
  }
  
  /**
   * Get the total amount of data written to the file_t with
   * the given fileName.
   * @param fileName - name of the file_t to pull the dataLength from.
   * @return the dataLength of the file, 0 if it doesn't exist
   */
  command uint32_t BFileDir.getDataLength[uint8_t id](char *fileName) {
    filename_t currentFilename;
    file_t *currentFile;
    
    call BlackbookUtil.filenameCpy(&currentFilename, fileName);
    if((currentFile = call NodeMap.getFile(&currentFilename)) == NULL) {
      return 0;
    }
    
    return call NodeMap.getDataLength(currentFile);
  }
 
  /**
   * Find if a file_t is corrupt. This will read each node
   * from the file_t and verify it against its dataCrc.
   * If the calculated data CRC from a flashnode_t does
   * not match the node's recorded CRC, the file_t is corrupt.
   * @return SUCCESS if the corrupt check will proceed.
   */
  command error_t BFileDir.checkCorruption[uint8_t id](char *fileName) {
    filename_t currentFilename;
    
    if(call BlackbookState.requestState(S_DIR_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    currentClient = id;
    
    call BlackbookUtil.filenameCpy(&currentFilename, fileName);
    if((crcFile = call NodeMap.getFile(&currentFilename)) == NULL) {
      call BlackbookState.toIdle();
      return FAIL;
    }
    
    
    crcNode = crcFile->firstNode;
    call InternalDictionary.isFileDictionary(crcFile);
    return SUCCESS;
  }


  /***************** BDictionary Events ****************/
  
  /**
   * @param isDictionary - TRUE if the file_t is a dictionary
   * @param error - SUCCESS if the reading is valid
   */
  event void BDictionary.fileIsDictionary(bool isDictionary, error_t error) {
    if(call BlackbookState.getState() == S_DIR_BUSY) {
      if(!error && isDictionary) {
        // This is a dictionary file_t - it is not corrupted
        call BlackbookState.toIdle();
        signal BFileDir.corruptionCheckDone[currentClient](
            (char *) (&filenameBuffer), FALSE, SUCCESS);
        
      } else {
        // This is not a dictionary file_t - verify it
        post getCrc();
      }   
    }
  }
  
  /**
   * A Dictionary file_t was opened successfully.
   * @param totalSize - the total amount of flash space dedicated to storing
   *     key-value pairs in the file
   * @param remainingBytes - the remaining amount of space left to write to
   * @param error - SUCCESS if the file_t was successfully opened.
   */
  event void BDictionary.opened(uint32_t totalSize, uint32_t remainingBytes, 
      error_t error) {
  }
  
  /** 
   * The opened Dictionary file_t is now closed
   * @param error - SUCCSESS if there are no open files
   */
  event void BDictionary.closed(error_t error) {
  }
  
  /**
   * A key-value pair was inserted into the currently opened Dictionary file.
   * @param key - the key used to insert the value
   * @param value - pointer to the buffer containing the value.
   * @param valueSize - the amount of bytes copied from the buffer into flash
   * @param error - SUCCESS if the key was written successfully.
   */
  event void BDictionary.inserted(uint32_t key, void *value, uint16_t valueSize,
      error_t error) {
  }
  
  /**
   * A value was retrieved from the given key.
   * @param key - the key used to find the value
   * @param valueHolder - pointer to the buffer where the value was stored
   * @param valueSize - the actual size of the value.
   * @param error - SUCCESS if the value was pulled out and is uncorrupted
   */
  event void BDictionary.retrieved(uint32_t key, void *valueHolder, 
      uint16_t valueSize, error_t error) {
  }
  
  /**
   * A key-value pair was removed
   * @param key - the key that should no longer exist
   * @param error - SUCCESS if the key was really removed
   */
  event void BDictionary.removed(uint32_t key, error_t error) {
  }
  
  /**
   * The next key in the open Dictionary file
   * @param nextKey - the next key
   * @param error - SUCCESS if this is the really the next key,
   *     FAIL if the presentKey was invalid or there is no next key.
   */
  event void BDictionary.nextKey(uint32_t nextKey, error_t error) {
  }

  event void BDictionary.totalKeys(uint16_t totalKeys) {
  }
  
  
  /***************** NodeShop Events ****************/ 
  /**
   * A crc was calculated from flashnode_t data on flash
   * @param dataCrc - the crc of the data read from the flashnode_t on flash.
   * @param error - SUCCESS if the crc is valid
   */
  event void NodeShop.crcCalculated(uint16_t dataCrc) {
    if(dataCrc == crcNode->dataCrc) {
      if((crcNode = crcNode->nextNode) != NULL) {
        // More nodes in this file_t to verify
        post getCrc();
        
      } else {
        // No more nodes to verify, all are ok.
        call BlackbookState.toIdle();
        signal BFileDir.corruptionCheckDone[currentClient](
            (char *) (&filenameBuffer), FALSE, SUCCESS);
      }
         
    } else {
      // This flashnode_t is corrupted, so the whole file_t is corrupt.
      call BlackbookState.toIdle();
      signal BFileDir.corruptionCheckDone[currentClient](
          (char *) (&filenameBuffer), TRUE, SUCCESS);
    }
  }
  
  /**
   * The filename_t was retrieved from flash
   * @param focusedFile - the file_t that we obtained the filename_t for
   * @param *name - pointer to where the filename_t was stored
   * @param error - SUCCESS if the filename_t was retrieved
   */
  event void NodeShop.filenameRetrieved(filename_t *name) {
    call BlackbookState.toIdle();
    signal BFileDir.nextFile[currentClient]((char *) name->getName, SUCCESS);
  }
  
  /** 
   * The node's metadata was written to flash
   * @param focusedNode - the flashnode_t that metadata was written for
   * @param error - SUCCESS if it was written
   */
  event void NodeShop.metaWritten() {
  }
  
  /**
   * A flashnode_t was deleted from flash by marking its magic number
   * invalid in the metadata.
   * @param focusedNode - the flashnode_t that was deleted.
   * @param error - SUCCESS if the flashnode_t was deleted successfully.
   */
  event void NodeShop.metaDeleted(flashnode_t *focusedNode) {
  }
  
  /***************** Tasks ****************/
  /**
   * Get the CRC of the data in the current crcNode
   */
  task void getCrc() {
    if(call NodeShop.getCrc(crcNode, crcFile) != SUCCESS) {
      post getCrc();
    }
  }
  
  
  /***************** Defaults ****************/

  default event void BFileDir.corruptionCheckDone[uint8_t id](char *fileName, 
      bool isCorrupt, error_t error) {
  }

  default event void BFileDir.existsCheckDone[uint8_t id](char *fileName, 
      bool doesExist, error_t error) {
  }
    
  default event void BFileDir.nextFile[uint8_t id](char *fileName, 
      error_t error) {
  }
  
}




