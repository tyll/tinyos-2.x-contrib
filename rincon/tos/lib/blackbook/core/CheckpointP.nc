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
 * Blackbook Checkpoint Module
 * Saves the state of open binary nodes to a Checkpoint
 * dicationary file_t on flash for catastrophic failure recovery.
 *
 * Use unique("Checkpoint") when connecting to a parameterized interface
 *
 * @author David Moss - dmm@rincon.com
 */
 
includes BDictionary;
 
module CheckpointP {
  provides {
    interface Checkpoint;
    interface Init;
  }
  
  uses {
    interface NodeMap;
    interface NodeShop; 
    interface BDictionary;
    interface InternalDictionary;
    interface State;
    interface BlackbookUtil;
    interface CheckNode;
    ////interface JDebug;
  }
}

implementation {
  
  /** TRUE if we currently have a checkpoint_t file_t open for interaction */
  bool checkpointFileOpened;
  
  /** The current checkpoint_t information being read or written to flash */
  checkpoint_t currentCheckpoint;
  
  /** Buffer to store a dictionary magic header */
  uint16_t dictionaryHeaderBuffer;

  /** Current flashnode_t to repair */  
  flashnode_t *currentNode;
 
  /** Checkpoint States */
  enum {
    S_IDLE = 0,
    S_OPEN,
    S_UPDATE,
    S_RECOVER,
  };
  
  /***************** Prototypes ****************/
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    checkpointFileOpened = FALSE;
    return SUCCESS;
  }
  
  
  /***************** Checkpoint Commands ****************/
  /**
   * After boot is complete, open the checkpoint_t file
   * in the BDictionary
   * @return SUCCESS if the checkpoint file will be 
   *     created and/or opened.
   */
  command error_t Checkpoint.openCheckpoint() {
    if(!checkpointFileOpened) {
      if(call State.requestState(S_OPEN) != SUCCESS) {
        return FAIL;
      }
      
      if(call BDictionary.open("cp.bb_", 
          call BlackbookUtil.convertWriteUnitsToBytes(
              CHECKPOINT_DEDICATED_PAGES) - sizeof(nodemeta_t) 
                  - sizeof(filemeta_t)) != SUCCESS) {
        call State.toIdle();
        return FAIL;
      }
      
    } else {
      call State.toIdle();
      signal Checkpoint.checkpointOpened(SUCCESS);
    }

    return SUCCESS;
  }
  
  /**
   * Update a node.
   * @param focusedNode - the flashnode_t to save or delete
   * @return SUCCESS if the information will be updated
   */
  command error_t Checkpoint.update(flashnode_t *focusedNode) {
    if(call State.requestState(S_UPDATE) != SUCCESS) {
      //trace(1000);
      return FAIL;  
    }
    
    //trace(1001);
    currentNode = focusedNode;
    
    if(currentNode == NULL) {
      //trace(1002);
      call State.toIdle();
      return FAIL;
    }
    
    if(currentNode->nodestate == NODE_VALID) {
      //trace(1003);
      // This flashnode_t needs to be saved.
      currentCheckpoint.filenameCrc = currentNode->filenameCrc;
      currentCheckpoint.dataCrc = currentNode->dataCrc;
      currentCheckpoint.dataLength = currentNode->dataLength;
      ////call JDebug.jdbg("cp.update node is valid addr: %xl\n", &(currentNode->flashAddress), 0, 0);
      if(currentNode->nextNode->nodestate == NODE_VALID) {
        ////call JDebug.jdbg("cp.update: node locked\n", 0, 0, 0);
        //trace(1004);
        currentNode->nodestate = NODE_LOCKED;
      }
      
      //trace(1005);
      if(call BDictionary.insert(currentNode->flashAddress, &currentCheckpoint, 
          sizeof(checkpoint_t)) != SUCCESS) {
        //trace(1006);
        call State.toIdle();
        return FAIL;
      }
      
    } else if(currentNode->nodestate == NODE_DELETED) {
      //trace(1007);
      // This flashnode_t should be removed from the Checkpoint.
      if(call BDictionary.remove(currentNode->flashAddress) != SUCCESS) {
        //trace(1008);
        call State.toIdle();
        return FAIL;
      }
            
    } else {
      //trace(1009);
      // Nothing to do. Signal and complete.
      ////call JDebug.jdbg("cp.update nothing happening\n", 0, 0, 0);
      call State.toIdle();
      signal Checkpoint.updated(currentNode, SUCCESS);
    }
    ////call JDebug.jdbg("cp.update returned\n", 0, 0, 0);
    
    //trace(1010);
    return SUCCESS;
  }
  
  /**
   * Recover a node's dataLength and dataCrc
   * from the Checkpoint.
   *
   * If the flashnode_t cannot be recovered, it is deleted.
   *
   * @param focusedNode - the flashnode_t to recover, with client set to its element number
   * @return SUCCESS if recovery will proceed
   */
  command error_t Checkpoint.recover(flashnode_t *focusedNode) {
    if(call State.requestState(S_RECOVER) != SUCCESS) {
      return FAIL;
    }
    
    currentNode = focusedNode;
    
    if(currentNode->nodeflags & DICTIONARY) {
      currentNode->dataLength = currentNode->reserveLength;
      currentNode->dataCrc = 0;
      currentNode->nodestate = NODE_VALID;
      call State.toIdle();
      signal Checkpoint.recovered(currentNode, SUCCESS);
      return SUCCESS;
    }
    
    if(SUCCESS != call BDictionary.retrieve(currentNode->flashAddress, &currentCheckpoint, 
        sizeof(checkpoint_t))) {
      call State.toIdle();
      return FAIL;
    }
    
    return SUCCESS;
  }
  
  /***************** BDictionary Events ****************/
  
  /**
   * A Dictionary file_t was opened successfully.
   * @param totalSize - the total amount of flash space dedicated to storing
   *     key-value pairs in the file
   * @param remainingBytes - the remaining amount of space left to write to
   * @param error - SUCCESS if the file_t was successfully opened.
   */
  event void BDictionary.opened(uint32_t totalSize, uint32_t remainingBytes,
      error_t error) {
    checkpointFileOpened = TRUE;
    call State.toIdle();
    signal Checkpoint.checkpointOpened(error);
  }
  
  /** 
   * The opened Dictionary file_t is now closed
   * @param error - SUCCSESS if there are no open files
   */
  event void BDictionary.closed(error_t error) {
    checkpointFileOpened = FALSE;
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
    call State.toIdle();
    ////call JDebug.jdbg("CP.inserted\n", 0, 0, 0);
    signal Checkpoint.updated(currentNode, error);
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
    if(!error) {
      ////call JDebug.jdbg("CP.Bdict.retrieved ln 245\n", 0, 0, 0);
      if(currentNode->filenameCrc == currentCheckpoint.filenameCrc) {
        if(currentNode->nextNode != NULL){
          ////call JDebug.jdbg("CP.Bdict.retrieved: node locked here flashAddr = %xl\n", currentNode->flashAddress, 0, 0);
          currentNode->nodestate = NODE_LOCKED;
        }
        currentNode->dataLength = currentCheckpoint.dataLength;
        currentNode->dataCrc = currentCheckpoint.dataCrc;
        //This is where we check to see if the node was written after the last save
        call State.toIdle();
        call CheckNode.checkNode(currentNode);
        return;
      }
    }
      
    // Recovery failed
    /*
     * We now do a check on Checkpoint.recover to see if this is a dictionary
     * node
    if(currentNode->fileElement == 0) {
      if(call InternalDictionary.isFileDictionary(
          call NodeMap.getFileFromNode(currentNode))) {
        return;
      }
    }
     *
     */
     
    ////call JDebug.jdbg("CP.Bdict.retrieved: retrieve failed\n", 0, 0, 0);
    call NodeShop.deleteNode(currentNode); 
  }
  
  /**
   * A key-value pair was removed
   * @param key - the key that should no longer exist
   * @param error - SUCCESS if the key was really removed
   */
  event void BDictionary.removed(uint32_t key, error_t error) {
    if(call State.getState() == S_UPDATE) {
      call State.toIdle();
      ////call JDebug.jdbg("CP: updated!", 0, 0, 0);
      signal Checkpoint.updated(currentNode, error);
      
    } else if(call State.getState() == S_RECOVER) {
      call State.toIdle();
      signal Checkpoint.recovered(currentNode, error);
    }
  }
  
  /**
   * The next key in the open Dictionary file
   * @param key - the next key
   * @param error - SUCCESS if this information is valid
   */
  event void BDictionary.nextKey(uint32_t nextKey, error_t error) {
  }
  
  event void BDictionary.fileIsDictionary(bool isDictionary, error_t error) {
    if(call State.getState() == S_RECOVER) {
      if(!error && isDictionary) {
        currentNode->dataLength = currentNode->reserveLength;
        currentNode->nodestate = NODE_VALID;
        call State.toIdle();
        signal Checkpoint.recovered(currentNode, error);
      
      } else {
        call NodeShop.deleteNode(currentNode);
      }
    }
  }
  
  event void BDictionary.totalKeys(uint16_t totalKeys) {
  }
  /***************** CheckNode Events*****************/
  
  event void CheckNode.nodeChecked(flashnode_t *focusedNode, bool ok2write){
    
    if(!ok2write){
      focusedNode -> nodestate = NODE_LOCKED;
    }
    signal Checkpoint.recovered(currentNode, SUCCESS);  
  }
  /***************** NodeShop Events ****************/
  
  /** 
   * The node's metadata was written to flash
   * @param focusedNode - the flashnode_t that metadata was written for
   * @param error - SUCCESS if it was written
   */
  event void NodeShop.metaWritten() {
  }
  
  /**
   * The filename was retrieved from flash
   * @param focusedFile - the file_t that we obtained the filename for
   * @param *name - pointer to where the filename was stored
   * @param error - SUCCESS if the filename was retrieved
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
    file_t *focusedFile;
    
    if(call State.getState() == S_RECOVER) {
      if((focusedFile = call NodeMap.getFileFromNode(focusedNode)) != NULL) {
        if(focusedFile->firstNode == focusedNode) {
          focusedFile->filestate = FILE_EMPTY;
        }
      }
      focusedNode->nodestate = NODE_EMPTY;
      call BDictionary.remove(currentNode->flashAddress);
      return; 
    }
  }
 
  /**
   * A crc was calculated from flashnode_t data on flash
   * @param dataCrc - the crc of the data read from the flashnode_t on flash.
   * @param error - SUCCESS if the crc is valid
   */
  event void NodeShop.crcCalculated(uint16_t dataCrc) {
  }
  
}


