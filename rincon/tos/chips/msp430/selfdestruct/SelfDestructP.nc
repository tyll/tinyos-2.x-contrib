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
 * RINCON RESEARCH OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
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

#include "SelfDestruct.h"
#include "msp430regtypes.h"

// see http://www.motherboardpoint.com/getting-code-size-function-c-t95049.html
// also https://community.ti.com/forums/t/653.aspx

module SelfDestructP { 
  provides {
    interface SelfDestruct;
  }
  
  uses {
    interface Leds;
  }
}

implementation {

  //uint8_t ramFunction[256];

  /**
   * This function must be copied to RAM before executing
   */
  void microcontrollerSuicide() {
    uint16_t *addressPtr;
    uint8_t romTotalSegments = 96;
    int i;
    
    WDTCTL = 0x5A80; // Disable watchdog
    
    atomic {
      for(i = 0; i < romTotalSegments; i++) {
        // addressPtr = ROM_START_ADDRESS + (segment offset)
        // The start address is 0x4000
        // Each segment is 512 bytes long
        
        FCTL3 = 0x0A500; // Lock = 0
        FCTL1 = 0x0A502; // Erase = 1
      
        addressPtr = (uint16_t *) (0x4000 + (512 * i));
        *addressPtr = 0; // Erase segment
        
        FCTL1 = 0x0A500; // Erase = 0
        FCTL3 = 0x0A500; // Lock = 1
      
      }
      
      
      P6OUT |= (0x01 << 7);
      while(1) {}
    }
  }
  
  /**
   * This is a place holder for the end address of the microcontrollerSuicide()
   * function so we can calculate its size
   *
  void microcontrollerSuicideEndAddress() {}
   */
   
  /**
   * Self-destruct the program flash
   */
  command void SelfDestruct.execute() {
    // TODO this only seems to erase the first segment in a test app.
    microcontrollerSuicide();
    
    /*
     * Attempted to load the function into RAM, but it didn't seem to work.
    void (*ramFx)();
    uint16_t size = &microcontrollerSuicideEndAddress - &microcontrollerSuicide;
    
    memset(&ramFunction, 0x0, sizeof(ramFunction));
    memcpy(&ramFunction, microcontrollerSuicide, size);
    ramFx = (void (*)(void))(ramFunction);
    ramFx();
    */
  }
  
}
