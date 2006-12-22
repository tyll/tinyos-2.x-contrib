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
 * Blackbook Erase Unit Map 
 * Keeps track of memory usage and reserves erase blocks for
 * writing, helps decide where to place new nodes.
 *
 * BLACKBOOK_TOTAL_ERASEBLOCKS should be defined as a compile flag.
 * Its value is a multiple of the number of actual erase units allocated to 
 * VOLUME_BLACKBOOK.  Erase blocks of 65536 bytes is a good place to start.
 *
 * For example, if VOLUME_BLACKBOOK contains 16 erase units, and 
 * BLACKBOOK_TOTAL_ERASEBLOCKS = 8, then each erase block will contain 2
 * erase units.
 *
 * Another example - if VOLUME_BLACKBOOK contains 16 erase units, and you define
 * BLACKBOOK_TOTAL_ERASEBLOCKS = 5, then each erase block will contain 3
 * erase units, and the last erase block will contain 4 erase units.  This
 * brings the total to 16 erase units.
 *
 * Do not define BLACKBOOK_TOTAL_ERASEBLOCKS to be less than the actual number
 * of erase units in your volume.
 * 
 * This is a pain, I know, but has to suffice for now until one of the following
 * is true:
 *  A) The StorageVolumes.h file uniformly defines the base and sizes of
 *     each volume in an enum accessible at compile time for each chip
 *
 *  B) Blackbook supports nodes laying across erase units.
 *
 *  C) The information in the flashEraseBlocks[] array is maintained on the fly.
 * 
 * @author David Moss (dmm@rincon.com)
 */
 
#include "Blackbook.h"

module EraseUnitMapP {
  provides {
    interface EraseUnitMap;
    interface Init;
  }
  
  uses {
    interface VolumeSettings;
    interface BlackbookUtil;
    interface NodeMap;
  }
}

