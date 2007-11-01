/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration BlinkPrim {
  provides interface SSPrimitive;
}

implementation {
  components BlinkPrimM;
  components SensorSchemeC;
  components LedsC;
  
  SSPrimitive = BlinkPrimM;
  BlinkPrimM.SSRuntime -> SensorSchemeC;
  BlinkPrimM.Leds -> LedsC;
}
