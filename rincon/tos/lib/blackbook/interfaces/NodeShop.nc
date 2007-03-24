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
 * Responsible for managing all file metadata information on flash
 * @author David Moss
 */
 
#include "Blackbook.h"

interface NodeShop {
  
  /**
   * Write the nodemeta to flash for the given node
   * @param focusedFile - the file_t to write the nodemeta for
   * @param focusedNode - the flashnode_t to write the nodemeta for
   * @param name - pointer to the name of the file_t if this is the first node
   */
  command error_t writeNodemeta(file_t *focusedFile, flashnode_t *focusedNode, filename_t *name);
  
  /**
   * Delete a flashnode_t on flash. This will not erase the
   * data from flash, but it will simply mark the magic
   * number of the flashnode_t to make it invalid.
   * 
   * After the command is called and executed, a metaDeleted
   * event will be signaled.
   *
   * @return SUCCESS if the magic number will be marked
   */
  command error_t deleteNode(flashnode_t *focusedNode);
  
  /**
   * Get the CRC of a flashnode_t on flash.
   *
   * After the command is called and executed, a crcCalculated
   * event will be signaled.
   *
   * @param focusedNode - the flashnode_t to read and calculate a CRC for
   * @return SUCCESS if the CRC will be calculated.
   */
  command error_t getCrc(flashnode_t *focusedNode, file_t *focusedFile);

  /**
   * Get the filename_t for a file
   * @param focusedFile - the file_t to obtain the filename_t for
   * @param *name - pointer to store the filename
   */
  command error_t getFilename(file_t *focusedFile, filename_t *name);
  
  
  
  /** 
   * The node's metadata was written to flash
   * @param focusedNode - the flashnode_t that metadata was written for
   * @param error - SUCCESS if it was written
   */
  event void metaWritten();
  
  /**
   * The filename_t was retrieved from flash
   * @param focusedFile - the file_t that we obtained the filename_t for
   * @param *name - pointer to where the filename_t was stored
   * @param error - SUCCESS if the filename_t was retrieved
   */
  event void filenameRetrieved(filename_t *name);
  
  /**
   * A flashnode_t was deleted from flash by marking its magic number
   * invalid in the metadata.
   * @param focusedNode - the flashnode_t that was deleted.
   * @param error - SUCCESS if the flashnode_t was deleted successfully.
   */
  event void metaDeleted(flashnode_t *focusedNode);
 
  /**
   * A crc was calculated from flashnode_t data on flash
   * @param dataCrc - the crc of the data read from the flashnode_t on flash.
   * @param error - SUCCESS if the crc is valid
   */
  event void crcCalculated(uint16_t dataCrc);
  
}


