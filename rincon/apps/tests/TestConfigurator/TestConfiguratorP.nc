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
 * @author David Moss
 */
 
module TestConfiguratorP {
  uses {
    interface Configurator as Config1;
    interface Configurator as Config2;
    interface Configurator as Config3;
    interface Leds;
    interface JDebug;
  }
}

implementation {

  struct {
    uint8_t myShort;
    uint16_t myInt;
    uint32_t loginAttempts;
  } myConfig1;
  
  struct {
    uint8_t myArray[5];
    uint32_t loginAttempts;
  } myConfig2;
  
  uint16_t unchangingInt;
  
  /***************** Config1 Events ****************/
  event void Config1.requestLogin() {
    call Config1.login(&myConfig1, sizeof(myConfig1));
  }
  
  event void Config1.stored(error_t error) {
    call JDebug.jdbg("Config1 login attempts: %l", myConfig1.loginAttempts, 0, 0);
  }
  
  event void Config1.loaded(bool valid, void *data, uint8_t size, error_t error) {
    if(!valid) {
      myConfig1.loginAttempts = 1;
    } else {
      myConfig1.loginAttempts++;
    }
    
    call Config1.store();
  }
  
  
  /***************** Config2 Events ****************/
  event void Config2.requestLogin() {
    call Config2.login(&myConfig2, sizeof(myConfig2));
  }
  
  event void Config2.stored(error_t error) {
    call JDebug.jdbg("Config2 login attempts: %l", myConfig2.loginAttempts, 0, 0);
    call Leds.set(myConfig2.loginAttempts);
  }
  
  event void Config2.loaded(bool valid, void *data, uint8_t size, error_t error) {
    if(!valid) {
      myConfig2.loginAttempts = 1;
    } else {
      myConfig2.loginAttempts++;
    }
    
    call Config2.store();
  }
  
  
  /***************** Config3 Events ****************/
  event void Config3.requestLogin() {
    call Config3.login(&unchangingInt, sizeof(unchangingInt));
  }
  
  event void Config3.stored(error_t error) {
    call JDebug.jdbg("Initialized unchangingInt %l", unchangingInt, 0, 0);
  }
  
  event void Config3.loaded(bool valid, void *data, uint8_t size, error_t error) {
    if(!valid) {
      unchangingInt = 1024;
      call Config3.store();
      
    } else {
      call JDebug.jdbg("Loaded: unchangingInt = %l", unchangingInt, 0, 0);
    }
  }
}

