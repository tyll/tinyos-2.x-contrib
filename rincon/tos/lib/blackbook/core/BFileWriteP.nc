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
 * Blackbook BFileWrite Configuration
 * Open, Write, Save, Close Blackbook files.
 * Use unique("BFileWrite") when connecting to a parameterized
 * interface.
 *
 * @author David Moss - dmm@rincon.com
 * @author Mark Kranz
 */
 
#include "Blackbook.h"

module BFileWriteP {
  provides {
    interface Init;
    interface BFileWrite[uint8_t id];
  }
  
  uses {
    interface State as BlackbookState;
    interface WriteAlloc;
    interface NodeMap;
    interface Fileio; 
    interface Checkpoint;
    interface BlackbookUtil;
    ////interface JDebug;
  }
}

implementation {

  /** Each client's file_t writing information */
  file_t *writers[uniqueCount("BFileWrite")];
  
  /** The current client we're working with */
  uint8_t currentClient;
  
  /** Current flashnode_t we're closing or checkpointing */
  flashnode_t *currentNode;
  
  
  /** Command States */
  enum {
    S_IDLE = 0,
    S_COMMAND_OPEN,
    S_COMMAND_CLOSE,
    S_COMMAND_SAVE,
    S_COMMAND_APPEND,
    
  };
  
  
  /***************** Prototypes ****************/
  
  /** Checkpoint the current client's open file_t */
  task void checkpointNode();
  
  uint32_t getFileLength();
  
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;
    for(i = 0; i < uniqueCount(UQ_BFILEWRITE); i++) {
      writers[i] = NULL;
    }
    return SUCCESS;
  }
  
  
  /***************** BFileWrite Commands ****************/
  /**
   * Open a file_t for writing. 
   * @param fileName - name of the file_t to write to
   * @param minimumSize The minimum requested amount of total data space
   *            to reserve in the file.  The physical amount of flash 
   *            consumed by the file_t may be more.
   */
  command error_t BFileWrite.open[uint8_t id](char *fileName, 
      uint32_t minimumSize) {
    if(call BlackbookState.requestState(S_WRITE_BUSY) != SUCCESS) {
      return FAIL;
    }
    currentClient = id;
    
    if(writers[currentClient] == NULL) {
      if(call WriteAlloc.openForWriting(fileName, minimumSize, FALSE, FALSE) == SUCCESS) {
        return SUCCESS;
      }
    
    } else {
      // There's a file open already
      call BlackbookState.toIdle();
      
      if(call BlackbookUtil.filenameCrc((filename_t *) fileName) ==
          writers[currentClient]->filenameCrc) {
        // It's the same file
        /*
        signal BFileWrite.opened[currentClient](
            call NodeMap.getReserveLength(writers[currentClient]), SUCCESS);
        */
        signal BFileWrite.opened[currentClient](
            getFileLength(), SUCCESS);
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
  command bool BFileWrite.isOpen[uint8_t id]() {
    return (writers[id] != NULL);
  }
  
  
  /**
   * Close any currently opened write file.
   */
  command error_t BFileWrite.close[uint8_t id]() {
    if(call BlackbookState.requestState(S_WRITE_CLOSE_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    currentClient = id;

    if(writers[currentClient] == NULL) {
      call BlackbookState.toIdle();
      signal BFileWrite.closed[currentClient](SUCCESS);
      return SUCCESS;
    }
    
    currentNode = writers[currentClient]->firstNode;
    post checkpointNode();
    return SUCCESS;
  }

  /**
   * Save the current state of the file, guaranteeing the next time
   * we experience a catastrophic failure, we will at least be able to
   * recover data from the open write file_t up to the point
   * where save was called.
   *
   * If data is simply being logged for a long time, use save() 
   * periodically but probably more infrequently.
   *
   * @return SUCCESS if the currently open file_t will be saved.
   */
  command error_t BFileWrite.save[uint8_t id]() {
    if(call BlackbookState.requestState(S_WRITE_SAVE_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    currentClient = id;
    
    if(writers[currentClient] == NULL) {
      call BlackbookState.toIdle();
      return FAIL;
    }
    
    currentNode = writers[currentClient]->firstNode;
    post checkpointNode();
    return SUCCESS;
  }

  /**
   * Append the specified amount of data from a given buffer
   * to the open write file.  
   *
   * @param buf - the buffer of data to append
   * @param amount - the amount of data in the buffer to write.
   * @return SUCCESS if the data will be written, FAIL if there
   *     is no open file_t to write to.
   */ 
  command error_t BFileWrite.append[uint8_t id](void *data, uint16_t amount) {
    if(call BlackbookState.requestState(S_WRITE_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    currentClient = id;
    
    if(writers[currentClient] != NULL) {
      if(call Fileio.writeData(writers[currentClient], 
          call NodeMap.getDataLength(writers[currentClient]), data, amount) 
              == SUCCESS) {
        return SUCCESS;
      }
    }
    
    call BlackbookState.toIdle();
    return FAIL;
  }

  /**
   * Obtain the remaining bytes available to be written in this file
   * @return the remaining length of the file.
   */
  command uint32_t BFileWrite.getRemaining[uint8_t id]() {
    flashnode_t *focusedNode;
    uint32_t remaining = 0;
    
    if(writers[id] != NULL) {
      for(focusedNode = writers[id]->firstNode; focusedNode != NULL; 
          focusedNode = focusedNode->nextNode) {
        if(focusedNode->nodestate != NODE_LOCKED) {
          remaining += focusedNode->reserveLength - focusedNode->dataLength;
        }
      }
    }
    
    return remaining;
  }


  /***************** WriteAlloc Events ****************/
  /**
   * The write open process completed
   * @param openFile - the file_t that was opened for writing 
   * @param writeNode - the flashnode_t to write to
   * @param error - SUCCESS if the file_t was correctly opened
   */
  event void WriteAlloc.openedForWriting(file_t *openFile, 
      flashnode_t *writeNode, uint32_t totalSize, error_t error) {
    if(call BlackbookState.getState() == S_WRITE_BUSY) {
      if(!error) {
        writers[currentClient] = openFile;
      }

      call BlackbookState.toIdle();
      signal BFileWrite.opened[currentClient](totalSize, SUCCESS);
    }
  }
  
  
  /***************** Fileio Events ****************/
  /**
   * Data was appended to the flashnode_t in the flash.
   * @param writeBuffer - pointer to the buffer containing the data written
   * @param amountWritten - the amount of data appended to the node.
   * @param error - SUCCESS if the data was successfully written
   */
  event void Fileio.writeDone(void *writeBuffer, uint32_t amountWritten, 
      error_t error) {
    if(call BlackbookState.getState() == S_WRITE_BUSY) {
      call BlackbookState.toIdle();
      signal BFileWrite.appended[currentClient](writeBuffer, amountWritten, 
          error);
    }
  }
  
  /**
   * Data was read from the file
   * @param *readBuffer - pointer to the location where the data was stored
   * @param amountRead - the amount of data actually read
   * @param error - SUCCESS if the data was successfully read
   */
  event void Fileio.readDone(void *readBuffer, uint32_t amountRead, 
      error_t error) {
  }
  
  /**
   * Data was flushed to flash
   * @param error - SUCCESS if the data was flushed
   */
  event void Fileio.flushDone(error_t error) {
  }
  
  /***************** Checkpoint Events ****************/
  /**
   * The given flashnode_t was updated in the Checkpoint
   * @param focusedNode - the flashnode_t that was updated
   * @param error - SUCCESS if everything's ok
   */
  event void Checkpoint.updated(flashnode_t *focusedNode, error_t error) {
    flashnode_t *previousNode;    
    
    if(call BlackbookState.getState() == S_WRITE_SAVE_BUSY) {
      currentNode = currentNode->nextNode;
      if(currentNode != NULL) {
        if(currentNode->nodestate != NODE_TEMPORARY) {
          post checkpointNode();
          return;
        }
      }
      
      call BlackbookState.toIdle();
      signal BFileWrite.saved[currentClient](error);
     
    } else if(call BlackbookState.getState() == S_WRITE_CLOSE_BUSY) {
      currentNode = currentNode->nextNode;
      if(currentNode != NULL) {
        if(currentNode->nodestate != NODE_TEMPORARY) {
          post checkpointNode();
          return;
        }
      }
      
      currentNode = writers[currentClient]->firstNode;
      for(previousNode = currentNode; currentNode != NULL; 
          currentNode = currentNode->nextNode) {
        if(currentNode->nodestate == NODE_TEMPORARY) {
          previousNode->nextNode = NULL;
          currentNode->nodestate = NODE_EMPTY;
        
        } else if(currentNode->nodestate == NODE_VALID) {
          // Prevent this flashnode_t from ever being written to again
          if(currentNode->nextNode != NULL){
            ////call JDebug.jdbg("BFW.updated: node locked here addr: %xl\n", &(currentNode->flashAddress), 0, 0);
            currentNode->nodestate = NODE_LOCKED;
          }
        }
      }
      
      if(writers[currentClient]->filestate == FILE_READING_AND_WRITING){
        writers[currentClient]->filestate = FILE_READING;
      }
      else{
        writers[currentClient]->filestate = FILE_IDLE;
      }
      
      writers[currentClient] = NULL;
      call BlackbookState.toIdle();
      signal BFileWrite.closed[currentClient](SUCCESS);
    }
  }
  
  /**
   * The checkpoint file_t was opened.
   * @param error - SUCCESS if it was opened successfully
   */
  event void Checkpoint.checkpointOpened(error_t error) {
  }
  
  /** 
   * A flashnode_t was recovered.
   * @param error - SUCCESS if it was handled correctly.
   */
  event void Checkpoint.recovered(flashnode_t *focusedNode, error_t error) {
  }
  
  /***************** Tasks ****************/
  /**
   * Checkpoint the open flashnode_t from the current client
   */
  task void checkpointNode() {
    if(call Checkpoint.update(currentNode) != SUCCESS) {
      post checkpointNode();
    }
  }
  
  
  /***************** Functions ****************/
  
  uint32_t getFileLength(){
  
    flashnode_t *curNode = writers[currentClient]->firstNode;
    flashnode_t *lastNode;
    uint32_t totalSize = 0;
    do {
      totalSize += curNode->dataLength;
      lastNode = curNode;
      
    } while((curNode = curNode->nextNode) != NULL);
    
    if(lastNode->nodestate != NODE_LOCKED){
      totalSize += lastNode->reserveLength;
      totalSize -= lastNode->dataLength;
    }
    return totalSize;
    
  }
  /***************** Defaults ****************/  
  default event void BFileWrite.opened[uint8_t id](uint32_t len, 
      error_t error) {
  }

  default event void BFileWrite.closed[uint8_t id](error_t error) {
  }

  default event void BFileWrite.saved[uint8_t id](error_t error) {
  }

  default event void BFileWrite.appended[uint8_t id](void *data, 
      uint16_t amountWritten, error_t error) {
  }
  
}

