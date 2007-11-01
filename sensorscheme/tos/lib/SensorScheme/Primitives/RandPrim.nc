/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration RandPrim {
  provides interface SSPrimitive;
}

implementation {
  components RandPrimM;
  components SensorSchemeC;
  components RandomC;
  
  SSPrimitive = RandPrimM;
  RandPrimM.SSRuntime -> SensorSchemeC;
  RandPrimM.Random -> RandomC;  
}
