/*
 * Copyright (c) 2005-2006 Arch Rock Corporation
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
 * - Neither the name of the Arch Rock Corporation nor the names of
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

#include "hotmac.h"

/**
 * @author Jonathan Hui <jhui@archrock.com>
 * @version $Revision$ $Date$
 */

module CC2420PowerP {
  provides interface AsyncSplitControl as SplitControl;
  provides interface PowerCycleInfo;

  uses interface Resource;
  uses interface CC2420Power;
  uses interface AsyncStdControl as SubControl;
  uses interface State as SplitControlState;
  
  uses interface Alarm<T32khz, uint32_t>;
}

implementation {

  enum {
    S_STOPPED,
    S_STARTING,
    S_STARTED,
    S_STOPPING,
  };

  /****************** Prototypes ****************/
  void startDone_task();
  task void stopDone_task();
  
  void shutdown();
  norace uint32_t start_time;

  /***************** SplitControl Commands ****************/
  async command error_t SplitControl.start() {
    if(call SplitControlState.requestState(S_STARTING) == SUCCESS) {
      call CC2420Power.startVReg();
      return SUCCESS;
    
    } else if(call SplitControlState.isState(S_STARTED)) {
      return EALREADY;
      
    } else if(call SplitControlState.isState(S_STARTING)) {
      return SUCCESS;
    }
    
    return EBUSY;
  }

  async command error_t SplitControl.stop() {
    if (call SplitControlState.isState(S_STARTED)) {
      call SplitControlState.forceState(S_STOPPING);
      shutdown();
      return SUCCESS;
      
    } else if(call SplitControlState.isState(S_STOPPED)) {
      return EALREADY;
    
    } else if(call SplitControlState.isState(S_STOPPING)) {
      return SUCCESS;
    }
    
    return EBUSY;
  }

  /**************** Events ****************/
  async event void CC2420Power.startVRegDone() {
    if (call Resource.immediateRequest() == SUCCESS) {
      // avoid posting a task if the resource is uncontended
      if (call CC2420Power.startOscillator() == SUCCESS) {
        return;
      } else {
        call Resource.release();
      }
    }
    call Resource.request();
  }
  
  event void Resource.granted() {
    call CC2420Power.startOscillator();
  }

  async event void CC2420Power.startOscillatorDone() {
    start_time = call Alarm.getNow();
    startDone_task();
  }
  
  
  /***************** Tasks ****************/

  void startDone_task() {
    call SubControl.start();
    call CC2420Power.rxOn();
    call Resource.release();
    call SplitControlState.forceState(S_STARTED);
    signal SplitControl.startDone( SUCCESS );
  }
  
  task void stopDone_task() {
    call SplitControlState.forceState(S_STOPPED);
    signal SplitControl.stopDone( SUCCESS );
    signal PowerCycleInfo.stopDone( call Alarm.getNow() - start_time );
  }
  
  
  /***************** Functions ****************/
  /**
   * Shut down all sub-components and turn off the radio
   */
  void shutdown() {
    call SubControl.stop();
    call CC2420Power.stopVReg();
    post stopDone_task();
  }

  async event void Alarm.fired() {}

  /***************** Defaults ***************/
  default async event void SplitControl.startDone(error_t error) {
  }
  
  default event void SplitControl.stopDone(error_t error) {
  }
  default event void PowerCycleInfo.stopDone(uint32_t time) {
  }
}

