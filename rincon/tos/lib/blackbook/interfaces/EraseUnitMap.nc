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
 * Blackbook EraseUnitMap Interface
 * @author David Moss
 */
 
#include "Blackbook.h"

interface EraseUnitMap {
  
  /**
   * @return the total erase blocks on flash
   */
  command uint8_t getTotalEraseBlocks();
  
  /**
   * Obtain the largest erase block that is not in use
   * on the flash
   * @return the largest available erase block to write to 
   */
  command flasheraseblock_t *nextLargestIdleEraseBlock();
  
  /**
   * Obtain the largest erase block that is not in use
   * on the flash.  This will allow us to see exactly
   * how much space exists for the next flashnode_t without
   * affecting the global variable that decides which erase block
   * that may be.  This is especially useful for dictating the
   * size of a file that is part of a continuous-write operation
   * and the file size needs to fit exactly in one erase block.
   *
   * @return the largest available erase block that will be written to
   *      when a EraseBlockMap.nextLargestIdleEraseBlock() command is called
   */
  command flasheraseblock_t *viewNextLargestIdleEraseBlock();
  
  /**
   * Get the flasheraseblock_t at the specified address in flash.
   * @return the flasheraseblock_t that exists at the given address
   *     NULL if the flashAddress is out of bounds.
   */
  command flasheraseblock_t *getEraseBlockAtAddress(uint32_t flashAddress);
  
  /**
   * Get the erase block at a specified index
   */
  command flasheraseblock_t *getEraseBlock(uint8_t eraseBlockIndex);
  
  /**
   * @return the total nodes in the given erase block
   */
  command uint8_t getNodesInEraseBlock(flasheraseblock_t *focusedEraseBlock);
  
  /**
   * @return TRUE if the erase unit can be erased
   */
  command bool canErase(flasheraseblock_t *focusedEraseBlock);
  
  /**
   * Document the existence of a flashnode_t in a erase block on flash.
   * @param focusedNode - the flashnode_t to document
   */
  command void documentNode(flashnode_t *focusedNode);
  
  /**
   * Remove a valid flashnode_t from its erase block.
   * The flashnode_t must be finalized before removing it.
   * This helps the garbage collector know which erase blocks to erase.
   */
  command void removeNode(flashnode_t *focusedNode);
  
  /**
   * Retreive the earliest available write address in a given erase block.
   * @return the write address of the erase block relative to 0x0
   */
  command uint32_t getEraseBlockWriteAddress(flasheraseblock_t *focusedEraseBlock);
  
  /**
   * @return the base address of the next erase block
   */
  command uint32_t getNextEraseBlockAddress(flasheraseblock_t *currentEraseBlock);
  
  /**
   * @return TRUE if the given flashnode_t is within the bounds of the given erase block
   */
  command bool isInEraseBlock(flasheraseblock_t *focusedEraseBlock, flashnode_t *focusedNode);
  
  /**
   * @return the relative address of the flasheraseblock_t from 0x0
   */
  command uint32_t getEraseBlockBaseAddress(flasheraseblock_t *focusedEraseBlock);
  
  /**
   * @return the total size of the erase block in bytes
   */
  command uint32_t getEraseBlockTotalBytes(flasheraseblock_t *focusedEraseBlock);
  
  /**
   * @return the index of the first actual erase unit in this erase block,
   */
  command uint16_t getBaseEraseUnit(flasheraseblock_t *focusedEraseBlock);
  
  /**
   * @return the total number of erase units in this erase block
   */
  command uint16_t getTotalEraseUnits(flasheraseblock_t *focusedEraseBlock);
  
  /**
   * @return the total number of write units in this erase block
   */
  command uint16_t getTotalWriteUnits(flasheraseblock_t *focusedEraseBlock);
  
  /**
   * Obtain the remaining free bytes in a specified
   * flasheraseblock_t
   * @param focusedEraseBlock - the flasheraseblock_t to find the free bytes in
   * @return the number of free page bytes in the flasheraseblock_t
   */
  command uint32_t bytesRemaining(flasheraseblock_t *focusedEraseBlock);

  /**
   * Obtain the total amount of free space on the flash.
   * @return the total amount of free space on the flash
   */
  command uint32_t getFreeSpace();
  
  /**
   * The erase block was erased by the garbage collector
   * @param erase blockIndex - the erase block erased
   */
  command void eraseComplete(uint8_t eraseBlockIndex);
  
  /** 
   * Reserve a erase block for writing
   * @param *focusedEraseBlock pointer to the erase block we want to reserve
   */
  command void reserveEraseBlock(flasheraseblock_t *focusedEraseBlock);
  
  /**
   * Free a erase block that was reserved for writing
   * @param *focusedEraseBlock pointer to the erase block we want to free
   */
  command void freeEraseBlock(flasheraseblock_t *focusedEraseBlock);
}


