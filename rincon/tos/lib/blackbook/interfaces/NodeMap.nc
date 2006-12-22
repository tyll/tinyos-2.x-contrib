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
 * Blackbook NodeMap interface
 * NodeMap controls all nodes in memory, and regulates
 * access to those nodes.  This direct interface
 * only helps control and find information about nodes.
 *
 * @author David Moss
 */

#include "Blackbook.h"

interface NodeMap {

  /**
   * @return the maximum number of nodes allowed
   */
  command uint16_t getMaxNodes();
  
  /** 
   * @return the maximum number of files allowed
   */
  command uint8_t getMaxFiles();
  
  /** 
   * @return the total nodes used by the file_t system
   */
  command uint16_t getTotalNodes();
  
  /**
   * @return the total nodes allocated to the given file
   */
  command uint8_t getTotalNodesInFile(file_t *focusedFile);
  
  /**
   * @return the total files used by the file_t system
   */
  command uint8_t getTotalFiles();
  
  /**
   * Get the flashnode_t and offset into the flashnode_t that represents
   * an address in a file
   * @param focusedFile - the file_t to find the address in
   * @param fileAddress - the address to find
   * @param returnOffset - pointer to a location to store the offset into the node
   * @return the flashnode_t that contains the file_t address in the file.
   */
  command flashnode_t *getAddressInFile(file_t *focusedFile, uint32_t fileAddress, uint16_t *returnOffset); 
  
  /**
   * @return the node's position in a file, 0xFF if not valid
   *
  command uint8_t getElementNumber(flashnode_t *focusedNode);
  
  /**
   * If you already know the file, this is faster than getElementNumber(..)
   * @return the node's position in the given file, 0xFF if not valid
   *
  command uint8_t getElementNumberFromFile(flashnode_t *focusedNode, file_t *focusedFile);
  
  /**
   * @return the file_t with the given name if it exists, NULL if it doesn't
   */
  command file_t *getFile(filename_t *name);
  
  /**
   * @return the file_t associated with the given node, NULL if n/a.
   */
  command file_t *getFileFromNode(flashnode_t *focusedNode);
  
  /**
   * Traverse the files on the file_t system from
   * 0 up to (max files - 1)
   * If performing a DIR, be sure to hide
   * Checkpoint files on the way out.
   * @return the file_t at the given index
   */
  command file_t *getFileAtIndex(uint8_t index);
  
  /**
   * Get a flashnode_t at a given index
   * @return the flashnode_t if it exists, NULL if it doesn't.
   */
  command flashnode_t *getNodeAtIndex(uint8_t index);
  
  /** 
   * @return the length of the file's data
   */
  command uint32_t getDataLength(file_t *focusedFile);
    
  /**
   * @return the reserve length of all nodes in the file
   */
  command uint32_t getReserveLength(file_t *focuseFile);
  
  /**
   * @return TRUE if there exists another flashnode_t belonging
   * to the same file_t with the same element number
   */
  command bool hasDuplicate(flashnode_t *focusedNode);
  
}

