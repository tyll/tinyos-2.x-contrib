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


module BTAMAddressM {

  provides interface BTAMAddress;
  
  uses interface BTIOMapComm;

}

implementation {
  // Using the least significant part of BT LAP field
  // as AM addr 
  // Option: Make XOR with NAP and UAP
  command am_addr_t BTAMAddress.btToAM(bt_addr_t b) {
    return (b[4]<<8 | b[5]);  
  }
  
  // Find the matching BT address
  command error_t BTAMAddress.amToBT(am_addr_t a, bt_addr_t b) {
    uint8_t i;
    
    error_t retval = FAIL;
    
    IOMAPCOMM* iom = call BTIOMapComm.getIOMapCommAddr();
    
    for(i = 0; i < SIZE_OF_BT_DEVICE_TABLE; i++) {
      if(a == call BTAMAddress.btToAM(iom->BtDeviceTable[i].BdAddr)) {
        b[0] = iom->BtDeviceTable[i].BdAddr[0];
        b[1] = iom->BtDeviceTable[i].BdAddr[1];
        b[2] = iom->BtDeviceTable[i].BdAddr[2];
        b[3] = iom->BtDeviceTable[i].BdAddr[3];
        b[4] = iom->BtDeviceTable[i].BdAddr[4];
        b[5] = iom->BtDeviceTable[i].BdAddr[5];
        
        retval = SUCCESS;
        
        break;
      }
    }
    
    return retval;
  }

  command void BTAMAddress.nxToBT(bt_addr_t b, nx_uint8_t bnx[]) {
    uint8_t i;
    for(i = 0; i < SIZE_OF_BDADDR; i++) {
			b[0] = bnx[0];
			b[1] = bnx[1];
			b[2] = bnx[2];
			b[3] = bnx[3];
			b[4] = bnx[4];
			b[5] = bnx[5];
    }        
  }
	  
  command void BTAMAddress.btToNx(bt_addr_t b, nx_uint8_t bnx[]) {
    uint8_t i;
    for(i = 0; i < SIZE_OF_BDADDR; i++) {
			bnx[i] = b[i];
    }  
  }
  
  command uint8_t* BTAMAddress.getBtAddr() {
    return call BTIOMapComm.getBtAddr();
  }
  
  command void BTAMAddress.swapBTNx(nx_uint8_t* bnx1, nx_uint8_t* bnx2) {
    uint8_t i;
    nx_uint8_t tmp;
    for(i = 0; i < SIZE_OF_BDADDR; i++) {
			tmp = bnx1[i];
			bnx1[i] = bnx2[i];
			bnx2[i] = tmp;
    }    
  }
}