implementation {
   
  /** Array of erase blocks on the flash - user defined */
  flasheraseblock_t flashEraseBlocks[BLACKBOOK_TOTAL_ERASEBLOCKS];
  
  /** Contains the last erase block we allocated new nodes to */
  uint16_t currentEraseBlockIndex;
  
  /** The total number of valid erase blocks */
  uint16_t totalEraseBlocks;
  
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;
    uint32_t currentEraseUnit;
    uint32_t eraseUnitsPerBlock;
    uint32_t extraEraseUnitsInLastBlock;
    
    totalEraseBlocks = BLACKBOOK_TOTAL_ERASEBLOCKS;
    if(call VolumeSettings.getTotalEraseUnits() < totalEraseBlocks) {
      totalEraseBlocks = call VolumeSettings.getTotalEraseUnits();
    }
    
    currentEraseUnit = 0;
    eraseUnitsPerBlock = call VolumeSettings.getTotalEraseUnits() 
        / totalEraseBlocks;
    extraEraseUnitsInLastBlock = call VolumeSettings.getTotalEraseUnits() 
        % totalEraseBlocks;
    
    for(i = 0; i < totalEraseBlocks; i++) {
      flashEraseBlocks[i].index = (uint8_t) i;
      flashEraseBlocks[i].writeUnit = 0;
      flashEraseBlocks[i].inUse = FALSE;
      flashEraseBlocks[i].totalNodes = 0;
      flashEraseBlocks[i].baseEraseUnit = currentEraseUnit;
      flashEraseBlocks[i].totalEraseUnits = eraseUnitsPerBlock;
      currentEraseUnit += eraseUnitsPerBlock;
      if(i == call EraseUnitMap.getTotalEraseBlocks() - 1) {
        flashEraseBlocks[i].totalEraseUnits += extraEraseUnitsInLastBlock;
      }
    }
    
    currentEraseBlockIndex = 0;
    return SUCCESS;
  }
  
  
  /***************** EraseUnitMap Commands ****************/
  /**
   * @return the total sectors on flash
   */
  command uint8_t EraseUnitMap.getTotalEraseBlocks() {
    return totalEraseBlocks;
  }
 
  /**
   * @return the index of the first actual erase unit in this erase block,
   */
  command uint16_t EraseUnitMap.getBaseEraseUnit(
      flasheraseblock_t *focusedEraseBlock) {      
    return focusedEraseBlock->baseEraseUnit;
  }
  
  /**
   * @return the total number of erase units in this erase block
   */
  command uint16_t EraseUnitMap.getTotalEraseUnits(
      flasheraseblock_t *focusedEraseBlock) {
    return focusedEraseBlock->totalEraseUnits;
  }
  
  /**
   * @return the total number of write units in the given erase block
   */
  command uint16_t EraseUnitMap.getTotalWriteUnits(
      flasheraseblock_t *focusedEraseBlock) {
    return (focusedEraseBlock->totalEraseUnits 
        * (call VolumeSettings.getEraseUnitSize() 
            / call VolumeSettings.getWriteUnitSize()));
  }
  
  /**
   * Obtain the largest sector that is not in use
   * on the flash.  We use a global to store the
   * current sector index we're evaluating
   * so that each call to this function will
   * spread nodes more evenly around the flash.
   * @return the largest available sector to write to 
   */
  command flasheraseblock_t *EraseUnitMap.nextLargestIdleEraseBlock() {
    uint32_t mostFreeBytes = 0;
    flasheraseblock_t *largestEraseBlock = NULL;
    int eraseBlockIndex;
    
    for(eraseBlockIndex = 0; eraseBlockIndex 
        < call EraseUnitMap.getTotalEraseBlocks(); eraseBlockIndex++) {
      currentEraseBlockIndex++;
      currentEraseBlockIndex %= call EraseUnitMap.getTotalEraseBlocks();
      
      if(!flashEraseBlocks[currentEraseBlockIndex].inUse 
          && flashEraseBlocks[currentEraseBlockIndex].writeUnit != call EraseUnitMap.getTotalWriteUnits(&flashEraseBlocks[currentEraseBlockIndex])
          && call EraseUnitMap.bytesRemaining(&flashEraseBlocks[currentEraseBlockIndex]) > mostFreeBytes) {
        mostFreeBytes = call EraseUnitMap.bytesRemaining(&flashEraseBlocks[currentEraseBlockIndex]);
        largestEraseBlock = &flashEraseBlocks[currentEraseBlockIndex];
      }
    }
    
    currentEraseBlockIndex = largestEraseBlock->index;
    return largestEraseBlock;
  }
  
  /**
   * Obtain the largest sector that is not in use
   * on the flash.  This will allow us to see exactly
   * how much space exists for the next flashnode_t without
   * affecting the global variable that decides which sector
   * that may be.  This is especially useful for dictating the
   * size of a file that is part of a continuous-write operation
   * and the file size needs to fit exactly in one sector.
   *
   * @return the largest available sector that will be written to
   *      when a EraseUnitMap.nextLargestIdleEraseBlock() command is called
   */
  command flasheraseblock_t *EraseUnitMap.viewNextLargestIdleEraseBlock() {
    int mostFreeBytes = 0; 
    flasheraseblock_t *largestEraseBlock = NULL;
    int eraseBlockIndex;
    uint16_t virtualEraseBlockIndex;

    virtualEraseBlockIndex = currentEraseBlockIndex;
    
    for(eraseBlockIndex = 0; eraseBlockIndex < totalEraseBlocks; 
        eraseBlockIndex++) {
      virtualEraseBlockIndex++;
      virtualEraseBlockIndex %= totalEraseBlocks;
      
      if(!flashEraseBlocks[virtualEraseBlockIndex].inUse 
          && flashEraseBlocks[virtualEraseBlockIndex].writeUnit != call EraseUnitMap.getTotalWriteUnits(&flashEraseBlocks[currentEraseBlockIndex])
          && call EraseUnitMap.bytesRemaining(&flashEraseBlocks[currentEraseBlockIndex]) > mostFreeBytes) {
        mostFreeBytes = call EraseUnitMap.bytesRemaining(&flashEraseBlocks[currentEraseBlockIndex]);
        largestEraseBlock = &flashEraseBlocks[virtualEraseBlockIndex];
      }
    }
    
    return largestEraseBlock;
  }
  
  
  /**
   * @return the total nodes in the given sector
   */
  command uint8_t EraseUnitMap.getNodesInEraseBlock(
      flasheraseblock_t *focusedEraseBlock) {
    return focusedEraseBlock->totalNodes;
  }
  
  /**
   * Get the flasheraseblock_t at the specified address in flash.
   * @return the flasheraseblock_t that exists at the given address
   *     NULL if the flashAddress is out of bounds.
   */
  command flasheraseblock_t *EraseUnitMap.getEraseBlockAtAddress(
      uint32_t flashAddress) {
    int i;
    flashnode_t tempNode;
    tempNode.flashAddress = flashAddress;
    
    for(i = 0; i < call EraseUnitMap.getTotalEraseBlocks(); i++) {
      if(call EraseUnitMap.isInEraseBlock(&flashEraseBlocks[i], &tempNode)) {
        return &flashEraseBlocks[i];
      }
    }
    return NULL;
  }
  
  
  /**
   * Get the erase block at a specified index
   */
  command flasheraseblock_t *EraseUnitMap.getEraseBlock(
      uint8_t eraseBlockIndex) {
    return &flashEraseBlocks[eraseBlockIndex];
  }
  
  /**
   * @return TRUE if the sector can be erased
   */
  command bool EraseUnitMap.canErase(flasheraseblock_t *focusedEraseBlock) {
    return focusedEraseBlock->totalNodes == 0 
        && (call EraseUnitMap.getEraseBlockWriteAddress(focusedEraseBlock) 
            != call EraseUnitMap.getEraseBlockBaseAddress(focusedEraseBlock));
  }
  
  
  /**
   * Document the existence of a flashnode_t in a sector on flash.
   * @param focusedNode - the flashnode_t to document
   */
  command void EraseUnitMap.documentNode(flashnode_t *focusedNode) {
    flasheraseblock_t *myEraseBlock;
    uint32_t finalNodeAddress;

    myEraseBlock = call EraseUnitMap.getEraseBlockAtAddress(
        focusedNode->flashAddress);
    
    ////call JDebug.jdbg("EUM.documentNode: focusedNode->address=%xl", focusedNode->flashAddress, 0, 0);
    ////call JDebug.jdbg("EUM.documentNode: erase block holding this node=%i", 0, myEraseBlock->index, 0);
    
    if(call EraseUnitMap.getEraseBlockWriteAddress(myEraseBlock) 
        <= focusedNode->flashAddress) {      
      // Note the address check above - if this flashnode_t was already registered,
      // then totalUnfinalizedNodes can't be incremented twice.
      // Unfinalized 
      if(focusedNode->nodestate != NODE_DELETED) {
        myEraseBlock->totalNodes++;
      }
    }
    
    if((call NodeMap.getFileFromNode(focusedNode))->firstNode == focusedNode) {
      finalNodeAddress = focusedNode->flashAddress 
          + call BlackbookUtil.getNextWriteUnitAddress(
              focusedNode->reserveLength + sizeof(nodemeta_t) 
                  + sizeof(filemeta_t) - 1);
    } else {
      finalNodeAddress = focusedNode->flashAddress 
          + call BlackbookUtil.getNextWriteUnitAddress(
              focusedNode->reserveLength + sizeof(nodemeta_t) - 1);
    }
    
    if(call EraseUnitMap.getEraseBlockWriteAddress(myEraseBlock) 
        < finalNodeAddress) {
      myEraseBlock->writeUnit = call BlackbookUtil.convertBytesToWriteUnits(
          finalNodeAddress 
              - call EraseUnitMap.getEraseBlockBaseAddress(myEraseBlock) - 1);
    }
  }
  
  
  /**
   * Remove a valid flashnode_t from its sector. 
   * This helps the garbage collector know which sectors to erase.
   */
  command void EraseUnitMap.removeNode(flashnode_t *focusedNode) { 
    if(call EraseUnitMap.getEraseBlockWriteAddress(
        call EraseUnitMap.getEraseBlockAtAddress(focusedNode->flashAddress)) 
            > focusedNode->flashAddress) {      
      (call EraseUnitMap.getEraseBlockAtAddress(
          focusedNode->flashAddress))->totalNodes--;
    }
  }
  
  /**
   * @return TRUE if the given flashnode_t is within the bounds of the given sector
   */
  command bool EraseUnitMap.isInEraseBlock(flasheraseblock_t *focusedEraseBlock,
       flashnode_t *focusedNode) {
    return (call EraseUnitMap.getEraseBlockBaseAddress(focusedEraseBlock) 
        <= focusedNode->flashAddress)
            && (focusedNode->flashAddress 
                < call EraseUnitMap.getEraseBlockBaseAddress(focusedEraseBlock) 
                    + call EraseUnitMap.getEraseBlockTotalBytes(
                       focusedEraseBlock));
  }
  
  /**
   * Retreive the earliest available write address in a given sector.
   * @return the write address of the sector relative to 0x0
   */
  command uint32_t EraseUnitMap.getEraseBlockWriteAddress(
      flasheraseblock_t *focusedEraseBlock) {
    return ((uint32_t) call BlackbookUtil.convertWriteUnitsToBytes(
        focusedEraseBlock->writeUnit))
           + call EraseUnitMap.getEraseBlockBaseAddress(focusedEraseBlock);
  }
  
  /**
   * Retrieve the base address of the flasheraseblock_t relative to 0x0.
   * @return the relative address of the flasheraseblock_t from 0x0
   */
  command uint32_t EraseUnitMap.getEraseBlockBaseAddress(
      flasheraseblock_t *focusedEraseBlock) {
    uint32_t baseEraseUnit = (uint32_t) focusedEraseBlock->baseEraseUnit;
    return (uint32_t) (baseEraseUnit << call VolumeSettings.getEraseUnitSizeLog2());

  }
  
  /**
   * @return the base address of the next erase block
   */
  command uint32_t EraseUnitMap.getNextEraseBlockAddress(flasheraseblock_t *currentEraseBlock) {
    return call EraseUnitMap.getEraseBlockBaseAddress(currentEraseBlock)
        + call EraseUnitMap.getEraseBlockTotalBytes(currentEraseBlock);
  }
  
  
  /**
   * @return the total size of the erase block in bytes
   */
  command uint32_t EraseUnitMap.getEraseBlockTotalBytes(
      flasheraseblock_t *focusedEraseBlock) {
    return call VolumeSettings.getWriteUnitSize() 
        * call EraseUnitMap.getTotalWriteUnits(focusedEraseBlock);
  }
  
  
  /**
   * Obtain the remaining free bytes in a specified
   * flasheraseblock_t
   * @param focusedEraseBlock - the flasheraseblock_t to find the free bytes in
   * @return the number of free page bytes in the flasheraseblock_t
   */
  command uint32_t EraseUnitMap.bytesRemaining(
      flasheraseblock_t *focusedEraseBlock) {            
    return (uint32_t) call VolumeSettings.getWriteUnitSize() 
        * (call EraseUnitMap.getTotalWriteUnits(focusedEraseBlock) 
            - focusedEraseBlock->writeUnit);
  }

  /**
   * Obtain the total amount of free space on the flash.
   * @return the total amount of free space on the flash
   */
  command uint32_t EraseUnitMap.getFreeSpace() {
    uint8_t eraseBlockIndex;
    uint32_t totalSpace;
    
    eraseBlockIndex = 0;
    totalSpace = 0;

    // This performs a size estimate of the biggest single file we can create on flash.
    for(eraseBlockIndex = 0; eraseBlockIndex < totalEraseBlocks; 
        eraseBlockIndex++) {
      if(!flashEraseBlocks[eraseBlockIndex].inUse) {
        totalSpace += call EraseUnitMap.bytesRemaining(
            &flashEraseBlocks[eraseBlockIndex]);
        totalSpace -= sizeof(nodemeta_t);
      }
    }
    
    if(totalSpace > 0) {
      totalSpace -= sizeof(filemeta_t);
    }
    
    return totalSpace;
  }

  /**
   * The sector was erased by the garbage collector
   * @param eraseBlockIndex - the sector erased
   */
  command void EraseUnitMap.eraseComplete(uint8_t eraseBlockIndex) {
    flashEraseBlocks[eraseBlockIndex].writeUnit = 0;
    flashEraseBlocks[eraseBlockIndex].totalNodes = 0;
    flashEraseBlocks[eraseBlockIndex].inUse = FALSE;
  } 
  
  /** 
   * Reserve a sector for writing
   * @param *focusedEraseBlock pointer to the sector we want to reserve
   */
  command void EraseUnitMap.reserveEraseBlock(
      flasheraseblock_t *focusedEraseBlock) {
    focusedEraseBlock->inUse = TRUE;
  }
  
  /**
   * Free a sector that was reserved for writing
   * @param *focusedEraseBlock pointer to the sector we want to free
   */
  command void EraseUnitMap.freeEraseBlock(
      flasheraseblock_t *focusedEraseBlock) {
    focusedEraseBlock->inUse = FALSE;
  }
}

