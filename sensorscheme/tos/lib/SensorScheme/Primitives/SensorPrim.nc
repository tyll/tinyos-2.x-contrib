/**
 * @author Leon Evers
 */


includes SensorScheme;

configuration SensorPrim {
  provides interface SSPrimitive;
}

implementation {
  components SensorPrimM;
  components SensorSchemeC;
  
  SSPrimitive = SensorPrimM;
  SensorPrimM.SSRuntime -> SensorSchemeC;
}
