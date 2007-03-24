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
 * Blackbook Full Boot Module
 *
 *  1. Start at the first valid sector of flash and 
 *     read nodes, documenting, deleting, etc.
 *
 *  2. Repeat step 1 for every sector.
 *
 *  3. After all nodes on all sectors have been accounted for,
 *     recover their dataLengths and dataCrc's from the Checkpoint
 *  
 *  4. Link the files and nodes together in the NodeBooter.
 * 
 *  5. Boot complete.
 *
 * @author David Moss - dmm@rincon.com
 */
 
#include "Blackbook.h"
#include "BlackbookConst.h"

module BBootFullP {
  provides {
    interface BBoot;
  }
  
  uses {
    interface Boot;
    interface GenericCrc; 
    interface DirectStorage;
    interface VolumeSettings;
    interface EraseUnitMap;
    interface NodeBooter;
    interface Checkpoint;
    interface NodeShop;
    interface NodeMap;
    interface State as CommandState;
    interface State as BlackbookState;
    ////interface JDebug;
  }
}

implementation {

  /** The current address we're scanning */
  uint32_t currentAddress;
  
  /** The current nodemeta_t being read from flash */
  nodemeta_t currentNodeMeta;
  
  /** The currently allocated flashnode_t from the NodeBooter */
  flashnode_t *currentNode;
  
  /** The currently allocated file_t from the NodeBooter */
  file_t *currentFile;
  
  /** The current sector index we're working with */
  uint8_t currentIndex;

  /** The current filename_t readd from flash */
  filename_t currentFilename;
  
  
  /** Command States */
  enum {
    S_IDLE_TWO = 0,
    S_READ_NODEMETA,
    S_READ_FILEMETA,
  };
  
  /***************** Prototypes ****************/
  /** Parse the newly read flashnode_t */
  task void parseCurrentNode();
  
  /** Allocate a new flashnode_t and read it in from currentAddress */
  task void getNewNode();
  
  /** Allocate a new file_t and read it in from currentAddress */
  task void getNewFile();
  
  /** Read the nodemeta_t for the flashnode_t at currentAddress */
  task void readNodeMeta();
  
  /** Read the filemeta for the flashnode_t at currentAddress */
  task void readFileMeta();
 
  /** Continue parsing through the flash */
  task void continueParsing();

  /** Recover all node's dataLength's and dataCrc's */
  task void recoverNodes();
  
 /***************** BBoot Commands ****************/
  /**
   * @return TRUE if the file_t system has booted
   */
  command bool BBoot.isBooted() {
    return (call BlackbookState.getState() != S_BOOT_BUSY) 
        && (call BlackbookState.getState() != S_BOOT_RECOVERING_BUSY);
  }
  
  /***************** DirectStorage Events ****************/
  /**
   * Signaled when the flash is ready to be used
   * @param error - SUCCESS if we can use the flash.
   */
  event void Boot.booted() {
    call BlackbookState.forceState(S_BOOT_BUSY);
    currentIndex = 0;
    post continueParsing();
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
    if(call CommandState.getState() == S_READ_NODEMETA) {
      if(error) {
        post readNodeMeta();
        return;
      }

      if(currentNodeMeta.magicNumber != META_INVALID 
          && currentNodeMeta.fileElement == 0) {
        ////////call JDebug.jdbg("Boot: Reading filemeta at %xl", currentAddress + sizeof(nodemeta_t), 0, 0);
        post getNewFile();
        return;
        
      } else {
        post parseCurrentNode(); 
      }
      
    } else if(call CommandState.getState() == S_READ_FILEMETA) {
      if(error) {
        post readFileMeta();
        return;
      }
      
      currentFile->filenameCrc = call GenericCrc.crc16(0, &currentFilename, 
          sizeof(filename_t));
      currentFile->firstNode = currentNode;
      currentFile->filestate = FILE_IDLE;
      
      post parseCurrentNode();
    }
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

  
  /***************** NodeShop Events ****************/
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
  
  /**
   * A flashnode_t was deleted from flash by marking its magic number
   * invalid in the metadata.
   * @param focusedNode - the flashnode_t that was deleted.
   * @param error - SUCCESS if the flashnode_t was deleted successfully.
   */
  event void NodeShop.metaDeleted(flashnode_t *focusedNode) {
    if(call BlackbookState.getState() == S_BOOT_BUSY) {
      currentNode->nodestate = NODE_EMPTY;
      if(currentFile != NULL) {
       currentFile->filestate = FILE_EMPTY;
      }
      post continueParsing();
    }
  }
 
  /**
   * A crc was calculated from flashnode_t data on flash
   * @param dataCrc - the crc of the data read from the flashnode_t on flash.
   * @param error - SUCCESS if the crc is valid
   */
  event void NodeShop.crcCalculated(uint16_t dataCrc) {
  }
  
  
  
  /***************** Checkpoint Events ****************/
  /**
   * The checkpoint file_t was opened.
   * @param error - SUCCESS if it was opened successfully
   */
  event void Checkpoint.checkpointOpened(error_t error) {
    if(call BlackbookState.getState() == S_BOOT_BUSY) {
      if(error) {
        // Don't change the Blackbook state - just fail and lock up blackbook.
        signal BBoot.booted(call NodeMap.getTotalNodes(), 
            call NodeMap.getTotalFiles(), FAIL);
      }
      
      call BlackbookState.forceState(S_BOOT_RECOVERING_BUSY);
      currentIndex = 0;
      post recoverNodes();
    }
  }
  
  /**
   * The given flashnode_t was updated in the Checkpoint
   * @param focusedNode - the flashnode_t that was updated
   * @param error - SUCCESS if everything's ok
   */
  event void Checkpoint.updated(flashnode_t *focusedNode, error_t error) {
  }

  /** 
   * A flashnode_t was recovered.
   * @param error - SUCCESS if it was handled correctly.
   */
  event void Checkpoint.recovered(flashnode_t *focusedNode, error_t error) {
    if(call BlackbookState.getState() == S_BOOT_RECOVERING_BUSY) {
      
      call EraseUnitMap.documentNode(currentNode);
      if(currentNode->nodestate == NODE_DELETED) {
        currentNode->nodestate = NODE_EMPTY;
      }      
      
      currentIndex++;
      post recoverNodes();
    }
  }
  
  
  /***************** Tasks ****************/
  /**
   * Parse the current flashnode_t and nodemeta_t
   */
  task void parseCurrentNode() {
    currentNode->fileElement = currentNodeMeta.fileElement;
    currentNode->filenameCrc = currentNodeMeta.filenameCrc;
    currentNode->nodeflags = currentNodeMeta.nodeflags;
    currentNode->reserveLength = currentNodeMeta.reserveLength;
    //WHY IS THIS TRUE???
    currentNode->dataLength = currentNode->reserveLength;
    ////call JDebug.jdbg("Node flags %s", 0, 0, currentNode->nodeflags);
    if(currentNode->nodeflags & DICTIONARY) {
      ////call JDebug.jdbg("Dictionary node", 0, 0, 0);
    } else {
      ////call JDebug.jdbg("Regular node", 0, 0, 0);
    }
    
    
    ////////call JDebug.jdbg("Boot: parsing node...", 0, 0, 0);
    if(currentNodeMeta.magicNumber == META_EMPTY) {
      // Advance to the next sector.
      ////////call JDebug.jdbg("Boot:      no node found", 0, 0, 0);
      currentNode->nodestate = NODE_EMPTY;
      if(currentFile != NULL) {
        currentFile->filestate = FILE_EMPTY;
      }
      
      currentIndex++;
      
    } else if(currentNodeMeta.magicNumber == META_CONSTRUCTING) {
      /*
       * This flashnode_t must be deleted. 
       * First we act like it's there, then we delete it.
       */
      ////////call JDebug.jdbg("Boot:      constructing node found", 0, 0, 0);
      currentNode->nodestate = NODE_VALID;
      call EraseUnitMap.documentNode(currentNode);
      ////call JDebug.jdbg("BBoot.parse: Meta Constructing\n", 0, 0, 0);
      call NodeShop.deleteNode(currentNode);
      return;
        
    } else if(currentNodeMeta.magicNumber == META_VALID) {
      ////call JDebug.jdbg("Boot.parseNode: Valid node found, addr: %xl, data: %xi, res: %xs",  currentNode->flashAddress, (uint16_t)(currentNode->reserveLength), (uint8_t)(currentNode->dataLength));
      currentNode->nodestate = NODE_BOOTING;
      if(currentFile != NULL) {
        currentFile->filestate = FILE_IDLE;
      }
      
      if(call NodeMap.hasDuplicate(currentNode)) {
        ////call JDebug.jdbg("BBoot.parseNode: Duplicate found\n", 0, 0, 0);
        call NodeShop.deleteNode(currentNode);
        return; 
      } else {
        call EraseUnitMap.documentNode(currentNode);
      }
      
    } else if(currentNodeMeta.magicNumber == META_INVALID) {
      ////////call JDebug.jdbg("Boot:      invalid node found", 0, 0, 0);
      currentNode->nodestate = NODE_DELETED;
      if(currentFile != NULL) {
        currentFile->filestate = FILE_EMPTY;
      }
      ////////call JDebug.jdbg("Boot:      documenting invalid node", 0, 0, 0);
      call EraseUnitMap.documentNode(currentNode);
      ////////call JDebug.jdbg("Boot:      done documenting", 0, 0, 0);
      currentNode->nodestate = NODE_EMPTY;
      
    } else {
      // Garbage found. Document, remove, and advance to the next page.
      ////call JDebug.jdbg("Boot:      garbage found", 0, 0, 0);
      currentNode->nodestate = NODE_DELETED;
      currentNode->flashAddress = currentAddress;
      currentNode->reserveLength = 1;
      currentNode->dataLength = 1;
      call EraseUnitMap.documentNode(currentNode);
      currentNode->nodestate = NODE_EMPTY;
      if(currentFile != NULL) {
        currentFile->filestate = FILE_EMPTY;
      }
    }
    
    post continueParsing();
  }
  
  /**
   * Controls the state of the boot loop
   * and verifies the currentAddress is within range
   */
  task void continueParsing() {
    ////////call JDebug.jdbg("Boot: currentIndex=%i", 0, currentIndex, 0);
    if(currentIndex < call EraseUnitMap.getTotalEraseBlocks()) {
      // Ensure the current address is not at the next sector's base address
      if((currentAddress = call EraseUnitMap.getEraseBlockWriteAddress(
          call EraseUnitMap.getEraseBlock(currentIndex))) 
              < call EraseUnitMap.getNextEraseBlockAddress(
                  call EraseUnitMap.getEraseBlock(currentIndex))) {
        
        ////////call JDebug.jdbg("Boot: currentAddress set to %xl", currentAddress, 0, 0);
        post getNewNode();
      
      } else {
        // Reached the end of the erase block
        ////////call JDebug.jdbg("Boot: reached the end of the erase block", 0, 0, 0);
        currentIndex++;
        post continueParsing();
      }
      
    } else {
      // Done loading nodes, open the checkpoint, link, and finish booting
      ////////call JDebug.jdbg("Boot: call Checkpoint.openCheckpoint", 0, 0, 0);
      call Checkpoint.openCheckpoint();
    }
  }
  
  
  /**
   * Recover each flashnode_t from the Checkpoint file.
   */
  task void recoverNodes() {
    if(currentIndex < call NodeMap.getMaxNodes()) {
      currentNode = call NodeMap.getNodeAtIndex(currentIndex);
      if(currentNode->nodestate == NODE_BOOTING) {
        if(call Checkpoint.recover(currentNode) == SUCCESS) {
          return;
        }
      }
      
      // Could not recover the node... this shouldn't happen.
      currentIndex++;
      post recoverNodes();
      
    } else {
      call NodeBooter.link();
      call BlackbookState.toIdle();
      ////////call JDebug.jdbg("BBootFull: Booted with %i files", 0, call NodeMap.getTotalFiles(), 0);
      signal BBoot.booted(call NodeMap.getTotalNodes(), 
          call NodeMap.getTotalFiles(), SUCCESS);
    }
  }
  
  /**
   * Allocate a new flashnode_t and read it in from currentAddress
   */
  task void getNewNode() {
    currentFile = NULL;
    if((currentNode = call NodeBooter.requestAddNode()) == NULL) {
      // There aren't enough nodes in our NodeMap. Do not change
      //  the BlackbookState to prevent the file_t system from being
      //  further corrupted.
      signal BBoot.booted(call NodeMap.getTotalNodes(), 
          call NodeMap.getTotalFiles(), FAIL);
      return;
    }
   
    post readNodeMeta();
  }

  
  /**
   * Allocate a new file_t and read it in from currentAddress
   */
  task void getNewFile() {
    if((currentFile = call NodeBooter.requestAddFile()) == NULL) {
      // Massive error: There aren't enough nodes in our NodeMap
      //  to supply the amount of nodes on flash. Do not change
      //  the BlackbookState to prevent the file_t system from being
      //  corrupted.
      signal BBoot.booted(call NodeMap.getTotalNodes(), 
          call NodeMap.getTotalFiles(), FAIL);
      return;
    }
    
    currentFile->firstNode = currentNode;
    post readFileMeta(); 
  }
  
  /**
   * Read the nodemeta_t from the flashnode_t at currentAddress
   */
  task void readNodeMeta() {
    ////////call JDebug.jdbg("Boot: node@%xl?", currentAddress, 0, 0);
    call CommandState.forceState(S_READ_NODEMETA);
    currentNode->flashAddress = currentAddress;
    if(call DirectStorage.read(currentAddress, &currentNodeMeta, 
        sizeof(nodemeta_t)) != SUCCESS) {
      post readNodeMeta();
    }
  }
  
  /** 
   * Read the filemeta for the flashnode_t at currentAddress
   * into the currentFile
   */
  task void readFileMeta() {
    ////////call JDebug.jdbg("Boot: file@%xl?", currentAddress + sizeof(nodemeta_t), 0, 0);
    call CommandState.forceState(S_READ_FILEMETA);
    if(call DirectStorage.read(currentAddress + sizeof(nodemeta_t), 
        &currentFilename, sizeof(filemeta_t)) != SUCCESS) {
      post readFileMeta();
    }
  }
  
  default event void BBoot.booted(uint16_t totalNodes, uint8_t totalFiles, error_t error) {
  }
  
}



