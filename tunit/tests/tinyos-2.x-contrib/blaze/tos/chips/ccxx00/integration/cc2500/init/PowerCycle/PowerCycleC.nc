
/**
 * Test the ability for BlazeInit's SplitControl to turn the radio on and
 * off many times very quickly.  This can also be used for power analysis
 * testing to find out how quick the radio can turn on and off.
 * 
 * @author David Moss
 */
 
configuration PowerCycleC {
}

implementation {

  components new TestCaseC() as TestPowerCycleC;
  
  components PowerCycleP,
      BlazeInitC,
      CC2500ControlC,
      LedsC;
      
  PowerCycleP.SplitControl -> BlazeInitC;
  PowerCycleP.TestPowerCycle -> TestPowerCycleC;
  PowerCycleP.Leds -> LedsC;
  
}

