/* 
 * Copyright (c) 2006, Ecole Polytechnique Federale de Lausanne (EPFL),
 * Switzerland.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the distribution.
 * - Neither the name of the Ecole Polytechnique Federale de Lausanne (EPFL) 
 *   nor the names of its contributors may be used to 
 *   endorse or promote products derived from this software without 
 *   specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 * OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * ========================================================================
 */

/**
 * Implementation of SX1211PatternConf interface.
 *
 * @author Henri Dubois-Ferriere
 */



module SX1211PatternConfP {

  provides interface SX1211PatternConf;
  provides interface Init @atleastonce();

  uses interface Resource as SpiResource;
  uses interface SX1211Register as RXParam;
  uses interface SX1211Register as SYNCParam;

} 
implementation {

#include "sx1211debug.h"

  task void initTask() {
    atomic {
	
      sx1211check(1, call SpiResource.immediateRequest()); // should always succeed: task happens after softwareInit, before interrupts are enabled
      
      // pattern detection enabled, error tolerance=0, pattern length 3
      call RXParam.write(REG_RXPARAM3,
			 RX3_SYNC_RECOG_ON |
			 RX3_SYNC_SIZE_24 |
			 RX3_SYNC_TOL_0 );
      call SYNCParam.write(REG_SYNCBYTE1, (data_pattern >> 16) & 0xff);
      call SYNCParam.write(REG_SYNCBYTE2, (data_pattern >> 8) & 0xff);
      call SYNCParam.write(REG_SYNCBYTE3,  data_pattern & 0xff);
      
      call SpiResource.release();
    
    }
  }

  command error_t Init.init() 
  {
    post initTask();
    return SUCCESS;
  }
  
  event void SpiResource.granted() {  }

  async command error_t SX1211PatternConf.setDetectLen(uint8_t len) 
  {
    uint8_t reg;
    error_t status;

    if (len == 0 || len > 4)  return EINVAL;

    if (call SpiResource.isOwner()) return EBUSY;
    status = call SpiResource.immediateRequest();
    sx1211check(2, status);
    if (status != SUCCESS) return status;

    call RXParam.read(REG_RXPARAM3,
		      &reg);
    reg &= ~(3 << 3);
    reg |= (len << 3);
    
    call RXParam.write(REG_RXPARAM3,reg);
    call SpiResource.release();
    return SUCCESS;
  }
  async command error_t SX1211PatternConf.loadDataPatternHasBus() {
      
      call SYNCParam.write(REG_SYNCBYTE1, (data_pattern >> 16) & 0xff);
      call SYNCParam.write(REG_SYNCBYTE2, (data_pattern >> 8) & 0xff);
      call SYNCParam.write(REG_SYNCBYTE3, (data_pattern & 0xff));
      
      return SUCCESS;
  }

  async command error_t SX1211PatternConf.loadAckPatternHasBus() {
      
      call SYNCParam.write(REG_SYNCBYTE1, (ack_pattern >> 16) & 0xff);
      call SYNCParam.write(REG_SYNCBYTE2, (ack_pattern >> 8) & 0xff);
      call SYNCParam.write(REG_SYNCBYTE3, (ack_pattern & 0xff));
      
      return SUCCESS;
  }

  async command error_t SX1211PatternConf.loadPatternHasBus(pattern_t pattern) {
      
      call SYNCParam.write(REG_SYNCBYTE1, (pattern >> 16) & 0xff);
      call SYNCParam.write(REG_SYNCBYTE2, (pattern >> 8) & 0xff);
      call SYNCParam.write(REG_SYNCBYTE3, (pattern & 0xff));
      
      return SUCCESS;
  }


  async command error_t SX1211PatternConf.loadPattern(uint8_t* pattern, uint8_t len) 
  {
    error_t status;

    if (len == 0 || len > 4) return EINVAL;

    if (call SpiResource.isOwner()) return EBUSY;
    status = call SpiResource.immediateRequest();
    sx1211check(3, status);
    if (status != SUCCESS) return status;

    call SYNCParam.write(REG_SYNCBYTE1, *pattern++);
    if (len == 1) goto done;
    
    call SYNCParam.write(REG_SYNCBYTE2, *pattern++);
    if (len == 2) goto done;
    
    call SYNCParam.write(REG_SYNCBYTE3, *pattern++);
    if (len == 3) goto done;
    
    call SYNCParam.write(REG_SYNCBYTE4,  *pattern);
    
  done:
    call SpiResource.release();
    return SUCCESS;
    
  }    
  
  
  
  async command error_t SX1211PatternConf.setDetectErrorTol(uint8_t nerrors) 
  {
    uint8_t reg;
    error_t status;

    if (nerrors > 3) return EINVAL;
    
    if (call SpiResource.isOwner()) return EBUSY;
    status = call SpiResource.immediateRequest();
    sx1211check(4, status);
    if (status != SUCCESS) return status;


    call RXParam.read(REG_RXPARAM3, &reg);
    reg &= ~(3 << 2);
    reg |= (nerrors << 2);
    call RXParam.write(REG_RXPARAM3, reg);
    
    call SpiResource.release();
    return SUCCESS;
  }
}
