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
 * Blackbook File Write Allocator
 * This component allows you to open a file_t with the given name and minimum
 * size, and the given type for writing.  If the file_t already exists,
 * it will be opened and if needed, more space will be allocated to the file
 * to meet the new minimum space requirements.  If the file_t doesn't exist,
 * it will be allocated in both the NodeMap and on flash and created.
 * In the end, if enough space exists and the file_t is created successfully,
 * the flashnode_t that can be written to in the file_t will be passed back.
 * When whatever component fills that flashnode_t completely and wants to keep
 * writing, it will need to load up the next flashnode_t in the file_t if it
 * exists.
 * @author David Moss - dmm@rincon.com
 */

#include "Blackbook.h"

module WriteAllocP {
  provides {
    interface WriteAlloc;
  }
  
  uses {
    interface EraseUnitMap;
    interface NodeMap;
    interface NodeBooter;
    interface NodeShop;
    interface State;
    interface BClean;
    interface BlackbookUtil;
    ////interface JDebug;
  }
}

implementation {

  /** The file_t we're trying to open for writing */
  file_t *currentFile;
  
  /** The flashnode_t we're working on */
  flashnode_t *currentNode;
  
  /** The current sector we're looking at */
  flasheraseblock_t *currentEraseBlock;
  
  /** Filename buffer */
  filename_t currentFilename;
  
  /** The minimum size to create the file_t */
  uint32_t minSize;
  
  /** The total size allocated to the file_t */
  uint32_t totalSize;
  
  /** Error to finish with */
  error_t finishError;
  
  /** TRUE if this open write file_t is to be deleted if the mote reboots */
  bool constructing;
  
  /** TRUE if we are to only allocate one flashnode_t for the file_t */
  bool onlyOneNode;
  
  /** The element number to set for the next allocated flashnode_t */
  uint8_t nextElement;
  
  /** TRUE if BClean was called during the current allocation attempt */
  bool cleaned;
  
  enum {
    S_IDLE = 0,
    S_OPEN,
  };

  /***************** Prototypes ****************/
  /** Set the 'finishError' variable and call finish to signal completion */
  task void finish();
  
  /** Allocate space on flash for the currentNode */
  task void allocate();
  
  
  /** Allocate and test a single sector to the currentNode */
  bool allocateOneEraseBlock();
  
  /** Function that deconstructs the file and completes with FAIL */
  void fail();
  
  /** Deconstruct the current file_t */
  void closeCurrentFile();
 
  /** Find and unfinalize (if necessary) the first writable flashnode */
  void getWritableNode(); 
  
  
  /***************** WriteAlloc Commands ****************/
  /**
   * Open a file_t for writing
   * Create a file_t with the given name and the specified minimum length
   * @return SUCCESS if the file_t will be opened for writing.
   */
  command error_t WriteAlloc.openForWriting(char *fileName, 
      uint32_t minimumSize, bool forceConstruction, bool oneNode) {
    flashnode_t *lastNode;
    if(call State.requestState(S_OPEN) != SUCCESS) {
      return FAIL;
    }

    cleaned = FALSE;
    minSize = minimumSize;
    totalSize = 0;
    constructing = forceConstruction;
    onlyOneNode = oneNode;
    nextElement = 0;
       
    call BlackbookUtil.filenameCpy(&currentFilename, fileName);
    currentFile = call NodeMap.getFile(&currentFilename);
    
    if(currentFile == NULL || forceConstruction) {
      // The file_t does not exist and needs to be created
      ////call JDebug.jdbg("WA: File needs to be created\n", 0, 0, 0);
      if((currentFile = call NodeBooter.requestAddFile()) == NULL) {
        call State.toIdle();
        return FAIL;
      }
      
      if((currentNode = call NodeBooter.requestAddNode()) == NULL) {
        call State.toIdle();
        return FAIL;
      }
      
      currentFile->filestate = FILE_TEMPORARY;
      currentFile->filenameCrc = call BlackbookUtil.filenameCrc(
          &currentFilename);
      currentFile->firstNode = currentNode;

      currentNode->filenameCrc = currentFile->filenameCrc;
      currentNode->nodestate = NODE_TEMPORARY;
      
      if(onlyOneNode) {
        currentNode->nodeflags = DICTIONARY;
      }
      
      post allocate();
      return SUCCESS;
      
    } else {
      // The file_t already exists.
      ////call JDebug.jdbg("WA: File already exists\n", 0, 0, 0);
      //ADDED SECOND TEST CONDITION SO FILE CAN BE OPENED FOR WRITING IF ALREADY OPEN FOR READING!!!!
      if((currentFile->filestate != FILE_IDLE) && (currentFile->filestate != FILE_READING)) {
        call State.toIdle();
        return FAIL;
      }

      currentNode = currentFile->firstNode;

      // Traverse through each existing flashnode_t of the file.
      do {
        ////call JDebug.jdbg("WA.openforwrite flashAddr = %xl\n", currentNode->flashAddress, 0, 0);
        if(oneNode) {
          // This is a dictionary file, add up its reserveLength
          // because the dataLength isn't set when Checkpoint opens this up
          // during boot
          totalSize += currentNode->reserveLength;  
        } else {
          totalSize += currentNode->dataLength;
          //minSize -= currentNode->dataLength;
        }
        
        lastNode = currentNode;
        nextElement++;
      } while((currentNode = currentNode->nextNode) != NULL);
      
      //At the last node, we need to see what space is available in the reserve also, as it is part of
      //the total size of the node, reserve length on dictionary file should be 0
      if(lastNode->nodestate != NODE_LOCKED){
        totalSize += lastNode->reserveLength;
        //reserve length includes the datalength as it represents the entire space of the node
        totalSize -= lastNode->dataLength;
      }
      // 'lastNode' now contains the last flashnode_t of the file.
      // 'currentNode' now contains NULL
      ////call JDebug.jdbg("WA.openforwrite: resLen = %xl, dataLen = %xi\n", 
      ////		lastNode->reserveLength, (uint16_t)(lastNode->dataLength), 0);   
      if((totalSize < minSize || lastNode->nodestate == NODE_LOCKED) 
          && !oneNode) {
        if(totalSize >= minSize){
          getWritableNode();
          return SUCCESS;
        }
        // Allocate more nodes to this file.
        if((currentNode = call NodeBooter.requestAddNode()) == NULL) {
          // Can't - we're out of nodes in our NodeMap.
          closeCurrentFile();
          return FAIL;
          
        } else {
          ////call JDebug.jdbg("WA.openforwrite: allocating node\n", 0, 0, 0);
          lastNode->nextNode = currentNode;
          currentNode->filenameCrc = currentFile->filenameCrc;
          currentNode->nodestate = NODE_TEMPORARY;
          post allocate();
          return SUCCESS;
        }
        
      } else {
        // Enough reserve space exists already, hand it over.
        ////call JDebug.jdbg("WA.openforwrite: enough reserve totalsize= %xl, minsize= %xi\n", totalSize, minSize, 0);
        getWritableNode();
        return SUCCESS;
        
      }
    } 
    
    return SUCCESS;
  }
  
  /***************** NodeShop Events ****************/
  /** 
   * The node's metadata was written to flash
   * @param focusedNode - the flashnode_t that metadata was written for
   * @param error - SUCCESS if it was written
   */
  event void NodeShop.metaWritten() {
    if(call State.getState() == S_OPEN) {
      finishError = SUCCESS;
      post finish();
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
  
  
  /***************** BClean Tasks ****************/ 
  /**
   * @return SUCCESS if any sectors were erased.
   */
  event void BClean.gcDone(error_t error) {
    flashnode_t *lastGoodNode;
    if(call State.getState() == S_OPEN) {
      if(error) {
        fail();
        return;
      }
      
      cleaned = TRUE;
      
      // 1. Erase all the current temporary nodes
      //    and find the last non-temporary flashnode_t of the file
      currentNode = currentFile->firstNode;
      lastGoodNode = NULL;
      totalSize = 0;
      nextElement = 0;
      
      do {
        if(currentNode->nodestate == NODE_TEMPORARY) {
          call EraseUnitMap.freeEraseBlock(
              call EraseUnitMap.getEraseBlockAtAddress(
                  currentNode->flashAddress));
          currentNode->nodestate = NODE_EMPTY;
          
        } else {
          if(onlyOneNode) {
            // This is a dictionary file, add up its reserveLength
            // because the dataLength isn't set when Checkpoint opens this up
            // during boot
            totalSize += currentNode->reserveLength;  
          
          } else {
            totalSize += currentNode->dataLength;
            minSize -= currentNode->dataLength;
          }
          
          nextElement++;
          lastGoodNode = currentNode;
        }
      } while((currentNode = currentNode->nextNode) != NULL);
    
      
      // 2. Allocate a flashnode_t to the file
      if((currentNode = call NodeBooter.requestAddNode()) == NULL) {
        fail();
        return;
      }
      
      // 3. Sew it into our linked list
      if(lastGoodNode == NULL) {
        currentFile->firstNode = currentNode;
      } else {
        lastGoodNode->nextNode = currentNode;
      }
      
      // 4. Setup parameters and re-attempt allocation
      currentNode->filenameCrc = currentFile->filenameCrc;
      currentNode->nodestate = NODE_TEMPORARY;
      
      post allocate();
    }
  }
  
  event void BClean.erasing() {
  }
  
  /***************** Tasks ****************/
  /**
   * A flashnode_t has already been reserved in the NodeMap,
   * this task will allocate space on flash for the node.
   */
  task void allocate() {
    if(!allocateOneEraseBlock()) {
      if(!cleaned) {
        call BClean.gc();
        
      } else {
        fail();
      }
    }
  }
  
  /**
   * Finish with the error stored in 'finishError'
   */
  task void finish() {
    call State.toIdle(); 
    
    if(onlyOneNode) {
      // Dictionary nodes only use one node, and their dataLength is always full
      currentNode->dataLength = currentNode->reserveLength;
    }
    
    totalSize = 0;
    currentNode = currentFile->firstNode;
    do {
      if(currentNode->nodestate == NODE_VALID 
           || currentNode->nodestate == NODE_BOOTING
           || currentNode->nodestate == NODE_TEMPORARY
           || currentNode->nodestate == NODE_CONSTRUCTING) {
        totalSize += currentNode -> reserveLength;
      } else /*if(currentNode->nodestate == NODE_LOCKED)*/ {
        totalSize += currentNode->dataLength;
      }
      ////call JDebug.jdbg("WA:finish: totalSize: %xl\n", totalSize, 0, 0);
      ////call JDebug.jdbg("WA:finish: resVal: %xl\n", (uint32_t)(currentNode->reserveLength), 0, 0);
      ////call JDebug.jdbg("WA:finish: dataVal: %xl\n", (uint32_t)(currentNode->dataLength), 0, 0);
    
    } while((currentNode = currentNode->nextNode) != NULL);
    
    //totalSize += currentNode->reserveLength;
    //totalSize -= currentNode->dataLength;
    //////call JDebug.jdbg("WA:finish: totalSize: %xl\n", totalSize, 0, 0);
    //////call JDebug.jdbg("WA:finish: resVal: %xl\n", (uint32_t)(currentNode->reserveLength), 0, 0);
    //////call JDebug.jdbg("WA:finish: dataVal: %xl\n", (uint32_t)(currentNode->dataLength), 0, 0);
    // The totalSize here is actually the append address in the file,
    // if we're finishing successfully.
    signal WriteAlloc.openedForWriting(currentFile, currentNode, totalSize, 
        finishError);
  }

  
  /***************** Functions ****************/
  /**
   * This function will allocate one sector for the currentNode
   * and determine if we need to allocate more sectors
   * for binary files.  When enough space is allocated, it finishes
   * up and returns the first writable node.  If it can't find enough
   * space, it returns FAIL, which will either run the garbage collector
   * or stop the allocation process.
   */
  bool allocateOneEraseBlock() {
    flashnode_t *lastNode;
    uint8_t metaSize = sizeof(nodemeta_t);
    
    
    if((currentEraseBlock = call EraseUnitMap.nextLargestIdleEraseBlock()) 
        == NULL) {
      // No free sectors
      return FALSE;
      
    } else {
      call EraseUnitMap.reserveEraseBlock(currentEraseBlock);
      currentNode->flashAddress = call EraseUnitMap.getEraseBlockWriteAddress(
          currentEraseBlock);
      currentNode->dataLength = 0;
      currentNode->dataCrc = 0;
      currentNode->fileElement = nextElement;
      nextElement++;
      
      if(currentFile->firstNode == currentNode) {
        metaSize += sizeof(filemeta_t);
      }
      
      currentNode->reserveLength = call EraseUnitMap.bytesRemaining(
          currentEraseBlock);
      if(call BlackbookUtil.convertBytesToWriteUnits(currentNode->reserveLength)
           > call BlackbookUtil.convertBytesToWriteUnits(minSize + metaSize 
               - totalSize)) {
        // Too much space was allocated from the sector, back it off
        currentNode->reserveLength = 
            call BlackbookUtil.convertWriteUnitsToBytes(
                call BlackbookUtil.convertBytesToWriteUnits(minSize + metaSize 
                    - totalSize));
      }
	  
      currentNode->reserveLength -= metaSize;
      totalSize += currentNode->reserveLength;
      ////call JDebug.jdbg("WA: allocate: reservelen: %xl\n",
      ////	 (uint32_t)(currentNode->reserveLength), 0, 0);
      ////call JDebug.jdbg("WA: allocate: totalSize: %xl \n", totalSize, 0, 0);
      ////call JDebug.jdbg("WA: allocate: minSize: %xl, metaLen: %xs \n", minSize, 0, metaSize); 
      
      if(totalSize < minSize) {
        // Need to allocate more space
        ////call JDebug.jdbg("WA: allocate: need more space\n", 0, 0, 0);
        lastNode = currentNode;
        if(onlyOneNode){
          return FALSE;
          
        } else if((currentNode = call NodeBooter.requestAddNode()) == NULL) {
          // We're out of nodes in our NodeMap, or we're trying to
          // create a dictionary file_t that requires a single node.
          fail();
      
        } else {
          lastNode->nextNode = currentNode;
          currentNode->filenameCrc = currentFile->filenameCrc;
          currentNode->nodestate = NODE_TEMPORARY;
          post allocate();
          return TRUE;
          
        }
      
      } else {
        // Enough space is allocated - unfinalize the first temporary node
        getWritableNode();
      }
        
      return TRUE;
    }
  }
  
  /**
   * Find the first writable flashnode_t of the file. If it needs
   * to be unfinalized, unfinalize it.  Finish up by
   * signaling completion with the first writable unfinalized node.
   * The app will write to the flashnode_t after the node's dataLength
   * location.
   */
  void getWritableNode() {
    totalSize = 0;  // here, totalSize is used to reflect the append address 
    currentNode = currentFile->firstNode;
    if(currentFile->filestate == FILE_READING){
      currentFile->filestate = FILE_READING_AND_WRITING;
    }
    else{
      currentFile->filestate = FILE_WRITING;
    }
    
    do {
      //totalSize += currentNode->dataLength;
      
      // Traverse through each existing flashnode_t of the file.
      // Find the first writable node.
      // Checkpoint files, on boot, will still be in state NODE_BOOTING,
      // So change them over.
      if(currentNode->nodestate == NODE_VALID 
          || currentNode->nodestate == NODE_BOOTING) {
        currentNode->nodestate = NODE_VALID;
        finishError = SUCCESS;
        post finish();
        return;
        
      } else if(currentNode->nodestate == NODE_TEMPORARY) {
        if(constructing) {
          currentNode->nodestate = NODE_CONSTRUCTING;
        }
        
        call NodeShop.writeNodemeta(currentFile, currentNode, &currentFilename);
        return;
        
      }
    } while((currentNode = currentNode->nextNode) != NULL);
    
    fail();  // Something bad happened. We should have succeeded.
  }
  
  
  /**
   * This operation failed.
   */
  void fail() {
    closeCurrentFile();
    finishError = FAIL;
    post finish();
  }
  
  /**
   * Deallocate and close all nodes for the current
   * binary file_t - this happens before any interaction
   * outside of WriteAlloc so no changes need to be
   * made to flash.
   */
  void closeCurrentFile() {
    if(currentFile->filestate == FILE_TEMPORARY) {
      currentFile->filestate = FILE_EMPTY;
      
    } else if(currentFile->filestate == FILE_WRITING) {
      currentFile->filestate = FILE_IDLE;
    }
    else if(currentFile->filestate == FILE_READING_AND_WRITING){
      currentFile->filestate = FILE_READING;  
    }
    
    currentNode = currentFile->firstNode;
    
    do {
      if(currentNode->nodestate == NODE_TEMPORARY) {
        call EraseUnitMap.freeEraseBlock(
            call EraseUnitMap.getEraseBlockAtAddress(
                currentNode->flashAddress));
        currentNode->nodestate = NODE_EMPTY;
      }
    } while((currentNode = currentNode->nextNode) != NULL);
  }
}

