module DummyOWP {
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
