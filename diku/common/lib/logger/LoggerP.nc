
/*
 * Copyright (c) 2007 University of Copenhagen
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
 * - Neither the name of University of Copenhagen nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE UNIVERSITY
 * OF COPENHAGEN OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
 * Log recording layer
 *
 * @author Marcus Chang <marcus@diku.dk>
 * @author Martin Leopold <leopold@diku.dk>
 */

module LoggerP {
  provides interface Init;
  provides interface GeneralIO as InputPin[uint8_t in];  
  uses interface GeneralIO as Trigger;
  uses interface GeneralIO as Mcu;
  uses interface GeneralIO as Bit1;
  uses interface GeneralIO as Bit2;
  uses interface GeneralIO as Bit3;
  uses interface GeneralIO as Bit4;
  uses interface GeneralIO as Bit5;
  uses interface GeneralIO as Bit6;
  uses interface GeneralIO as Bit7;
}

implementation {

    command error_t Init.init() 
    {       
      call Mcu.set();
      call Mcu.clr();
      call Bit1.clr();
      call Bit2.clr();
      call Bit3.clr();
      call Bit4.clr();
      call Bit5.clr();
      call Bit6.clr();
      call Bit7.clr();
      call Mcu.makeOutput();
      call Bit1.makeOutput();
      call Bit2.makeOutput();
      call Bit3.makeOutput();
      call Bit4.makeOutput();
      call Bit5.makeOutput();
      call Bit6.makeOutput();
      call Bit7.makeOutput();

      call Trigger.clr();
      call Trigger.makeOutput();
      return SUCCESS;
    }

  async command void InputPin.set[uint8_t id]() {
  
    switch(id) {
      case 0:
        call Mcu.set();
        call Trigger.toggle();
        break;
        
      case 1:
        call Bit1.set();
        call Trigger.toggle();
        break;
    
      case 2:
        call Bit2.set();
        call Trigger.toggle();
        break;
    
      case 3:
        call Bit3.set();
        call Trigger.toggle();
        break;
    
      case 4:
        call Bit4.set();
        call Trigger.toggle();
        break;
    
      case 5:
        call Bit5.set();
        call Trigger.toggle();
        break;
    
      case 6:
        call Bit6.set();
        call Trigger.toggle();
        break;
    
      case 7:
        call Bit7.set();
        call Trigger.toggle();
        break;
    
      default:
        break;
    }

  }
  
  async command void InputPin.clr[uint8_t id]() {

    switch(id) {
      case 0:
        call Mcu.clr();
        call Trigger.toggle();
        break;
        
      case 1:
        call Bit1.clr();
        call Trigger.toggle();
        break;
    
      case 2:
        call Bit2.clr();
        call Trigger.toggle();
        break;
    
      case 3:
        call Bit3.clr();
        call Trigger.toggle();
        break;
    
      case 4:
        call Bit4.clr();
        call Trigger.toggle();
        break;
    
      case 5:
        call Bit5.clr();
        call Trigger.toggle();
        break;
    
      case 6:
        call Bit6.clr();
        call Trigger.toggle();
        break;
    
      case 7:
        call Bit7.clr();
        call Trigger.toggle();
        break;
    
      default:
        break;
    }

  }

  async command void InputPin.toggle[uint8_t id]() {
 
    switch(id) {
      case 0:
        call Mcu.toggle();
        call Trigger.toggle();
        break;
        
      case 1:
        call Bit1.toggle();
        call Trigger.toggle();
        break;
    
      case 2:
        call Bit2.toggle();
        call Trigger.toggle();
        break;
    
      case 3:
        call Bit3.toggle();
        call Trigger.toggle();
        break;
    
      case 4:
        call Bit4.toggle();
        call Trigger.toggle();
        break;
    
      case 5:
        call Bit5.toggle();
        call Trigger.toggle();
        break;
    
      case 6:
        call Bit6.toggle();
        call Trigger.toggle();
        break;
    
      case 7:
        call Bit7.toggle();
        call Trigger.toggle();
        break;
    
      default:
        break;
    }

  }
  
  async command bool InputPin.get[uint8_t id]() {
    return TRUE;
  }
  
  async command void InputPin.makeInput[uint8_t id]() {

  }
  
  async command bool InputPin.isInput[uint8_t id]() {
    return TRUE;
  }
  
  async command void InputPin.makeOutput[uint8_t id]() {

  }
  
  async command bool InputPin.isOutput[uint8_t id]() {
    return TRUE;
  }
    
}
