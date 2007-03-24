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
 * Manage storing and retrieving configuration settings 
 * for various components, mainly to non-volatile internal microcontroller 
 * memory.
 * 
 * On install, the internal flash should be erased automatically on
 * both the avr and msp430 platforms, so you shouldn't have to worry
 * about loading incorrect config data left over from a different
 * version of the application.
 *
 * On boot, each unique parameterized Configurator interface will
 * be called with an event to requestLogin().  The component
 * using the Configurator interface must call the command login(..)
 * at that point to register its global buffers that store configuration data.
 * After all components have logged in, the loaded() event will be automatically
 * signaled for each client, with their loaded data.
 *
 * Each request will be queued up and handled, so several components can call
 * store() and load() simultaneously.  The only rule is that the a single
 * component cannot store() and load() at the same time.
 *
 *
 * Storing data will first calcute and store the CRC of the data to flash,
 * then store the actual data to flash.  Each client will take up the
 * size they register with plus 2 bytes extra for the CRC.
 *
 * Loading data will first load the CRC from flash, then load the
 * data from flash into the registered client's pointer.  If
 * the CRC's don't match, then the loaded() event will signal with
 * valid == FALSE and error == SUCCESS.  You can then fill
 * in the registered buffer with default data and call store().
 *
 * @author David Moss
 */
 
module ConfiguratorP {
  provides {
    interface Configurator[uint8_t id];
    interface Init;
  }
  
  uses {
    interface DirectModify;
    interface VolumeSettings;
    interface GenericCrc;
    interface State;
    interface Boot;
  }
}

