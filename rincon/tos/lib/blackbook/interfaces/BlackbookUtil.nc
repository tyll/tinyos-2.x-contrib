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
 * Blackbook Utilities
 * @author David Moss
 */

#include "Blackbook.h"

interface BlackbookUtil {

  /**
   * Convert the specified length of data
   * into number of flash pages. This always rounds up except
   * when it's right on.
   * @return the number of pages on flash required
   *     to hold the data
   */
  command uint32_t convertBytesToWriteUnits(uint32_t bytes);
  
  /**
   * Convert the specified number of flash pages
   * to bytes
   * @return the number of bytes in the given number of flash pages
   */
  command uint32_t convertWriteUnitsToBytes(uint32_t writeUnits);
  
  /**
   * Get the address of the first byte of the next page  
   * based on a given address
   * @param currentAddress -
   * @return the base address of the next write unit
   */
  command uint32_t getNextWriteUnitAddress(uint32_t currentAddress);
  
  /**
   * Get the address of the first byte of the next erase unit
   * @param currentAddress -
   * @return the base address of the next erase unit
   */
  //command uint32_t getNextEraseBlockAddress(uint32_t currentAddress);
  
  /**
   * Copy a string filename_t from one char
   * array to another
   */
  command void filenameCpy(filename_t *to, char *from);
  
  /**
   * @return the crc-16 of a a given filename_t
   */
  command uint16_t filenameCrc(filename_t *focusedFilename);
  
}


