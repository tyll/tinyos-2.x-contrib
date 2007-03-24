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
 * This module provides the ability to read and write to files
 * on flash. Although random read/write access is technically possible,
 * it assumes serial write access to prevent the creation of dangling node.
 * Random read access isn't a problem though.
 *
 * Pass in a file_t and an address you want to read/write from that file,
 * and this module will put together the nodes that are required to
 * access that information.
 *
 * @author David Moss (dmm@rincon.com)
 */
 
#include "Blackbook.h"

module FileioP {
  provides {
    interface Fileio;
  }
  
  uses {
    interface DirectStorage;
    interface GenericCrc;
    interface NodeMap;
    interface NodeShop;
    interface State;
    ////interface JDebug;
  }
}

implementation {

  /** Offset to read/write in the flashnode_t */
  uint16_t offset;
  
  /** The flashnode_t to interact with */
  flashnode_t *currentNode;
  
  /** The current file_t we're interacting with */
  file_t *currentFile;
  
  /** Pointer to the buffer to read or store data */
  void *currentBuffer;
  
  /** The total amount of data to read or write */ 
  uint32_t currentTotal;
  
  /** The total amount of bytes read or written */
  uint32_t totalComplete;
  
  /** The amount of data that we are currently reading or writting */
  uint16_t currentAmount;
  
  /** The actual address we're interacting with on flash */
  uint32_t actualAddress;  
  
  enum  {
    S_IDLE = 0,
    S_READING,
    S_WRITING,
    S_FLUSHING,
  };
  
  /***************** Prototypes ****************/
  task void transaction();
  task void writeNextNode();
  task void write();
  task void read();
  
  void ioInit(file_t *ioFile, uint32_t fileAddress);
  void finish(error_t error);
  bool isWriting();
  void writeCurrentNodeMeta();
  
  /***************** Fileio Commands ****************/
  /**
   * Write data to the flashnode_t belonging to the given file
   * at the given address in the file
   * @param currentFile - the file_t to write to
   * @param fileAddress - the address to write to in the file
   * @param *data - the data to write
   * @param total - the total amount of data to write
   * @return SUCCESS if the data will be written
   */
  command error_t Fileio.writeData(file_t *ioFile, uint32_t fileAddress, 
      void *data, uint32_t total) {
    if(call State.requestState(S_WRITING) != SUCCESS) {
      return FAIL;
    }
    
    currentBuffer = data;
    currentTotal = total;
    ioInit(ioFile, fileAddress);
    return SUCCESS;
  }
  
  /**
   * Read data from the flashnode_t belonging to the given file
   * at the given address in the file
   * @param currentFile - the file_t to read from
   * @param fileAddress - the address to read from in the file
   * @param *data - pointer to the buffer to store the data in
   * @param total - the total amount of data to read
   */
  command error_t Fileio.readData(file_t *ioFile, uint32_t fileAddress, 
      void *data, uint32_t total) {
    if(call State.requestState(S_READING) != SUCCESS) {
      return FAIL;
    }
    
    currentBuffer = data;
    currentTotal = total;
    ioInit(ioFile, fileAddress);
    return SUCCESS;
  }

  /**
   * Flush any written data to flash 
   * @return SUCCESS if the data is flushed, and an event will be signaled.
   */
  command error_t Fileio.flushData() {
    if(call State.requestState(S_FLUSHING) != SUCCESS) {
      return FAIL;
    }
    
    return call DirectStorage.flush();
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
    totalComplete += len;
    offset += len;
    post transaction();
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
    currentNode->dataLength += len;
    totalComplete += len;
    offset += len;
    post transaction();
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
    if(call State.getState() == S_FLUSHING) {
      call State.toIdle();
      signal Fileio.flushDone(error);
    }
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
  
  /***************** NodeShop Events ****************/
  /** 
   * The node's metadata was written to flash
   * @param focusedNode - the flashnode_t that metadata was written for
   * @param error - SUCCESS if it was written
   */
  event void NodeShop.metaWritten() {
    if(isWriting()) {
      post transaction();
    }
  }
  
  /**
   * The filename_t was retrieved from flash
   * @param focusedFile - the file_t that we obtained the filename_t for
   * @param *name - pointer to where the filename_t was stored
   * @param error - SUCCESS if the filename_t was retrieved
   */
  event void NodeShop.filenameRetrieved(filename_t *name) {
  }
  
  /**
   * A flashnode_t was deleted from flash by marking its magic number
   * invalid in the metadata.
   * @param focusedNode - the flashnode_t that was deleted.
   * @param error - SUCCESS if the flashnode_t was deleted successfully.
   */
  event void NodeShop.metaDeleted(flashnode_t *focusedNode) {
  }
 
  /**
   * A crc was calculated from flashnode_t data on flash
   * @param dataCrc - the crc of the data read from the flashnode_t on flash.
   * @param error - SUCCESS if the crc is valid
   */
  event void NodeShop.crcCalculated(uint16_t dataCrc) {
  }

  
  /***************** Tasks ****************/
  /**
   * Calculate and perform the transaction
   */
  task void transaction() {
    uint16_t nodeLength;
    
    if(totalComplete < currentTotal) {
      // More data to go
      if(isWriting()) {
        nodeLength = currentNode->reserveLength;
      } else {
        nodeLength = currentNode->dataLength;
      }
      
      currentAmount = currentTotal - totalComplete;
      if(nodeLength - offset < currentAmount) {
        currentAmount = nodeLength - offset;
      }
      
      if(currentAmount == 0) {
        // We're at the end of this node
        if(currentNode->nextNode != NULL) {
          offset = 0;
          
          if(isWriting()) {
            post writeNextNode();
            return;
            
          } else {
            if((currentNode = currentNode->nextNode) == NULL) {
              finish(SUCCESS);
            
            } else {
              post transaction();
            }
            
            return;
          }
          
        } else {
          // EOF
          finish(SUCCESS);
          return;
        }
      }
      
      
      actualAddress = currentNode->flashAddress + sizeof(nodemeta_t) + offset;
      if(currentFile->firstNode == currentNode) {
        actualAddress += sizeof(filemeta_t);
      }
      
      if(isWriting()) {
        post write();
        
      } else { 
        post read();
      }
        
    } else {
      // Transaction complete
      finish(SUCCESS);
    }
  }
  
  
  /**
   * After one flashnode_t is completely written,
   * the flashnode_t must be finalized to the Checkpoint
   * and the next flashnode_t metadata must be written
   * and obtained before proceeding.
   * Check that the next flashnode_t exists before entering
   * this function
   */
  task void writeNextNode() {
    bool constructing = currentNode->nodestate == NODE_CONSTRUCTING;
    // 1. Lock this flashnode_t in RAM
    // 2. Make the current flashnode_t the next node... then,
    // 3. Write the current node's metadata in NodeShop
    // 4. Continue transaction.
    
    
    // A flashnode_t that is constructing virtually gets a special
    // magic number that will delete the flashnode_t if the 
    // mote reboots before we're completely done with the
    // update.
    currentNode = currentNode->nextNode;

    if(constructing) {
      currentNode->nodestate = NODE_CONSTRUCTING;
    }
    
    writeCurrentNodeMeta();
  }
  
  
  /**
   * Perform the read from flash 
   */
  task void read() {
    if(call DirectStorage.read(actualAddress, currentBuffer + totalComplete, 
        currentAmount) != SUCCESS) {
      post read();
    }
  }
  
  
  /** 
   * Perform the write to flash 
   */
  task void write() {
    currentNode->dataCrc = call GenericCrc.crc16(currentNode->dataCrc, 
        currentBuffer + totalComplete, currentAmount);
    ////call JDebug.jdbg("FIO.write: writing to address: %xl\n", actualAddress, 0, 0); 
    if(call DirectStorage.write(actualAddress, currentBuffer + totalComplete, 
        currentAmount) != SUCCESS) {
      post write();
    }
  }
  
  
  
  
  /***************** Functions ****************/
  /**
   * Initialize the transaction
   */
  void ioInit(file_t *ioFile, uint32_t fileAddress) {
    currentFile = ioFile;
    totalComplete = 0;
    
    if((currentNode = call NodeMap.getAddressInFile(ioFile, fileAddress, 
        &offset)) == NULL) {
      finish(SUCCESS);
    }
   
    // Any information written to the end of a file_t must be appended!
    // Because if the next address to write to actually belongs to
    // the next flashnode_t in the file, that flashnode_t is checked to see if its
    // metadata is actually written to flash.  This won't check
    // to see if any previous nodes before it have their metadatas
    // written.  It's ok to write to an address previous to the
    // point where we last appended.
    if(isWriting() && currentNode->nodestate == NODE_TEMPORARY) {
      writeCurrentNodeMeta();
      
    } else {
      post transaction();
    }
  }
  
  /**
   * Finish the transaction 
   */
  void finish(error_t error) {
    if(isWriting()) {
      call State.toIdle();
      signal Fileio.writeDone(currentBuffer, totalComplete, error);
      
    } else {
      call State.toIdle();
      signal Fileio.readDone(currentBuffer, totalComplete, error);
    }
  }
  
  /**
   * @return TRUE if this component is writing to flash
   */
  bool isWriting() {
    return call State.getState() == S_WRITING;
  }
  
  /**
   * Write the nodemeta_t for the currentNode to flash
   */
  void writeCurrentNodeMeta() {
    // We'll never have to write the filename_t out here.
    call NodeShop.writeNodemeta(currentFile, currentNode, NULL);
  }
}

