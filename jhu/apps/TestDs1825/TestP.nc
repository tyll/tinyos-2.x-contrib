
#include "OneWire.h"
#include "printf.h"
/**
 * See the description in the configuration file
 * @author David Moss
 * @author Doug Carlson (platform independent version)
 */
module TestP {
  uses {
    interface Boot;
    interface Read<int16_t> as TemperatureCC;
    interface OneWireDeviceInstanceManager;
    
    interface Leds;
  }
}

implementation {

  // Temperature level indicator thresholds, in degrees celsius * 100
  enum {
    TEMP_LEVEL_0 = 0,     // 32 degrees F
    TEMP_LEVEL_1 = 2222,  // 74 degrees F
    TEMP_LEVEL_2 = 2777,  // 82 degrees F
  };
  
  /***************** Tasks ****************/
  task void getTemp() {
    if (call TemperatureCC.read() != SUCCESS) {
        printf("error\n");
        printfflush();
    }
  }
  
  /***************** Boot Events ****************/
  event void Boot.booted() {
    error_t error;
    
    printf("Reading 64-bit ID...\n\r");
    error = call OneWireDeviceInstanceManager.refresh();
    
    if(error != SUCCESS) {
      printf("Error %d\n\r", error);
      return;
    }
    
    printf("\n\r");
    printfflush();
   
  }

  event void OneWireDeviceInstanceManager.refreshDone(error_t result, bool devicesChanged) {
    uint8_t i;
    onewire_t id;
    if (result == SUCCESS) {
      id = call OneWireDeviceInstanceManager.getDevice(call OneWireDeviceInstanceManager.numDevices()-1);
      for(i = 0; i < sizeof(onewire_t); i++) {
        printf("0x%02x ", id.data[i]);
      }    
      call OneWireDeviceInstanceManager.setDevice(id);
      printf("\n\rRetrieving Temperatures:\n\r");
      printfflush();
      post getTemp();
    }
    else {
      printf("Error %d\n\r", result);
      printfflush();
      return;

    }
  }

  /***************** Read Events ****************/
  event void TemperatureCC.readDone(error_t error, int16_t value) {
    int32_t temp_f;
    if (SUCCESS != error) {
      printf("Temperature : ERROR %d\n", error);
      return;
    }
    temp_f = 3200 + (9 * value) / 5;
    printf("Temperature : %d.%02dC (%ld.%02ldF)\n\r", (value / 100), value % 100, temp_f / 100, temp_f % 100);
    
    call Leds.set(0);
    if(value > TEMP_LEVEL_0) {
      call Leds.led0On();
    }
    
    if(value > TEMP_LEVEL_1) {
      call Leds.led1On();
    }
    
    if(value > TEMP_LEVEL_2) {
      call Leds.led2On();
    }
    
    post getTemp();
  }
}
