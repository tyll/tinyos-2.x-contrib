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
 * Blackbook BlackbookUtilities
 * @author David Moss
 */

#include "Blackbook.h"

module BlackbookUtilP {
  provides {
    interface BlackbookUtil;
  }
  
  uses {
    interface GenericCrc;
    interface VolumeSettings;
    interface EraseUnitMap;
    ////interface JDebug;
  }
}

implementation {
  
  /***************** BlackbookUtil Commands ****************/
  /**
   * Convert the specified length of data
   * into number of flash pages. This always rounds up except
   * when it's right on.
   * @return the number of pages on flash required
   *     to hold the data
   */
  command uint32_t BlackbookUtil.convertBytesToWriteUnits(uint32_t bytes) {
   
    if((bytes % (call VolumeSettings.getWriteUnitSize())) == 0){
      return (bytes >> call VolumeSettings.getWriteUnitSizeLog2());
    }
    else{
      return (bytes >> call VolumeSettings.getWriteUnitSizeLog2()) + 1;
    }
  }
    
  /**
   * Convert the specified number of flash pages
   * to bytes
   * @return the number of bytes in the given number of flash pages
   */
  command uint32_t BlackbookUtil.convertWriteUnitsToBytes(uint32_t writeUnits) {
    // This is stupid, but fixes a multiplication bug on the MSP430
    uint32_t totalWu = (uint32_t) writeUnits;
    uint32_t wuSize = call VolumeSettings.getWriteUnitSize();
    return totalWu * wuSize;
  }
  
  /**
   * Get the address of the first byte of the next page  
   * based on a given address
   * @param currentAddress -
   */
  command uint32_t BlackbookUtil.getNextWriteUnitAddress(
      uint32_t currentAddress) {
    return call VolumeSettings.getWriteUnitSize() 
        * ((currentAddress >> call VolumeSettings.getWriteUnitSizeLog2()) + 1);
  }
  
  /**
   * Copy a string filename from one char
   * array to a filename
   */
  command void BlackbookUtil.filenameCpy(filename_t *to, char *from) {
    int i;
    char *destPtr = (char *) to->getName;
    memset(destPtr, '\0', sizeof(filename_t));
 
    for(i = 0; i < sizeof(filename_t) - 1; i++) {
      if(!(*destPtr++ = *from++)) {
        return;
      }
    }
    *destPtr = '\0';
  }
  
  /**
   * @return the crc-16 of a a given filename
   */
  command uint16_t BlackbookUtil.filenameCrc(filename_t *focusedFilename) {
    return call GenericCrc.crc16(0, focusedFilename, sizeof(filename_t));
  }
}

