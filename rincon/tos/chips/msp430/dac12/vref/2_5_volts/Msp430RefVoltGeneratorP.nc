/*
 * Copyright (c) 2004, Technische Universität Berlin
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
 * - Neither the name of the Technische Universität Berlin nor the names 
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
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
 * - Revision -------------------------------------------------------------
 * $Revision$
 * $Date$
 * @author: Jan Hauer <hauer@tkn.tu-berlin.de>
 * @author David Moss
 * ========================================================================
 */


/**
 * The purpose of this 2.5V Vref generator module is to shrink the code size
 * from the default implementation. If you know your application only needs
 * a 2.5V Vref, then prioritize this directory at compile time over other 
 * Msp430RefVoltGeneratorP implementations.
 */
 
#warning "Using the 2.5V Vref Generator Only"

module Msp430RefVoltGeneratorP {
  provides {
    interface SplitControl as RefVolt_1_5V;
    interface SplitControl as RefVolt_2_5V;
  }
  
  uses {
    interface HplAdc12;
    interface Timer<TMilli> as SwitchOnTimer;
    interface Timer<TMilli> as SwitchOffTimer;
  }
  
} 

implementation {
  
  enum {
    GENERATOR_OFF,
    REFERENCE_PENDING,
    REFERENCE_STABLE,
  };

  uint8_t state;
  
  /***************** Prototypes ****************/
  error_t switchOn();
  error_t switchOff();
  
  /***************** SplitControl Commands ****************/
  command error_t RefVolt_2_5V.start() {
  
    call SwitchOffTimer.stop();
          
    switch (state) {
      case REFERENCE_STABLE:
        signal RefVolt_2_5V.startDone(SUCCESS);
        return SUCCESS;
        
      case GENERATOR_OFF:
        if (switchOn() == SUCCESS){
          call SwitchOnTimer.startOneShot(STABILIZE_INTERVAL);
          state = REFERENCE_PENDING;
          return SUCCESS; 
        }
        break;
          
      default:
        break;
    }
    
    return FAIL;
  }

  command error_t RefVolt_2_5V.stop() {
    uint8_t currentState = state;
    
    switch (state) {
      case REFERENCE_PENDING:
        if (switchOff() == SUCCESS) {
          call SwitchOnTimer.stop();
          state = GENERATOR_OFF;
          signal RefVolt_2_5V.stopDone(SUCCESS);
          return SUCCESS;
        } 
        break;
        
      case REFERENCE_STABLE:
        call SwitchOffTimer.startOneShot(SWITCHOFF_INTERVAL);
        return SUCCESS;

      default:
        break;
    }
    
    return FAIL;
  }

  command error_t RefVolt_1_5V.start() {
    return FAIL;
  }
  
  command error_t RefVolt_1_5V.stop() {
    return FAIL;
  }


  /***************** Timer Events ******************/
  event void SwitchOnTimer.fired() {
    if(state == REFERENCE_PENDING) {
      state = REFERENCE_STABLE;
      signal RefVolt_2_5V.startDone(SUCCESS);
    }
  }
    
  event void SwitchOffTimer.fired() {
    if(state == REFERENCE_STABLE) {
      if (switchOff() == SUCCESS) {
        state = GENERATOR_OFF;
        signal RefVolt_2_5V.stopDone(SUCCESS);
 
      } else {
        call SwitchOffTimer.startOneShot(SWITCHOFF_INTERVAL);
      }
    }
  }
  
  /**************** HplAdc12 Events ***************/
  async event void HplAdc12.conversionDone(uint16_t iv) {
  }

  /**************** Functions ****************/
  error_t switchOn() {
    atomic {
      if (call HplAdc12.isBusy()) {
        return FAIL;
        
      } else {
        adc12ctl0_t ctl0 = call HplAdc12.getCtl0();
        ctl0.enc = 0;
        call HplAdc12.setCtl0(ctl0);
        ctl0.refon = 1;
        ctl0.r2_5v = 0;  
        call HplAdc12.setCtl0(ctl0);
        return SUCCESS;
      }
    }
  }
  
  
  error_t switchOff() {
    atomic {
      if (call HplAdc12.isBusy()) {
        return FAIL;
        
      } else {
        adc12ctl0_t ctl0 = call HplAdc12.getCtl0();
        ctl0.enc = 0;
        call HplAdc12.setCtl0(ctl0);
        ctl0.refon = 0;
        call HplAdc12.setCtl0(ctl0);
        return SUCCESS;
      }
    }
  }  
  
  
  
  /***************** Defaults ****************/
  default event void RefVolt_1_5V.startDone(error_t error){}
  default event void RefVolt_2_5V.startDone(error_t error){}
  default event void RefVolt_1_5V.stopDone(error_t error){}
  default event void RefVolt_2_5V.stopDone(error_t error){}
  
}