implementation {
  
  /** The current parameterized client we're working with */
  uint8_t currentClient;
  
  /** Storage for the crc of a configuration on flash */
  uint8_t crc;
  
  /**
   * Information about all the parameterized clients
   * using the Configurator interface
   */
  struct clients {
    /** Pointer to the client's configuration buffer */
    void *buffer;
    
    /** Size of the client's configuration buffer */
    uint16_t size;
    
    /** TRUE if this client has properly registered */
    uint8_t state;
    
  } clients[uniqueCount(UQ_CONFIGURATOR)];
  
  /**
   * Component States
   */
  enum {
    S_IDLE,
    
    S_LOGIN,
    
    S_STORE_CRC,
    S_STORE_DATA,
    
    S_LOAD_CRC,
    S_LOAD_DATA,
  };
  
  /**
   * Registration states
   */
  enum {
    NOT_LOGGED_IN,
    LOGGED_IN,
    LOCKED_OUT,
    REQUESTING_LOAD,
    REQUESTING_STORE,
  };
  
  
  /***************** Prototypes ****************/
  uint32_t getFlashAddress(uint8_t clientId);
  task void processRequest();
  
  /***************** Init Commands ****************/
  command error_t Init.init() {
    int i;
    for(i = 0; i < uniqueCount(UQ_CONFIGURATOR); i++) {
      clients[i].state = NOT_LOGGED_IN;
    }
    
    call State.forceState(S_LOGIN);
    
    for(i = 0; i < uniqueCount(UQ_CONFIGURATOR); i++) {
      signal Configurator.requestLogin[i]();
      if(clients[i].state != REQUESTING_LOAD) {
        clients[i].state = LOCKED_OUT;
      }
    }
    
    call State.toIdle();
    post processRequest();
    
    return SUCCESS;
  }
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
  
  }
  
  /***************** Configurator Commands ****************/
  /**
   * Register the parameterized interface with the Configurator
   * component. This command must be called during the requestLogin()
   * event.
   *
   * If registering this client causes the amount of config data to exceed
   * the size of the flash, this command will return FAIL and
   * the client will not be allowed to use the Configurator storage.
   *
   * @param data Pointer to the buffer that contains the local
   *     component's configuration data in global memory.
   * @param size Size of the buffer that contains local config data.
   * @return SUCCESS if the client got registered
   *     ESIZE if there is not enough memory
   *     FAIL if the client cannot login at this time.
   */
  command error_t Configurator.login[uint8_t id](void *data, uint8_t size) {
    if(call State.getState() != S_LOGIN) {
      return FAIL;
    }
    
    if(clients[id].state == NOT_LOGGED_IN) {
      clients[id].buffer = data;
      clients[id].size = size;
      
      if(getFlashAddress(id) + size > call VolumeSettings.getVolumeSize()) {
        clients[id].state = LOCKED_OUT;
        return ESIZE;
      
      } else {
        // Immediately request to load data from flash
        clients[id].state = REQUESTING_LOAD;
        return SUCCESS;
      }
    }
    
    return FAIL;
  }
  
  /**
   * Store the registered configuration data 
   * into non-volatile memory.  This assumes that the pointer
   * to the global data has not changed.
   * @return SUCCESS if the configuration data will be stored,
   *     FAIL if it will not be stored.
   */
  command error_t Configurator.store[uint8_t id]() {
    if(clients[id].state != LOGGED_IN) {
      return FAIL;
    }
    
    clients[id].state = REQUESTING_STORE;
    post processRequest();
    
    return SUCCESS;
  }
  
  /**
   * Load the registered configuration data
   * from non-volatile memory into the registered buffer location.
   * @return SUCCESS if the configuration data will be loaded
   *     directly into the buffer, FAIL if it won't.
   */
  command error_t Configurator.load[uint8_t id]() {
    if(clients[id].state != LOGGED_IN) {
      return FAIL;
    }
    
    clients[id].state = REQUESTING_LOAD;
    post processRequest();
    
    return SUCCESS;
  }
  
  /**
   * Cancel any pending requests
   */
  command void Configurator.cancel[uint8_t id]() {
    if(clients[id].state != LOCKED_OUT) {
      clients[id].state = LOGGED_IN;
    }
  }
  
  
  /***************** DirectModify Events ****************/
  /**
   * Bytes have been modified on flash
   * @param addr The address modified
   * @param *buf Pointer to the buffer that was written to flash
   * @param len The amount of data from the buffer that was written
   * @param error SUCCESS if the bytes were correctly modified
   */
  event void DirectModify.modified(uint32_t addr, void *buf, uint32_t len, error_t error) {
    if(call State.getState() == S_STORE_CRC) {
      call State.forceState(S_STORE_DATA);
      if(call DirectModify.modify(getFlashAddress(currentClient) + sizeof(crc), clients[currentClient].buffer, clients[currentClient].size) != SUCCESS) {
        call State.toIdle();
        clients[currentClient].state = LOGGED_IN;
        signal Configurator.stored[currentClient](FAIL);
        post processRequest();
      }
    
    } else if(call State.getState() == S_STORE_DATA) {
      call DirectModify.flush();
    }
  }
  
  event void DirectModify.readDone(uint32_t addr, void *buf, uint32_t len, error_t error) {
    if(call State.getState() == S_LOAD_CRC) {
      call State.forceState(S_LOAD_DATA);
      if(call DirectModify.read(getFlashAddress(currentClient) + sizeof(crc), clients[currentClient].buffer, clients[currentClient].size)
          != SUCCESS) {
        call State.toIdle();
        clients[currentClient].state = LOGGED_IN;
        signal Configurator.loaded[currentClient](FALSE, clients[currentClient].buffer, clients[currentClient].size, FAIL);
        post processRequest();
      }
    
    } else if(call State.getState() == S_LOAD_DATA) {
      call State.toIdle();
      clients[currentClient].state = LOGGED_IN;
      signal Configurator.loaded[currentClient]((crc == (uint8_t) call GenericCrc.crc16(0, clients[currentClient].buffer, clients[currentClient].size)), clients[currentClient].buffer, clients[currentClient].size, SUCCESS);
      post processRequest();
    }   
  }
  
  event void DirectModify.flushDone(error_t error) {
    call State.toIdle();
    clients[currentClient].state = LOGGED_IN;
    signal Configurator.stored[currentClient](SUCCESS);
    post processRequest();
  }
  
  /***************** Tasks ****************/
  task void processRequest() {
    int i;
    for(i = 0; i < uniqueCount(UQ_CONFIGURATOR); i++) {
      currentClient = i;
      if(clients[i].state == REQUESTING_LOAD) {
        call State.forceState(S_LOAD_CRC);
        if(call DirectModify.read(getFlashAddress(currentClient), &crc, sizeof(crc))
            != SUCCESS) {
          post processRequest();
          
        } else {
          return;
        }
        
      } else if(clients[i].state == REQUESTING_STORE) {
        call State.forceState(S_STORE_CRC);
        crc = (uint8_t) call GenericCrc.crc16(0, clients[currentClient].buffer, clients[currentClient].size);
    
        if(call DirectModify.modify(getFlashAddress(currentClient), &crc, sizeof(crc))
            != SUCCESS) {
          post processRequest();
          
        } else {
          return;
        }
      }
    }
  }
  
  /***************** Functions ****************/
  /**
   * @return the address on flash for a particular client's data
   */
  uint32_t getFlashAddress(uint8_t clientId) {
    uint32_t addr = 0;
    int i;
    
    for(i = 0; i < uniqueCount(UQ_CONFIGURATOR); i++) {
      if(i == clientId) {
        break;
      }
      
      if(clients[i].state == LOGGED_IN) {
        addr += sizeof(crc) + clients[i].size;
      }
    }
    
    return addr;
  }
  
  
  /***************** Defaults ****************/
  default event void Configurator.requestLogin[uint8_t id]() {
  }
  
  default event void Configurator.stored[uint8_t id](error_t error) {
  }

  default event void Configurator.loaded[uint8_t id](bool valid, void *data, uint8_t size, error_t error) {
  }
}

 
