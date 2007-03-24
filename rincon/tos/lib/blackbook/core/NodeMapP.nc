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
 * Blackbook NodeMap Module
 * Allows access to general file_t system information through NodeMap interface
 * File system modifications through NodeBooter interface
 * File allocation and services through NodeLoader interface
 * @author David Moss (dmm@rincon.com)
 */
 
#include "Blackbook.h"

module NodeMapP {
  provides {
    interface Init;
    interface NodeMap;
    interface NodeBooter;
  }
  
  uses {
    interface EraseUnitMap;
    interface BlackbookUtil;
    ////interface JDebug;
  }
}

implementation {

  /** The array of files in memory */
  file_t files[MAX_FILES];
  
  /** The array of nodes in memory */
  flashnode_t nodes[MAX_FILES*NODES_PER_FILE];
  
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i; 

    for(i = 0; i < call NodeMap.getMaxNodes(); i++) {
      nodes[i].filenameCrc = 0;
      nodes[i].nextNode = NULL;
      nodes[i].nodestate = NODE_EMPTY;
    }
    
    for(i = 0; i < call NodeMap.getMaxFiles(); i++) {
      files[i].filenameCrc = 0;
      files[i].firstNode = NULL;
      files[i].filestate = FILE_EMPTY;
    }
    
    return SUCCESS;
  }
  
  
  
  /***************** NodeBooter Commands *****************/
  /**
   * Request to add a flashnode_t to the file_t system.
   * It is the responsibility of the calling function
   * to properly setup:
   *   > flashAddress
   *   > dataLength
   *   > reserveLength
   *   > dataCrc
   *   > filenameCrc
   *   > fileElement
   * 
   * Unless manually linked, state and nextNode are handled by NodeMap.
   * @return a pointer to an empty flashnode_t if one is available
   *     NULL if no more exist
   */
  command flashnode_t *NodeBooter.requestAddNode() {
    int i;

    for(i = 0; i < call NodeMap.getMaxNodes(); i++) {
      if(nodes[i].nodestate == NODE_EMPTY) {
        nodes[i].nextNode = NULL;
        nodes[i].nodeflags = NO_FLAGS;
        return &nodes[i];
      }
    }
    return NULL;
  }
  
  /**
   * Request to add a file_t to the file_t system
   * It is the responsibility of the calling function
   * to properly setup:
   *   > filename
   *   > filenameCrc
   *   > type
   *
   * Unless manually linked, state and nextNode are handled in NodeMap.
   * @return a pointer to an empty file_t if one is available
   *     NULL if no more exist
   */
  command file_t *NodeBooter.requestAddFile() {
    int i;
    for(i = 0; i < call NodeMap.getMaxFiles(); i++) {
      if(files[i].filestate == FILE_EMPTY) {
        files[i].firstNode = NULL;
        return &files[i];
      }
    }
    return NULL;
  }
  
  /**
   * After booting, the nodes loaded from flash must
   * be corrected linked. 
   * The node.fileelement will represent the fileElement from the nodemeta
   * before the file_t is finished being linked.
   *
   */
  command error_t NodeBooter.link() {
    int fileIndex;
    int nodeIndex;
    flashnode_t *lastLinkedNode;
    uint8_t currentElement;
    
    // Link all files and nodes
    for(fileIndex = 0; fileIndex < call NodeMap.getMaxFiles(); fileIndex++) {
      if(files[fileIndex].filestate != FILE_EMPTY && ((files[fileIndex].filestate 
          != FILE_WRITING) || (files[fileIndex].filestate 
          != FILE_READING_AND_WRITING))) {
        files[fileIndex].filestate = FILE_IDLE;
        lastLinkedNode = NULL;
        currentElement = 0;
        
        // locate all nodes associated with the file_t in the correct order
        for(nodeIndex = 0; nodeIndex < call NodeMap.getMaxNodes(); 
            nodeIndex++) {
          // Check out the next node
          if(nodes[nodeIndex].nodestate != NODE_EMPTY) {
            // This flashnode_t needs to be linked
            if(nodes[nodeIndex].filenameCrc == files[fileIndex].filenameCrc) {
              // and it belongs to the current file_t we're linking
              if(nodes[nodeIndex].fileElement == currentElement) {
                // in fact it's the next flashnode_t we're looking for
                if(currentElement == 0) {
                  // This is the first flashnode_t of the file
                  files[fileIndex].firstNode = &nodes[nodeIndex];
                } else {
                  // This is the next flashnode_t of the file
                  lastLinkedNode->nextNode = &nodes[nodeIndex];
                  /*my addition for setting the states properly*/
                  lastLinkedNode->nodestate = NODE_LOCKED;
                }
                
                nodes[nodeIndex].fileElement = 0xFF;
                nodes[nodeIndex].nextNode = NULL;
                lastLinkedNode = &nodes[nodeIndex];
                currentElement++;
                nodeIndex = -1;  // -1 because the for loop immediately adds 1
              }
            }
          }
        }
      }
    }
    
    // Remove all the dangling nodes - although this should never happen,
    // we take some precautions.  One issue is this will not erase
    // the node's checkpoint, so the checkpoint for this flashnode_t will 
    // be around forever, until another flashnode_t is written to its location
    // I'd rather have a lingering 18 byte checkpoint hanging around
    // than a sector-long undeletable node
    for(nodeIndex = 0; nodeIndex < call NodeMap.getMaxNodes(); nodeIndex++) {
      if(nodes[nodeIndex].nodestate != NODE_EMPTY 
          && nodes[nodeIndex].nodestate != NODE_VALID) {
        if(nodes[nodeIndex].fileElement != 0xFF) {
          nodes[nodeIndex].nodestate = NODE_DELETED;
          call EraseUnitMap.removeNode(&nodes[nodeIndex]);
          nodes[nodeIndex].nodestate = NODE_EMPTY;
        }
      }
    }
    
    return SUCCESS;
  }
  
  /***************** NodeMap Commands ****************/
  /**
   * @return the maximum number of nodes allowed
   */
  command uint16_t NodeMap.getMaxNodes() {
    return MAX_FILES * NODES_PER_FILE;
  }
  
  /** 
   * @return the maximum number of files allowed
   */
  command uint8_t NodeMap.getMaxFiles() {
    return MAX_FILES;
  }
  
  /** 
   * @return the total nodes used by the file_t system
   */
  command uint16_t NodeMap.getTotalNodes() {
    int i;
    uint16_t totalNodes = 0;
    for(i = 0; i < call NodeMap.getMaxNodes(); i++) {
      if(nodes[i].nodestate != NODE_EMPTY) {
        totalNodes++;
      }
    }
    return totalNodes;
  }
    
  
  /**
   * Get the flashnode_t and offset into the flashnode_t that represents
   * an address in a file
   * @param focusedFile - the file_t to find the address in
   * @param fileAddress - the address to find
   * @param returnOffset - pointer to a location to store the offset into the node
   * @return the flashnode_t that contains the file_t address in the file.
   */
  command flashnode_t *NodeMap.getAddressInFile(file_t *focusedFile, 
      uint32_t fileAddress, uint16_t *returnOffset) {
    flashnode_t *focusedNode;
    uint16_t nodeLength;
    uint32_t currentAddress = 0;
    
    for(focusedNode = focusedFile->firstNode; focusedNode != NULL; 
        focusedNode = focusedNode->nextNode) {
      if(focusedNode->nodestate == NODE_LOCKED) {
        nodeLength = focusedNode->dataLength;
      } else {
        nodeLength = focusedNode->reserveLength;
      }
      
      if(fileAddress - currentAddress < nodeLength) {
        // The address is in this node
        *returnOffset = fileAddress - currentAddress;
        return focusedNode;
        
      } else {
        currentAddress += nodeLength;
      }
    }
    
    return NULL;     
  }
  
  
  /**
   * @return the total nodes allocated to the given file
   */
  command uint8_t NodeMap.getTotalNodesInFile(file_t *focusedFile) {
    flashnode_t *currentNode;
    uint8_t totalNodes = 0;
   
    if((focusedFile != NULL) && focusedFile->filestate != FILE_EMPTY) {
      currentNode = focusedFile->firstNode;
      while(currentNode != NULL) {
        totalNodes++;
        currentNode = currentNode->nextNode;
      }
    }
    return totalNodes;
  }
  
  /**
   * @return the total files used by the file_t system
   */
  command uint8_t NodeMap.getTotalFiles() {
    int i;
    uint8_t totalFiles = 0;
    for(i = 0; i < call NodeMap.getMaxFiles(); i++) {
      if(files[i].filestate != FILE_EMPTY) {
        totalFiles++;
      }
    }
    return totalFiles;
  }
  
  
  /**
   * @return the file_t with the given name if it exists, NULL if it doesn't
   */
  command file_t *NodeMap.getFile(filename_t *focusedFilename) {
    int i;
    uint16_t focusedFileCrc = call BlackbookUtil.filenameCrc(focusedFilename);
    for(i = 0; i < call NodeMap.getMaxFiles(); i++) {
      if(focusedFileCrc == files[i].filenameCrc 
          && files[i].filestate != FILE_EMPTY) {
        return &files[i];
      }
    }
    return NULL;
  }
  
  /**
   * @return the file_t associated with the given node, NULL if n/a.
   */
  command file_t *NodeMap.getFileFromNode(flashnode_t *focusedNode) {
    int i;
    if(focusedNode == NULL || focusedNode->nodestate == NODE_EMPTY) {
      return NULL;
    }
    
    for(i = 0; i < call NodeMap.getMaxFiles(); i++) {
      if(focusedNode->filenameCrc == files[i].filenameCrc 
          && files[i].filestate != FILE_EMPTY) {
        return &files[i];
      }
    }
    return NULL;
  }
  
   
  /**
   * Traverse the files on the file_t system from
   * 0 up to (max files - 1).
   * If performing a DIR, be sure to hide
   * Checkpoint files on the way out.
   * @return the file_t at the given index
   */
  command file_t *NodeMap.getFileAtIndex(uint8_t fileIndex) {
    if(fileIndex < call NodeMap.getMaxFiles()) {
      return &files[fileIndex];
    }
    return NULL;
  }
  
  /**
   * Get a flashnode_t at a given index
   * @return the flashnode_t if it exists, NULL if it doesn't.
   */
  command flashnode_t *NodeMap.getNodeAtIndex(uint8_t nodeIndex) {
    if(nodeIndex < call NodeMap.getMaxNodes()) {
      return &nodes[nodeIndex];
    }
    return NULL;
  }
  
  /** 
   * Get the total length of data of a given file
   * @return the length of the file's data
   */
  command uint32_t NodeMap.getDataLength(file_t *focusedFile) {
    flashnode_t *focusedNode;
    uint32_t dataLength = 0;
    
    for(focusedNode = focusedFile->firstNode; focusedFile != FILE_EMPTY 
        && focusedNode != NULL; focusedNode = focusedNode->nextNode) {
      dataLength += focusedNode->dataLength;
    }
    //////call JDebug.jdbg("map.dataLen, nodeAddr: %xl\n", focusedFile->firstNode, 0, 0);
    //////call JDebug.jdbg("map.dataLen, dataAddr: %xl\n", (uint32_t)&((focusedFile->firstNode)->dataLength), 0, 0);
    //////call JDebug.jdbg("map.dataLen, dataVal: %xl\n", (uint32_t)((focusedFile->firstNode)->dataLength), 0, 0);
    
    return dataLength;
  }
  
  /**
   * @return the reserve length of all nodes in the file
   */
  command uint32_t NodeMap.getReserveLength(file_t *focusedFile) {
    flashnode_t *focusedNode;
    uint32_t reserveLength = 0;
    
    for(focusedNode = focusedFile->firstNode; focusedFile != FILE_EMPTY 
        && focusedNode != NULL; focusedNode = focusedNode->nextNode) {
      reserveLength += focusedNode->reserveLength;
    }
    
    return reserveLength;
  }
  
  /**
   * @return TRUE if there exists another node
   *     that belongs to the same file_t with the same element
   *     number.
   */
  command bool NodeMap.hasDuplicate(flashnode_t *focusedNode) {
    int i;
    uint8_t numNodes = 0;
    
    for(i = 0; i < call NodeMap.getMaxNodes(); i++) {
      if(nodes[i].nodestate != NODE_EMPTY) {
        if(nodes[i].filenameCrc == focusedNode->filenameCrc) {
          if(nodes[i].fileElement == focusedNode->fileElement) {
            numNodes++;
          }
        }
      }
    }
    
    return (numNodes > 1);
  }
}

