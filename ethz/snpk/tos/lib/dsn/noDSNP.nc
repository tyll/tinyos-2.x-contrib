/* Copyright (c) 2007 ETH Zurich.
*  All rights reserved.
*
*  Redistribution and use in source and binary forms, with or without
*  modification, are permitted provided that the following conditions
*  are met:
*
*  1. Redistributions of source code must retain the above copyright
*     notice, this list of conditions and the following disclaimer.
*  2. Redistributions in binary form must reproduce the above copyright
*     notice, this list of conditions and the following disclaimer in the
*     documentation and/or other materials provided with the distribution.
*  3. Neither the name of the copyright holders nor the names of
*     contributors may be used to endorse or promote products derived
*     from this software without specific prior written permission.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*
*  For additional information see http://www.btnode.ethz.ch/
*
*  $Id$
* 
*/

#include <AM.h>
#include "DSN.h"

module noDSNP
{
	provides interface DSN;	
	provides interface Init as NodeIdInit;
	uses command void setAmAddress(am_addr_t a);
}
implementation
{
  command error_t DSN.log(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.logLen(void * msg, uint8_t len) {
  	return SUCCESS;
  	}
  command error_t DSN.logError(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.logWarning(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.logInfo(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.logDebug(void * msg) {
  	return SUCCESS;
  	}
  command error_t DSN.appendLog(void * msg) {
	return SUCCESS;
	}
	
  async command void DSN.logInt(uint32_t n) {}
  command error_t DSN.logPacket(message_t * msg) {return SUCCESS;}
  command error_t DSN.logHexStream(uint8_t* msg, uint8_t len) {return SUCCESS;}   

  command error_t DSN.stopLog() {
  	return SUCCESS;
  	}
  command error_t DSN.startLog() {
  	return SUCCESS;
  	}
  
  command error_t NodeIdInit.init() {
		 volatile uint16_t *IdAddr;
	  	// setup node id
		IdAddr=(uint16_t *)ID_ADDR;
		if (*IdAddr!=NO_ID) {
			TOS_NODE_ID=*IdAddr;
			call setAmAddress(TOS_NODE_ID);
		}
		return SUCCESS;
  }
  
  command void DSN.emergencyLogEnable(uint32_t timeout) {}
  command void DSN.emergencyLogDisable() {}
  command error_t DSN.emergencyLogAdd(void * pointer, uint8_t numBytes, uint8_t * description) {
  	return SUCCESS;
  	}
}

