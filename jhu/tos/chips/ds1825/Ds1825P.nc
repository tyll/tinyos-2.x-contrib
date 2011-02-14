/*
 * Copyright (c) 2009-2010 People Power Company
 * All rights reserved.
 *
 * This open source code was developed with funding from People Power Company
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
 * - Neither the name of the People Power Company nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE
 * PEOPLE POWER CO. OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE
 */
/*
 * DS 1825 Driver implementation
 * <ul>
 *   <li> Exposes the functionality of a DS 1825 device on a onewire bus with the Read interface.</li>
 *   <li> Hides the low-level details of onewire commands</li>
 *   <li> Hides obtaining a lock on the bus with split-phase read</li>
 * </ul>
 *
 * Much of this code was adapted by the Ds1825OneWireImplementationP by David Moss/People Power co.
 * @author Doug Carlson <carlson@cs.jhu.edu>
 * @author David Moss
 * @modified 6/16/10
 */
module Ds1825P {
  uses {
    interface OneWireMaster;
    interface Resource;
    interface OneWireDeviceInstanceManager;
    interface Timer<TMilli>;
  }
  provides {
    interface Read<int16_t>;
  }
}
implementation {
  enum {
    CMD_CONVERT_TEMPERATURE = 0x44,
    CMD_READ_SCRATCHPAD = 0xBE,
    CMD_WRITE_SCRATCHPAD = 0x4E,
  };

  command error_t Read.read() {
    if ((call OneWireDeviceInstanceManager.currentDevice()).id != ONEWIRE_NULL_ADDR) {
      return call Resource.request();
    }
    else {
      return FAIL;
    }
  }

  event void Resource.granted() {
    /*
     * Step 1.
     * Configure the ADC for a 10-bit conversion by setting the config byte
     * to a 0x20.
     */
    call OneWireMaster.addressDevice(call OneWireDeviceInstanceManager.currentDevice());
    call OneWireMaster.writeByte(CMD_WRITE_SCRATCHPAD);

    call OneWireMaster.writeByte(0x0);  // User byte 1
    call OneWireMaster.writeByte(0x0);  // User byte 2
    call OneWireMaster.writeByte(0x20); // Configuration Register (0x20 = 10bit)

    /*
     * Step 2.
     * Begin the temperature conversion process. Note from the datasheet
     * a 10-bit ADC takes a maximum of 187.5 ms.  We'll just do something
     * else during that time, maybe go to sleep, instead of constantly polling
     * the 1-wire device.
     */
    call OneWireMaster.addressDevice(call OneWireDeviceInstanceManager.currentDevice());
    call OneWireMaster.writeByte(CMD_CONVERT_TEMPERATURE);

    /*
     * Step 3.
     * Wait for the conversion to complete without polling.
     * 188 ms / 1000 (ms per second) = X (bms) / 1024 (bms per second)
     *   => X = 193
     */
    call Timer.startOneShot(193);
 }

  /***************** Timer Events ****************/
  /**
   * Step 4.
   * The timer is firing because the temperature conversion is now complete.
   * Read the scratchpad to find out what the temperature is, and signal
   * readDone(..);
   */
  event void Timer.fired() {
    int16_t rawValue = 0;
    int32_t temperature;
    
    call OneWireMaster.addressDevice(call OneWireDeviceInstanceManager.currentDevice());

    // 5. Send command to read the scratch pad
    call OneWireMaster.writeByte(CMD_READ_SCRATCHPAD);

    rawValue = call OneWireMaster.readByte();
    rawValue |= call OneWireMaster.readByte() << 8;

    temperature = (int32_t) rawValue;

    /*
     * Example (using page 5 of the datasheet)
     *   0x191 should equal +25.0625 degrees C
     *
     *   0x191 * 625 => 401 * 625 => 250625
     *   250625 / 100 => [2506] (25.06 C)
     */
    temperature *= 625;
    temperature /= 100;

    call Resource.release();
    signal Read.readDone(SUCCESS, (int16_t) temperature);
  }
  
  event void OneWireDeviceInstanceManager.refreshDone(error_t result, bool devicesChanged) {
    //this particular driver doesn't care when new devices show up.
  }

  //read logic can be made more complex, if, for instance, we want to send CONVERT to all devices on the first read, then respond to subsequent reads (within some time window) by just reading the scratchpad of those devices.
}
