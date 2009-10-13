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

/*
 * Implementation of SX1211IrqConf interface.
 *
 * @author Henri Dubois-Ferriere
 */



module SX1211IrqConfP {

  provides interface SX1211IrqConf;
  provides interface Init @atleastonce();
  uses interface SX1211Register as IRQParam;
  uses interface Resource as SpiResource;
}
implementation {

#include "sx1211debug.h"


  // norace is ok because protected by the isOwner() calls
  norace uint8_t irq0Param; 
  norace uint8_t irq1Param;
  
  task void initTask() 
  {
    atomic {

      sx1211check(1, call SpiResource.immediateRequest()); // should always succeed: task happens after softwareInit, before interrupts are enabled
      irq0Param=0xC9;
      irq1Param=0x5f;
      call IRQParam.write(REG_IRQ0PARAM,
			  irq0Param);
      call IRQParam.write(REG_IRQ1PARAM,
			  0x10);
      
      call SpiResource.release();
    }
  }

  command error_t Init.init() 
  {
    post initTask();
    return SUCCESS;
  }
  
  event void SpiResource.granted() {  }


  /* 
   * Set IRQ0 sources in Rx mode. 
   * @param src may be one of: irq_write_byte, irq_nFifoEmpty, or irq_Pattern.
   */
  async command error_t SX1211IrqConf.setRxIrq0Source(sx1211_rx_irq0_src_t src) 
  {
    error_t status;

    if (src > 3)  return EINVAL;

    if (call SpiResource.isOwner()) return EBUSY;

    status = call SpiResource.immediateRequest();
    sx1211check(2, status);
    if (status != SUCCESS) return status;
    call SpiResource.release();
    return SUCCESS;
  }


  /* 
   * Set IRQ1 sources in Rx mode. 
   * @param src may be one of: irq_Rssi or irq_FifoFull.
   */
  async command error_t SX1211IrqConf.setRxIrq1Source(sx1211_rx_irq1_src_t src) 
  {
    error_t status;

    if (src > 2) return EINVAL;

    if (call SpiResource.isOwner()) return EBUSY;

    status = call SpiResource.immediateRequest();
    sx1211check(3, status);
    if (status != SUCCESS) return status;

    irq0Param &= ~(3 << 4);
    irq0Param |= (src << 4);
    call IRQParam.write(REG_IRQ0PARAM,
			irq0Param);
    call SpiResource.release();
    return SUCCESS;
  }

  /* 
   * Set IRQ1 sources in Tx mode. 
   * @param src my be one of: irq_FifoFull or irq_TxStopped.
   */
  async command error_t SX1211IrqConf.setTxIrq1Source(sx1211_tx_irq1_src_t src) 
  {
    error_t status;

    if (src > 1) return EINVAL;

    if (call SpiResource.isOwner()) return EBUSY;

    status = call SpiResource.immediateRequest();
    sx1211check(4, status);
    if (status != SUCCESS) return status;

    irq1Param &= ~(1 << 3);
    irq1Param |= (src << 3);
    call IRQParam.write(REG_IRQ0PARAM,
			irq0Param);
    call SpiResource.release();
    return SUCCESS;
  }


  void clearFifoOverrun() {
      irq0Param |= 1;
      call IRQParam.write(REG_IRQ0PARAM,
			  irq0Param);
  }
  
  /**
   * Clear FIFO overrun flag.
   */
  async command error_t SX1211IrqConf.clearFifoOverrun(bool haveResource) 
  {
    error_t status;

    if (haveResource) {
      clearFifoOverrun();
    } else {
      if (call SpiResource.isOwner()) return EBUSY;
      status = call SpiResource.immediateRequest();
      clearFifoOverrun();
      call SpiResource.release();
    }
    return SUCCESS;
    
  }

  bool getFifoOverrun() {
    uint8_t reg;
    call IRQParam.read(REG_IRQ0PARAM,
		       &reg);
    return reg & 1;
  }

  async command error_t SX1211IrqConf.getFifoOverrun(bool haveResource, bool* fifooverrun) 
  {
    error_t status;

    if (haveResource) {
      *fifooverrun = getFifoOverrun();
    } else {
      if (call SpiResource.isOwner()) return EBUSY;
      status = call SpiResource.immediateRequest();
      sx1211check(5, status);
      if (status != SUCCESS) return status;
      *fifooverrun = getFifoOverrun();
      call SpiResource.release();
    }
    return SUCCESS;
  }
  
  void armPatternDetector() {
      irq1Param |= (1 << 6);
      call IRQParam.write(REG_IRQ1PARAM, irq1Param);
  }

  /**
   * Arm the pattern detector (clear Start_detect flag).
   */
  async command error_t SX1211IrqConf.armPatternDetector(bool haveResource)  
  {
    error_t status;

    if (haveResource) {
      armPatternDetector();
    } else {
      if (call SpiResource.isOwner()) return EBUSY;
      status = call SpiResource.immediateRequest();
      sx1211check(5, status);
      if (status != SUCCESS) return status;
      armPatternDetector();
      call SpiResource.release();
    }
    return SUCCESS;
  }
}
