/*
 * Copyright (c) 2007, Vanderbilt University
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE VANDERBILT UNIVERSITY BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE VANDERBILT
 * UNIVERSITY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE VANDERBILT UNIVERSITY SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE VANDERBILT UNIVERSITY HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 */

/**
 * This module is the implementation of an 1-wire bus master.
 * @author Janos Sallai
 * @author David Moss
 * @author Doug Carlson <carlson@cs.jhu.edu>
 * 
 * @modified 6/16/10 Added addressDevice command per 1-wire standards.
 * @modified 2/14/11 switched surf leds for generic leds
 */
 
generic module OneWireMasterP () {
  provides {
    interface OneWireMaster;
  }
  
  uses {
    interface GeneralIO as Pin;
    //interface GeneralIO as DebugPin;
    interface BusyWait<TMicro, uint16_t>;
    interface Leds;
  }
}

implementation {
  
  /** Timing values, in binary microseconds, required for the protocol
   * to work.  Note that time ranges in comments are decimal
   * microseconds, which are rougly 5% longer.  */
  enum {
    /** Time to wait after resetting device */
    t_RSTL = 504, // 480 <= t_RSTL
    /** Maximum time following reset before device generates valid
     * presence signal */
    t_PDHIGH = 63, // 15 <= t_PDHIGH <= 60
    /** Maximum time that presence pulse is valid */
    t_PDLOW = 252, // 60 <= t_PDLOW <= 240
    /** Duration to hold bus low when writing a zero */
    t_LOW0 = 63, // 60 <= t_LOW0 <= 120
    /** Duration to hold bus low when writing a one */
    t_LOW1 = 1, // 1 <= t_LOW1 <= 15
    /** Duration to hold bus low prior to reading a bit */
    t_RDV = 1,  // t_RDV <= 15
    /** Recovery time between slots */
    t_REC = 1,  // 1 <= t_REC
    /** Duration of a read or write slot */
    t_SLOT = 63, // 60 <= t_SLOT <= 120 
  };

  /**
   *  standard onewire commands needed by this component. If there's only one device, we don't need the MATCH_ROM command.
   */ 
  #if MAX_ONEWIRE_DEVICES == 1
    enum {
      CMD_SKIP_ROM = 0xCC,
    };
  #else
    enum {
      CMD_MATCH_ROM = 0x55,
    };
  #endif

  async command error_t OneWireMaster.addressDevice(onewire_t id) {
    #if MAX_ONEWIRE_DEVICES == 1
      call OneWireMaster.init();
      if(call OneWireMaster.reset() == SUCCESS) {
        call OneWireMaster.writeByte(CMD_SKIP_ROM);
        return SUCCESS;
      }
      else {
        return EOFF;
      }
    #else
      uint8_t i;
      call OneWireMaster.init();
      if (call OneWireMaster.reset() == SUCCESS) {
        call OneWireMaster.writeByte(CMD_MATCH_ROM);
        for (i=0; i < ONEWIRE_DATA_LENGTH; i++) {
          call OneWireMaster.writeByte(id.data[i]);
        }
        return SUCCESS;
      }
      else {
        return EOFF;
      }
    #endif
  }

  async command void OneWireMaster.idle() {
    call Pin.makeInput();
  }

  async command void OneWireMaster.init() {
    call Pin.makeInput();
  }

  async command void OneWireMaster.release() {
    call Pin.makeInput();
  }

  async command error_t OneWireMaster.reset() {
    bool present;

    atomic {
      call Leds.led0On();
      //call DebugPin.makeOutput();
      //call DebugPin.set();
      //call DebugPin.clr();
      // it is assumed that the bus is in idle state here
    
      // transmit reset pulse
      call Pin.clr();
      call Pin.makeOutput(); // output low
      call BusyWait.wait(t_RSTL); // must be at least 480us
      call Pin.makeInput(); // input with pullup set

      /* Wait for device to generate valid presence signal; sample it;
       * then wait for it to clear before moving on.  There is a
       * device present if the signal is low. */
      call BusyWait.wait(t_PDHIGH);
      present = (0 == call Pin.get());
      call BusyWait.wait(t_PDLOW);
      call Leds.led0Off();
    }
    return present ? SUCCESS : FAIL;
  }

  async command void OneWireMaster.writeOne() {
    atomic {
      call Pin.makeOutput(); // output low
      call Pin.clr();
      call BusyWait.wait(t_LOW1);
      call Pin.makeInput(); // input with pullup set
      call BusyWait.wait(t_REC + t_SLOT - t_LOW1);
    }
  }

  async command void OneWireMaster.writeZero() {
    atomic {
      call Pin.makeOutput(); // output low
      call Pin.clr();
      call BusyWait.wait(t_LOW0);
      call Pin.makeInput(); // input with pullup set
      call BusyWait.wait(t_REC + t_SLOT - t_LOW0);
    }
  }

  async command void OneWireMaster.writeByte(uint8_t b) {
    uint8_t i;
    // send out bits, LSB first
    for(i = 0; i < 8; i++) {
      if(b & 0x01) {
        call OneWireMaster.writeOne();
      } else {
        call OneWireMaster.writeZero();
      }
      b >>= 1;
    }
  }

  async command bool OneWireMaster.readBit() {
    bool b;
    
    atomic {
      call Pin.makeOutput(); // output low
      call Pin.clr();
      call BusyWait.wait(t_RDV);
      call Pin.makeInput(); // input with pullup set
      b = !! call Pin.get(); // read pin
      call BusyWait.wait(t_REC + t_SLOT - t_RDV);
    }
    return b;
  }

  async command void OneWireMaster.writeBit(uint8_t b){
    if (b){
      call OneWireMaster.writeOne();
    }else{
      call OneWireMaster.writeZero();
    }
  }

  async command uint8_t OneWireMaster.readByte() {
    uint8_t i = 0;
    uint8_t b = 0;

    // read bits, LSB first
    for(i = 0; i < 8; i++) {
      b >>= 1;
      b |= call OneWireMaster.readBit() << 7;
    }
    return b;
  }

}
