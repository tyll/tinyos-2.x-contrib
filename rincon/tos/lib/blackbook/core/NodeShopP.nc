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
 * Blackbook NodeShop Configuration
 *
 * NodeShop writes metadata for nodes and files to flash.
 *
 * @author David Moss (dmm@rincon.com)
 */
 
#include "Blackbook.h"

module NodeShopP {
  provides {
    interface NodeShop;
  }
  
  uses {
    interface NodeMap;
    interface State;
    interface EraseUnitMap;
    interface DirectStorage;
    ////interface JDebug;
  }
}

implementation {

  /** Pointer to the current flashnode_t */
  flashnode_t *currentNode;
  
  /** Pointer to the current file_t */
  file_t *currentFile;
  
  /** Filename pointer */
  filename_t *currentFilename;
  
  /** Node meta to write to flash */
  nodemeta_t currentNodeMeta;
  
  
  enum { 
    S_IDLE = 0,
    S_WRITE_NODEMETA,
    S_WRITE_FILEMETA,
    S_NODEMETA_DELETE,
    S_GET_FILENAME,
    S_CRC,
  };
  
  
  /***************** Prototypes ****************/
  /** Delete the current flashnode_t */
  task void deleteMyNode();
  
  /** Write the nodemeta_t for the current flashnode_t to flash */
  task void writeNodemeta();
  
  /** Write the filemeta for the current flashnode_t to flash */
  task void writeFilemeta();
    
  /** Flush all changes to flash */
  task void flush();
  
  /** Get the CRC of the data in the current flashnode_t */
  task void getMyNodeCrc();
  
  /** Signal completion for the current state */ 
  task void signalDone(); 
  
  /** Read the filename_t of a file_t from flash */
  task void readFilename();
 
  /***************** NodeShop Commands ****************/
  /**
   * Write the nodemeta_t to flash for the given node
   * @param focusedFile - the file
   * @param focusedNode - the flashnode_t to write the nodemeta_t for
   * @param name - pointer to the filename
   */
  command error_t NodeShop.writeNodemeta(file_t *focusedFile, 
      flashnode_t *focusedNode, filename_t *name) {
    if(call State.requestState(S_WRITE_NODEMETA) != SUCCESS) {
      return FAIL;
    }
  
    currentNode = focusedNode;
    currentFile = focusedFile;
    currentFilename = name;
    
    currentNodeMeta.filenameCrc = currentNode->filenameCrc;
    currentNodeMeta.reserveLength = currentNode->reserveLength;
    currentNodeMeta.fileElement = currentNode->fileElement;
    currentNodeMeta.nodeflags = currentNode->nodeflags;
    
    if(focusedNode->nodestate == NODE_CONSTRUCTING) {
      currentNodeMeta.magicNumber = META_CONSTRUCTING;
    } else {
      currentNodeMeta.magicNumber = META_VALID;
    }
    
    call EraseUnitMap.freeEraseBlock(call EraseUnitMap.getEraseBlockAtAddress(
        currentNode->flashAddress));
    
    post writeNodemeta();
    
    return SUCCESS;
  }

  /**
   * Delete a flashnode_t on flash. This will not erase the
   * data from flash, but it will simply mark the magic
   * number of the flashnode_t to make it invalid.
   * 
   * After the command is called and executed, a metaDeleted
   * event will be signaled.
   *
   * @return SUCCESS if the magic number will be marked
   */
  command error_t NodeShop.deleteNode(flashnode_t *focusedNode) { 
    if(call State.requestState(S_NODEMETA_DELETE) != SUCCESS) {
      return FAIL;
    }

    currentNode = focusedNode;

    post deleteMyNode();
    return SUCCESS;
  }
  
  /**
   * Get the CRC of a flashnode_t on flash.
   *
   * After the command is called and executed, a crcCalculated
   * event will be signaled.
   *
   * @param focusedNode - the flashnode_t to read and calculate a CRC for
   * @param focusedFile - the file_t belonging to the node
   * @return SUCCESS if the CRC will be calculated.
   */
  command error_t NodeShop.getCrc(flashnode_t *focusedNode, 
      file_t *focusedFile) {
    if(call State.requestState(S_CRC) != SUCCESS) {
      return FAIL;
    }
    
    currentNode = focusedNode;
    currentFile = focusedFile;
    
    post getMyNodeCrc();
    return SUCCESS;
  }

  /**
   * Get the filename_t for a file
   * @param focusedFile - the file_t to obtain the filename_t for
   * @param *name - pointer to store the filename
   */
  command error_t NodeShop.getFilename(file_t *focusedFile, filename_t *name) {
    if(call State.requestState(S_GET_FILENAME) != SUCCESS) {
      return FAIL;
    }
    
    currentFile = focusedFile;
    currentFilename = name;
    
    post readFilename();
    return SUCCESS;
  }
  
  /***************** DirectStorage Events ****************/
  /**
   * Write is complete
   * @param addr - the address to write to
   * @param *buf - the buffer to write from
   * @param len - the amount to write
   * @return SUCCESS if the bytes will be written
   */
  event void DirectStorage.writeDone(uint32_t addr, void *buf, uint32_t len, 
      error_t error) {
    if(call State.getState() == S_WRITE_NODEMETA) {

      if(currentFile != NULL) {
        if(currentFile->firstNode == currentNode) {
          post writeFilemeta();
          return; 
        }
      }
      
      if(currentNode->nodestate != NODE_CONSTRUCTING) {
        currentNode->nodestate = NODE_VALID;
      }
      call EraseUnitMap.documentNode(currentNode);
      
    } else if(call State.getState() == S_WRITE_FILEMETA) {      
      if(currentNode->nodestate != NODE_CONSTRUCTING) {
        currentNode->nodestate = NODE_VALID;
      }
      call EraseUnitMap.documentNode(currentNode);

    } else if(call State.getState() == S_NODEMETA_DELETE) {
      call EraseUnitMap.removeNode(currentNode);
      currentNode->nodestate = NODE_DELETED;

    }
    
    post flush();
    return;
  }
  
  /**
   * Flush is complete
   * @param error - SUCCESS if the flash was flushed
   */
  event void DirectStorage.flushDone(error_t error) {
    post signalDone();
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
    call State.toIdle();
    signal NodeShop.crcCalculated(calculatedCrc);
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
    post signalDone();
  }
  
  
  /**
   * Erase is complete
   * @param sector - the sector id to erase
   * @return SUCCESS if the sector will be erased
   */
  event void DirectStorage.eraseDone(uint16_t sector, error_t error) {
  }
  

  /***************** Tasks ****************/
  /**
   * Write the magic number to flash to invalidate "currentNode"
   */
  task void deleteMyNode() {
    currentNodeMeta.magicNumber = META_INVALID;
    
    // Here we only want to write the new magicNumber to flash
    // Very nodemeta_t dependant.
    if(call DirectStorage.write(currentNode->flashAddress, 
        &currentNodeMeta.magicNumber, sizeof(currentNodeMeta.magicNumber)) 
            != SUCCESS) {
      post deleteMyNode();
    }
  }
  
  /**
   * Write the nodemeta_t to flash
   */
  task void writeNodemeta() {
    ////call JDebug.jdbg("NS.writeMeta: resLen = %xl, dataLen = %xi\n", currentNode->reserveLength, 
    ////	(uint16_t)(currentNode->dataLength), 0);
    if(call DirectStorage.write(currentNode->flashAddress, &currentNodeMeta, 
        sizeof(nodemeta_t)) != SUCCESS) {
      post writeNodemeta();
    }
  }

  /**
   * Write the filemeta to "currentNode"
   */
  task void writeFilemeta() {
    call State.forceState(S_WRITE_FILEMETA);
    if(call DirectStorage.write(currentNode->flashAddress + sizeof(nodemeta_t), 
        currentFilename, sizeof(filemeta_t)) != SUCCESS) {
      post writeFilemeta();
    }
  }
  
  /**
   * Get the CRC of all the data in the current node
   * It is assumed that currentNodeMeta.fileElement 
   * contains the element number of the current node.
   */
  task void getMyNodeCrc() {
    uint32_t dataStartAddress = currentNode->flashAddress + sizeof(nodemeta_t);
    if(currentFile->firstNode == currentNode) {
      dataStartAddress += sizeof(filemeta_t);
    }
    
    if(call DirectStorage.crc(dataStartAddress, currentNode->dataLength, 0) 
        != SUCCESS) {
      post getMyNodeCrc();
    }
  }
  
  /**
   * Read the currentFile's filename_t from flash
   */
  task void readFilename() {
    if(call DirectStorage.read(currentFile->firstNode->flashAddress 
        + sizeof(nodemeta_t), currentFilename, sizeof(filename_t)) != SUCCESS) {
      post readFilename();
    }
  }
  
  /** 
   * Flush changes to flash 
   */
  task void flush() {
    if(call DirectStorage.flush() != SUCCESS) {
      post flush();
    }
  }
  
  
  /** 
   * Signal task completion after
   * everything is set and finished and checkpointed.
   */
  task void signalDone() {
    uint8_t state = call State.getState();
    call State.toIdle();
    
    switch(state) {
      case S_WRITE_NODEMETA:
      case S_WRITE_FILEMETA:
        signal NodeShop.metaWritten();
        break;
        
      case S_NODEMETA_DELETE:
        signal NodeShop.metaDeleted(currentNode);
        break;

      case S_GET_FILENAME:
        signal NodeShop.filenameRetrieved(currentFilename);
        break;
        
      default:
    }
  }
}

