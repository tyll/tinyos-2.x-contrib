
/**
 * On boot, attempt to read the ID from the one-wire chip. 
 * 
 * If successful, print the 1-wire chip's 64-bit unique ID to the terminal.
 * Continue reading temperatures which are printed to the terminal and indicated
 * on a power-meter like LED scale.
 * 
 * If it doesn't work, light up the single 'FailLed' and exit.
 *
 * @author David Moss
 */
configuration TestC {
}

implementation {

  components MainC,
      TestP,
      LedsC,
      Ds1825C;
      
  TestP.Boot -> MainC;
  TestP.Leds -> LedsC;
  
  TestP.TemperatureCC -> Ds1825C.Read;
  TestP.OneWireDeviceInstanceManager -> Ds1825C.OneWireDeviceInstanceManager;
  
}
