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
 * This is a state controller for any and every component's
 * state machine(s).
 *
 * There are several compelling reasons to use the State module/interface
 * in all your components that have any kind of state associated with them:
 *
 *   1) It provides a unified interface to control any state, which makes
 *      it easy for everyone to understand your code
 *   2) You can easily keep track of multiple state machines in one component
 *   3) You could have one state machine control several components
 *
 * There are three ways to change a component's state:
 *  > Request a state change
 *     The state is only changed if the state is currently in S_IDLE.  If
 *     the state changes and access is grated, requestState returns SUCCESS.
 *
 *  > Force a state change
 *     The state changes no matter what
 * 
 *  > toDefaultState()
 *     The state changes to the default state, no matter what state the 
 *     component is in.
 *
 * On instantiation of this generic object, pass in the enumeration of your 
 * component's states, and the initial state value your component should have.
 * @author David Moss
 * @author Kevin Klues
 */
 
generic module StateP(typedef stateEnum_t, uint8_t defaultState) {
  provides {
    interface State<stateEnum_t>;
  }
}

implementation {

  /** The current state */
  uint8_t state = defaultState;
  
  /***************** State Commands ****************/  
  /**
   * This will allow a state change so long as the current
   * state is S_IDLE.
   * @return SUCCESS if the state is change, FAIL if it isn't
   */
  async command error_t State.requestState(uint8_t reqState) {
    atomic {
      if(reqState == defaultState || state == defaultState) {
        state = reqState;
        return SUCCESS;
      }
    }
    return FAIL;
  }
  
  /**
   * Force the state machine to go into a certain state,
   * regardless of the current state it's in.
   */
  async command void State.forceState(uint8_t reqState) {
    atomic {
      state = reqState;
    }
  }
    
  /**
   * Set the current state back to the default state
   */
  async command void State.toDefaultState() {
    atomic {
      state = defaultState;
    }
  }
  
    
  /**
   * @return TRUE if the state machine is in the default state
   */
  async command bool State.isDefaultState() {
    atomic {
      return state == defaultState;
    }
  }
  
  /**
   * Get the current state
   */
  async command uint8_t State.getState() {
    atomic {
      return state;
    }
  }
}

