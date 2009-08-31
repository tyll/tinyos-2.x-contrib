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
 * This is for MSP430 processors with the Supply Voltage Supervisor (SVS)
 * It measures and monitors the internal voltage.
 *
 * @author Mark Siner
 */

#define SUPPLY_AUTOSAMPLE_MILLIS 61440U
#define SVSFG_MASK 0x01
#define LOW_VOLTAGE_LEVEL VLD_265V

module SupplyVoltageP {
  provides {
    interface SupplyVoltage;
  }
  
  uses {
    interface Timer<TMilli>;
    interface BusyWait<TMicro, uint16_t>;
  }
}

implementation {

  uint16_t translateToVoltage( uint8_t svsVolt );

  uint8_t lastVoltage = 0;
  
  enum {
    VLD_SVSOFF = 0,
    VLD_19V = 0x10,
    VLD_21V = 0x20,
    VLD_22V = 0x30,
    VLD_23V = 0x40,
    VLD_24V = 0x50,
    VLD_25V = 0x60,
    VLD_265V = 0x70,
    VLD_28V = 0x80,
    VLD_29V = 0x90,
    VLD_305V = 0xA0,
    VLD_32V = 0xB0,
    VLD_335V = 0xC0,
    VLD_35V = 0xD0,
    VLD_37V = 0xE0
  };
  
  /***************** SupplyVoltage Commands ****************/
  /**
   * @return the supply voltage times 100. So, 3.10 volts = 310.
   */
  command uint16_t SupplyVoltage.getVoltage() {
    return translateToVoltage( lastVoltage );
  }
  
  command bool SupplyVoltage.isBatteryLow() {
    return (SVSCTL & SVSFG_MASK);
  }
  
  command void SupplyVoltage.sample() {
    uint8_t vld = VLD_37V;
    
    //Step down through the thresholds
    for(; vld > 0; vld -= 0x10 ) {

      SVSCTL = vld;
      call BusyWait.wait( 24 );    

      if( !(SVSCTL & SVSFG_MASK) ) {
        if( vld < LOW_VOLTAGE_LEVEL ) {
#ifdef SUPPLY_VOLTAGE_PRINTF
          printf("VOLTAGE LOW\n\r");
#endif
          signal SupplyVoltage.batteryLow();
        }
        lastVoltage = vld + 0x10;
        break;
      }
    }
    SVSCTL = LOW_VOLTAGE_LEVEL;
#ifdef SUPPLY_VOLTAGE_PRINTF
    printf("VOLTAGE=%d\n\r", translateToVoltage( lastVoltage ) );
#endif
  }
  
  command void SupplyVoltage.automaticSampling(bool on) {
    if(on) {
      call Timer.startPeriodic(SUPPLY_AUTOSAMPLE_MILLIS);
    } else {
      call Timer.stop();
    }
  }
  
  /***************** Timer Events ****************/
  event void Timer.fired() {
    call SupplyVoltage.sample();
  }
  
  uint16_t translateToVoltage( uint8_t svsVolt ) {
    switch( lastVoltage ) {
      case VLD_SVSOFF:
        return 0; 
      case VLD_19V:
        return 190;
      case VLD_21V:
        return 210;
      case VLD_22V:
        return 220;
      case VLD_23V:
        return 230;
      case VLD_24V:
        return 240;
      case VLD_25V:
        return 250;
      case VLD_265V:
        return 265;
      case VLD_28V:
        return 280;
      case VLD_29V:
        return 290;
      case VLD_305V:
        return 305;
      case VLD_32V:
        return 320;
      case VLD_335V:
        return 335;
      case VLD_35V:
        return 350;
      case VLD_37V:
        return 370;
    }
    return lastVoltage;
  }
  
  /***************** Defaults ****************/
  default event void SupplyVoltage.batteryLow() {
  } 
  
}

