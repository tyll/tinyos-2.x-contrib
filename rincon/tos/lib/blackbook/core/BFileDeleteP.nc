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
 * Blackbook Delete Configuration
 * Invalidate a file_t on flash
 * 
 * @author David Moss - dmm@rincon.com
 */
 
includes Blackbook;

module BFileDeleteP {
  provides {
    interface BFileDelete[uint8_t id];
  }
 
  uses {
    interface State as BlackbookState;
    interface NodeShop;
    interface NodeMap;
    interface Checkpoint;
    interface BlackbookUtil;
    ////interface JDebug;
  }  
}

implementation {
  
  /** The current client we're connected with */
  uint8_t currentClient;
  
  /** The current file_t we're working with */
  file_t *currentFile;
  
  /** The current flashnode_t we're focused on */
  flashnode_t *currentNode;
  
  /** The flashnode_t previous to the current flashnode_t we're focused on */
  flashnode_t *previousNode;
  
  /***************** Prototypes ****************/
  /** Finalize the current flashnode_t if it needs to be */
  task void finalize();
  
  /***************** BFileDelete Commands ****************/
  /**
   * Delete a file_t - from the last flashnode_t to the first node,
   * to prevent the creation of dangling nodes.
   *
   *  1. Locate the last existing flashnode_t of the file.
   *  2. Delete it, remove its checkpoint.
   *  3. Repeat steps 1 and 2 until all nodes are invalidated.
   *  4. Remove all recognition of the file_t from memory.
   *
   * @param fileName - the name of the file_t to delete
   * @return SUCCESS if Blackbook will attempt to delete the file.
   */ 
  command error_t BFileDelete.delete[uint8_t id](char *fileName) {
    filename_t currentFilename;
    if(call BlackbookState.requestState(S_DELETE_BUSY) != SUCCESS) {
      return FAIL;
    }
    
    currentClient = id;
    
    call BlackbookUtil.filenameCpy(&currentFilename, fileName);
    
    if((currentFile = call NodeMap.getFile(&currentFilename)) == NULL) {
      call BlackbookState.toIdle();
      signal BFileDelete.deleted[id](SUCCESS);
      return SUCCESS;
    }
    
    if(currentFile->filestate != FILE_IDLE) {
      call BlackbookState.toIdle();
      signal BFileDelete.deleted[id](FAIL);
      return SUCCESS;
    }

    currentNode = currentFile->firstNode;
    previousNode = currentNode;
    post finalize();
    return SUCCESS;
  }
  
  /***************** NodeShop ****************/
  /**
   * A flashnode_t was deleted from flash by marking its magic number
   * invalid in the metadata.
   * @param focusedNode - the flashnode_t that was deleted.
   * @param error - SUCCESS if the flashnode_t was deleted successfully.
   */
  event void NodeShop.metaDeleted(flashnode_t *focusedNode) {
    if(call BlackbookState.getState() == S_DELETE_BUSY) {
      currentNode->nodestate = NODE_EMPTY;
      previousNode->nextNode = NULL;
    
      if(currentFile->firstNode->nodestate == NODE_EMPTY) {
        currentFile->firstNode = NULL;
        currentFile->filestate = FILE_EMPTY;
        call BlackbookState.toIdle();
        signal BFileDelete.deleted[currentClient](SUCCESS);
        
      } else {
        currentNode = currentFile->firstNode;
        previousNode = currentFile->firstNode;
        post finalize();
      }
    }
  }
 
  /**
   * A crc was calculated from flashnode_t data on flash
   * @param dataCrc - the crc of the data read from the flashnode_t on flash.
   * @param error - SUCCESS if the crc is valid
   */
  event void NodeShop.crcCalculated(uint16_t dataCrc) {
  }
  
  /** 
   * The node's metadata was written to flash
   * @param focusedNode - the flashnode_t that metadata was written for
   * @param error - SUCCESS if it was written
   */
  event void NodeShop.metaWritten() {
  }
  
  /**
   * The filename_t was retrieved from flash
   * @param focusedFile - the file_t that we obtained the filename_t for
   * @param *name - pointer to where the filename_t was stored
   * @param error - SUCCESS if the filename_t was retrieved
   */
  event void NodeShop.filenameRetrieved(filename_t *name) {
  }
  
  
  
  /***************** Checkpoint Events *****************/
  /**
   * The given flashnode_t was updated in the Checkpoint
   * @param focusedNode - the flashnode_t that was updated
   * @param error - SUCCESS if everything's ok
   */
  event void Checkpoint.updated(flashnode_t *focusedNode, error_t error) {
    
    if(call BlackbookState.getState() == S_DELETE_BUSY) {
      call NodeShop.deleteNode(currentNode);
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
   * Finalize the current node
   */
  task void finalize() {
    if((currentNode->nextNode == NULL) 
        || currentNode->nextNode->nodestate == NODE_DELETED) {
      // Working from the last flashnode_t in the file_t to the first node:
      // 1. Remove the checkpoint. This way, if we reboot in the middle,
      //    the flashnode_t will get erased anyway.
      // 2. Invalidate the nodemeta through NodeShop.
      currentNode->nodestate = NODE_DELETED;
      ////call JDebug.jdbg("BDel: call cp.upd", 0, 0, 0);
      call Checkpoint.update(currentNode);
      
    } else {
      // Run to the last flashnode_t of the file
      previousNode = currentNode;
      currentNode = currentNode->nextNode;
      post finalize();
    }
  }
  
  /***************** Functions ****************/

  /***************** Defaults ****************/
  default event void BFileDelete.deleted[uint8_t id](error_t error) {
  }
}



