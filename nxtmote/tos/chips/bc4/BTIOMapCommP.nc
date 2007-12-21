/*
 * Copyright (c) 2007 nxtmote project
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
 * - Neither the name of nxtmote project nor the names of
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


#include "BT.h"

module BTIOMapCommP {
  provides interface BTIOMapComm;
}
implementation {
  IOMAPCOMM*  pIOMapComm = NULL;

  // Set from HalBtM
  command void BTIOMapComm.setIOMapCommAddr(IOMAPCOMM*  pIOMapCommTmp) {
    pIOMapComm = pIOMapCommTmp;
  }
  
  command IOMAPCOMM* BTIOMapComm.getIOMapCommAddr() {
	  return pIOMapComm;
  }

  //Service functions

  command uint8_t* BTIOMapComm.getBtAddr() {
    return pIOMapComm->BrickData.BdAddr;
  }
  
  command error_t BTIOMapComm.getDeviceIndex(bt_addr_t b, uint8_t* ix) {
    uint8_t i;
    
    error_t retval = FAIL;
    
    for(i = 0; i < SIZE_OF_BT_DEVICE_TABLE; i++) {
      if(b[5] == pIOMapComm->BtDeviceTable[i].BdAddr[5] &&
         b[4] == pIOMapComm->BtDeviceTable[i].BdAddr[4] &&
         b[3] == pIOMapComm->BtDeviceTable[i].BdAddr[3] &&
         b[2] == pIOMapComm->BtDeviceTable[i].BdAddr[2] &&
         b[1] == pIOMapComm->BtDeviceTable[i].BdAddr[1] &&
         b[0] == pIOMapComm->BtDeviceTable[i].BdAddr[0]) {
 
        *ix = i;
        retval = SUCCESS;
        
        break;
      }
    }
    
    return retval;  
    
  }
  
}
